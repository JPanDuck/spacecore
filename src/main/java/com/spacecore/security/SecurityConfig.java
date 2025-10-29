package com.spacecore.security;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
public class SecurityConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
                // 보안으로 인한 404 문제로 webapp안에 정적 리소스를 넣어두었습니다 추후에 패치 예정 (2025.10.29)
                // 또한 HomeSecurity를 통해 index로 바로 접근할 수 있도록 하였습니다 추후에 수정 가능 (2025.10.29)
        http
                // 모든 요청을 인증 없이 접근 가능하게 설정 (개발단계)
                .authorizeHttpRequests(auth -> auth
                        .anyRequest().permitAll()
                )

                // CSRF 보호 비활성화 (전송 테스트나 JSP 개발 시 편의)
                .csrf(csrf -> csrf.disable())

                // 기본 로그인 폼 비활성화
                .formLogin(form -> form.disable())

                // 기본 로그아웃 기능 비활성화
                .logout(logout -> logout.disable())

                // HTTP Basic 인증 비활성화 (브라우저 팝업 로그인 차단)
                .httpBasic(basic -> basic.disable());

        return http.build();
    }
}
