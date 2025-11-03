package com.spacecore.test;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

public class AdminLoginTest {
    public static void main(String[] args) {
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
        String rawPassword = "admin1234"; // 관리자용 초기 비밀번호
        String encoded = encoder.encode(rawPassword);
        System.out.println("암호화된 관리자 비밀번호: " + encoded);
    }
}
//$2a$10$/j91tk8h5kn924S.geANXu/EDg/6CHmNyal4b3XBAhTnN8q1/2NOC