package com.spacecore.security.oauth2;

import com.spacecore.domain.user.User;
import lombok.Getter;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.oauth2.core.user.OAuth2User;

import java.util.Collection;
import java.util.List;
import java.util.Map;

/**
 * ✅ OAuth2User 구현체 (확장 버전)
 * - SecurityContext에서 사용자 정보를 쉽게 꺼낼 수 있도록 래핑
 * - name, role, username 모두 포함
 */
@Getter
public class CustomOAuth2User implements OAuth2User {

    private final Long id;
    private final String username;
    private final String email;
    private final String name;
    private final String role;
    private final Map<String, Object> attributes;

    // ✅ User 객체를 바로 받도록 (DB 기반)
    public CustomOAuth2User(User user, Map<String, Object> attributes) {
        this.id = user.getId();
        this.username = user.getUsername();
        this.email = user.getEmail();
        this.name = user.getName();
        this.role = user.getRole();
        this.attributes = attributes;
    }

    @Override
    public Map<String, Object> getAttributes() {
        return attributes;
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return List.of(new SimpleGrantedAuthority("ROLE_" + role));
    }

    @Override
    public String getName() {
        // ✅ SecurityContext에서 name을 표시할 때도 사용됨
        return name != null ? name : username;
    }
}
