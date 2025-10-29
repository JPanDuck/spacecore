package com.spacecore.domain.virtualAccount;

import lombok.Data;

import java.time.LocalDate;

@Data
public class VirtualAccount {
    private Long id;
    private Long resId;
    private String accountNo;
    private String bankCode;
    private LocalDate expiresAt;
    private String status;
    private LocalDate createdAt;
}
