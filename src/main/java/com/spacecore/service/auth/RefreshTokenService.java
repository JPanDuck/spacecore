package com.spacecore.service.auth;

import com.spacecore.domain.auth.RefreshToken;

import java.util.Optional;

public interface RefreshTokenService {

    /** 특정 사용자에 대한 RefreshToken 생성 (기존 토큰 삭제 후 새로 생성) */
    RefreshToken create(Long userId, long daysValid);

    /** 토큰 문자열로 RefreshToken 조회 */
    Optional<RefreshToken> findByToken(String token);

    /** 특정 사용자 ID로 RefreshToken 삭제 */
    void deleteByUserId(Long userId);

    /** RefreshToken 만료 여부 확인 */
    boolean isExpired(RefreshToken token);
}