package com.spacecore.security.config;

import com.spacecore.security.jwt.JwtAuthenticationFilter;
import com.spacecore.security.oauth2.CustomOAuth2UserService;
import com.spacecore.security.oauth2.OAuth2AuthenticationSuccessHandler;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityCustomizer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

/**
 * ✅ SpaceCore Security Configuration
 * JWT + OAuth2 + Stateless 통합 보안 설정
 */
@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
@EnableGlobalMethodSecurity(prePostEnabled = true)
public class SecurityConfig {

    private final JwtAuthenticationFilter jwtAuthenticationFilter;
    private final CustomOAuth2UserService customOAuth2UserService;
    private final OAuth2AuthenticationSuccessHandler oAuth2AuthenticationSuccessHandler;

    /** ✅ 비밀번호 암호화 */
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    /** ✅ AuthenticationManager 등록 */
    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration configuration) throws Exception {
        return configuration.getAuthenticationManager();
    }

    /** ✅ 정적 리소스 보안 제외 */
    @Bean
    public WebSecurityCustomizer webSecurityCustomizer() {
        return (web) -> web.ignoring().antMatchers(
                "/css/**",
                "/js/**",
                "/img/**",
                "/images/**",
                "/video/**",
                "/favicon.ico",
                "/favicon-*.png"
        );
    }

    /** ✅ 보안 필터 체인 (JWT + OAuth2 + Stateless) */
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                // 기본 보안 비활성화
                .csrf().disable()
                .httpBasic().disable()
                .formLogin().disable()

                // 세션 비활성화 (JWT 기반)
                .sessionManagement()
                .sessionCreationPolicy(SessionCreationPolicy.STATELESS)
                .and()

                // 인가 규칙 설정
                .authorizeRequests()

                // ✅ 공개 경로 (비회원 접근 가능)
                .antMatchers(
                        "/", "/index",
                        "/auth/**",
                        "/oauth2/**",
                        "/error",
                        "/api/auth/login",
                        "/api/auth/register",
                        "/api/auth/validate",
                        "/api/auth/refresh",
                        "/reviews/**",
                        "/api/reviews/**",
                        "/chatbot/**",
                        "/map/**",
                        "/rooms/**",
                        "/offices/**",
                        "/api/offices", "/api/offices/**",
                        "/api/rooms", "/api/rooms/**",
                        "/reservations/", "/reservations/detail/**",
                        "/notices/**",
                        "/virtual-accounts/detail/**"
                ).permitAll()

                // ✅ 회원만 접근 가능한 영역 (JWT 인증 필요)
                .antMatchers(
                        "/user/**",
                        "/api/user/**",
                        "/favorites/**",
                        "/notifications/**",
                        "/api/notifications/**",
                        "/reservations/add/**",
                        "/reservations/edit/**",
                        "/api/reservations",
                        "/api/reservations/**/cancel",
                        "/payments/**",
                        "/api/payments/**"
                ).hasAnyRole("USER", "ADMIN")

                // ✅ 관리자 전용 영역
                .antMatchers(
                        "/admin/**",
                        "/api/admin/**"
                ).hasRole("ADMIN")

                // ✅ 그 외 요청은 인증 필요
                .anyRequest().authenticated()
                .and()

                // ✅ OAuth2 로그인 설정
                .oauth2Login()
                .loginPage("/auth/login")
                .userInfoEndpoint()
                .userService(customOAuth2UserService)
                .and()
                .successHandler(oAuth2AuthenticationSuccessHandler)
                .and()

                // ✅ 로그아웃 (JWT 기반)
                .logout()
                .logoutUrl("/logout")
                .logoutSuccessUrl("/auth/login")
                .deleteCookies("access_token", "refresh_token");

        // ✅ JWT 필터 등록 (UsernamePasswordAuthenticationFilter보다 앞에)
        http.addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }
}
