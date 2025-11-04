package com.spacecore.controller.auth;

import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;


@Slf4j
@Controller
public class AuthController {

    /** ✅ 메인 페이지 (로그인 여부와 상관없이 접근 가능) */
    @GetMapping({"/", "/index", ""})
    public String indexPage(Authentication authentication) {
        if (authentication != null && authentication.isAuthenticated()) {
            log.info("✅ 로그인된 사용자 메인 진입: {}", authentication.getName());
        } else {
            log.info("비로그인 상태로 메인 페이지 접속");
        }
        return "common/index"; // /WEB-INF/views/common/index.jsp
    }

    /** ✅ 로그인 페이지 */
    @GetMapping("/auth/login")
    public String loginPage(Authentication authentication) {
        // 이미 로그인된 사용자가 로그인 페이지에 접근하면 → 메인으로 이동
        if (authentication != null && authentication.isAuthenticated()) {
            log.info("이미 로그인된 사용자: {}", authentication.getName());
            return "redirect:/index";
        }
        return "auth/login"; // 로그인 JSP
    }

    /** ✅ 회원가입 페이지 */
    @GetMapping("/auth/register")
    public String registerPage() {

        return "auth/register"; // 회원가입 JSP
    }

    /** ✅ 비밀번호 찾기 페이지 */
    @GetMapping("/auth/find-password")
    public String findPasswordPage() {

        return "auth/find-password"; // 비밀번호 찾기 JSP
    }

    /** ✅ 비밀번호 재설정 페이지 */
    @GetMapping("/auth/reset-password")
    public String resetPasswordPage() {
        return "auth/reset-password"; // 비밀번호 재설정 JSP
    }
}
