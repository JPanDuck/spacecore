package com.spacecore.service.review;

import com.spacecore.dto.common.PaginationDTO;
import com.spacecore.dto.review.ReviewRequestDTO;
import com.spacecore.dto.review.ReviewResponseDTO;
import com.spacecore.dto.review.ReviewSummaryDTO;
import com.spacecore.mapper.review.ReviewMapper;
import com.spacecore.util.common.PaginationHelper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class ReviewServiceImpl implements ReviewService {

    private final ReviewMapper reviewMapper;

    @Override
    public PaginationDTO<ReviewResponseDTO> getReviews(Long roomId, int page, int size,
                                                       String keyword, String userName, Integer rating) {
        // ✅ 총 리뷰 수
        int totalCount = reviewMapper.countReviews(roomId, keyword, userName, rating);

        // ✅ 오프셋 계산
        int offset = (page - 1) * size;

        // ✅ 리뷰 목록 조회
        List<ReviewResponseDTO> reviews =
                reviewMapper.findReviews(roomId, keyword, userName, rating, size, offset);

        // ✅ 페이징 정보 계산
        Map<String, Object> pageInfo = PaginationHelper.getPageInfo(totalCount, page, size, 5);

        return new PaginationDTO<>(reviews, pageInfo);
    }

    @Override
    public ReviewSummaryDTO getReviewSummary(Long roomId) {
        return reviewMapper.getReviewSummary(roomId);
    }
    @Override
    public void createReview(Long roomId, ReviewRequestDTO request) {
        request.setRoomId(roomId); // roomId 세팅 명확히
        reviewMapper.insertReview(request);
    }
}
