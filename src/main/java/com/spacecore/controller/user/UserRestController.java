package com.spacecore.controller.user;

import com.spacecore.domain.user.User;
import com.spacecore.dto.user.PasswordChangeRequest;
import com.spacecore.security.CustomUserDetails;
import com.spacecore.service.user.UserService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletResponse;
import java.util.Map;

/**
 * 🧩 사용자 관련 REST API 컨트롤러 (최신)
 * - JWT 인증 기반 사용자 API
 * - 내 정보 조회 / 수정 / 비밀번호 변경 / 탈퇴 / 이메일·전화번호 중복 검사
 */
@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/user")
@PreAuthorize("isAuthenticated()")
public class UserRestController {

    private final UserService userService;
    private final PasswordEncoder passwordEncoder;

    // ✅ 현재 로그인한 사용자 정보 조회
    @GetMapping("/me")
    public ResponseEntity<?> getMyInfo(@AuthenticationPrincipal CustomUserDetails userDetails) {
        if (userDetails == null || userDetails.getUser() == null) {
            return ResponseEntity.status(401).body("로그인이 필요합니다.");
        }
        log.info("👤 사용자 정보 조회 요청: {}", userDetails.getUsername());
        return ResponseEntity.ok(userDetails.getUser());
    }

    // ✅ 내 정보 수정
    @PutMapping("/me")
    public ResponseEntity<String> updateMyInfo(
            @AuthenticationPrincipal CustomUserDetails userDetails,
            @RequestBody User updatedUser) {

        try {
            if (userDetails == null || userDetails.getUser() == null) {
                return ResponseEntity.status(401).body("인증 정보가 없습니다.");
            }

            Long userId = userDetails.getUser().getId();
            updatedUser.setId(userId);

            // ✅ 전화번호 형식 검증
            if (updatedUser.getPhone() != null &&
                    !updatedUser.getPhone().matches("^010-\\d{4}-\\d{4}$")) {
                return ResponseEntity.badRequest().body("전화번호 형식이 올바르지 않습니다. (예: 010-1234-5678)");
            }

            // ✅ 전화번호 중복 검증
            if (updatedUser.getPhone() != null &&
                    userService.existsByPhone(updatedUser.getPhone()) &&
                    !updatedUser.getPhone().equals(userDetails.getUser().getPhone())) {
                return ResponseEntity.badRequest().body("이미 등록된 전화번호입니다.");
            }

            // ✅ 이메일 중복 검증
            if (updatedUser.getEmail() != null &&
                    userService.existsByEmail(updatedUser.getEmail()) &&
                    !updatedUser.getEmail().equals(userDetails.getUser().getEmail())) {
                return ResponseEntity.badRequest().body("이미 사용 중인 이메일입니다.");
            }

            userService.update(updatedUser);
            log.info("🔄 사용자 정보 수정 완료: {}", userId);

            return ResponseEntity.ok("내 정보가 성공적으로 수정되었습니다.");
        } catch (Exception e) {
            log.error("❌ 사용자 정보 수정 실패: {}", e.getMessage(), e);
            return ResponseEntity.internalServerError().body("내 정보 수정 중 오류가 발생했습니다.");
        }
    }

    // ✅ 전화번호 중복 확인 API (AJAX용)
    @GetMapping("/check-phone")
    public ResponseEntity<Boolean> checkPhoneDuplicate(@RequestParam String phone) {
        boolean exists = userService.existsByPhone(phone);
        log.debug("📞 전화번호 중복 검사: {} → {}", phone, exists);
        return ResponseEntity.ok(exists);
    }

    // ✅ 이메일 중복 확인 API (AJAX용)
    @GetMapping("/check-email")
    public ResponseEntity<Boolean> checkEmailDuplicate(@RequestParam String email) {
        boolean exists = userService.existsByEmail(email);
        log.debug("📧 이메일 중복 검사: {} → {}", email, exists);
        return ResponseEntity.ok(exists);
    }

    // ✅ 비밀번호 변경
    @PutMapping("/change-password")
    public ResponseEntity<?> changePassword(
            @AuthenticationPrincipal CustomUserDetails userDetails,
            @RequestBody PasswordChangeRequest request,
            HttpServletResponse response) {

        if (userDetails == null || userDetails.getUser() == null) {
            return ResponseEntity.status(401).body(Map.of("message", "인증 정보가 없습니다."));
        }

        User user = userDetails.getUser();

        if (!passwordEncoder.matches(request.getCurrentPassword(), user.getPassword())) {
            return ResponseEntity.badRequest().body(Map.of("message", "현재 비밀번호가 일치하지 않습니다."));
        }

        if (passwordEncoder.matches(request.getNewPassword(), user.getPassword())) {
            return ResponseEntity.badRequest().body(Map.of("message", "새 비밀번호는 기존 비밀번호와 달라야 합니다."));
        }

        if (request.getNewPassword().length() < 8) {
            return ResponseEntity.badRequest().body(Map.of("message", "새 비밀번호는 8자 이상이어야 합니다."));
        }

        userService.changePassword(user.getId(), passwordEncoder.encode(request.getNewPassword()));
        log.info("🔑 비밀번호 변경 완료: {}", user.getUsername());

        invalidateJwtCookies(response);
        return ResponseEntity.ok(Map.of("message", "비밀번호가 성공적으로 변경되었습니다. 다시 로그인해주세요."));
    }

    // ✅ 회원 탈퇴
    @DeleteMapping("/me")
    public ResponseEntity<String> deleteMyAccount(
            @AuthenticationPrincipal CustomUserDetails userDetails,
            HttpServletResponse response) {
        try {
            if (userDetails == null || userDetails.getUser() == null) {
                return ResponseEntity.status(401).body("인증 정보가 없습니다.");
            }

            Long userId = userDetails.getUser().getId();
            userService.delete(userId);
            invalidateJwtCookies(response);

            log.info("👋 회원 탈퇴 완료: {}", userId);
            return ResponseEntity.ok("회원 탈퇴가 완료되었습니다.");
        } catch (Exception e) {
            log.error("❌ 회원 탈퇴 실패: {}", e.getMessage(), e);
            return ResponseEntity.internalServerError().body("회원 탈퇴 중 오류가 발생했습니다.");
        }
    }

    // ✅ JWT 쿠키 무효화
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
