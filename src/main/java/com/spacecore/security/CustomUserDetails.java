package com.spacecore.security;

import com.spacecore.domain.user.User;
import lombok.Getter;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.Collection;
import java.util.Collections;

/**
 * ✅ CustomUserDetails
 * ------------------------
 * - Spring Security 인증 컨텍스트에 저장되는 사용자 세부정보
 * - JWT, SecurityContextHolder 에서 활용됨
 */
@Getter
public class CustomUserDetails implements UserDetails {

    private final User user;

    public CustomUserDetails(User user) {
        this.user = user;
    }

    // ✅ User PK 반환
    public Long getId() {
        return user.getId();
    }

    // ✅ 이름 반환
    public String getName() {
        return user.getName();
    }

    // ✅ User Role 반환
    public String getRole() {
        return user.getRole();
    }

    // ✅ 권한 반환 (Spring Security 표준)
    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return Collections.singletonList(new SimpleGrantedAuthority("ROLE_" + user.getRole()));
    }

    @Override
    public String getPassword() {
        return user.getPassword();
    }

    @Override
    public String getUsername() {
        return user.getUsername();
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return !"SUSPENDED".equalsIgnoreCase(user.getStatus());
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return "ACTIVE".equalsIgnoreCase(user.getStatus());
    }
}