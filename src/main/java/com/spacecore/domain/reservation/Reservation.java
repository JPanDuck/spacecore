package com.spacecore.domain.reservation;

import lombok.Data;

import java.time.LocalDate;

@Data
public class Reservation {
    private Long id;
    private Long userId;
    private Long roomId;
    private LocalDate startAt;
    private LocalDate endAt;
    private String unit;
    private String status;
    private Long amount;
    private String memo;
    private LocalDate createdAt;
}
