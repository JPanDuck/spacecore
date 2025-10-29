package com.spacecore.domain.user;

import lombok.Data;

import java.time.LocalDate;

@Data
public class User {
    private Long id;
    private String email;
    private String password;
    private String Name;
    private String phone;
    private String role;
    private String status;
    private LocalDate createdAt;
}
