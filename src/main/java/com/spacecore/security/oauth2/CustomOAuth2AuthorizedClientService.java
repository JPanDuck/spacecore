package com.spacecore.security.oauth2;

import com.spacecore.mapper.user.UserMapper;
import com.spacecore.service.oauth2.OAuth2AccountService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.Authentication;
import org.springframework.security.oauth2.client.OAuth2AuthorizedClient;
import org.springframework.security.oauth2.client.OAuth2AuthorizedClientService;
import org.springframework.security.oauth2.core.OAuth2RefreshToken;
import org.springframework.security.oauth2.core.oidc.user.DefaultOidcUser;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;

/**
 * ✅ CustomOAuth2AuthorizedClientService
 *  - Google / Kakao / Naver OIDC 대응
 *  - RefreshToken 저장 관리 (oauth2_account 테이블)
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class CustomOAuth2AuthorizedClientService implements OAuth2AuthorizedClientService {

    private final UserMapper userMapper;
    private final OAuth2AccountService oAuth2AccountService;

    @Override
    public void saveAuthorizedClient(OAuth2AuthorizedClient authorizedClient, Authentication principal) {
        OAuth2RefreshToken refreshToken = authorizedClient.getRefreshToken();

        // ✅ refresh_token 없으면 바로 종료
        if (refreshToken == null) {
            log.warn("⚠️ RefreshToken이 존재하지 않음 (Google이 반환하지 않음)");
            return;
        }

        String tokenValue = refreshToken.getTokenValue() != null ? refreshToken.getTokenValue().trim() : "";
        if (tokenValue.isEmpty()) {
            log.warn("⚠️ RefreshToken 값이 비어 있어서 저장 생략 (Principal: {})", principal.getName());
            return;
        }

        // ✅ 만료일 계산 (issuedAt 기준 +14일)
        Instant issuedAt = refreshToken.getIssuedAt();
        LocalDateTime expiry = issuedAt != null
                ? LocalDateTime.ofInstant(issuedAt, ZoneId.systemDefault()).plusDays(14)
                : LocalDateTime.now().plusDays(14);

        try {
            String email = null;
            Object principalObj = principal.getPrincipal();

            // ✅ Google OIDC
            if (principalObj instanceof DefaultOidcUser) {
                DefaultOidcUser oidcUser = (DefaultOidcUser) principalObj;
                email = oidcUser.getEmail();
            }
            // ✅ CustomOAuth2User (Kakao / Naver)
            else if (principalObj instanceof CustomOAuth2User) {
                CustomOAuth2User customUser = (CustomOAuth2User) principalObj;
                email = customUser.getEmail();
            }
            // ✅ Fallback (principalName이 이메일일 경우)
            else if (authorizedClient.getPrincipalName() != null &&
                    authorizedClient.getPrincipalName().contains("@")) {
                email = authorizedClient.getPrincipalName();
            }

            if (email == null) {
                log.warn("⚠️ 이메일 정보를 찾을 수 없음 → RefreshToken 저장 생략");
                return;
            }

            Long userId = userMapper.findIdByEmail(email);
            if (userId == null) {
                log.warn("⚠️ 이메일에 해당하는 사용자 없음: {}", email);
                return;
            }

            // ✅ DB 반영 (refresh_token만 갱신)
            oAuth2AccountService.updateTokens(userId, null, tokenValue, expiry);
            log.info("✅ RefreshToken DB 반영 완료: userId={}, email={}, 만료={}", userId, email, expiry);

        } catch (Exception e) {
            log.error("❌ RefreshToken 저장 중 예외 발생: {}", e.getMessage(), e);
        }
    }

    @Override
    public OAuth2AuthorizedClient loadAuthorizedClient(String clientRegistrationId, String principalName) {
        return null; // 저장 전용
    }

    @Override
    public void removeAuthorizedClient(String clientRegistrationId, String principalName) {
        log.info("🧹 AuthorizedClient 제거: registrationId={}, principalName={}",
                clientRegistrationId, principalName);
    }
}