package com.spacecore.dto.user;

import lombok.Data;

import javax.validation.constraints.Email;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Size;

@Data
public class RegisterRequest {

    @NotBlank(message = "아이디를 입력하세요.")
    private String username;

    @NotBlank(message = "비밀번호를 입력하세요.")
    @Size(min = 8, message = "비밀번호는 8자 이상이어야 합니다.")
    private String password;

    @NotBlank(message = "이름을 입력하세요.")
    private String name;

    @NotBlank(message = "이메일을 입력하세요.")
    @Email(message = "이메일 형식이 올바르지 않습니다.")
    private String email;

    private String phone;
}
