package com.spacecore.service.auth;

import com.spacecore.domain.auth.RefreshToken;
import com.spacecore.mapper.auth.RefreshTokenMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Optional;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class RefreshTokenServiceImpl implements RefreshTokenService {

    private final RefreshTokenMapper refreshTokenMapper;

    /**
     * 사용자별 RefreshToken을 새로 생성 (기존 토큰은 삭제)
     */
    @Override
    public RefreshToken create(Long userId, long daysValid) {
        // 기존 토큰 삭제 (중복 방지)
        refreshTokenMapper.deleteByUserId(userId);

        // 새로운 토큰 생성
        RefreshToken token = new RefreshToken();
        token.setUserId(userId);
        token.setToken(UUID.randomUUID().toString()); // 고유한 UUID 문자열
        token.setExpiryDate(LocalDateTime.now().plusDays(daysValid));

        refreshTokenMapper.insert(token);
        return token;
    }

    /**
     * 토큰 문자열로 RefreshToken 조회
     */
    @Override
    public Optional<RefreshToken> findByToken(String token) {
        return Optional.ofNullable(refreshTokenMapper.findByToken(token));
    }

    /**
     * 사용자별 RefreshToken 삭제
     */
    @Override
    public void deleteByUserId(Long userId) {
        refreshTokenMapper.deleteByUserId(userId);
    }

    /**
     * RefreshToken 만료 여부 판단
     */
    @Override
    public boolean isExpired(RefreshToken token) {
        return token.getExpiryDate().isBefore(LocalDateTime.now());
    }
}