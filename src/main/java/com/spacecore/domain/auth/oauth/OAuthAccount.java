package com.spacecore.domain.auth.oauth;

import lombok.Data;

import java.time.LocalDate;

@Data
public class OAuthAccount {
    private Long id;
    private Long userId;
    private String provider;
    private String providerUID;
    private String profileName;
    private String ProfileEmail;
    private String avatarUrl;
    private LocalDate createdAt;
}
