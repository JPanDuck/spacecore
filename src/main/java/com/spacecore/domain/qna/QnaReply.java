package com.spacecore.domain.qna;

import lombok.Data;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Data
public class QnaReply {
    private Long id;
    private Long qnaId;         //원본 문의글
    private Long userId;        //작성자 ID
    private String name;        //작성자 이름 - JOIN을 통해 users.name 필드를 가져옴
    private String isAdmin;     //관리자 답변인지 여부 (Y: 관리자 / N: 사용자)
    private Long parentReplyId; //대댓글 처리를 위한 부모댓글 ID (Null일 경우 최상위 답변)
    private String content;
    private LocalDateTime createdAt;

    //JSTL - LocalDate 사용 불가로 String 으로 변환 / 출력 전용
    public String getCreatedAtStr() {
        return createdAt != null ? createdAt.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")) : "";
    }
}
