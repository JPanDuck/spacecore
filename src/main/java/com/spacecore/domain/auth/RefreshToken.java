package com.spacecore.domain.auth;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RefreshToken {
    private Long id;              // PK
    private Long userId;          // FK → users.id
    private String token;         // refresh token 문자열
    private LocalDateTime expiryDate;
}