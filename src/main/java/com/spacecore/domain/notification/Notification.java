package com.spacecore.domain.notification;

import lombok.Data;

import java.time.LocalDate;

@Data
public class Notification {
    private Long notiId;
    private Long userId;
    private String type;
    private Long refId;
    private String message;
    private String readYn;
    private LocalDate createdAt;
}
