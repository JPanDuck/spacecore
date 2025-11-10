package com.spacecore.security.oauth2;

import com.spacecore.domain.auth.RefreshToken;
import com.spacecore.domain.oauth2.OAuth2Account;
import com.spacecore.domain.user.User;
import com.spacecore.mapper.user.UserMapper;
import com.spacecore.security.jwt.JwtTokenProvider;
import com.spacecore.service.auth.RefreshTokenService;
import com.spacecore.service.oauth2.OAuth2AccountService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseCookie;
import org.springframework.security.core.Authentication;
import org.springframework.security.oauth2.client.OAuth2AuthorizedClient;
import org.springframework.security.oauth2.client.OAuth2AuthorizedClientService;
import org.springframework.security.oauth2.client.authentication.OAuth2AuthenticationToken;
import org.springframework.security.oauth2.core.oidc.user.DefaultOidcUser;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.time.Duration;
import java.time.LocalDateTime;
import java.time.ZoneId;

/**
 * ✅ OAuth2AuthenticationSuccessHandler (최신화)
 * - Google / Kakao / Naver OAuth2 로그인 성공 시 실행
 * - User 조회 및 JWT 발급
 * - OAuth2Account(DB) 토큰 동기화 (refresh_token 재사용 지원)
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class OAuth2AuthenticationSuccessHandler implements AuthenticationSuccessHandler {

    private final JwtTokenProvider jwtTokenProvider;
    private final RefreshTokenService refreshTokenService;
    private final UserMapper userMapper;
    private final OAuth2AuthorizedClientService authorizedClientService;
    private final OAuth2AccountService oauth2AccountService;

    private final Duration accessTokenDuration = Duration.ofHours(1);
    private final int refreshTokenDurationDays = 14;

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request,
                                        HttpServletResponse response,
                                        Authentication authentication)
            throws IOException, ServletException {

        try {
            // ✅ (1) 사용자 정보 추출
            String email = null;
            String name = null;
            String providerId = null;

            Object principal = authentication.getPrincipal();
            if (principal instanceof DefaultOidcUser) {
                // ✅ Google OIDC
                DefaultOidcUser oidcUser = (DefaultOidcUser) principal;
                email = oidcUser.getEmail();
                name = oidcUser.getFullName();
                providerId = oidcUser.getSubject(); // Google sub
            } else if (principal instanceof CustomOAuth2User) {
                // ✅ Kakao / Naver
                CustomOAuth2User oAuth2User = (CustomOAuth2User) principal;
                email = oAuth2User.getEmail();
                name = oAuth2User.getName();
                providerId = email;
            }

            if (email == null) {
                log.error("❌ OAuth2 인증 성공 후 이메일 정보를 가져올 수 없습니다. principal={}", principal);
                response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "이메일 정보를 가져올 수 없습니다.");
                return;
            }

            // ✅ (2) DB 사용자 조회
            User user = userMapper.findByEmail(email);
            if (user == null) {
                log.error("❌ OAuth2 성공 후 DB에서 사용자 찾기 실패: {}", email);
                response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "사용자 정보를 찾을 수 없습니다.");
                return;
            }

            // ✅ (3) SavedRequest 제거 (Redirect 잔재 방지)
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.removeAttribute("SPRING_SECURITY_SAVED_REQUEST");
            }

            // ✅ (4) JWT AccessToken & RefreshToken 발급
            String accessToken = jwtTokenProvider.generateToken(user, accessTokenDuration);
            RefreshToken refreshToken = refreshTokenService.create(user.getId(), refreshTokenDurationDays);

            // ✅ (5) OAuth2 Provider 토큰 저장/갱신
            if (authentication instanceof OAuth2AuthenticationToken) {
                OAuth2AuthenticationToken oauth2Token = (OAuth2AuthenticationToken) authentication;
                String provider = oauth2Token.getAuthorizedClientRegistrationId(); // google / kakao / naver

                OAuth2AuthorizedClient client = authorizedClientService.loadAuthorizedClient(provider, oauth2Token.getName());
                if (client != null && client.getAccessToken() != null) {

                    // 기존 OAuth2Account 조회 (refresh_token 재사용)
                    OAuth2Account existingAccount = oauth2AccountService.findByUserId(user.getId());

                    String providerAccessToken = client.getAccessToken().getTokenValue();
                    String providerRefreshToken = (client.getRefreshToken() != null)
                            ? client.getRefreshToken().getTokenValue()
                            : null;

                    // refresh_token 미발급 시 기존 DB 값 유지
                    if (providerRefreshToken == null && existingAccount != null && existingAccount.getRefreshToken() != null) {
                        providerRefreshToken = existingAccount.getRefreshToken();
                        log.info("♻️ 기존 OAuth2 RefreshToken 재사용 (provider={}, userId={})", provider, user.getId());
                    }

                    // 토큰 만료 시간 계산
                    LocalDateTime tokenExpiresAt = client.getAccessToken().getExpiresAt() != null
                            ? LocalDateTime.ofInstant(client.getAccessToken().getExpiresAt(), ZoneId.systemDefault())
                            : LocalDateTime.now().plusHours(1);

                    // DB 동기화
                    OAuth2Account account = new OAuth2Account();
                    account.setUserId(user.getId());
                    account.setProvider(provider);
                    account.setProviderId(providerId);
                    account.setAccessToken(providerAccessToken);
                    account.setRefreshToken(providerRefreshToken);
                    account.setTokenExpiresAt(tokenExpiresAt);

                    oauth2AccountService.saveOrUpdate(account);
                    log.info("🔐 OAuth2Account 저장/갱신 완료 - provider={}, userId={}, refreshToken여부={}",
                            provider, user.getId(), providerRefreshToken != null);
                } else {
                    log.warn("⚠️ OAuth2AuthorizedClient 정보를 불러올 수 없습니다. provider={}", oauth2Token.getAuthorizedClientRegistrationId());
                }
            }

            // ✅ (6) JWT Access/Refresh 쿠키 발급
            ResponseCookie accessCookie = ResponseCookie.from("access_token", accessToken)
                    .httpOnly(false)  // JS 접근 허용 (localStorage 동기화 목적)
                    .secure(false)
                    .path("/")
                    .maxAge(accessTokenDuration)
                    .sameSite("Lax")
                    .build();

            ResponseCookie refreshCookie = ResponseCookie.from("refresh_token", refreshToken.getToken())
                    .httpOnly(true)
                    .secure(false)
                    .path("/")
                    .maxAge(Duration.ofDays(refreshTokenDurationDays))
                    .sameSite("Lax")
                    .build();

            response.addHeader(HttpHeaders.SET_COOKIE, accessCookie.toString());
            response.addHeader(HttpHeaders.SET_COOKIE, refreshCookie.toString());

            log.info("✅ OAuth2 로그인 성공 - username={}, email={}", user.getUsername(), user.getEmail());

            // ✅ (7) localStorage 동기화 + Redirect
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

        } catch (Exception e) {
            log.error("💥 OAuth2AuthenticationSuccessHandler 처리 중 예외 발생: {}", e.getMessage(), e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "OAuth2 로그인 처리 중 오류가 발생했습니다.");
        }
    }
}