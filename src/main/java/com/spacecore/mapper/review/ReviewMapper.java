package com.spacecore.mapper.review;

import com.spacecore.dto.review.ReviewRequestDTO;
import com.spacecore.dto.review.ReviewResponseDTO;
import com.spacecore.dto.review.ReviewSummaryDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface ReviewMapper {

    /** 리뷰 등록 */
    void insertReview(@Param("request") ReviewRequestDTO request);

    /** 리뷰 목록 조회 (페이징 + 검색 + 필터링) */
    List<ReviewResponseDTO> findReviews(
            @Param("roomId") Long roomId,
            @Param("keyword") String keyword,
            @Param("userName") String userName,
            @Param("rating") Integer rating,
            @Param("limit") int limit,
            @Param("offset") int offset
    );

    /** 리뷰 개수 */
    int countReviews(
            @Param("roomId") Long roomId,
            @Param("keyword") String keyword,
            @Param("userName") String userName,
            @Param("rating") Integer rating
    );

    /** 리뷰 요약 (평균 별점 + 총 리뷰 수) */
    ReviewSummaryDTO getReviewSummary(@Param("roomId") Long roomId);
}
