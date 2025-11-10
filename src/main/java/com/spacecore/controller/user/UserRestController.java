package com.spacecore.controller.user;

import com.spacecore.domain.user.User;
import com.spacecore.dto.user.PasswordChangeRequest;
import com.spacecore.security.CustomUserDetails;
import com.spacecore.service.user.UserService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.*;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.oauth2.client.OAuth2AuthorizedClientService;
import org.springframework.security.oauth2.client.authentication.OAuth2AuthenticationToken;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Map;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/user")
@PreAuthorize("isAuthenticated()")
public class UserRestController {

    private final UserService userService;
    private final PasswordEncoder passwordEncoder;
    private final OAuth2AuthorizedClientService authorizedClientService;

    /** ✅ 현재 로그인한 사용자 정보 조회 */
    @GetMapping("/me")
    public ResponseEntity<?> getMyInfo(@AuthenticationPrincipal CustomUserDetails userDetails) {
        if (userDetails == null || userDetails.getUser() == null) {
            return ResponseEntity.status(401).body(Map.of("message", "로그인이 필요합니다."));
        }
        log.info("👤 사용자 정보 조회 요청: {}", userDetails.getUsername());
        return ResponseEntity.ok(userDetails.getUser());
    }

    /** ✅ 내 정보 수정 */
    @PutMapping("/me")
    public ResponseEntity<Map<String, String>> updateMyInfo(
            @AuthenticationPrincipal CustomUserDetails userDetails,
            @RequestBody User updatedUser) {

        try {
            if (userDetails == null || userDetails.getUser() == null)
                return ResponseEntity.status(401).body(Map.of("message", "인증 정보가 없습니다."));

            Long userId = userDetails.getUser().getId();
            updatedUser.setId(userId);

            // 전화번호 유효성 검사
            if (updatedUser.getPhone() != null &&
                    !updatedUser.getPhone().matches("^010-\\d{4}-\\d{4}$")) {
                return ResponseEntity.badRequest().body(Map.of("message", "전화번호 형식이 올바르지 않습니다."));
            }

            // 중복 전화번호 검사
            if (updatedUser.getPhone() != null &&
                    userService.existsByPhone(updatedUser.getPhone()) &&
                    !updatedUser.getPhone().equals(userDetails.getUser().getPhone())) {
                return ResponseEntity.badRequest().body(Map.of("message", "이미 등록된 전화번호입니다."));
            }

            // 중복 이메일 검사
            if (updatedUser.getEmail() != null &&
                    userService.existsByEmail(updatedUser.getEmail()) &&
                    !updatedUser.getEmail().equals(userDetails.getUser().getEmail())) {
                return ResponseEntity.badRequest().body(Map.of("message", "이미 사용 중인 이메일입니다."));
            }

            userService.update(updatedUser);
            log.info("🔄 사용자 정보 수정 완료: {}", userId);
            return ResponseEntity.ok(Map.of("message", "내 정보가 성공적으로 수정되었습니다."));

        } catch (Exception e) {
            log.error("❌ 사용자 정보 수정 실패: {}", e.getMessage(), e);
            return ResponseEntity.internalServerError().body(Map.of("message", "내 정보 수정 중 오류가 발생했습니다."));
        }
    }

    /** ✅ 비밀번호 변경 (로그아웃 포함) */
    @PutMapping(value = "/change-password", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map<String, String>> changePassword(
            @AuthenticationPrincipal CustomUserDetails userDetails,
            @RequestBody PasswordChangeRequest request,
            HttpServletResponse response,
            HttpSession session) {

        if (userDetails == null || userDetails.getUser() == null)
            return ResponseEntity.status(401).body(Map.of("message", "인증 정보가 없습니다."));

        User user = userDetails.getUser();

        // 🔒 기존 비밀번호 확인
        if (!passwordEncoder.matches(request.getCurrentPassword(), user.getPassword())) {
            return ResponseEntity.badRequest().body(Map.of("message", "현재 비밀번호가 일치하지 않습니다."));
        }

        // 🔒 새 비밀번호 유효성 검사
        if (request.getNewPassword().length() < 8) {
            return ResponseEntity.badRequest().body(Map.of("message", "새 비밀번호는 8자 이상이어야 합니다."));
        }

        try {
            userService.changePassword(user.getId(), request.getNewPassword());
            log.info("🔑 비밀번호 변경 완료: {}", user.getUsername());

            // ✅ 세션 및 인증정보 완전 초기화
            org.springframework.security.core.context.SecurityContextHolder.clearContext();
            if (session != null) session.invalidate();

            // ✅ JWT 쿠키 삭제
            invalidateJwtCookies(response);

            return ResponseEntity.ok(Map.of("message", "비밀번호가 성공적으로 변경되었습니다. 다시 로그인해주세요."));
        } catch (IllegalArgumentException e) {
            log.warn("⚠️ 비밀번호 변경 실패 (동일 비밀번호): {}", e.getMessage());
            return ResponseEntity.badRequest().body(Map.of("message", e.getMessage()));
        } catch (Exception e) {
            log.error("❌ 비밀번호 변경 중 예외 발생", e);
            return ResponseEntity.internalServerError().body(Map.of("message", "비밀번호 변경 중 오류가 발생했습니다."));
        }
    }

    /** ✅ 회원 탈퇴 */
    @DeleteMapping("/me")
    public ResponseEntity<Map<String, String>> deleteMyAccount(
            @AuthenticationPrincipal CustomUserDetails userDetails,
            Authentication authentication,
            HttpServletResponse response,
            HttpSession session) {

        try {
            if (userDetails == null || userDetails.getUser() == null)
                return ResponseEntity.status(401).body(Map.of("message", "인증 정보가 없습니다."));

            Long userId = userDetails.getUser().getId();

            // ✅ OAuth2AuthorizedClientService에서 연결된 AuthorizedClient 제거 (Java 11 방식)
            if (authentication instanceof OAuth2AuthenticationToken) {
                OAuth2AuthenticationToken oauth2Token = (OAuth2AuthenticationToken) authentication;
                authorizedClientService.removeAuthorizedClient(
                        oauth2Token.getAuthorizedClientRegistrationId(),
                        oauth2Token.getName()
                );
                log.info("🔗 OAuth2AuthorizedClient 제거 완료");
            }

            // ✅ UserService에서 모든 연관 데이터(OAuth2Account + RefreshToken + User) 정리
            userService.delete(userId);

            // ✅ 세션, 쿠키, 인증정보 초기화
            org.springframework.security.core.context.SecurityContextHolder.clearContext();
            if (session != null) session.invalidate();
            invalidateJwtCookies(response);

            log.info("👋 회원 탈퇴 완료: userId={}", userId);
            return ResponseEntity.ok(Map.of("message", "회원 탈퇴가 완료되었습니다."));

        } catch (Exception e) {
            log.error("❌ 회원 탈퇴 실패: {}", e.getMessage(), e);
            return ResponseEntity.internalServerError().body(Map.of("message", "회원 탈퇴 중 오류가 발생했습니다."));
        }
    }

    /** ✅ JWT 쿠키 무효화 */
    private void invalidateJwtCookies(HttpServletResponse response) {
        Cookie access = new Cookie("access_token", null);
        access.setPath("/");
        access.setHttpOnly(true);
        access.setSecure(true);
        access.setMaxAge(0);
        response.addCookie(access);

        Cookie refresh = new Cookie("refresh_token", null);
        refresh.setPath("/");
        refresh.setHttpOnly(true);
        refresh.setSecure(true);
        refresh.setMaxAge(0);
        response.addCookie(refresh);

        response.addHeader("Set-Cookie", "access_token=; Max-Age=0; Path=/; HttpOnly; Secure; SameSite=Lax");
        response.addHeader("Set-Cookie", "refresh_token=; Max-Age=0; Path=/; HttpOnly; Secure; SameSite=Lax");

        log.debug("🧹 JWT 쿠키 삭제 완료 (access_token, refresh_token)");
    }
}