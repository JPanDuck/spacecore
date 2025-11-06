package com.spacecore.security.jwt;

import com.spacecore.domain.user.User;
import com.spacecore.mapper.user.UserMapper;
import com.spacecore.security.CustomUserDetails;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.JwtException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Collections;
import java.util.List;

/**
 * ✅ JWT 인증 필터 (최신화)
 * - 매 요청마다 JWT 검증
 * - 정지 계정 차단 및 쿠키 무효화
 * - 세션 비활성화 (완전 Stateless)
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private final JwtTokenProvider jwtTokenProvider;
    private final UserMapper userMapper;

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain filterChain)
            throws ServletException, IOException {

        try {
            String token = resolveToken(request);

            if (token != null) {
                Claims claims = jwtTokenProvider.validateAndGetClaims(token);
                String username = claims.getSubject();
                String role = (String) claims.get("role");

                // ✅ 사용자 존재 여부 확인
                User user = userMapper.findByUsername(username);
                if (user == null) {
                    log.warn("❌ JWT 인증 실패: 존재하지 않는 사용자 [{}]", username);
                    clearAuthCookies(response);
                    response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "유효하지 않은 사용자입니다.");
                    return;
                }

                // ✅ 정지된 계정 차단
                if ("SUSPENDED".equalsIgnoreCase(user.getStatus())) {
                    log.warn("🚫 정지된 계정 접근 차단: {}", username);
                    clearAuthCookies(response);
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "정지된 계정입니다.");
                    return;
                }

                // ✅ SecurityContext 생성 및 세션 비활성화
                CustomUserDetails userDetails = new CustomUserDetails(user);
                List<SimpleGrantedAuthority> authorities =
                        Collections.singletonList(new SimpleGrantedAuthority("ROLE_" + role));

                UsernamePasswordAuthenticationToken authentication =
                        new UsernamePasswordAuthenticationToken(userDetails, null, authorities);
                authentication.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));

                // ✅ 세션에 저장하지 않도록 새로운 Context로 대체
                SecurityContext context = SecurityContextHolder.createEmptyContext();
                context.setAuthentication(authentication);
                SecurityContextHolder.setContext(context);

                // ✅ 세션에 SecurityContext 저장 방지 (Stateless)
                request.setAttribute(
                        org.springframework.security.web.context.HttpSessionSecurityContextRepository.SPRING_SECURITY_CONTEXT_KEY,
                        null
                );

                log.debug("✅ JWT 인증 성공: {} (Role: {})", username, role);
            } else {
                log.trace("⚪ JWT 토큰 없음 - 익명 요청: {}", request.getRequestURI());
            }

        } catch (ExpiredJwtException e) {
            log.warn("⚠️ 만료된 JWT 토큰 요청 - URI: {}, Message: {}", request.getRequestURI(), e.getMessage());
            clearAuthCookies(response);
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "토큰이 만료되었습니다.");
            return;

        } catch (JwtException e) {
            log.warn("⚠️ 잘못된 JWT 토큰 - URI: {}, Message: {}", request.getRequestURI(), e.getMessage());
            clearAuthCookies(response);
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "유효하지 않은 토큰입니다.");
            return;

        } catch (Exception e) {
            log.error("💥 JWT 필터 처리 중 예외 발생 - URI: {}, Error: {}", request.getRequestURI(), e.getMessage(), e);
            clearAuthCookies(response);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "인증 처리 중 오류가 발생했습니다.");
            return;
        }

        // 다음 필터로 진행
        filterChain.doFilter(request, response);
    }

    /**
     * ✅ JWT 토큰 추출 (Authorization 헤더 > access_token 쿠키)
     */
    private String resolveToken(HttpServletRequest request) {
        String header = request.getHeader("Authorization");
        if (header != null && header.startsWith("Bearer ")) {
            return header.substring(7);
        }

        if (request.getCookies() != null) {
            for (Cookie cookie : request.getCookies()) {
                if ("access_token".equals(cookie.getName())) {
                    return cookie.getValue();
                }
            }
        }
        return null;
    }

    /**
     * ✅ 쿠키 무효화 (정지 계정, 만료, 잘못된 토큰 등)
     */
    private void clearAuthCookies(HttpServletResponse response) {
        Cookie access = new Cookie("access_token", null);
        access.setPath("/");
        access.setMaxAge(0);
        access.setHttpOnly(true);

        Cookie refresh = new Cookie("refresh_token", null);
        refresh.setPath("/");
        refresh.setMaxAge(0);
        refresh.setHttpOnly(true);

        Cookie session = new Cookie("JSESSIONID", null);
        session.setPath("/");
        session.setMaxAge(0);

        response.addCookie(access);
        response.addCookie(refresh);
        response.addCookie(session);
        log.debug("🧹 인증 관련 쿠키 모두 삭제 완료");
    }
}