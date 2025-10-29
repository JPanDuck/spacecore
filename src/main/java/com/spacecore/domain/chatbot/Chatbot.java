package com.spacecore.domain.chatbot;

import lombok.Data;

import java.time.LocalDate;
@Data
public class Chatbot {
    private Long id;
    private  String question;
    private  String answer;
    private  String category;
    private  Long priority;
    private LocalDate createdAt;
}
