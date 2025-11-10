package com.spacecore.mapper.oauth2;

import com.spacecore.domain.oauth2.OAuth2Account;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDateTime;

@Mapper
public interface OAuth2AccountMapper {

    /** 신규 OAuth2 계정 등록 */
    void insert(OAuth2Account account);

    /** userId로 계정 조회 */
    OAuth2Account findByUserId(@Param("userId") Long userId);

    /** Access + RefreshToken 갱신 (refresh_token null 시 무시됨) */
    void updateTokens(@Param("userId") Long userId,
                      @Param("accessToken") String accessToken,
                      @Param("refreshToken") String refreshToken,
                      @Param("expiresAt") LocalDateTime expiresAt);

    /** AccessToken만 갱신 (refresh_token 그대로 유지) */
    void updateAccessTokenOnly(
            @Param("userId") Long userId,
            @Param("accessToken") String accessToken,
            @Param("tokenExpiresAt") LocalDateTime tokenExpiresAt
    );

    /** 특정 사용자 OAuth2 계정 삭제 */
    void deleteByUserId(@Param("userId") Long userId);
}