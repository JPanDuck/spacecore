package com.spacecore.controller.review;

import com.spacecore.dto.common.PaginationDTO;
import com.spacecore.dto.review.ReviewRequestDTO;
import com.spacecore.dto.review.ReviewResponseDTO;
import com.spacecore.dto.review.ReviewSummaryDTO;
import com.spacecore.service.review.ReviewService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import javax.servlet.http.HttpSession;
import java.util.Collections;
import java.util.Map;

@RestController
@RequestMapping("/api/reviews")
@RequiredArgsConstructor
public class ReviewRestController {

    private final ReviewService reviewService;

    /** 리뷰 등록 (USER만 가능) */
    @PostMapping("/rooms/{roomId}")
    public ResponseEntity<?> createReview(@PathVariable Long roomId,
                                          @ModelAttribute ReviewRequestDTO request,
                                          HttpSession session) {
        Object user = session.getAttribute("user");
        String role = (String) session.getAttribute("role");

        if (user == null) {
            return ResponseEntity.status(401).body("로그인 후 이용 가능합니다.");
        }
        if ("ADMIN".equals(role)) {
            return ResponseEntity.status(403).body("관리자는 리뷰를 작성할 수 없습니다.");
        }

        reviewService.createReview(roomId, request);
        return ResponseEntity.ok("리뷰가 등록되었습니다.");
    }

    /** 리뷰 목록 조회 */
    @GetMapping("/rooms/{roomId}")
    public ResponseEntity<Map<String, Object>> getReviews(@PathVariable Long roomId,
                                                          @RequestParam(defaultValue = "1") int page,
                                                          @RequestParam(defaultValue = "5") int limit,
                                                          @RequestParam(required = false) String keyword,
                                                          @RequestParam(required = false) String userName,
                                                          @RequestParam(required = false) Integer rating) {
        PaginationDTO<ReviewResponseDTO> result =
                reviewService.getReviews(roomId, page, limit, keyword, userName, rating);

        if (result == null) {
            return ResponseEntity.ok(Map.of(
                    "pageInfo", Collections.emptyMap(),
                    "data", Collections.emptyList()
            ));
        }

        return ResponseEntity.ok(Map.of(
                "pageInfo", result.getPageInfo(),
                "data", result.getData() != null ? result.getData() : Collections.emptyList()
        ));
    }

    /** 리뷰 요약 */
    @GetMapping("/rooms/{roomId}/summary")
    public ResponseEntity<ReviewSummaryDTO> getReviewSummary(@PathVariable Long roomId) {
        return ResponseEntity.ok(reviewService.getReviewSummary(roomId));
    }
}
