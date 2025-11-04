package com.spacecore.security.oauth2;

import com.spacecore.domain.auth.RefreshToken;
import com.spacecore.domain.user.User;
import com.spacecore.mapper.user.UserMapper;
import com.spacecore.security.jwt.JwtTokenProvider;
import com.spacecore.service.auth.RefreshTokenService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseCookie;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.time.Duration;

/**
 * ✅ OAuth2 로그인 성공 핸들러
 * - JWT 발급 및 Refresh Token 저장
 * - AccessToken/RefreshToken 쿠키 저장
 * - localStorage에도 정보 저장 (JS 실행)
 * - 로그인 성공 시 /index 로 리다이렉트
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class OAuth2AuthenticationSuccessHandler implements AuthenticationSuccessHandler {

    private final JwtTokenProvider jwtTokenProvider;
    private final RefreshTokenService refreshTokenService;
    private final UserMapper userMapper;

    private final Duration accessTokenDuration = Duration.ofHours(1);
    private final int refreshTokenDurationDays = 14;

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request,
                                        HttpServletResponse response,
                                        Authentication authentication)
            throws IOException, ServletException {

        // ✅ (1) OAuth2 사용자 정보 조회
        CustomOAuth2User oAuth2User = (CustomOAuth2User) authentication.getPrincipal();
        String email = oAuth2User.getEmail();

        // ✅ (2) DB에서 사용자 조회
        User user = userMapper.findByEmail(email);
        if (user == null) {
            log.error("❌ OAuth2 인증 성공 후 DB에서 사용자를 찾을 수 없습니다: {}", email);
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "사용자 정보를 찾을 수 없습니다.");
            return;
        }

        // ✅ (3) SavedRequest 제거 (redirect 캐시 방지)
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.removeAttribute("SPRING_SECURITY_SAVED_REQUEST");
        }

        // ✅ (4) Access Token 발급
        String accessToken = jwtTokenProvider.generateToken(user, accessTokenDuration);

        // ✅ (5) Refresh Token 생성 및 저장
        RefreshToken refreshToken = refreshTokenService.create(user.getId(), refreshTokenDurationDays);

        // ✅ (6) Access Token → JS 접근 가능 쿠키 저장
        ResponseCookie accessCookie = ResponseCookie.from("access_token", accessToken)
                .httpOnly(false)
                .secure(false)
                .path("/")
                .maxAge(accessTokenDuration)
                .sameSite("Lax")
                .build();

        // ✅ (7) Refresh Token → HttpOnly 쿠키 저장
        ResponseCookie refreshCookie = ResponseCookie.from("refresh_token", refreshToken.getToken())
                .httpOnly(true)
                .secure(false)
                .path("/")
                .maxAge(Duration.ofDays(refreshTokenDurationDays))
                .sameSite("Lax")
                .build();

        // ✅ (8) 쿠키 추가
        response.addHeader(HttpHeaders.SET_COOKIE, accessCookie.toString());
        response.addHeader(HttpHeaders.SET_COOKIE, refreshCookie.toString());

        log.info("✅ OAuth2 로그인 성공 - username: {}, email: {}", user.getUsername(), user.getEmail());

        // ✅ (9) localStorage 설정 및 index로 이동 (JS 스크립트 삽입)
        response.setContentType("text/html; charset=UTF-8");
        response.getWriter().write(
                "<script>" +
                        "localStorage.setItem('accessToken', '" + accessToken + "');" +
                        "localStorage.setItem('refreshToken', '" + refreshToken.getToken() + "');" +
                        "localStorage.setItem('username', '" + user.getName() + "');" +
                        "localStorage.setItem('role', '" + user.getRole() + "');" +
                        "window.location.href='" + request.getContextPath() + "/index';" +
                        "</script>"
        );
    }
}
