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
import java.io.IOException;
import java.time.Duration;

/**
 * ✅ OAuth2 로그인 성공 핸들러 (UserService 없이 직접 Mapper 사용)
 * - SecurityConfig와 순환 참조 완전 제거
 * - JWT 발급 및 쿠키 저장만 담당
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class OAuth2AuthenticationSuccessHandler implements AuthenticationSuccessHandler {

    private final JwtTokenProvider jwtTokenProvider;
    private final RefreshTokenService refreshTokenService;
    private final UserMapper userMapper; // ✅ Mapper 직접 주입

    private final Duration accessTokenDuration = Duration.ofHours(1);
    private final int refreshTokenDurationDays = 14;

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request,
                                        HttpServletResponse response,
                                        Authentication authentication)
            throws IOException, ServletException {

        // 1️⃣ 인증된 사용자 정보 가져오기
        CustomOAuth2User oAuth2User = (CustomOAuth2User) authentication.getPrincipal();
        String email = oAuth2User.getEmail();

        // 2️⃣ DB 조회 (null 체크)
        User user = userMapper.findByEmail(email);
        if (user == null) {
            log.error("OAuth2 인증 성공 후 DB에서 사용자를 찾을 수 없습니다: {}", email);
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "사용자를 찾을 수 없습니다.");
            return;
        }

        // 3️⃣ Access Token 발급
        String accessToken = jwtTokenProvider.generateToken(user, accessTokenDuration);

        // 4️⃣ Refresh Token 생성 및 DB 저장
        RefreshToken refreshToken = refreshTokenService.create(user.getId(), refreshTokenDurationDays);

        // 5️⃣ Refresh Token → HttpOnly 쿠키 저장
        ResponseCookie refreshCookie = ResponseCookie.from("refresh_token", refreshToken.getToken())
                .httpOnly(true)
                .secure(true)
                .path("/")
                .maxAge(Duration.ofDays(refreshTokenDurationDays))
                .sameSite("Lax")
                .build();

        // 6️⃣ Access Token → Header, Refresh Token → Cookie
        response.addHeader(HttpHeaders.AUTHORIZATION, "Bearer " + accessToken);
        response.addHeader(HttpHeaders.SET_COOKIE, refreshCookie.toString());

        log.info("✅ OAuth2 로그인 성공 - 사용자: {} ({})", user.getUsername(), email);

        // 7️⃣ 로그인 성공 후 리다이렉트
        response.sendRedirect("/auth/oauth2/success");
    }
}
