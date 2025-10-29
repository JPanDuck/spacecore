package com.spacecore.domain.qna;

import lombok.Data;

import java.time.LocalDate;

@Data
public class QnaAnswer {
    private Long id;
    private Long qnaId;
    private Long userId;
    private String content;
    private LocalDate createdAt;
}
