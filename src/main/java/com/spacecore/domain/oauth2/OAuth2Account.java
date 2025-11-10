package com.spacecore.domain.oauth2;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * ✅ OAuth2Account (소셜 계정 연동 정보)
 * - 소셜 로그인 성공 시 OAuth2 토큰/프로바이더 정보 저장
 * - 회원 탈퇴 시 revoke API 호출 후 자동 삭제 (ON DELETE CASCADE)
 * - provider: google / kakao / naver 등
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class OAuth2Account {

    /** PK */
    private Long id;

    /** FK → users.id */
    private Long userId;

    /** 소셜 제공자 (예: google, kakao, naver) */
    private String provider;

    /** 소셜 계정 고유 식별자 (예: provider의 user id, sub 값 등) */
    private String providerId;

    /** OAuth2 Access Token (암호화 저장 권장) */
    private String accessToken;

    /** OAuth2 Refresh Token (암호화 저장 권장) */
    private String refreshToken;

    /** 토큰 만료 시각 */
    private LocalDateTime tokenExpiresAt;

    /** 생성일자 */
    private LocalDateTime createdAt;

    /** 수정일자 */
    private LocalDateTime updatedAt;
}