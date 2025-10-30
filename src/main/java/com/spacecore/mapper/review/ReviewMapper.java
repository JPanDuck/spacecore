package com.spacecore.mapper.review;

import com.spacecore.dto.review.ReviewResponseDTO;
import com.spacecore.dto.review.ReviewSummaryDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;
import java.util.Map;

@Mapper
public interface ReviewMapper {

    void insertReview(@Param("userId") Long userId,
                      @Param("roomId") Long roomId,
                      @Param("rating") Long rating,
                      @Param("content") String content,
                      @Param("img") byte[] img);

    List<ReviewResponseDTO> selectReviews(Map<String, Object> params);

    int countReviews(Map<String, Object> params);

    ReviewSummaryDTO selectReviewSummary(Long roomId);
}
