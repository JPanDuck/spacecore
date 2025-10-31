package com.spacecore.dto.review;

import lombok.Data;
import org.springframework.web.multipart.MultipartFile;

@Data
public class ReviewRequestDTO {
    private Long userId;
    private Long roomId;
    private int rating;
    private String content;
    private MultipartFile imgFile; //이미지파일
    private String imgUrl; //파일 경로
}

