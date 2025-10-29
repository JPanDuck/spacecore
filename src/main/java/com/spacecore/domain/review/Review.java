package com.spacecore.domain.review;

import lombok.Data;

import java.sql.Blob;
import java.time.LocalDate;

@Data
public class Review {
    private Long id;
    private Long userId;
    private Long roomId;
    private Long rating;
    private Blob img;
    private String content;
    private LocalDate createdAt;
}
