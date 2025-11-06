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

    /** ✅ 보안 필터 체인 (JWT + OAuth2 + Stateless + SessionLogin 지원) */
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {

        http
                // 기본 보안 비활성화
                .csrf().disable()
                .httpBasic().disable()
                .formLogin().disable()

                // ✅ 세션 정책 (OAuth2Login 위해 IF_REQUIRED)
                // ✅ JWT 요청은 Stateless 하게 처리 (JwtAuthenticationFilter 내부 제어)
                .sessionManagement()
                .sessionCreationPolicy(SessionCreationPolicy.IF_REQUIRED)
                .and()

                // ✅ 인가 규칙 설정
                .authorizeRequests()

                // 비회원 접근 가능 영역
                .antMatchers(
                        "/", "/index",
                        "/auth/**",
                        "/oauth2/**",
                        "/error",
                        "/api/auth/login",
                        "/api/auth/register",
                        "/api/auth/validate",
                        "/api/auth/refresh",
                        "/api/auth/find-password",
                        "/api/auth/reset-password",
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

                // 회원 전용 영역
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

                // 관리자 전용 영역
                .antMatchers(
                        "/admin/**",
                        "/api/admin/**"
                ).hasRole("ADMIN")

                // 그 외 요청은 인증 필요
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

                // ✅ 로그아웃 처리 (JWT 쿠키 삭제 + 세션 무효화)
                .logout()
                .logoutUrl("/logout")
                .logoutSuccessUrl("/auth/login")
                .deleteCookies("access_token", "refresh_token", "JSESSIONID")
                .clearAuthentication(true)
                .invalidateHttpSession(true);

        // ✅ JWT 인증 필터 등록 (UsernamePasswordAuthenticationFilter 앞에)
        http.addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }
}
