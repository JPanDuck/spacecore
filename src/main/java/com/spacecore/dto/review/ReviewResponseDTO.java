package com.spacecore.dto.review;

import lombok.Data;


@Data
public class ReviewResponseDTO {
    private Long id;
    private String userName;  // SQL에서 AS userName
    private Long roomId;
    private Long rating;
    private String content;
    private String imgUrl;
    private String createdAt;  // DB에서 TO_CHAR로 문자열로 변환하여 반환
}
