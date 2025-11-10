package com.spacecore.service.oauth2;

import com.spacecore.domain.oauth2.OAuth2Account;
import java.time.LocalDateTime;

/**
 * ✅ OAuth2AccountService (최신화)
 * - Google / Kakao / Naver 등 소셜 계정 연동 관리용 Service
 * - Controller에서는 직접 접근하지 않으며,
 *   OAuth2 로그인 과정 (CustomOAuth2UserService, OAuth2AuthenticationSuccessHandler) 내에서만 호출됨.
 *
 * ⚙️ 주요 역할:
 *  - OAuth2Account 신규 등록 및 갱신 (refresh_token 재사용 지원)
 *  - OAuth2 토큰 만료 갱신
 *  - 소셜 계정 해제 시 provider revoke 처리 (ex: Google revoke)
 *  - 일반 로그인용 refresh_tokens 테이블과는 완전히 별도로 동작
 */
public interface OAuth2AccountService {

    /** ✅ 신규 OAuth2 계정 등록 (최초 로그인 시 1회) */
    void save(OAuth2Account account);

    /**
     * ✅ OAuth2 계정 등록 또는 갱신 (userId 단위로 중복 방지)
     *  - 이미 존재하면 update 수행
     *  - refresh_token 이 null인 경우, 기존 DB 값은 유지 (재발급되지 않으므로)
     */
    void saveOrUpdate(OAuth2Account account);

    /** ✅ 사용자별 OAuth2 계정 조회 */
    OAuth2Account findByUserId(Long userId);

    /**
     * ✅ AccessToken / RefreshToken 만료 갱신
     *  - OAuth2AuthorizedClientService 에서 가져온 토큰 정보를 반영
     */
    void updateTokens(Long userId, String accessToken, String refreshToken, LocalDateTime expiresAt);

    /**
     * ✅ 회원 탈퇴 시 소셜 연동 해제 및 계정 삭제
     *  - Google 등 OAuth provider에 revoke 요청 포함 가능
     *  - DB에서도 해당 OAuth2Account 레코드 삭제
     */
    void deleteAndRevoke(Long userId);
}