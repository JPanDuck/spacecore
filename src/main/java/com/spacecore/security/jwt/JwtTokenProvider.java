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

@Slf4j
@Component
public class JwtTokenProvider {

    @Value("${app.jwt.secret}")
    private String secretKey;

    @Value("${app.jwt.access-token-validity-seconds}")
    private long accessTokenValiditySeconds;

    @Value("${app.jwt.refresh-token-validity-seconds}")
    private long refreshTokenValiditySeconds;

    private Key getSigningKey() {
        byte[] keyBytes = Decoders.BASE64.decode(secretKey);
        if (keyBytes.length < 32) {
            throw new IllegalArgumentException("JWT secret key must be at least 256 bits");
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

        return Jwts.builder()
                .setClaims(claims)
                .setSubject(user.getUsername())
                .setIssuedAt(now)
                .setExpiration(expiry)
                .signWith(getSigningKey(), SignatureAlgorithm.HS256)
                .compact();
    }

    /** ✅ Refresh Token → Access Token 재발급 */
    public String refreshAccessToken(String refreshToken) {
        Claims claims = validateAndGetClaims(refreshToken);

        User user = new User();
        user.setUsername(claims.getSubject());
        user.setRole((String) claims.get("role"));
        user.setId(((Number) claims.get("id")).longValue());

        return generateToken(user, Duration.ofHours(1));
    }

    /** ✅ Claims 검증 + 반환 */
    public Claims validateAndGetClaims(String token) {
        try {
            return Jwts.parserBuilder()
                    .setSigningKey(getSigningKey())
                    .build()
                    .parseClaimsJws(token)
                    .getBody();
        } catch (JwtException e) {
            log.warn("JWT 검증 실패: {}", e.getMessage());
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
