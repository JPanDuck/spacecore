package com.spacecore.controller.review;

import com.spacecore.dto.common.PaginationDTO;
import com.spacecore.dto.review.ReviewRequestDTO;
import com.spacecore.dto.review.ReviewSummaryDTO;
import com.spacecore.dto.common.PaginationDTO;
import com.spacecore.service.review.ReviewService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.Map;

@RestController
@RequestMapping("/api/reviews/list")
@RequiredArgsConstructor
public class ReviewRestController {

    private final ReviewService reviewService;

    /** 리뷰 등록 (파일첨부 포함) */
    @PostMapping("/{roomId}")
    public ResponseEntity<String> createReview(
            @PathVariable Long roomId,
            @ModelAttribute ReviewRequestDTO request) {
        reviewService.createReview(roomId, request);
        return ResponseEntity.ok("리뷰가 등록되었습니다.");
    }

    /** 리뷰 조회 (페이징 + 검색 + 필터링) */
    @GetMapping("/{roomId}")
    public ResponseEntity<Map<String, Object>> getReviews(
            @PathVariable Long roomId,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "5") int size,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String userName,
            @RequestParam(required = false) Integer rating) {

        PaginationDTO result = reviewService.getReviews(roomId, page, size, keyword, userName, rating);
        return ResponseEntity.ok(Map.of(
                "reviews", result.getData(),
                "pageInfo", result.getPageInfo()
        ));
    }

    /** 리뷰 요약 (평균 + 개수) */
    @GetMapping("/{roomId}/summary")
    public ResponseEntity<ReviewSummaryDTO> getReviewSummary(@PathVariable Long roomId) {
        return ResponseEntity.ok(reviewService.getReviewSummary(roomId));
    }
}
