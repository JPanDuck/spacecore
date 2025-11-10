package com.spacecore.security.oauth2;

import com.spacecore.domain.oauth2.OAuth2Account;
import com.spacecore.domain.user.User;
import com.spacecore.mapper.user.UserMapper;
import com.spacecore.service.oauth2.OAuth2AccountService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Map;

/**
 * ✅ CustomOAuth2UserService (최신화)
 *  - Google, Kakao, Naver 통합 로그인 지원
 *  - User / OAuth2Account 자동 등록 및 갱신
 *  - 일반 로그인용 refresh_tokens 테이블은 건드리지 않음
 *  - refresh_token은 OAuth2AuthenticationSuccessHandler 단계에서 보강 가능
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class CustomOAuth2UserService extends DefaultOAuth2UserService {

    private final UserMapper userMapper;
    private final OAuth2AccountService oauth2AccountService;

    @Override
    @SuppressWarnings("unchecked")
    public OAuth2User loadUser(OAuth2UserRequest userRequest) throws OAuth2AuthenticationException {

        String provider = userRequest.getClientRegistration().getRegistrationId(); // google, naver, kakao
        log.info("🔑 [OAuth2] provider={}, accessToken={}", provider,
                userRequest.getAccessToken() != null ? userRequest.getAccessToken().getTokenValue() : "null");

        OAuth2User oAuth2User;
        try {
            oAuth2User = super.loadUser(userRequest);
        } catch (OAuth2AuthenticationException ex) {
            log.error("❌ OAuth2 사용자 정보 로드 실패 - provider={}, message={}", provider, ex.getMessage(), ex);
            throw ex;
        }

        Map<String, Object> attrs = oAuth2User.getAttributes();
        String email = null;
        String name = null;
        String providerId = null;

        // ✅ provider별 사용자 정보 추출
        switch (provider) {
            case "google":
                email = (String) attrs.get("email");
                name = (String) attrs.get("name");
                providerId = (String) attrs.get("sub");
                break;

            case "kakao":
                log.info("⭐ Kakao attributes 전체 = {}", attrs);
                Map<String, Object> kakaoAccount = (Map<String, Object>) attrs.get("kakao_account");

                if (kakaoAccount == null) {
                    throw new OAuth2AuthenticationException("카카오 계정 정보가 비어 있습니다.");
                }

                email = (String) kakaoAccount.get("email");
                Map<String, Object> profile = (Map<String, Object>) kakaoAccount.get("profile");
                name = profile != null ? (String) profile.get("nickname") : null;
                providerId = String.valueOf(attrs.get("id"));

                if (email == null || email.isBlank()) {
                    email = "kakao_" + providerId + "@kakao.local";
                }
                if (name == null || name.isBlank()) {
                    name = "KakaoUser";
                }
                break;

            case "naver":
                Map<String, Object> response = (Map<String, Object>) attrs.get("response");
                if (response != null) {
                    email = (String) response.get("email");
                    name = (String) response.get("name");
                    providerId = (String) response.get("id");
                }
                break;

            default:
                log.warn("⚠️ 지원되지 않는 provider: {}", provider);
        }

        if (!"kakao".equals(provider) && email == null) {
            log.error("❌ OAuth2 로그인 실패 - provider={}, email=null", provider);
            throw new OAuth2AuthenticationException("이메일 정보를 가져올 수 없습니다. provider=" + provider);
        }

        // ✅ 1️⃣ 사용자 조회 또는 신규 생성
        User existing = userMapper.findByEmail(email);
        if (existing == null) {
            log.info("🆕 [{}] 신규 OAuth2 사용자 등록 시도 - email={}", provider, email);

            User newUser = new User();
            String base = email != null && email.contains("@") ? email.split("@")[0] : provider + "_user";
            newUser.setUsername(base + "_" + System.currentTimeMillis());
            newUser.setEmail(email);
            newUser.setName(name != null ? name : provider + "User");
            newUser.setPassword("OAUTH_" + provider.toUpperCase() + "_USER");
            newUser.setRole("USER");
            newUser.setStatus("ACTIVE");
            newUser.setIsTempPassword("N");
            newUser.setProvider(provider);
            newUser.setProviderId(providerId);
            userMapper.insert(newUser);

            existing = userMapper.findByEmail(email);
            log.info("✅ [{}] 신규 OAuth2 사용자 등록 완료: {}", provider, email);
        } else {
            if ("SUSPENDED".equalsIgnoreCase(existing.getStatus())) {
                throw new OAuth2AuthenticationException("정지된 계정입니다.");
            }

            if (existing.getProvider() == null) {
                existing.setProvider(provider);
                existing.setProviderId(providerId);
                userMapper.updateProviderInfo(existing);
            }

            log.info("✅ [{}] 기존 OAuth2 사용자 로그인: {}", provider, email);
        }

        // ✅ 2️⃣ Access Token / Refresh Token 처리
        String accessToken = userRequest.getAccessToken().getTokenValue();
        LocalDateTime tokenExpiresAt = userRequest.getAccessToken().getExpiresAt() != null
                ? LocalDateTime.ofInstant(userRequest.getAccessToken().getExpiresAt(), ZoneId.systemDefault())
                : LocalDateTime.now().plusHours(1);

        // 🔍 Debug용: 추가 파라미터 전체 출력
        Map<String, Object> additionalParams = userRequest.getAdditionalParameters();
        log.debug("🧩 [{}] additionalParameters = {}", provider, additionalParams);

        // Spring OAuth2 구조상 이곳에서는 refresh_token을 대부분 받지 못함 (항상 null)
        String refreshToken = null;
        Object rtObj = additionalParams != null ? additionalParams.get("refresh_token") : null;
        if (rtObj instanceof String) {
            refreshToken = ((String) rtObj).trim();
        }

        log.info("🔍 [{}] provider refresh_token={}", provider,
                (refreshToken != null && !refreshToken.isEmpty()) ? "수신됨" : "없음/미발급");

        // ✅ 3️⃣ OAuth2Account 테이블 저장/갱신
        OAuth2Account account = new OAuth2Account();
        account.setUserId(existing.getId());
        account.setProvider(provider);
        account.setProviderId(providerId);
        account.setAccessToken(accessToken);
        account.setRefreshToken(refreshToken);
        account.setTokenExpiresAt(tokenExpiresAt);

        oauth2AccountService.saveOrUpdate(account);
        log.info("✅ [{}] OAuth2Account saveOrUpdate 완료 (userId={}, hasRefreshToken={})",
                provider, existing.getId(), refreshToken != null);

        // ✅ 4️⃣ 사용자 정보 객체 반환
        return new CustomOAuth2User(existing, oAuth2User.getAttributes());
    }
}