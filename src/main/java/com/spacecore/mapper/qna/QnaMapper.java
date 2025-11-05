package com.spacecore.mapper.qna;

import com.spacecore.domain.qna.Qna;
import com.spacecore.domain.qna.QnaReply;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface QnaMapper {
    //문의글 등록
    void insertQna(Qna qna);

    //문의글 목록 조회 (비공개 여부 포함)
    //currentUserId: 서비스 계층에서 매퍼로 전달되는 파라미터, 현재 로그인한 사용자의 ID, 권한 확인용도 - xml에서 사용
    //              ㄴ null일 경우 비로그인으로 간주
    List<Qna> selectQnaList(@Param("currentUserId") Long currentUserId,
                            @Param("currentUserRole") String currentUserRole);

    //문의글 상세조회 (권한 확인)
    Qna selectQnaById(@Param("id") Long id,
                      @Param("currentUserId") Long currentUserId,
                      @Param("currentUserRole") String currentUserRole);

    //문의글 단건 조회 - 댓글, 알림 처리용 단순 조회
    Qna selectQnaByIdSimple(Long id);

    //문의글 수정
    int updateQna(Qna qna);

    //문의글 상태 변경 (답변 완료 시 'ANSWERED' 로 변경)
    int updateQnaStatus(@Param("id") Long id, @Param("status") String status);

    //문의글 삭제
    int deleteQna(@Param("id") Long id, @Param("userId") Long userId);

    //--------- QnaReply ---------------------------------------------

    //특정 문의글의 모든 답변/댓글 조회
    List<QnaReply> selectQnaReplies(Long qnaId);

    //답변/댓글 등록
    int insertReply(QnaReply reply);

    //답변/댓글 수정
    int updateReply(QnaReply reply);

    //답변/댓글 삭제
    int deleteReply(Long id);

    //특정 댓글 ID로 댓글 정보 조회 (대댓글 알림 및 삭제 상태 변경 로직에 사용)
    QnaReply selectReplyById(Long id);

    //특정 문의글에 달린 답변/댓글 개수 카운트 (삭제 후 상태 변경 확인용)
    int getReplyCountByQnaId(Long qnaId);

}
