package com.spacecore.service.chatbot;

import com.spacecore.domain.chatbot.Chatbot;
import com.spacecore.mapper.chatbot.ChatbotMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ChatbotServiceImpl implements ChatbotService{
    private final ChatbotMapper chatbotMapper;

    //사용자용 FAQ 목록 조회 (카테고리별)
    @Override
    public List<Chatbot> getChatbotsByCategory(String category) {
        //사용자가 처음 FAQ 페이지에 접속했을때
        if(category == null || category.trim().isEmpty()){
            //카테고리가 지정되지 않으면 전체 목록을 반환
            return chatbotMapper.selectAllChatbots();
        }

        //지정된 카테고리 목록만 반환
        return chatbotMapper.selectChatbotByCategory(category);
    }

    //관리자용 전체 FAQ 목록 조회
    @Override
    public List<Chatbot> getAllChatbots() {
        return chatbotMapper.selectAllChatbots();
    }

    //FAQ 등록 - 관리자
    @Override
    public boolean registerChatbot(Chatbot chatbot) {
        return chatbotMapper.insertChatbot(chatbot) == 1;
    }

    //FAQ 수정 - 관리자
    @Override
    public boolean modifyChatbot(Chatbot chatbot) {
        return chatbotMapper.updateChatbot(chatbot) == 1;
    }

    //FAQ 삭제 - 관리자
    @Override
    public boolean removeChatbot(Long id) {
        return chatbotMapper.deleteChatbot(id) == 1;
    }

    //FAQ 단일 조회 (수정 폼 로딩 시 사용)
    @Override
    public Chatbot getChatbotById(Long id) {
        return chatbotMapper.selectChatbotById(id);
    }
}