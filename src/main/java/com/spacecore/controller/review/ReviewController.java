package com.spacecore.controller.review;

import com.spacecore.dto.common.PaginationDTO;
import com.spacecore.dto.review.ReviewSummaryDTO;
import com.spacecore.service.review.ReviewService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/reviews")
@RequiredArgsConstructor
public class ReviewController {

    private final ReviewService reviewService;

    @GetMapping("/rooms/{roomId}")
    public PaginationDTO getReviews(
            @PathVariable Long roomId,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "5") int size,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String userName,
            @RequestParam(required = false) Integer rating
    ) {
        return reviewService.getReviews(roomId, page, size, keyword, userName, rating);
    }

    @GetMapping("/rooms/{roomId}/summary")
    public ReviewSummaryDTO getReviewSummary(@PathVariable Long roomId) {
        return reviewService.getReviewSummary(roomId);
    }
}

