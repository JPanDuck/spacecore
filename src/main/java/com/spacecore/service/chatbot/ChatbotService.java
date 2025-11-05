package com.spacecore.service.chatbot;

import com.spacecore.domain.chatbot.Chatbot;

import java.util.List;

public interface ChatbotService {
    //사용자용 FAQ 목록 조회 (카테고리별)
    List<Chatbot> getChatbotsByCategory(String category);

    //관리자용 전체 FAQ 목록 조회
    List<Chatbot> getAllChatbots();

    //FAQ 등록 - 관리자
    boolean registerChatbot(Chatbot chatbot);

    //FAQ 수정 - 관리자
    boolean modifyChatbot(Chatbot chatbot);

    //FAQ 삭제 - 관리자
    boolean removeChatbot(Long id);

    //FAQ 단일 조회 (수정 폼 로딩 시 사용)
    Chatbot getChatbotById(Long id);

}