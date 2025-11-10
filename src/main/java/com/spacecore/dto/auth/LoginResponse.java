package com.spacecore.dto.auth;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

@Data
@AllArgsConstructor
@Builder
public class LoginResponse {
    private String username;
    private String role;
    private String accessToken;
    private String refreshToken;
}