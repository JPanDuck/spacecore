package com.spacecore.domain.payment;

import lombok.Data;

import java.time.LocalDate;

@Data
public class Payment {
    private Long id;
    private Long vaId;
    private Long amount;
    private String status;
    private LocalDate createdAt;
}
