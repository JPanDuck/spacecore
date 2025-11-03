package com.spacecore.domain.user;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * 사용자 엔티티
 * - 일반 회원 + 소셜(OAuth2) 사용자 공통
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class User {
    private Long id;                // PK
    private String username;        // 로그인 ID
    private String email;           // 이메일
    private String password;        // 암호화된 비밀번호 (소셜 로그인 시 null)
    private String name;            // 이름
    private String phone;           // 연락처
    private String role;            // ROLE_USER / ROLE_ADMIN
    private String status;          // ACTIVE / SUSPENDED
    private String isTempPassword;  // Y/N
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
