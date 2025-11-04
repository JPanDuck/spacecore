package com.spacecore.dto.user;

import lombok.Data;

@Data
public class UserUpdateRequest {
    private String name;
    private String email;
    private String phone;
}
