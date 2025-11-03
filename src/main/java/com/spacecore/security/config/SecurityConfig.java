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
     * ✅ 비밀번호 암호화
     */
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    /**
     * ✅ 인증 매니저 등록 (로그인 시 AuthenticationBuilder에서 사용)
     */
    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration configuration) throws Exception {
        return configuration.getAuthenticationManager();
    }

    /**
     * ✅ 정적 리소스 보안 필터 완전 제외 (성능 향상)
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
     * ✅ 보안 필터 체인 설정 (JWT + OAuth2 + Stateless)
     */
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                // 기본 시큐리티 기능 비활성화
                .csrf().disable()
                .httpBasic().disable()
                .formLogin().disable()

                // ✅ 세션 사용 안 함 (JWT 기반)
                .sessionManagement()
                .sessionCreationPolicy(SessionCreationPolicy.STATELESS)
                .and()

                // ✅ 요청별 인가 규칙
                .authorizeRequests()
                .antMatchers(
                        "/", "/auth/**", "/api/auth/**",
                        "/oauth2/**", "/error"
                ).permitAll()
                .anyRequest().authenticated()
                .and()

                // ✅ OAuth2 로그인
                .oauth2Login()
                .loginPage("/auth/login")
                .userInfoEndpoint()
                .userService(customOAuth2UserService)
                .and()
                .successHandler(oAuth2AuthenticationSuccessHandler)

                // ✅ 로그아웃 설정 (JWT 기반이라 실제 동작은 AuthRestController에서 처리)
                .and()
                .logout()
                .logoutUrl("/logout")
                .logoutSuccessUrl("/auth/login")
                .deleteCookies("access_token", "refresh_token");

        // ✅ JWT 인증 필터를 UsernamePasswordAuthenticationFilter보다 먼저 등록
        http.addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }
}
