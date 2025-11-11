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

@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
@EnableGlobalMethodSecurity(prePostEnabled = true)
public class SecurityConfig {

    private final JwtAuthenticationFilter jwtAuthenticationFilter;
    private final CustomOAuth2UserService customOAuth2UserService;
    private final OAuth2AuthenticationSuccessHandler oAuth2AuthenticationSuccessHandler;

    /**
     * 비밀번호 암호화
     */
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    /**
     * AuthenticationManager 등록
     */
    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration configuration) throws Exception {
        return configuration.getAuthenticationManager();
    }

    /**
     *  정적 리소스 보안 필터 제외
     */
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

    /**
     * 필터 체인 구성 (JWT + OAuth2 + Stateless)
     */
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                // 기본 보안 기능 비활성화
                .csrf().disable()
                .httpBasic().disable()
                .formLogin().disable()

                // ✅ 세션 관리 - OAuth2Login 위해 IF_REQUIRED
                // ✅ JWT 요청은 Stateless 하게 필터에서 처리 (JwtAuthenticationFilter 내부 제어)
                .sessionManagement()
                .sessionCreationPolicy(SessionCreationPolicy.IF_REQUIRED)
                .and()

                // 인가 규칙 설정
                .authorizeRequests()
                // ✅ 공개 경로 (비회원 접근 가능)
                .antMatchers(
                        "/", "/index",
                        "/auth/login",
                        "/auth/register",
                        "/auth/find-password",
                        "/auth/reset-password",
                        "/oauth2/**",
                        "/error",
                        "/api/auth/login",
                        "/api/auth/register",
                        "/api/auth/validate",
                        "/api/auth/refresh",
                        "/api/auth/find-password",
                        "/api/auth/reset-password",
                        "/reviews/**", "/api/reviews/**",
                        "/chatbot/**",
                        "/map/**",
                        "/offices/**", "/api/offices/**",
                        "/offices/*/rooms/**",
                        "/rooms/detail/**",
                        "/reservations/**",
                        "/reservations/add/**",
                        "/reservations/detail/**",
                        "/notices/**", "/api/notices/**",
                        "/payments/detail/**",
                        "/api/rooms/**",
                        "/api/reservations/calendar/**"

                ).permitAll()

                // ✅ 관리자 전용 경로
                .antMatchers(
                        "/admin/**",          // 관리자 대시보드, 관리 기능 등
                        "/api/admin/**"       // 관리자용 API
                ).hasRole("ADMIN")

                // ✅ 일반 사용자 전용 경로
                .antMatchers(
                        "/user/**",
                        "/api/user/**",
                        "/favorites/**",
                        "/api/notifications/**"
                ).hasAnyRole("USER", "ADMIN")

                .anyRequest().authenticated()
                .and()

                // OAuth2 로그인
                .oauth2Login()
                .loginPage("/auth/login")
                .userInfoEndpoint()
                .userService(customOAuth2UserService)
                .and()
                .successHandler(oAuth2AuthenticationSuccessHandler)

                // 로그아웃 (JWT 기반 - 쿠키 제거만)
                .and()
                .logout()
                .logoutUrl("/logout")
                .logoutSuccessUrl("/auth/login")
                .deleteCookies("access_token", "refresh_token")
                .clearAuthentication(true)
                .invalidateHttpSession(true);;

        // JWT 필터 등록 (UsernamePasswordAuthenticationFilter보다 앞에)
        http.addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }
}