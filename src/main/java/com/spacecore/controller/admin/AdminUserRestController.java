package com.spacecore.controller.admin;

import com.spacecore.domain.user.User;
import com.spacecore.service.user.UserService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/admin/users")
@PreAuthorize("hasRole('ADMIN')")
public class AdminUserRestController {

    private final UserService userService;

    /** 전체 사용자 목록 조회 */
    @GetMapping
    public ResponseEntity<List<User>> getAllUsers() {
        List<User> users = userService.findAll();
        return ResponseEntity.ok(users);
    }

    /** 사용자 상세 조회 */
    @GetMapping("/{id}")
    public ResponseEntity<?> getUser(@PathVariable Long id) {
        User user = userService.findById(id);
        if (user == null) {
            log.warn("사용자 조회 실패 - 존재하지 않음: id={}", id);
            return ResponseEntity.status(404).body(Map.of("message", "사용자를 찾을 수 없습니다."));
        }
        log.info("👁 사용자 조회 성공: id={}", id);
        return ResponseEntity.ok(user);
    }

    /** 사용자 수정 */
    @PutMapping("/{id}")
    public ResponseEntity<?> updateUserStatus(@PathVariable Long id, @RequestBody User formUser) {
        try {
            User existingUser = userService.findById(id);
            if (existingUser == null) {
                return ResponseEntity.status(404)
                        .body(Map.of("message", "해당 사용자를 찾을 수 없습니다."));
            }

            if (formUser.getStatus() == null) {
                return ResponseEntity.badRequest()
                        .body(Map.of("message", "상태 값이 누락되었습니다."));
            }

            existingUser.setStatus(formUser.getStatus());
            userService.update(existingUser);

            log.info("관리자 - 사용자 상태 변경 완료: id={}, newStatus={}", id, formUser.getStatus());
            return ResponseEntity.ok(Map.of("message", "✅ 사용자 상태가 변경되었습니다."));

        } catch (Exception e) {
            log.error("사용자 상태 변경 중 오류: {}", e.getMessage(), e);
            return ResponseEntity.internalServerError()
                    .body(Map.of("message", "사용자 상태 변경 중 오류 발생"));
        }
    }

    /** 비밀번호 초기화 (관리자 전용) */
    @PostMapping("/{id}/reset-password")
    public ResponseEntity<?> resetPassword(@PathVariable Long id) {
        try {
            String tempPassword = userService.resetPasswordByAdmin(id);
            log.info("관리자 - 비밀번호 초기화 완료: userId={}", id);
            return ResponseEntity.ok(Map.of(
                    "message", "비밀번호가 임시 비밀번호로 초기화되었습니다.",
                    "tempPassword", tempPassword
            ));
        } catch (Exception e) {
            log.error("비밀번호 초기화 실패: {}", e.getMessage());
            return ResponseEntity.status(500).body("비밀번호 초기화 중 오류 발생");
        }
    }

    /** 사용자 삭제 */
    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteUser(@PathVariable Long id) {
        try {
            userService.delete(id);
            log.info("관리자 - 사용자 삭제 완료: userId={}", id);
            return ResponseEntity.ok(Map.of("message", "사용자가 삭제되었습니다."));
        } catch (IllegalArgumentException e) {
            log.warn("⚠사용자 삭제 실패(존재하지 않음): {}", e.getMessage());
            return ResponseEntity.status(404).body(Map.of("message", e.getMessage()));
        } catch (Exception e) {
            log.error("사용자 삭제 중 오류 발생", e);
            return ResponseEntity.internalServerError().body(Map.of("message", "사용자 삭제 중 오류 발생"));
        }
    }
}
