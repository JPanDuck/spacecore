package com.spacecore.security.oauth2;

import lombok.Getter;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.oauth2.core.user.OAuth2User;

import java.util.Collection;
import java.util.Map;

/**
 * ✅ OAuth2User 구현체
 * - SecurityContext에서 사용자 정보를 쉽게 꺼낼 수 있도록 래핑
 */
@Getter
public class CustomOAuth2User implements OAuth2User {

    private final Map<String, Object> attributes;
    private final String email;

    public CustomOAuth2User(Map<String, Object> attributes, String email) {
        this.attributes = attributes;
        this.email = email;
    }

    @Override
    public Map<String, Object> getAttributes() {
        return attributes;
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return null; // 권한은 JWT 인증 시 부여됨
    }

    @Override
    public String getName() {
        return email;
    }
}
