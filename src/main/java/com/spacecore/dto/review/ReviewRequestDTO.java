package com.spacecore.dto.review;

import lombok.Data;
import org.springframework.web.multipart.MultipartFile;

@Data
public class ReviewRequestDTO {
    private Long roomId;
    private Long userId;
    private Long rating;
    private String content;
    private MultipartFile img; // 파일 업로드용
}
