package com.spacecore.controller.qna;

import com.spacecore.domain.qna.Qna;
import com.spacecore.domain.qna.QnaReply;
import com.spacecore.security.CustomUserDetails;
import com.spacecore.service.qna.QnaService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@PreAuthorize("isAuthenticated()")
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/qna")
public class QnaRestController {
    private final QnaService qnaService;

    //문의글 등록
    @PostMapping
    public ResponseEntity<?> registerQna(@RequestBody Qna qna,
                                         @AuthenticationPrincipal CustomUserDetails user){
        Long currentUserId = user.getId();
        if(currentUserId == null){
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of("message", "로그인이 필요합니다."));
        }

        qna.setUserId(currentUserId);
        qnaService.registerQna(qna, currentUserId);

        return ResponseEntity.status(HttpStatus.CREATED)
                .body(Map.of("message", "문의글이 등록되었습니다.", "qnaId", qna.getId()));
    }

    //문의글 수정
    @PutMapping("/{id}")
    public ResponseEntity<?> modifyQna(@PathVariable Long id, @RequestBody Qna qna,
                                       @AuthenticationPrincipal CustomUserDetails user){
        Long currentUserId = user.getId();

        qna.setId(id);
        qna.setUserId(currentUserId);

        boolean success = qnaService.modifyQna(qna);

        if(success){
            return ResponseEntity.ok(Map.of("message", "문의글이 수정되었습니다."));
        }else {
            //본인 글이 아니거나, 이미 답변이 달렸을때 등 실패 시
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(Map.of(
                    "message", "문의글 수정 권한이 없거나 이미 답변 완료된 문의글입니다."));
        }
    }

    //문의글 삭제
    @DeleteMapping("/{id}")
    public ResponseEntity<?> removeQna(@PathVariable Long id,
                                       @AuthenticationPrincipal CustomUserDetails user){
        Long currentUserId = user.getId();

        boolean success = qnaService.removeQna(id, currentUserId);

        if(success){
            return ResponseEntity.ok(Map.of("message", "문의글이 삭제되었습니다."));
        }else {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(Map.of(
                    "message", "문의글 삭제 권한이 없거나 존재하지 않는 글입니다."));
        }
    }

//------------------------ QnaReply -------------------------------------------------------------------

    //답변/댓글 등록
    @PostMapping("/{qnaId}/reply")
    public ResponseEntity<?> registerReply(@PathVariable Long qnaId,
                                           @RequestBody QnaReply reply,
                                           @AuthenticationPrincipal CustomUserDetails user){
        Long currentUserId = user.getId();
        String currentUserRole = user.getRole();

        if(currentUserId == null){
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of("message", "로그인이 필요합니다."));
        }

        try{
            reply.setQnaId(qnaId);
            //서비스 계층에서 권한 체크 및 알림 처리
            qnaService.registerReply(reply, currentUserId, currentUserRole);

            return ResponseEntity.status(HttpStatus.CREATED).body(Map.of("message", "댓글이 등록되었습니다."));
        }catch (SecurityException e){
            //비공개 글에 대한 권한이 없을 경우 - 403
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(Map.of("message", e.getMessage()));
        }catch (IllegalArgumentException e){
            //문의글이 존재하지 않을 경우 - 404
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(Map.of("message", e.getMessage()));
        }catch (Exception e){
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body((Map.of(
                    "message", "댓글 등록 중 오류 발생", "error", e.getMessage())));
        }
    }

    //답변/댓글 수정
    @PutMapping("/reply/{id}")
    public ResponseEntity<?> modifyReply(@PathVariable Long id,
                                         @RequestBody QnaReply reply,
                                         @AuthenticationPrincipal CustomUserDetails user){
        Long currentUserId = user.getId();

        if(currentUserId == null){
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of("message", "로그인이 필요합니다."));
        }

        reply.setId(id);
        boolean success = qnaService.modifyReply(reply, currentUserId);

        if(success){
            return ResponseEntity.ok(Map.of("message", "댓글이 수정었습니다."));
        }else { //403
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(Map.of("message", "댓글 수정 권한이 없습니다."));
        }
    }

    //답변/댓글 삭제
    @DeleteMapping("/reply/{id}")
    public ResponseEntity<?> removeReply(@PathVariable Long id, @AuthenticationPrincipal CustomUserDetails user){
        Long currentUserId = user.getId();
        String currentUserRole = user.getRole();

        if(currentUserId == null){
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of("message", "로그인이 필요합니다."));
        }

        boolean success = qnaService.removeReply(id, currentUserId, currentUserRole);

        if(success){
            return ResponseEntity.ok(Map.of("message", "댓글이 삭제되었습니다."));
        }else {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(Map.of(
                    "message", "댓글 삭제 권한이 없거나 존재하지 않습니다."));
        }
    }
}
