package com.spacecore.domain.virtualAccount;

import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
public class VirtualAccount {
    private Long id;
    private Long resId;
    private String accountNo;
    private String bankName;
    private LocalDateTime expiresAt;
    private String status;
    private LocalDate createdAt;
}
