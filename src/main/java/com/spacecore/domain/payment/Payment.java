package com.spacecore.domain.payment;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
public class Payment {
    private Long id;
    private Long vaId;
    private Long amount;
    private String status;
    private LocalDateTime createdAt;
}
