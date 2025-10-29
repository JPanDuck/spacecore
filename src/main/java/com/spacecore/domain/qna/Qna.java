package com.spacecore.domain.qna;

import lombok.Data;

import java.time.LocalDate;

@Data
public class Qna {
    private Long id;
    private Long userId;
    private String title;
    private String content;
    private String isPrivate;
    private String status;
    private LocalDate createdAt;
}
