package com.spacecore.domain.notice;

import lombok.Data;

import java.time.LocalDate;
@Data
public class Notice {
    private Long id;
    private Long userId;
    private String title;
    private String content;
    private String pinned;
    private LocalDate createdAt;
}
