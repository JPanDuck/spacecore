package com.spacecore.service.oauth2;

import com.spacecore.domain.oauth2.OAuth2Account;
import com.spacecore.mapper.oauth2.OAuth2AccountMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestTemplate;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;
import java.util.Map;

/**
 * ✅ OAuth2AccountServiceImpl (최신화)
 * - OAuth2 계정 등록/갱신/삭제/토큰갱신/Revoke 지원
 * - refresh_token null 방어 및 Mapper 파라미터 정합성 보완
 */
@Slf4j
@Service
@RequiredArgsConstructor
@Transactional
public class OAuth2AccountServiceImpl implements OAuth2AccountService {

    private final OAuth2AccountMapper oauth2AccountMapper;

    @Value("${spring.security.oauth2.client.registration.google.client-id}")
    private String googleClientId;

    @Value("${spring.security.oauth2.client.registration.google.client-secret}")
    private String googleClientSecret;

    @Value("${oauth2.naver.client-id:}")
    private String naverClientId;

    @Value("${oauth2.naver.client-secret:}")
    private String naverClientSecret;

    /**
     * ✅ 신규 등록
     */
    @Override
    public void save(OAuth2Account account) {
        oauth2AccountMapper.insert(account);
        log.info("✅ OAuth2Account 저장 완료: provider={}, userId={}", account.getProvider(), account.getUserId());
    }

    /**
     * ✅ 등록 or 갱신 (refreshToken null 방지 포함)
     */
    @Override
    public void saveOrUpdate(OAuth2Account account) {
        OAuth2Account existing = oauth2AccountMapper.findByUserId(account.getUserId());
        log.debug("💬 saveOrUpdate() 호출됨 - accessToken={}, refreshToken={}",
                account.getAccessToken(), account.getRefreshToken());

        if (existing == null) {
            oauth2AccountMapper.insert(account);
            log.info("🆕 OAuth2Account 신규 등록: provider={}, userId={}", account.getProvider(), account.getUserId());
        } else {
            if (account.getRefreshToken() != null && !account.getRefreshToken().isEmpty()) {
                oauth2AccountMapper.updateTokens(
                        account.getUserId(),
                        account.getAccessToken(),
                        account.getRefreshToken(),
                        account.getTokenExpiresAt()
                );
                log.info("🔄 OAuth2Account 토큰 전체 갱신 완료 (userId={}, provider={})",
                        account.getUserId(), account.getProvider());
            } else {
                oauth2AccountMapper.updateAccessTokenOnly(
                        account.getUserId(),
                        account.getAccessToken(),
                        account.getTokenExpiresAt()
                );
                log.info("ℹ️ refreshToken 없음 → AccessToken만 갱신 (userId={}, provider={})",
                        account.getUserId(), account.getProvider());
            }
        }
    }

    /**
     * ✅ 사용자별 OAuth2Account 조회
     */
    @Override
    public OAuth2Account findByUserId(Long userId) {
        return oauth2AccountMapper.findByUserId(userId);
    }

    /**
     * ✅ 명시적 토큰 갱신
     */
    @Override
    public void updateTokens(Long userId, String accessToken, String refreshToken, LocalDateTime expiresAt) {
        oauth2AccountMapper.updateTokens(userId, accessToken, refreshToken, expiresAt);
        log.info("🔄 OAuth2 토큰 갱신 완료 (userId={})", userId);
    }

    /**
     * ✅ 회원 탈퇴 시 revoke + DB 삭제
     */
    @Override
    public void deleteAndRevoke(Long userId) {
        OAuth2Account account = oauth2AccountMapper.findByUserId(userId);
        if (account == null) {
            log.debug("⚠️ 연결된 OAuth2Account 없음 (userId={})", userId);
            return;
        }

        boolean revokeSuccess = false;
        String provider = account.getProvider().toLowerCase();

        switch (provider) {
            case "google":
                String accessTokenToRevoke = account.getAccessToken();
                String refreshToken = account.getRefreshToken();

                if (refreshToken != null) {
                    log.info("🔄 Google RefreshToken 존재 → AccessToken 갱신 시도");
                    String newAccessToken = refreshGoogleToken(account);
                    if (newAccessToken != null) {
                        accessTokenToRevoke = newAccessToken;
                    }
                }

                if (accessTokenToRevoke != null) {
                    revokeSuccess = revokeGoogle(accessTokenToRevoke);
                }

                if (!revokeSuccess && refreshToken != null) {
                    log.warn("⚠️ AccessToken revoke 실패 → RefreshToken으로 2차 시도");
                    revokeSuccess = revokeGoogle(refreshToken);
                }
                break;

            case "kakao":
                revokeKakao(account.getAccessToken());
                revokeSuccess = true;
                break;

            case "naver":
                revokeNaver(account.getAccessToken());
                revokeSuccess = true;
                break;
        }

        oauth2AccountMapper.deleteByUserId(userId);
        log.info("🧹 OAuth2Account 삭제 완료 (provider={}, userId={}, revoke={})",
                provider, userId, revokeSuccess ? "SUCCESS" : "FAIL");
    }

    /* =============================
       🔒 provider별 revoke/refresh 구현
       ============================= */

    /**
     * ✅ Google Token Refresh
     */
    private String refreshGoogleToken(OAuth2Account account) {
        String refreshToken = account.getRefreshToken();
        if (refreshToken == null || refreshToken.isEmpty()) {
            log.warn("⚠️ RefreshToken 없음 → 갱신 생략");
            return null;
        }

        try {
            String url = "https://oauth2.googleapis.com/token";
            String body = "grant_type=refresh_token"
                    + "&client_id=" + URLEncoder.encode(googleClientId, StandardCharsets.UTF_8)
                    + "&client_secret=" + URLEncoder.encode(googleClientSecret, StandardCharsets.UTF_8)
                    + "&refresh_token=" + URLEncoder.encode(refreshToken, StandardCharsets.UTF_8);

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
            HttpEntity<String> request = new HttpEntity<>(body, headers);

            ResponseEntity<Map> res = new RestTemplate().exchange(url, HttpMethod.POST, request, Map.class);

            if (res.getStatusCode() == HttpStatus.OK && res.getBody() != null) {
                String newAccessToken = (String) res.getBody().get("access_token");
                Integer expiresIn = (Integer) res.getBody().get("expires_in");

                if (newAccessToken != null) {
                    LocalDateTime newExpiresAt = (expiresIn != null)
                            ? LocalDateTime.now().plusSeconds(expiresIn)
                            : LocalDateTime.now().plusHours(1);

                    oauth2AccountMapper.updateAccessTokenOnly(account.getUserId(), newAccessToken, newExpiresAt);
                    log.info("✅ Google AccessToken 갱신 성공 (userId={})", account.getUserId());
                    return newAccessToken;
                }
            }
        } catch (HttpClientErrorException e) {
            log.error("❌ Google Token 갱신 실패: {}", e.getResponseBodyAsString());
        } catch (Exception e) {
            log.error("❌ Google Token 갱신 예외: {}", e.getMessage(), e);
        }
        return null;
    }

    /**
     * ✅ Google revoke
     */
    private boolean revokeGoogle(String tokenToRevoke) {
        if (tokenToRevoke == null || tokenToRevoke.isEmpty()) return false;
        try {
            String url = "https://oauth2.googleapis.com/revoke";
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
            String body = "token=" + URLEncoder.encode(tokenToRevoke, StandardCharsets.UTF_8);

            HttpEntity<String> req = new HttpEntity<>(body, headers);
            ResponseEntity<String> res = new RestTemplate().exchange(url, HttpMethod.POST, req, String.class);

            boolean success = (res.getStatusCode() == HttpStatus.OK || res.getStatusCode() == HttpStatus.NO_CONTENT);
            log.info("✅ Google revoke 결과: {}, token={}", success ? "성공" : "실패", tokenToRevoke.substring(0, 10) + "...");
            return success;
        } catch (Exception e) {
            log.error("❌ Google revoke 예외: {}", e.getMessage());
            return false;
        }
    }

    /**
     * ✅ Kakao revoke
     */
    private void revokeKakao(String accessToken) {
        try {
            String url = "https://kapi.kakao.com/v1/user/unlink";
            HttpHeaders headers = new HttpHeaders();
            headers.setBearerAuth(accessToken);
            new RestTemplate().exchange(url, HttpMethod.POST, new HttpEntity<>(headers), String.class);
            log.info("✅ Kakao unlink 성공");
        } catch (Exception e) {
            log.error("❌ Kakao revoke 실패: {}", e.getMessage());
        }
    }

    /**
     * ✅ Naver revoke (POST, form-urlencoded)
     */
    private void revokeNaver(String accessToken) {
        if (accessToken == null || accessToken.isBlank()) {
            log.warn("⚠️ Naver revoke 생략: accessToken 없음");
            return;
        }

        try {
            String url = "https://nid.naver.com/oauth2.0/token";

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

            String body = "grant_type=delete"
                    + "&client_id=" + URLEncoder.encode(naverClientId, StandardCharsets.UTF_8)
                    + "&client_secret=" + URLEncoder.encode(naverClientSecret, StandardCharsets.UTF_8)
                    + "&access_token=" + URLEncoder.encode(accessToken, StandardCharsets.UTF_8)
                    + "&service_provider=naver"; // ✅ 소문자 'naver'도 허용 (공식문서 예시 기준)

            HttpEntity<String> request = new HttpEntity<>(body, headers);
            ResponseEntity<String> response = new RestTemplate().exchange(
                    url, HttpMethod.POST, request, String.class
            );

            if (response.getStatusCode().is2xxSuccessful()) {
                log.info("✅ Naver revoke 성공 (status={})", response.getStatusCodeValue());
            } else {
                log.warn("⚠️ Naver revoke 응답 비정상 (status={}, body={})",
                        response.getStatusCodeValue(), response.getBody());
            }

        } catch (HttpClientErrorException e) {
            log.error("❌ Naver revoke 실패: {}", e.getResponseBodyAsString());
        } catch (Exception e) {
            log.error("❌ Naver revoke 예외: {}", e.getMessage(), e);
        }
    }
}