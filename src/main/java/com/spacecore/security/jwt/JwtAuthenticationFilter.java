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
 * ✅ JWT 인증 필터
 * - 매 요청마다 JWT 유효성 검증
 * - 유효한 경우 SecurityContext에 인증 정보 저장
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
            // ✅ 1. 토큰 추출
            String token = resolveToken(request);

            if (token != null) {
                // ✅ 2. 토큰 검증 및 클레임 추출
                Claims claims = jwtTokenProvider.validateAndGetClaims(token);
                String username = claims.getSubject();
                String role = (String) claims.get("role");

                // ✅ 3. 사용자 조회
                User user = userMapper.findByUsername(username);
                if (user == null) {
                    log.warn("❌ JWT 인증 실패: 존재하지 않는 사용자 [{}]", username);
                    response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "유효하지 않은 사용자입니다.");
                    return;
                }

                if ("SUSPENDED".equalsIgnoreCase(user.getStatus())) {
                    log.warn("🚫 정지된 계정 접근 차단: {}", username);
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "정지된 계정입니다.");
                    return;
                }

                // ✅ 4. 인증 객체 생성 및 컨텍스트 등록
                CustomUserDetails userDetails = new CustomUserDetails(user);
                List<SimpleGrantedAuthority> authorities =
                        Collections.singletonList(new SimpleGrantedAuthority("ROLE_" + role));

                UsernamePasswordAuthenticationToken authentication =
                        new UsernamePasswordAuthenticationToken(userDetails, null, authorities);
                authentication.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));

                SecurityContextHolder.getContext().setAuthentication(authentication);

                // ✅ 7️⃣ 세션에 사용자 정보 저장 (Controller에서 HttpSession 사용을 위해)
                request.getSession().setAttribute("user", user);
                request.getSession().setAttribute("role", role);
                request.getSession().setAttribute("userName", user.getName() != null ? user.getName() : username);
                
                log.debug("✅ JWT 인증 성공: {} (Role: {})", username, role);
            } else {
                log.trace("⚪ JWT 토큰 없음 - 익명 요청: {}", request.getRequestURI());
            }

        } catch (ExpiredJwtException e) {
            log.warn("⚠️ 만료된 JWT 토큰 요청 - URI: {}, Message: {}", request.getRequestURI(), e.getMessage());
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "토큰이 만료되었습니다.");
            return;
        } catch (JwtException e) {
            log.warn("⚠️ 잘못된 JWT 토큰 - URI: {}, Message: {}", request.getRequestURI(), e.getMessage());
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "유효하지 않은 토큰입니다.");
            return;
        } catch (Exception e) {
            log.error("💥 JWT 필터 처리 중 예외 발생 - URI: {}, Error: {}", request.getRequestURI(), e.getMessage(), e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "인증 처리 중 오류가 발생했습니다.");
            return;
        }

        // ✅ 5. 다음 필터로 진행
        filterChain.doFilter(request, response);
    }

    /**
     * ✅ JWT 토큰 추출 (Authorization 헤더 > access_token 쿠키)
     */
    private String resolveToken(HttpServletRequest request) {
        // 1️⃣ Authorization 헤더 우선
        String header = request.getHeader("Authorization");
        if (header != null && header.startsWith("Bearer ")) {
            return header.substring(7);
        }

        // 2️⃣ 쿠키에서 access_token 찾기
        if (request.getCookies() != null) {
            for (Cookie cookie : request.getCookies()) {
                if ("access_token".equals(cookie.getName())) {
                    return cookie.getValue();
                }
            }
        }

        return null;
    }
}
