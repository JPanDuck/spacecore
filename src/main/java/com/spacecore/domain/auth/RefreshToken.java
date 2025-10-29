package com.spacecore.domain.auth;

import lombok.Data;

import java.time.LocalDate;
@Data
public class RefreshToken {
    private Long id;
    private Long userId;
    private String token;
    private LocalDate expiryDate;
}