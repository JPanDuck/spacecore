package com.spacecore.mapper.chatbot;

import com.spacecore.domain.chatbot.Chatbot;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface ChatbotMapper {
    //챗봇 데이터 생성(FAQ) (관리자용)
    int insertChatbot(Chatbot chatbot);

    //챗봇 전체 목록 조회 (관라지 또는 전체 목록 페이지용) - priority 순으로 정렬하여 반환
    List<Chatbot> selectAllChatbots();

    //특정 카테고리에 해당하는 FAQ 목록 조회 (사용자 페이지용)
    List<Chatbot> selectChatbotByCategory(@Param("category") String category);

    //특정 FAQ 데이터 조회 (수정 또는 상세보기용)
    Chatbot selectChatbotById(Long id);

    //FAQ 데이터 수정 (관리자용)
    int updateChatbot(Chatbot chatbot);

    //FAQ 데이터 삭제 (관리자용)
    int deleteChatbot(Long id);
}