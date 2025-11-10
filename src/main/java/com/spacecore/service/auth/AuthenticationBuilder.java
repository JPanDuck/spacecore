package com.spacecore.service.auth;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Component;

@Slf4j
@Component
@RequiredArgsConstructor
public class AuthenticationBuilder {

    private final AuthenticationManager authenticationManager;

    /**
     * Spring Security의 AuthenticationManager를 사용하여 인증을 수행한다.
     * - username, password를 기반으로 Authentication 객체를 생성
     * - 내부적으로 CustomUserDetailsService + PasswordEncoder 검증 수행
     */
    public Authentication authenticate(String username, String password) {
        // username + password 기반 인증 토큰 생성
        UsernamePasswordAuthenticationToken authToken =
                new UsernamePasswordAuthenticationToken(username, password);

        // AuthenticationManager가 실제 인증 처리 수행
        Authentication authentication = authenticationManager.authenticate(authToken);

        log.debug("인증 성공 - 사용자: {}", authentication.getName());

        // Authentication 객체 반환 (JWT 토큰 생성 시 사용)
        return authentication;
    }
}