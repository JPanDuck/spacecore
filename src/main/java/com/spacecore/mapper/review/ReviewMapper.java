package com.spacecore.mapper.review;

import com.spacecore.dto.review.*;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface ReviewMapper {

    List<ReviewResponseDTO> findReviews(
            @Param("roomId") Long roomId,
            @Param("keyword") String keyword,
            @Param("userName") String userName,
            @Param("rating") Integer rating,
            @Param("offset") int offset,
            @Param("limit") int limit
    );

    int countReviews(
            @Param("roomId") Long roomId,
            @Param("keyword") String keyword,
            @Param("userName") String userName,
            @Param("rating") Integer rating
    );

    void insertReview(ReviewRequestDTO dto);

    ReviewSummaryDTO getReviewSummary(@Param("roomId") Long roomId);

    ReviewResponseDTO findById(@Param("reviewId") Long reviewId);
}
