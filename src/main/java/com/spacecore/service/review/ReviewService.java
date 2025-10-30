package com.spacecore.service.review;

import com.spacecore.dto.review.ReviewRequestDTO;
import com.spacecore.dto.review.ReviewSummaryDTO;
import com.spacecore.dto.common.PaginationDTO;

public interface ReviewService {

    void createReview(Long roomId, ReviewRequestDTO request);

    PaginationDTO getReviews(Long roomId, int page, int size, String keyword, String userName, Integer rating);

    ReviewSummaryDTO getReviewSummary(Long roomId);
}
