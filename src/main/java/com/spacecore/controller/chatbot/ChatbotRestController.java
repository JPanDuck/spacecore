package com.spacecore.controller.chatbot;

import com.spacecore.domain.chatbot.Chatbot;
import com.spacecore.service.chatbot.ChatbotService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

/**
 * 관리자 전용 API 컨트롤러
 * */

@RestController
@RequestMapping("/api/admin/chatbot")
@RequiredArgsConstructor
public class ChatbotRestController {
    private final ChatbotService chatbotService;

    //FAQ 등록
    @PostMapping
    public ResponseEntity<?> register(@RequestBody Chatbot chatbot){
        boolean success = chatbotService.registerChatbot(chatbot);
        if(success){
            return ResponseEntity.status(HttpStatus.CREATED).body("FAQ 등록이 완료되었습니다.");
        }
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("FAQ 등록에 실패했습니다.");
    }

    //FAQ 수정
    @PutMapping("/{id}")
    public ResponseEntity<?> modify(@PathVariable Long id, @RequestBody Chatbot chatbot){
        if(chatbot.getId() == null){
            chatbot.setId(id);  //URL의 ID를 Chatbot 객체에 설정 (ID 누락방지)
        }

        boolean success = chatbotService.modifyChatbot(chatbot);
        if(success){
            return ResponseEntity.ok("FAQ 수정이 완료되었습니다.");
        }
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body("수정할 FAQ를 찾을 수 없거나 수정에 실패했습니다.");
    }

    //FAQ 삭제
    @DeleteMapping("/{id}")
    public ResponseEntity<?> remove(@PathVariable Long id){
        boolean success = chatbotService.removeChatbot(id);
        if(success){
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body("삭제할 FAQ를 찾을 수 없습니다.");
    }
}