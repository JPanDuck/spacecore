package com.spacecore.dto.review;

import lombok.Data;

import java.time.LocalDate;


@Data
public class ReviewResponseDTO {
    private Long id;
    private String userName;  // SQL에서 AS userName
    private Long roomId;
    private Long rating;
    private String content;
    private String imgUrl;
    private LocalDate createdAt;
}
