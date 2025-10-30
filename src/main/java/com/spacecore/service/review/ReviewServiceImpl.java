package com.spacecore.service.review;

import com.spacecore.dto.common.PaginationDTO;
import com.spacecore.dto.review.*;
import com.spacecore.mapper.review.ReviewMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import java.io.IOException;
import java.util.*;

@Service
@RequiredArgsConstructor
public class ReviewServiceImpl implements ReviewService {

    private final ReviewMapper reviewMapper;

    @Override
    public void createReview(Long roomId, ReviewRequestDTO request) {
        byte[] imgBytes = null;
        MultipartFile file = request.getImg();

        if (file != null && !file.isEmpty()) {
            try {
                imgBytes = file.getBytes();
            } catch (IOException e) {
                throw new RuntimeException("이미지 업로드 중 오류 발생", e);
            }
        }

        reviewMapper.insertReview(
                request.getUserId(),
                roomId,
                request.getRating(),
                request.getContent(),
                imgBytes
        );
    }

    @Override
    public PaginationDTO<ReviewResponseDTO> getReviews(
            Long roomId, int page, int size, String keyword, String userName, Integer rating) {

        int offset = (page - 1) * size;
        Map<String, Object> params = new HashMap<>();
        params.put("roomId", roomId);
        params.put("offset", offset);
        params.put("size", size);
        params.put("keyword", keyword);
        params.put("userName", userName);
        params.put("rating", rating);

        List<ReviewResponseDTO> data = reviewMapper.selectReviews(params);
        int total = reviewMapper.countReviews(params);

        // 페이지 정보 세팅
        PaginationDTO.PageInfo pageInfo = new PaginationDTO.PageInfo();
        pageInfo.setCurrentPage(page);
        pageInfo.setSize(size);
        pageInfo.setTotalCount(total);
        pageInfo.setTotalPages((int) Math.ceil((double) total / size));
        pageInfo.setSortField("createdAt");
        pageInfo.setSortOrder("DESC");

        // 반환 객체 세팅
        PaginationDTO<ReviewResponseDTO> result = new PaginationDTO<>();
        result.setData(data);
        result.setPageInfo(pageInfo);

        return result;
    }

    @Override
    public ReviewSummaryDTO getReviewSummary(Long roomId) {
        return reviewMapper.selectReviewSummary(roomId);
    }
}
