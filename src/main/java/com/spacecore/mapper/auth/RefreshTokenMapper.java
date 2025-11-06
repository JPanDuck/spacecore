package com.spacecore.mapper.auth;

import com.spacecore.domain.auth.RefreshToken;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.time.LocalDateTime;

@Mapper
public interface RefreshTokenMapper {

    /** 토큰 문자열로 조회 */
    RefreshToken findByToken(@Param("token") String token);

    /** ✅ userId로 조회 (회원탈퇴 시 사용) */
    RefreshToken findByUserId(@Param("userId") Long userId);

    /** Refresh Token 저장 */
    void insert(RefreshToken refreshToken);

    /** 특정 사용자 ID 기준으로 삭제 (재로그인 시 기존 토큰 제거용) */
    void deleteByUserId(@Param("userId") Long userId);

    /** ✅ upsert (존재 시 update, 없으면 insert) */
    void saveOrUpdate(@Param("userId") Long userId,
                      @Param("token") String token,
                      @Param("expiry") LocalDateTime expiry);
}