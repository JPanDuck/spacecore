package com.spacecore.controller.auth;

import com.spacecore.domain.auth.RefreshToken;
import com.spacecore.domain.user.User;
import com.spacecore.dto.auth.*;
import com.spacecore.dto.user.RegisterRequest;
import com.spacecore.security.CustomUserDetails;
import com.spacecore.security.jwt.JwtTokenProvider;
import com.spacecore.service.auth.AuthenticationBuilder;
import com.spacecore.service.auth.RefreshTokenService;
import com.spacecore.service.user.UserService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseCookie;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.time.Duration;
import java.util.Map;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/auth")
public class AuthRestController {

    private final AuthenticationBuilder authenticationBuilder;
    private final JwtTokenProvider jwtTokenProvider;
    private final RefreshTokenService refreshTokenService;
    private final UserService userService;

    /** ✅ 로그인 (JWT 발급 + 쿠키 저장) */
    @PostMapping("/login")
    public ResponseEntity<?> login(@Valid @RequestBody LoginRequest request) {
        try {
            Authentication auth = authenticationBuilder.authenticate(request.getUsername(), request.getPassword());
            User user = userService.findByUsername(request.getUsername())
                    .orElseThrow(() -> new BadCredentialsException("존재하지 않는 사용자"));

            if ("SUSPENDED".equalsIgnoreCase(user.getStatus())) {
                log.warn("🚫 로그인 시도 차단: 정지된 계정 [{}]", user.getUsername());
                refreshTokenService.deleteByUserId(user.getId());

                ResponseCookie expiredAccess = ResponseCookie.from("access_token", "")
                        .httpOnly(true).secure(false).path("/").maxAge(0).sameSite("Lax").build();
                ResponseCookie expiredRefresh = ResponseCookie.from("refresh_token", "")
                        .httpOnly(true).secure(false).path("/").maxAge(0).sameSite("Lax").build();

                return ResponseEntity.status(403)
                        .header(HttpHeaders.SET_COOKIE, expiredAccess.toString())
                        .header(HttpHeaders.SET_COOKIE, expiredRefresh.toString())
                        .body(Map.of("message", "정지된 계정입니다. 관리자에게 문의하세요."));
            }

            // ✅ 임시 비밀번호 로그인 감지
            if ("Y".equals(user.getIsTempPassword())) {
                log.warn("⚠️ 임시 비밀번호 로그인: {}", user.getUsername());
            }

            String accessToken = jwtTokenProvider.generateToken(user, Duration.ofHours(1));
            RefreshToken refreshToken = refreshTokenService.create(user.getId(), 14);

            ResponseCookie accessCookie = ResponseCookie.from("access_token", accessToken)
                    .httpOnly(true).secure(false).path("/").maxAge(Duration.ofHours(1)).sameSite("Lax").build();
            ResponseCookie refreshCookie = ResponseCookie.from("refresh_token", refreshToken.getToken())
                    .httpOnly(true).secure(false).path("/").maxAge(Duration.ofDays(14)).sameSite("Lax").build();

            log.info("✅ 로그인 성공: {}", user.getUsername());

            // ✅ 응답 본문에 isTempPassword 추가
            return ResponseEntity.ok()
                    .header(HttpHeaders.SET_COOKIE, accessCookie.toString())
                    .header(HttpHeaders.SET_COOKIE, refreshCookie.toString())
                    .body(Map.of(
                            "message", "로그인 성공",
                            "username", user.getUsername(),
                            "name", user.getName() != null ? user.getName() : user.getUsername(),
                            "role", user.getRole(),
                            "accessToken", accessToken,
                            "refreshToken", refreshToken.getToken(),
                            "isTemp", "Y".equals(user.getIsTempPassword())
                    ));
        } catch (BadCredentialsException e) {
            return ResponseEntity.status(401).body("아이디 또는 비밀번호가 올바르지 않습니다.");
        } catch (Exception e) {
            log.error("❌ 로그인 오류", e);
            return ResponseEntity.status(500).body("서버 오류 발생");
        }
    }

    /** ✅ 회원가입 */
    @PostMapping("/register")
    public ResponseEntity<?> register(@Valid @RequestBody RegisterRequest req) {
        if (userService.existsByUsername(req.getUsername()))
            return ResponseEntity.badRequest().body("이미 사용 중인 아이디입니다.");
        if (userService.existsByEmail(req.getEmail()))
            return ResponseEntity.badRequest().body("이미 등록된 이메일입니다.");

        User user = new User();
        user.setUsername(req.getUsername());
        user.setPassword(req.getPassword());
        user.setEmail(req.getEmail());
        user.setName(req.getName());
        user.setPhone(req.getPhone());
        user.setRole("USER");
        user.setStatus("ACTIVE");
        user.setIsTempPassword("N");

        userService.register(user);
        log.info("✅ 회원가입 완료: {}", req.getUsername());
        return ResponseEntity.ok(Map.of("message", "회원가입 완료", "redirect", "/index"));
    }

    /** ✅ 로그인 상태 확인 */
    @GetMapping("/validate")
    public ResponseEntity<?> validateToken(Authentication authentication) {
        if (authentication != null && authentication.isAuthenticated()
                && authentication.getPrincipal() instanceof CustomUserDetails) {
            CustomUserDetails user = (CustomUserDetails) authentication.getPrincipal();
            return ResponseEntity.ok(Map.of("valid", true, "username", user.getUsername(), "role", user.getRole()));
        }
        return ResponseEntity.status(401).body(Map.of("valid", false));
    }

    /** ✅ 현재 로그인 사용자 정보 */
    @GetMapping("/me")
    public ResponseEntity<?> getCurrentUser(Authentication authentication) {
        if (authentication == null || !(authentication.getPrincipal() instanceof CustomUserDetails)) {
            return ResponseEntity.status(401).body(Map.of("message", "로그인이 필요합니다."));
        }

        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        User user = userService.findById(userDetails.getId());
        return ResponseEntity.ok(Map.of(
                "id", user.getId(),
                "username", user.getUsername(),
                "name", user.getName(),
                "email", user.getEmail(),
                "role", user.getRole()
        ));
    }

    /** ✅ 로그아웃 (RefreshToken 삭제 + 쿠키 만료 + 세션 무효화) */
    @PostMapping("/logout")
    public ResponseEntity<?> logout(
            javax.servlet.http.HttpServletRequest request,
            @CookieValue(name = "refresh_token", required = false) String refreshToken) {
        try {
            if (refreshToken != null) {
                refreshTokenService.findByToken(refreshToken)
                        .ifPresent(token -> refreshTokenService.deleteByUserId(token.getUserId()));
            }

            // ✅ 세션 무효화 추가
            request.getSession().invalidate();

            // ✅ 쿠키 만료
            ResponseCookie expiredAccess = ResponseCookie.from("access_token", "")
                    .httpOnly(true).secure(false).path("/").maxAge(0).sameSite("Lax").build();
            ResponseCookie expiredRefresh = ResponseCookie.from("refresh_token", "")
                    .httpOnly(true).secure(false).path("/").maxAge(0).sameSite("Lax").build();

            log.info("🚪 로그아웃 완료 (세션 + 쿠키 삭제)");
            return ResponseEntity.ok()
                    .header(HttpHeaders.SET_COOKIE, expiredAccess.toString())
                    .header(HttpHeaders.SET_COOKIE, expiredRefresh.toString())
                    .body(Map.of("message", "로그아웃 완료"));
        } catch (Exception e) {
            log.error("❌ 로그아웃 중 오류", e);
            return ResponseEntity.status(500).body(Map.of("message", "로그아웃 오류 발생"));
        }
    }

    /** ✅ 비밀번호 찾기 (아이디 + 이메일 확인) */
    @PostMapping("/find-password")
    public ResponseEntity<Map<String, String>> findPassword(@RequestBody Map<String, String> req) {
        String username = req.get("username");
        String email = req.get("email");

        // ✅ 아이디 + 이메일 일치 여부 확인
        boolean match = userService.checkUsernameAndEmail(username, email);

        if (!match) {
            log.warn("❌ 비밀번호 찾기 실패 - 아이디 또는 이메일 불일치: username={}, email={}", username, email);
            return ResponseEntity.badRequest().body(Map.of("message", "입력하신 정보가 일치하지 않습니다."));
        }

        log.info("✅ 비밀번호 찾기 성공 - username={}, email={}", username, email);
        return ResponseEntity.ok(Map.of(
                "message", "확인되었습니다. 비밀번호 재설정 페이지로 이동합니다.",
                "redirectUrl", "/auth/reset-password?username=" + username + "&email=" + email
        ));
    }

    /** ✅ 비밀번호 재설정 */
    @PostMapping("/reset-password")
    public ResponseEntity<?> resetPassword(@RequestBody Map<String, String> req) {
        String username = req.get("username");
        String newPassword = req.get("newPassword");

        try {
            userService.resetPasswordByUser(username, newPassword);
            log.info("비밀번호 재설정 완료: {}", username);
            return ResponseEntity.ok("비밀번호가 성공적으로 변경되었습니다.");
        } catch (Exception e) {
            log.error("비밀번호 재설정 실패: {}", e.getMessage());
            return ResponseEntity.status(500).body("비밀번호 재설정 중 오류가 발생했습니다.");
        }
    }

    /** ✅ 토큰 재발급 */
    @PostMapping("/refresh")
    public ResponseEntity<?> refresh(@CookieValue(name = "refresh_token", required = false) String refreshToken) {
        if (refreshToken == null)
            return ResponseEntity.status(401).body("Refresh Token이 없습니다.");

        var savedToken = refreshTokenService.findByToken(refreshToken)
                .orElseThrow(() -> new BadCredentialsException("RefreshToken 없음"));

        if (refreshTokenService.isExpired(savedToken)) {
            refreshTokenService.deleteByUserId(savedToken.getUserId());
            return ResponseEntity.status(401).body("Refresh Token 만료됨");
        }

        User user = userService.findById(savedToken.getUserId());
        String newAccessToken = jwtTokenProvider.generateToken(user, Duration.ofHours(1));

        ResponseCookie newAccessCookie = ResponseCookie.from("access_token", newAccessToken)
                .httpOnly(true).secure(false).path("/").maxAge(Duration.ofHours(1)).sameSite("Lax").build();

        return ResponseEntity.ok()
                .header(HttpHeaders.SET_COOKIE, newAccessCookie.toString())
                .body(Map.of("accessToken", newAccessToken));
    }
}