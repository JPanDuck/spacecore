package com.spacecore.controller.admin;

import com.spacecore.domain.user.User;
import com.spacecore.service.user.UserService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

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
        try {
            User user = userService.findById(id);
            return ResponseEntity.ok(user);
        } catch (Exception e) {
            log.warn("사용자 조회 실패: {}", e.getMessage());
            return ResponseEntity.status(404).body("사용자를 찾을 수 없습니다.");
        }
    }

    /** 사용자 수정 */
    @PutMapping("/{id}")
    public ResponseEntity<?> updateUser(@PathVariable Long id, @RequestBody User formUser) {
        try {
            User existingUser = userService.findById(id);
            if (formUser.getName() != null) existingUser.setName(formUser.getName());
            if (formUser.getEmail() != null) existingUser.setEmail(formUser.getEmail());
            existingUser.setPhone(formUser.getPhone());
            existingUser.setStatus(formUser.getStatus());

            userService.update(existingUser);
            log.info("관리자 - 사용자 수정: {}", existingUser.getUsername());
            return ResponseEntity.ok("사용자 정보가 수정되었습니다.");
        } catch (Exception e) {
            log.error("사용자 수정 실패: {}", e.getMessage());
            return ResponseEntity.status(500).body("사용자 수정 중 오류 발생");
        }
    }

    /** 비밀번호 초기화 */
    @PostMapping("/{id}/reset-password")
    public ResponseEntity<?> resetPassword(@PathVariable Long id) {
        try {
            // 서비스가 랜덤 임시 비밀번호 생성
            userService.resetPassword(id);

            log.info("관리자 - 비밀번호 초기화: userId={}", id);
            return ResponseEntity.ok("비밀번호가 임시 비밀번호로 초기화되었습니다.");
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
            log.info("관리자 - 사용자 삭제: userId={}", id);
            return ResponseEntity.ok("사용자가 삭제되었습니다.");
        } catch (Exception e) {
            log.error("사용자 삭제 실패: {}", e.getMessage());
            return ResponseEntity.status(500).body("사용자 삭제 중 오류 발생");
        }
    }
}
