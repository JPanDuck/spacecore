package com.spacecore.security.oauth2;

import com.spacecore.mapper.auth.RefreshTokenMapper;
import com.spacecore.mapper.user.UserMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.Authentication;
import org.springframework.security.oauth2.client.OAuth2AuthorizedClient;
import org.springframework.security.oauth2.client.OAuth2AuthorizedClientService;
import org.springframework.security.oauth2.core.OAuth2RefreshToken;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;

@Slf4j
@Service
@RequiredArgsConstructor
public class CustomOAuth2AuthorizedClientService implements OAuth2AuthorizedClientService {

    private final RefreshTokenMapper refreshTokenMapper;
    private final UserMapper userMapper; // ✅ 추가 (이메일 → userId 매핑용)

    @Override
    public void saveAuthorizedClient(OAuth2AuthorizedClient authorizedClient, Authentication principal) {
        OAuth2RefreshToken refreshToken = authorizedClient.getRefreshToken();

        if (refreshToken == null) {
            log.warn("⚠️ RefreshToken이 존재하지 않음 (Google이 반환하지 않음)");
            return;
        }

        String principalName = authorizedClient.getPrincipalName(); // 대부분 이메일
        String tokenValue = refreshToken.getTokenValue();

        // ✅ issuedAt(Instant)을 LocalDateTime으로 변환 후 +14일 계산
        Instant issuedAt = refreshToken.getIssuedAt();
        LocalDateTime expiry = issuedAt != null
                ? LocalDateTime.ofInstant(issuedAt, ZoneId.systemDefault()).plusDays(14)
                : LocalDateTime.now().plusDays(14);

        try {
            Long userId;

            // principalName이 숫자 형태면 그대로 사용
            if (principalName.matches("\\d+")) {
                userId = Long.parseLong(principalName);
            } else {
                // 이메일이면 DB에서 userId 조회
                userId = userMapper.findIdByEmail(principalName);
            }

            if (userId != null) {
                refreshTokenMapper.saveOrUpdate(userId, tokenValue, expiry);
                log.info("✅ RefreshToken 저장 완료: userId={}, 만료={}", userId, expiry);
            } else {
                log.warn("⚠️ 해당 이메일에 매핑된 사용자 없음: {}", principalName);
            }

        } catch (Exception e) {
            log.error("❌ RefreshToken 저장 중 오류: {}", e.getMessage(), e);
        }
    }

    @Override
    public OAuth2AuthorizedClient loadAuthorizedClient(String clientRegistrationId, String principalName) {
        // 불필요 — 단순 revoke 용도만
        return null;
    }

    @Override
    public void removeAuthorizedClient(String clientRegistrationId, String principalName) {
        log.info("🧹 AuthorizedClient 제거: registrationId={}, principalName={}", clientRegistrationId, principalName);
    }
}