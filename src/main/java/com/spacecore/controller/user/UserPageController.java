package com.spacecore.controller.user;

import com.spacecore.security.CustomUserDetails;
import com.spacecore.service.user.UserService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Slf4j
@Controller
@RequiredArgsConstructor
@RequestMapping("/user")
@PreAuthorize("isAuthenticated()")
public class UserPageController {

    private final UserService userService;

    /** 마이페이지 (내 정보 조회) */
    @GetMapping("/mypage")
    public String myPage(@AuthenticationPrincipal CustomUserDetails userDetails, Model model) {
        model.addAttribute("user", userDetails.getUser());
        return "user/mypage";
    }

    /** 내 정보 수정 페이지 */
    @GetMapping("/edit")
    public String editPage(@AuthenticationPrincipal CustomUserDetails userDetails, Model model) {
        model.addAttribute("user", userService.findById(userDetails.getUser().getId()));
        return "user/edit";
    }

    /** 비밀번호 변경 페이지 */
    @GetMapping("/change-password")
    public String passwordPage() {
        return "user/change-password";
    }

    /** 회원 탈퇴 페이지 */
    @GetMapping("/delete")
    public String deletePage() {
        return "user/delete";
    }
}
