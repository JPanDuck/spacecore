package com.spacecore.controller.review;

import com.spacecore.dto.common.PaginationDTO;
import com.spacecore.dto.review.ReviewRequestDTO;
import com.spacecore.dto.review.ReviewResponseDTO;
import com.spacecore.dto.review.ReviewSummaryDTO;
import com.spacecore.service.review.ReviewService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Collections;
import java.util.Map;

@RestController
@RequestMapping("/api/reviews")
@RequiredArgsConstructor
public class ReviewRestController {

    private final ReviewService reviewService;

    /** 💾 리뷰 등록 (파일첨부 포함) */
    @PostMapping("/rooms/{roomId}")
    public ResponseEntity<String> createReview(
            @PathVariable Long roomId,
            @ModelAttribute ReviewRequestDTO request
    ) {
        reviewService.createReview(roomId, request);
        return ResponseEntity.ok("리뷰가 등록되었습니다.");
    }

    /** 📄 리뷰 목록 조회 (페이징 + 검색 + 필터링) */
    @GetMapping("/rooms/{roomId}")
    public ResponseEntity<Map<String, Object>> getReviews(
            @PathVariable Long roomId,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "5") int limit,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String userName,
            @RequestParam(required = false) Integer rating
    ) {
        // ✅ 서비스 호출
        PaginationDTO<ReviewResponseDTO> result =
                reviewService.getReviews(roomId, page, limit, keyword, userName, rating);

        // ✅ null 방어 처리
        if (result == null) {
            return ResponseEntity.ok(Map.of(
                    "pageInfo", Collections.emptyMap(),
                    "data", Collections.emptyList()
            ));
        }

        // ✅ 데이터가 없을 때도 항상 data 키 포함
        return ResponseEntity.ok(Map.of(
                "pageInfo", result.getPageInfo(),
                "data", result.getData() != null ? result.getData() : Collections.emptyList()
        ));
    }

    /** ⭐ 리뷰 요약 (평균 + 총 개수) */
    @GetMapping("/rooms/{roomId}/summary")
    public ResponseEntity<ReviewSummaryDTO> getReviewSummary(@PathVariable Long roomId) {
        return ResponseEntity.ok(reviewService.getReviewSummary(roomId));
    }
}
