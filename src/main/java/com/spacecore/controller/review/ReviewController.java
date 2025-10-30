package com.spacecore.controller.review;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequiredArgsConstructor
public class ReviewController {

    // 그냥 페이지 보여주는 역할만
    @GetMapping("/reviews")
    public String reviewListPage(@RequestParam(required = false) Long roomId) {
        // roomId는 JSP에서 param으로 받아쓰면 됨
        return "review/review-list";   // /WEB-INF/views/review/review-list.jsp
    }
}
