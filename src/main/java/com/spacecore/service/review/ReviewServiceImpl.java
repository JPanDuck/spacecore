package com.spacecore.service.review;

import com.spacecore.dto.common.PageInfoDTO;
import com.spacecore.dto.common.PaginationDTO;
import com.spacecore.dto.review.ReviewRequestDTO;
import com.spacecore.dto.review.ReviewResponseDTO;
import com.spacecore.dto.review.ReviewSummaryDTO;
import com.spacecore.mapper.review.ReviewMapper;
import com.spacecore.util.common.PaginationHelper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ReviewServiceImpl implements ReviewService {

    private final ReviewMapper reviewMapper;

    @Override
    public PaginationDTO<ReviewResponseDTO> getReviews(Long roomId, int page, int size,
                                                       String keyword, String userName, Integer rating) {
        if (page <= 0) page = 1;
        if (size <= 0) size = 10;

        int totalCount = reviewMapper.countReviews(roomId, keyword, userName, rating);
        int offset = (page - 1) * size;

        List<ReviewResponseDTO> reviews = null;
        try {
            reviews = reviewMapper.findReviews(roomId, keyword, userName, rating, offset, size);
        } catch (Exception e) {
            System.err.println("❌ 리뷰 매퍼 조회 중 예외 발생:");
            e.printStackTrace();
            throw e;
        }

        // 디버깅 로그
        System.out.println("=== 리뷰 조회 디버깅 ===");
        System.out.println("roomId: " + roomId);
        System.out.println("page: " + page);
        System.out.println("size(limit): " + size);
        System.out.println("offset: " + offset);
        System.out.println("totalCount: " + totalCount);
        System.out.println("조회된 리뷰 개수: " + (reviews != null ? reviews.size() : 0));
        
        if (reviews != null && reviews.size() > 0) {
            System.out.println("=== 첫 번째 리뷰 데이터 ===");
            ReviewResponseDTO firstReview = reviews.get(0);
            System.out.println("id: " + firstReview.getId());
            System.out.println("userName: " + firstReview.getUserName() + " (type: " + (firstReview.getUserName() != null ? firstReview.getUserName().getClass().getName() : "null") + ")");
            System.out.println("content: " + firstReview.getContent() + " (type: " + (firstReview.getContent() != null ? firstReview.getContent().getClass().getName() : "null") + ")");
            System.out.println("rating: " + firstReview.getRating());
            System.out.println("roomId: " + firstReview.getRoomId());
            System.out.println("imgUrl: " + firstReview.getImgUrl());
            System.out.println("createdAt: " + firstReview.getCreatedAt());
            System.out.println("========================");
        }
        
        System.out.println("======================");

        PageInfoDTO pageInfo = PaginationHelper.createPageInfo(totalCount, page, size);

        return new PaginationDTO<>(reviews, pageInfo);
    }

    @Override
    public ReviewSummaryDTO getReviewSummary(Long roomId) {
        return reviewMapper.getReviewSummary(roomId);
    }

    @Override
    public void createReview(Long roomId, ReviewRequestDTO dto) {
        // roomId 세팅
        dto.setRoomId(roomId);

        // null 방지 방어 코드
        if (dto.getRoomId() == null) {
            throw new IllegalArgumentException("roomId 값이 누락되었습니다.");
        }
        if (dto.getUserId() == null) {
            throw new IllegalArgumentException("userId 값이 누락되었습니다.");
        }
        if (dto.getContent() == null || dto.getContent().trim().isEmpty()) {
            throw new IllegalArgumentException("리뷰 내용이 비어 있습니다.");
        }
        if (dto.getRating() <= 0 || dto.getRating() > 5) {
            throw new IllegalArgumentException("별점 값이 유효하지 않습니다. (1~5 사이여야 함)");
        }

        // 실제 DB 저장
        reviewMapper.insertReview(dto);
    }

    @Override
    public ReviewResponseDTO getReviewById(Long reviewId) {
        return reviewMapper.findById(reviewId);
    }
}
