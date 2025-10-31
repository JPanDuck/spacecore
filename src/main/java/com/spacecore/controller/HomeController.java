package com.spacecore.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

    // ✅ 메인 페이지
    @GetMapping({"/", "/index"})
    public String index() {
        return "common/index"; // => /WEB-INF/views/common/index.jsp
    }

    // ✅ 로그인 페이지 이동
    @GetMapping("/login")
    public String loginForm() {
        return "auth/login"; // => /WEB-INF/views/auth/login.jsp
    }

    // ✅ (선택) 회원가입 페이지도 나중에 추가할 경우
    @GetMapping("/register")
    public String registerForm() {
        return "auth/register"; // => /WEB-INF/views/auth/register.jsp
    }
}
