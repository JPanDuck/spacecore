package com.spacecore.domain.user;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

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
    private String provider;        // 소셜 로그인 공급자 (google, naver 등)
    private String providerId;      // 공급자 고유 ID 또는 이메일
    private String isTempPassword;  // Y/N
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    //JSTL - LocalDateTime 사용 불가로 String 으로 변환 / 출력 전용
    public String getCreatedAtStr() {
        return createdAt != null ? createdAt.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")) : "";
    }

    public String getUpdatedAtStr() {
        return updatedAt != null ? updatedAt.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")) : "";
    }
}