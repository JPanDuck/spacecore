package com.spacecore.domain.reservation;

import lombok.Data;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
public class Reservation {
    private Long id;
    private Long userId;
    private Long roomId;
    private String reservantName;
    @DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss")
    private LocalDateTime startAt;

    @DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss")
    private LocalDateTime endAt;
    private String unit;
    private String status;
    private Long amount;
    private String memo;
    private LocalDate createdAt;

    // 목록 조회용
    private String userName;
    private String roomName;
}
