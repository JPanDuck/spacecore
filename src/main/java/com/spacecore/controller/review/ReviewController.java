package com.spacecore.controller.review;

import com.spacecore.dto.common.PaginationDTO;
import com.spacecore.dto.review.ReviewRequestDTO;
import com.spacecore.dto.review.ReviewResponseDTO;
import com.spacecore.service.review.ReviewService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpSession;
import java.nio.file.*;
import java.util.List;

@Controller
@RequiredArgsConstructor
@RequestMapping("/reviews")
public class ReviewController {

    private final ReviewService reviewService;

    // ============================================================
    // ✅ 리뷰 목록 (누구나 접근 가능)
    // ============================================================
    @GetMapping
    public String reviewListPage(@RequestParam(required = false) Long roomId,
                                 @RequestParam(defaultValue = "1") int page,
                                 @RequestParam(defaultValue = "5") int limit,
                                 @RequestParam(required = false) String keyword,
                                 @RequestParam(required = false) String userName,
                                 @RequestParam(required = false) Integer rating,
                                 Model model) {

        if (roomId == null) roomId = 1L;

        PaginationDTO<ReviewResponseDTO> result =
                reviewService.getReviews(roomId, page, limit, keyword, userName, rating);

        model.addAttribute("data", result.getData());
        model.addAttribute("pageInfo", result.getPageInfo());
        model.addAttribute("filterFields", List.of("keyword", "userName", "rating"));
        model.addAttribute("roomId", roomId);

        // 목록 페이지 이동 시 query 유지
        String baseUrl = "/reviews" + (roomId != null ? "?roomId=" + roomId : "");
        model.addAttribute("baseUrl", baseUrl);

        return "review/review-list";
    }

    // ============================================================
    // ✅ 리뷰 작성 폼 (USER만 접근 가능)
    // ============================================================
    @GetMapping("/create")
    public String reviewForm(@RequestParam(value = "roomId", required = false) Long roomId,
                             HttpSession session,
                             Model model) {
        if (roomId == null) roomId = 1L;

        String role = (String) session.getAttribute("role");
        if (role == null) {
            // 비회원 → 로그인 유도
            return "redirect:/auth/login";
        } else if ("ADMIN".equals(role)) {
            // 관리자 → 접근 불가
            model.addAttribute("message", "관리자는 리뷰를 작성할 수 없습니다.");
            return "error/403";
        }

        model.addAttribute("roomId", roomId);
        return "review/review-create";
    }

    // ============================================================
    // ✅ 리뷰 등록 처리 (USER만 가능)
    // ============================================================
    @PostMapping("/create")
    public String createReview(@ModelAttribute ReviewRequestDTO dto,
                               @RequestParam(value = "imgFiles", required = false) List<MultipartFile> imgFiles,
                               HttpSession session,
                               Model model) {

        String role = (String) session.getAttribute("role");
        if (role == null) {
            return "redirect:/auth/login";
        } else if ("ADMIN".equals(role)) {
            model.addAttribute("message", "관리자는 리뷰를 작성할 수 없습니다.");
            return "error/403";
        }

        try {
            if (dto.getRoomId() == null) {
                throw new IllegalArgumentException("roomId 값이 누락되었습니다.");
            }

            // 업로드 경로 생성
            String uploadDir = "C:/uploads/reviews/";
            Path uploadPath = Paths.get(uploadDir);
            if (Files.notExists(uploadPath)) {
                Files.createDirectories(uploadPath);
            }

            // 이미지 파일 업로드
            if (imgFiles != null && !imgFiles.isEmpty()) {
                StringBuilder imgPaths = new StringBuilder();

                for (MultipartFile file : imgFiles) {
                    if (!file.isEmpty()) {
                        String fileName = System.currentTimeMillis() + "_" + file.getOriginalFilename();
                        Path filePath = uploadPath.resolve(fileName);
                        file.transferTo(filePath.toFile());
                        imgPaths.append("/uploads/reviews/").append(fileName).append(",");
                    }
                }

                if (imgPaths.length() > 0) {
                    imgPaths.setLength(imgPaths.length() - 1);
                    dto.setImgUrl(imgPaths.toString());
                }
            }

            reviewService.createReview(dto.getRoomId(), dto);
            return "redirect:/reviews?roomId=" + dto.getRoomId();

        } catch (Exception e) {
            e.printStackTrace();
            return "error/500";
        }
    }

    // ============================================================
    // ✅ 리뷰 상세보기 (누구나 접근 가능)
    // ============================================================
    @GetMapping("/{reviewId}")
    public String reviewDetail(@PathVariable Long reviewId, Model model) {
        ReviewResponseDTO review = reviewService.getReviewById(reviewId);

        if (review == null) {
            model.addAttribute("message", "해당 리뷰를 찾을 수 없습니다.");
            return "error/404";
        }

        // base64 이미지 변환 처리
        String base64Img = null;
        if (review.getImgUrl() != null && review.getImgUrl().startsWith("data:")) {
            base64Img = review.getImgUrl().substring(review.getImgUrl().indexOf(",") + 1);
        }

        model.addAttribute("review", review);
        model.addAttribute("base64Img", base64Img);
        return "review/review-detail";
    }
}
