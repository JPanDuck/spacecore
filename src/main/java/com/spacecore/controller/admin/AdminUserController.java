package com.spacecore.controller.admin;

import com.spacecore.domain.user.User;
import com.spacecore.service.user.UserService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Slf4j
@Controller
@RequiredArgsConstructor
@RequestMapping("/admin")
@PreAuthorize("hasRole('ADMIN')") // 관리자만 접근 가능
public class AdminUserController {

    private final UserService userService;

    /** ✅ 사용자 목록 */
    @GetMapping("/list")
    public String listUsers(Model model) {
        List<User> userList = userService.findAll();
        model.addAttribute("users", userList);
        return "admin/list";
    }

    /** ✅ 사용자 상세 정보 */
    @GetMapping("/{id}")
    public String detailUser(@PathVariable Long id, Model model) {
        User user = userService.findById(id);
        model.addAttribute("user", user);
        return "admin/detail";
    }

    /** ✅ 사용자 수정 폼 */
    @GetMapping("/{id}/edit")
    public String editForm(@PathVariable Long id, Model model) {
        User user = userService.findById(id);
        model.addAttribute("user", user);
        return "admin/edit";
    }

    /** ✅ 사용자 수정 처리 */
    @PostMapping("/{id}/edit")
    public String updateUser(@PathVariable Long id,
                             @ModelAttribute User formUser,
                             RedirectAttributes redirectAttributes) {
        try {
            User existingUser = userService.findById(id);
            if (existingUser == null) {
                redirectAttributes.addFlashAttribute("message", "해당 사용자를 찾을 수 없습니다.");
                return "redirect:/admin/list";
            }

            // ✅ 상태(status)만 변경
            if (formUser.getStatus() != null) {
                existingUser.setStatus(formUser.getStatus());
                userService.update(existingUser);
                log.info("관리자 - 사용자 상태 변경 완료: id={}, newStatus={}", id, formUser.getStatus());
                redirectAttributes.addFlashAttribute("message", "✅ 사용자 상태가 변경되었습니다.");
            } else {
                redirectAttributes.addFlashAttribute("message", "⚠️ 상태 값이 비어 있습니다.");
            }

            return "redirect:/admin/" + id;

        } catch (Exception e) {
            log.error("❌ 사용자 상태 변경 중 오류: {}", e.getMessage(), e);
            redirectAttributes.addFlashAttribute("message", "상태 변경 중 오류가 발생했습니다.");
            return "redirect:/admin/list";
        }
    }

    /** ✅ 비밀번호 초기화 (관리자 전용) */
    @PostMapping("/{id}/reset-password")
    public String resetPassword(@PathVariable Long id,
                                RedirectAttributes redirectAttributes) {
        userService.resetPasswordByAdmin(id);
        redirectAttributes.addFlashAttribute("message", "비밀번호가 초기화되었습니다.");
        log.info("관리자 - 비밀번호 초기화: userId={}", id);
        return "redirect:/admin/" + id;
    }

    /** ✅ 사용자 삭제 */
    @PostMapping("/{id}/delete")
    public String deleteUser(@PathVariable Long id,
                             RedirectAttributes redirectAttributes) {
        userService.delete(id);
        redirectAttributes.addFlashAttribute("message", "사용자가 삭제되었습니다.");
        log.info("관리자 - 사용자 삭제: userId={}", id);
        return "redirect:/admin/list";
    }
}