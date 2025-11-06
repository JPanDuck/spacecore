package com.spacecore.security.jwt;

import com.spacecore.domain.user.User;
import io.jsonwebtoken.*;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;

import java.security.Key;
import java.time.Duration;
import java.util.*;

/**
 * ✅ JWT 토큰 유틸 (최신화)
 * - AccessToken / RefreshToken 발급 및 검증
 * - Expired 처리 명확화
 * - Claims 기반 인증 객체 변환
 */
@Slf4j
@Component
public class JwtTokenProvider {

    @Value("${app.jwt.secret}")
    private String secretKey;

    @Value("${app.jwt.access-token-validity-seconds}")
    private long accessTokenValiditySeconds;

    @Value("${app.jwt.refresh-token-validity-seconds}")
    private long refreshTokenValiditySeconds;

    /** ✅ 서명키 반환 */
    private Key getSigningKey() {
        byte[] keyBytes = Decoders.BASE64.decode(secretKey);
        if (keyBytes.length < 32) {
            throw new IllegalArgumentException("JWT secret key must be at least 256 bits (32 bytes)");
        }
        return Keys.hmacShaKeyFor(keyBytes);
    }

    /** ✅ Access Token 생성 */
    public String generateToken(User user, Duration validTime) {
        Date now = new Date();
        Date expiry = new Date(now.getTime() + validTime.toMillis());

        Map<String, Object> claims = new HashMap<>();
        claims.put("id", user.getId());
        claims.put("role", user.getRole());
        claims.put("username", user.getUsername());

        String token = Jwts.builder()
                .setClaims(claims)
                .setSubject(user.getUsername())
                .setIssuedAt(now)
                .setExpiration(expiry)
                .signWith(getSigningKey(), SignatureAlgorithm.HS256)
                .compact();

        log.info("✅ AccessToken 생성: {} (유효기간: {}분)", user.getUsername(), validTime.toMinutes());
        return token;
    }

    /** ✅ Refresh Token 생성 */
    public String generateRefreshToken(User user) {
        Date now = new Date();
        Date expiry = new Date(now.getTime() + (refreshTokenValiditySeconds * 1000L));

        Map<String, Object> claims = new HashMap<>();
        claims.put("id", user.getId());
        claims.put("role", user.getRole());

        String token = Jwts.builder()
                .setClaims(claims)
                .setSubject(user.getUsername())
                .setIssuedAt(now)
                .setExpiration(expiry)
                .signWith(getSigningKey(), SignatureAlgorithm.HS256)
                .compact();

        log.info("🔁 RefreshToken 생성: {} (유효기간: {}일)", user.getUsername(),
                refreshTokenValiditySeconds / 86400);
        return token;
    }

    /** ✅ Refresh Token → Access Token 재발급 */
    public String refreshAccessToken(String refreshToken) {
        try {
            Claims claims = validateAndGetClaims(refreshToken);

            User user = new User();
            user.setUsername(claims.getSubject());
            user.setRole((String) claims.get("role"));
            user.setId(((Number) claims.get("id")).longValue());

            return generateToken(user, Duration.ofSeconds(accessTokenValiditySeconds));

        } catch (ExpiredJwtException e) {
            log.warn("⚠️ 만료된 RefreshToken - 재발급 불가: {}", e.getMessage());
            throw new JwtException("만료된 RefreshToken 입니다.");
        }
    }

    /** ✅ Claims 검증 + 반환 (만료 포함) */
    public Claims validateAndGetClaims(String token) {
        try {
            return Jwts.parserBuilder()
                    .setSigningKey(getSigningKey())
                    .build()
                    .parseClaimsJws(token)
                    .getBody();
        } catch (ExpiredJwtException e) {
            log.warn("⚠️ 만료된 JWT 토큰 (sub={}): {}", e.getClaims().getSubject(), e.getMessage());
            throw e;
        } catch (JwtException e) {
            log.warn("❌ JWT 검증 실패: {}", e.getMessage());
            throw e;
        }
    }

    /** ✅ Authentication 객체 변환 */
    public UsernamePasswordAuthenticationToken getAuthentication(String token) {
        Claims claims = validateAndGetClaims(token);
        String username = claims.getSubject();
        String role = (String) claims.get("role");

        List<SimpleGrantedAuthority> authorities =
                Collections.singletonList(new SimpleGrantedAuthority("ROLE_" + role));

        UserDetails principal = new org.springframework.security.core.userdetails.User(
                username, "", authorities);

        return new UsernamePasswordAuthenticationToken(principal, null, authorities);
    }
}