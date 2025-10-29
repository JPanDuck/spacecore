package com.spacecore.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

    @GetMapping({"/", "/index"})
    public String index() {
        return "common/index";  // => /WEB-INF/views/common/index.jsp
    }
}
