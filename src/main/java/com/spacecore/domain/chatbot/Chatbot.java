package com.spacecore.domain.chatbot;

import lombok.Data;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Data
public class Chatbot {
    private Long id;
    private  String question;
    private  String answer;
    private  String category;
    private  Long priority;
    private LocalDateTime createdAt;

    //JSTL - LocalDate 사용 불가로 String 으로 변환 / 출력 전용
    public String getCreatedAtStr() {
        return createdAt != null ? createdAt.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")) : "";
    }
}