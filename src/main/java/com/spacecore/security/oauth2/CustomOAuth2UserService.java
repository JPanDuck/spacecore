package com.spacecore.security.oauth2;

import com.spacecore.domain.user.User;
import com.spacecore.mapper.auth.RefreshTokenMapper;
import com.spacecore.mapper.user.UserMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Map;

@Slf4j
@Service
@RequiredArgsConstructor
public class CustomOAuth2UserService extends DefaultOAuth2UserService {

    private final UserMapper userMapper;
    private final RefreshTokenMapper refreshTokenMapper;

    @Override
    @Transactional
    public OAuth2User loadUser(OAuth2UserRequest userRequest) {
        OAuth2User oAuth2User = super.loadUser(userRequest);
        Map<String, Object> attrs = oAuth2User.getAttributes();

        String provider = userRequest.getClientRegistration().getRegistrationId(); // "google"
        String email = (String) attrs.get("email");
        String name = (String) attrs.get("name");

        // ✅ 사용자 존재 여부 확인
        User existing = userMapper.findByEmail(email);

        if (existing == null) {
            // 신규 가입 처리
            User newUser = new User();
            String base = email != null && email.contains("@") ? email.split("@")[0] : "user";
            newUser.setUsername(base + "_" + System.currentTimeMillis());
            newUser.setEmail(email);
            newUser.setName(name);
            newUser.setPassword("OAUTH_" + provider.toUpperCase() + "_USER");
            newUser.setRole("USER");
            newUser.setStatus("ACTIVE");
            newUser.setIsTempPassword("N");
            newUser.setProvider(provider);       // ✅ provider 저장
            newUser.setProviderId(email);        // ✅ provider_id 대체용
            userMapper.insert(newUser);

            existing = newUser;
            log.info("🆕 OAuth2 신규 등록: {} ({})", email, provider);
        } else {
            // ✅ 정지 계정 차단
            if ("SUSPENDED".equalsIgnoreCase(existing.getStatus())) {
                log.warn("🚫 정지된 계정(Google) 로그인 차단: {}", email);
                throw new OAuth2AuthenticationException("정지된 계정입니다. 관리자에게 문의하세요.");
            }

            // ✅ provider 정보 갱신 (기존 DB에 없을 경우)
            if (existing.getProvider() == null) {
                existing.setProvider(provider);
                existing.setProviderId(email);
                userMapper.updateProviderInfo(existing);
            }

            log.info("✅ OAuth2 기존 사용자 로그인: {} ({})", email, provider);
        }

        // ✅ refresh_token 저장 (있을 때만)
        Map<String, Object> additionalParams = userRequest.getAdditionalParameters();
        if (additionalParams.containsKey("refresh_token")) {
            String refreshToken = (String) additionalParams.get("refresh_token");
            LocalDateTime expiry = LocalDateTime.now().plusDays(14); // 기본 14일 유효 (Google 기본값)

            refreshTokenMapper.saveOrUpdate(existing.getId(), refreshToken, expiry);
            log.info("🔄 Google refresh_token 저장 완료: userId={}, 만료일={}", existing.getId(), expiry);
        } else {
            log.debug("⚠️ Google refresh_token 없음 (일반적인 경우)");
        }

        // ✅ SecurityContext 등록
        return new CustomOAuth2User(existing, oAuth2User.getAttributes());
    }
}