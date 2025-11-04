package com.spacecore.controller.user;

import com.spacecore.domain.user.User;
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

    /** ✅ 마이페이지 (내 정보 조회) */
    @GetMapping("/mypage")
    public String myPage(@AuthenticationPrincipal CustomUserDetails userDetails, Model model) {
        User user = userDetails.getUser();
        model.addAttribute("user", user);

        // ✅ OAUTH_USER 비밀번호 구분으로 비밀번호 변경 버튼 숨김 처리
        boolean isOauthUser = user.getPassword() != null && user.getPassword().contains("OAUTH");
        model.addAttribute("isOauthUser", isOauthUser);

        log.info("📄 마이페이지 진입: {} (OAuth 계정 여부: {})", user.getUsername(), isOauthUser);
        return "user/mypage";
    }

    /** ✅ 내 정보 수정 페이지 */
    @GetMapping("/edit")
    public String editPage(@AuthenticationPrincipal CustomUserDetails userDetails, Model model) {
        model.addAttribute("user", userService.findById(userDetails.getUser().getId()));
        return "user/edit";
    }

    /** ✅ 비밀번호 변경 페이지 */
    @GetMapping("/change-password")
    public String passwordPage(@AuthenticationPrincipal CustomUserDetails userDetails, Model model) {
        User user = userDetails.getUser();
        boolean isOauthUser = "OAUTH_USER".equals(user.getPassword());
        if (isOauthUser) {
            // 구글 로그인 계정은 비밀번호 변경 불가
            model.addAttribute("error", "Google 계정으로 로그인한 사용자는 비밀번호를 변경할 수 없습니다.");
            return "user/mypage";
        }
        return "user/change-password";
    }

    /** ✅ 회원 탈퇴 페이지 */
    @GetMapping("/delete")
    public String deletePage() {
        return "user/delete";
    }
}
