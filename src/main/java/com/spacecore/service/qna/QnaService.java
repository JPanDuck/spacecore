package com.spacecore.service.qna;

import com.spacecore.domain.qna.Qna;
import com.spacecore.domain.qna.QnaReply;

import java.util.List;

public interface QnaService {
    //문의글 등록
    void registerQna(Qna qna, Long currentUserId);

    //문의글 목록 조회 (권한처리 포함)
    List<Qna> getQnaList(Long currentUserId, String currentUserRole);

    //문의글 상세조회
    Qna getQnaDetail(Long id, Long currentUserId, String currentUserRole);

    //문의글 단순 조회 - 댓글/알림/권한 확인용
    Qna getQnaByIdSimple(Long id);

    //문의글 수정
    boolean modifyQna(Qna qna);

    //문의글 삭제
    boolean removeQna(Long id, Long userId);

    //--------- QnaReply ---------------------------------------------

    //답변/댓글 등록 (알림 생성 로직 포함)
    void registerReply(QnaReply reply, Long currentUserId, String currentUserRole);

    //답변/댓글 수정
    boolean modifyReply(QnaReply reply, Long currentUserId);

    //답변/댓글 삭제
    boolean removeReply(Long id, Long currentUserId, String currentUserRole);
}
