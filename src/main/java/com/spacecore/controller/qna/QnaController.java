package com.spacecore.controller.qna;

import com.spacecore.domain.qna.Qna;
import com.spacecore.security.CustomUserDetails;
import com.spacecore.service.qna.QnaService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;
import java.util.Objects;

/**
 * 사용자에게 HTML 페이지(View)를 보여주는 역할
 */

@Controller
@RequiredArgsConstructor
@RequestMapping("/qna")
public class QnaController {
    private final QnaService qnaService;

    //기본 Get 핸들러
    @GetMapping
    public String defaultQna(){
        return "redirect:/qna/list";
    }

    //문의글 목록 페이지 - 비회원도 접근 가능
    @GetMapping("/list")
    public String qnaList(@AuthenticationPrincipal CustomUserDetails user, Model model){
        Long currentUserId = (user != null) ? user.getId() : null;
        String currentUserRole = (user != null) ? user.getRole() : null;

        List<Qna> qnaList = qnaService.getQnaList(currentUserId, currentUserRole);
        model.addAttribute("qnaList", qnaList);
        model.addAttribute("currentUserId", currentUserId);
        model.addAttribute("currentUserRole", currentUserRole);

        return "qna/list";
    }

    //문의글 상세조회 페이지
    @GetMapping("/detail/{id}")
    public String qnaDetail(@PathVariable Long id,
                            @AuthenticationPrincipal CustomUserDetails user,
                            Model model){
        Long currentUserId = (user != null) ? user.getId() : null;
        String currentUserRole = (user != null) ? user.getRole() : null;

        Qna qna = qnaService.getQnaDetail(id, currentUserId, currentUserRole);

        if(qna == null){
            //비공개 글에대한 접근 권한이 없거나 글이 존재하지 않을 경우
            return "redirect:/qna/list";
        }

        model.addAttribute("qna", qna);
        model.addAttribute("currentUserId", currentUserId);
        model.addAttribute("currentUserRole", currentUserRole);
        return "qna/detail";
    }

    //문의글 등록 페이지
    @PreAuthorize("isAuthenticated()")  //SecurityConfig 권한부분에 추가 시 삭제 가능
    @GetMapping("/write")
    public String writeForm(){
        return "qna/write";
    }

    //문의글 수정 페이지
    @PreAuthorize("isAuthenticated()")
    @GetMapping("/modify/{id}")
    public String modifyForm(@PathVariable Long id,
                             @AuthenticationPrincipal CustomUserDetails user,
                             Model model){

        if(user.getId() == null){
            return "redirect:/login";
        }

        //단순 조회 로직 활용 - 현재 글 정보 가져오기
        Qna qna = qnaService.getQnaDetail(id, user.getId(), user.getRole());

        //글이 존재하지 않거나, 작성자가 아니거나, 이미 답변이 완료된 글은 수정 불가
        if(qna == null || !Objects.equals(qna.getUserId(), user.getId()) || "ANSWERED".equals(qna.getStatus())){
            return "redirect:/qna/list";
        }

        model.addAttribute("qna", qna);
        model.addAttribute("currentUserId", user.getId());
        model.addAttribute("currentUserRole", user.getRole());
        return  "qna/modify";
    }
}
