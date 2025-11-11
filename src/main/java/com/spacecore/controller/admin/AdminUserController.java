package com.spacecore.controller.admin;

import com.spacecore.domain.user.User;
import com.spacecore.dto.common.PaginationDTO;
import com.spacecore.service.user.UserService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;

@Slf4j
@Controller
@RequiredArgsConstructor
@RequestMapping("/admin")
@PreAuthorize("hasRole('ADMIN')") // 관리자만 접근 가능
public class AdminUserController {

    private final UserService userService;

    /** ✅ 사용자 목록 (검색 및 페이징 지원) */
    @GetMapping("/list")
    public String listUsers(@RequestParam(value = "keyword", required = false, defaultValue = "") String keyword,
                            @RequestParam(value = "page", required = false, defaultValue = "1") int page,
                            @RequestParam(value = "limit", required = false, defaultValue = "10") int limit,
                            Model model) {
        PaginationDTO<User> pagination = userService.findAllWithSearch(keyword, page, limit);
        model.addAttribute("users", pagination.getData());
        model.addAttribute("pageInfo", pagination.getPageInfo());
        model.addAttribute("keyword", keyword);
        
        // baseUrl 생성 (검색어가 있으면 포함)
        String baseUrl = "/admin/list";
        if (keyword != null && !keyword.isEmpty()) {
            try {
                baseUrl += "?keyword=" + URLEncoder.encode(keyword, StandardCharsets.UTF_8.toString());
            } catch (UnsupportedEncodingException e) {
                baseUrl += "?keyword=" + keyword;
            }
        }
        model.addAttribute("baseUrl", baseUrl);
        
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

    /** ✅ 예약 차단 (사용자 상태를 SUSPENDED로 변경) */
    @PostMapping("/{id}/block-reservation")
    public String blockReservation(@PathVariable Long id,
                                   RedirectAttributes redirectAttributes) {
        try {
            User user = userService.findById(id);
            if (user == null) {
                redirectAttributes.addFlashAttribute("message", "해당 사용자를 찾을 수 없습니다.");
                return "redirect:/admin/list";
            }
            if (!"USER".equals(user.getRole())) {
                redirectAttributes.addFlashAttribute("message", "일반 사용자만 예약 차단할 수 있습니다.");
                return "redirect:/admin/" + id;
            }
            user.setStatus("SUSPENDED");
            userService.update(user);
            redirectAttributes.addFlashAttribute("message", "✅ 사용자의 예약이 차단되었습니다.");
            log.info("관리자 - 예약 차단: userId={}", id);
            return "redirect:/admin/" + id;
        } catch (Exception e) {
            log.error("❌ 예약 차단 중 오류: {}", e.getMessage(), e);
            redirectAttributes.addFlashAttribute("message", "예약 차단 중 오류가 발생했습니다.");
            return "redirect:/admin/" + id;
        }
    }

    /** ✅ 예약 차단 해제 (사용자 상태를 ACTIVE로 변경) */
    @PostMapping("/{id}/unblock-reservation")
    public String unblockReservation(@PathVariable Long id,
                                     RedirectAttributes redirectAttributes) {
        try {
            User user = userService.findById(id);
            if (user == null) {
                redirectAttributes.addFlashAttribute("message", "해당 사용자를 찾을 수 없습니다.");
                return "redirect:/admin/list";
            }
            if (!"USER".equals(user.getRole())) {
                redirectAttributes.addFlashAttribute("message", "일반 사용자만 예약 차단 해제할 수 있습니다.");
                return "redirect:/admin/" + id;
            }
            user.setStatus("ACTIVE");
            userService.update(user);
            redirectAttributes.addFlashAttribute("message", "✅ 사용자의 예약 차단이 해제되었습니다.");
            log.info("관리자 - 예약 차단 해제: userId={}", id);
            return "redirect:/admin/" + id;
        } catch (Exception e) {
            log.error("❌ 예약 차단 해제 중 오류: {}", e.getMessage(), e);
            redirectAttributes.addFlashAttribute("message", "예약 차단 해제 중 오류가 발생했습니다.");
            return "redirect:/admin/" + id;
        }
    }
}