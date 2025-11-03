package com.spacecore.security.oauth2;

import com.spacecore.domain.user.User;
import com.spacecore.mapper.user.UserMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;

import java.util.Map;

@Slf4j
@Service
@RequiredArgsConstructor
public class CustomOAuth2UserService extends DefaultOAuth2UserService {

    private final UserMapper userMapper; // ✅ UserService 대신 직접 Mapper 사용

    @Override
    public OAuth2User loadUser(OAuth2UserRequest userRequest) {
        // 1️⃣ 구글 사용자 정보 가져오기
        OAuth2User oAuth2User = super.loadUser(userRequest);
        Map<String, Object> attrs = oAuth2User.getAttributes();

        String provider = userRequest.getClientRegistration().getRegistrationId(); // "google"
        String email = (String) attrs.get("email");
        String name = (String) attrs.get("name");
        String picture = (String) attrs.get("picture");

        // 2️⃣ DB 조회
        User existing = userMapper.findByEmail(email);

        if (existing == null) {
            // 신규 유저 등록
            User newUser = new User();
            String base = email != null && email.contains("@") ? email.split("@")[0] : "user";
            newUser.setUsername(base + "_" + System.currentTimeMillis());
            newUser.setEmail(email);
            newUser.setName(name);
            newUser.setRole("USER");
            newUser.setStatus("ACTIVE");
            newUser.setIsTempPassword("N");

            userMapper.insert(newUser); // ✅ 직접 insert

            log.info("🆕 OAuth2 신규 등록: {} ({})", email, provider);
        } else {
            log.info("✅ OAuth2 기존 사용자 로그인: {} ({})", email, provider);
        }

        // 3️⃣ CustomOAuth2User 객체 반환
        return new CustomOAuth2User(oAuth2User.getAttributes(), email);
    }
}
