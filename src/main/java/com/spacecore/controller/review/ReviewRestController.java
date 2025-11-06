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

    /** 리뷰 목록 조회 (전체 리뷰) */
    @GetMapping
    public ResponseEntity<Map<String, Object>> getAllReviews(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(required = false, defaultValue = "10") int limit,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String userName,
            @RequestParam(required = false) Integer rating) {
        // roomId가 null이면 모든 리뷰 조회
        PaginationDTO<ReviewResponseDTO> result =
                reviewService.getReviews(null, page, limit, keyword, userName, rating);

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

    /** 리뷰 목록 조회 (특정 roomId) */
    @GetMapping("/rooms/{roomId}")
    public ResponseEntity<Map<String, Object>> getReviews(@PathVariable Long roomId,
                                                          @RequestParam(defaultValue = "1") int page,
                                                          @RequestParam(required = false, defaultValue = "10") int limit,
                                                          @RequestParam(required = false) String keyword,
                                                          @RequestParam(required = false) String userName,
                                                          @RequestParam(required = false) Integer rating) {
        try {
            // 디버깅: 요청 파라미터 확인
            System.out.println("=== ReviewRestController 요청 파라미터 ===");
            System.out.println("roomId: " + roomId);
            System.out.println("page: " + page);
            System.out.println("limit: " + limit);
            System.out.println("keyword: " + keyword);
            System.out.println("userName: " + userName);
            System.out.println("rating: " + rating);
            System.out.println("==========================================");
            
            PaginationDTO<ReviewResponseDTO> result =
                    reviewService.getReviews(roomId, page, limit, keyword, userName, rating);

            if (result == null) {
                System.out.println("⚠️ result가 null입니다!");
                return ResponseEntity.ok(Map.of(
                        "pageInfo", Collections.emptyMap(),
                        "data", Collections.emptyList()
                ));
            }

            // 디버깅: 응답 데이터 확인
            System.out.println("=== ReviewRestController 응답 데이터 ===");
            System.out.println("pageInfo: " + result.getPageInfo());
            System.out.println("data 개수: " + (result.getData() != null ? result.getData().size() : 0));
            
            if (result.getData() != null && result.getData().size() > 0) {
                System.out.println("=== 첫 번째 리뷰 응답 데이터 ===");
                ReviewResponseDTO firstReview = result.getData().get(0);
                System.out.println("id: " + firstReview.getId());
                System.out.println("userName: [" + firstReview.getUserName() + "]");
                System.out.println("content: [" + firstReview.getContent() + "]");
                System.out.println("rating: " + firstReview.getRating());
                System.out.println("roomId: " + firstReview.getRoomId());
                System.out.println("================================");
            }
            
            System.out.println("========================================");

            return ResponseEntity.ok(Map.of(
                    "pageInfo", result.getPageInfo(),
                    "data", result.getData() != null ? result.getData() : Collections.emptyList()
            ));
        } catch (Exception e) {
            System.err.println("❌ 리뷰 조회 중 예외 발생:");
            e.printStackTrace();
            return ResponseEntity.status(500).body(Map.of(
                    "error", "리뷰 조회 중 오류가 발생했습니다.",
                    "message", e.getMessage()
            ));
        }
    }

    /** 리뷰 요약 (전체) */
    @GetMapping("/summary")
    public ResponseEntity<ReviewSummaryDTO> getAllReviewSummary() {
        return ResponseEntity.ok(reviewService.getReviewSummary(null));
    }

    /** 리뷰 요약 (특정 roomId) */
    @GetMapping("/rooms/{roomId}/summary")
    public ResponseEntity<ReviewSummaryDTO> getReviewSummary(@PathVariable Long roomId) {
        return ResponseEntity.ok(reviewService.getReviewSummary(roomId));
    }
}
