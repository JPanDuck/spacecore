package com.spacecore.controller.chatbot;

import com.spacecore.domain.chatbot.Chatbot;
import com.spacecore.service.chatbot.ChatbotService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/chatbot")
@RequiredArgsConstructor
public class ChatbotController {
    private final ChatbotService chatbotService;

    // 루트 경로인 /chatbot 요청을 /chatbot/faq로 리다이렉트
    @GetMapping({"", "/"}) // /chatbot 또는 /chatbot/ 요청 모두 처리
    public String redirectToFaq() {
        return "redirect:/chatbot/faq";
    }

    //FAQ 페이지 로드 및 질문 목록 반환 - 사용자용
    @GetMapping("/faq")
    public String getFaqPage(@RequestParam(value = "category", required = false) String category, Model model){
        //전체 FAQ 목록을 가져와 카테고리 탭 목록 구성
        List<Chatbot> allFaqs = chatbotService.getAllChatbots();

        //전체 목록에서 중복없는 카테고리명만 추출하여 model에 추가
        Set<String> categories = allFaqs.stream()
                .map(Chatbot::getCategory)
                .filter(cat -> cat != null && !cat.trim().isEmpty())
                .collect(Collectors.toCollection(LinkedHashSet::new));
        model.addAttribute("categories", categories);

        //현재 표시할 FAQ 목록 (초기화면: 카테고리만, 카테고리 선택 시 해당 카테고리 질문 보임)
        List<Chatbot> currentFaqs = List.of();  //빈 리스트로 시작
        String currentCategoryLabel = "선택 필요";  //초기 상태 라벨

        if(category != null && !category.trim().isEmpty()){
            //카테고리가 선택된 경우에만 서비스 호출
            currentFaqs = chatbotService.getChatbotsByCategory(category);
            currentCategoryLabel = category;
        }
        model.addAttribute("faqList", currentFaqs);
        model.addAttribute("currentCategory",  currentCategoryLabel);

        return "chatbot/faq";
    }

//---------------------------------------------------------------------------------------------------------------------

    //관리자용 FAQ 목록 페이지
    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/admin/list")
    public String getAdminList(Model model){
        //항상 전체 목록 조회
        model.addAttribute("faqList", chatbotService.getAllChatbots());
        return "chatbot/faqList";
    }

    //관리자용 FAQ 등록 폼
    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/admin/register")
    public String registerForm(){
        return "chatbot/register";
    }

    //관리자용 FAQ 수정 폼
    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/admin/modify")
    public String modifyForm(@RequestParam("id") Long id, Model model){
        //수정할 데이터를 조회하여 폼에 미리 채우기 위해 전달
        model.addAttribute("faq", chatbotService.getChatbotById(id));
        return "chatbot/modify";
    }
}