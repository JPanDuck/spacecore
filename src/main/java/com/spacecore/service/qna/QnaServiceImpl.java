package com.spacecore.service.qna;

import com.spacecore.domain.notification.Notification;
import com.spacecore.domain.qna.Qna;
import com.spacecore.domain.qna.QnaReply;
import com.spacecore.mapper.qna.QnaMapper;
import com.spacecore.service.notification.NotificationService;
import com.spacecore.service.user.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Objects;

@Service
@RequiredArgsConstructor
public class QnaServiceImpl implements QnaService{

    private final QnaMapper qnaMapper;
    private final NotificationService notificationService;
    private final UserService userService;

    //상수 - 오타방지 및 가독성 향상
    private static final String QNA_STATUS_ANSWERED = "ANSWERED";
    private static final String QNA_STATUS_PENDING = "PENDING";
    private static final String ADMIN_ROLE = "ADMIN";   //관리자 역할 상수
    private static final String IS_PRIVATE_Y = "Y";


    //문의글 등록
    @Override
    @Transactional
    public void registerQna(Qna qna, Long currentUserId) {
        qna.setUserId(currentUserId);   //작성자 ID 설정
        qna.setStatus(QNA_STATUS_PENDING);  //상태: 답변대기
        qnaMapper.insertQna(qna);

        //모든 관리자에게 알림 생성 (새로운 문의글 등록 시)
        List<Long> adminIds = userService.getAllAdminIds();

        for(Long adminId : adminIds){
            //알림 생성
            notificationService.sendNotification(
                    adminId,
                    "QNA_REGISTERED",
                    qna.getId(),
                    "새로운 문의글이 등록되었습니다. (" + qna.getTitle() + ")",
                    "/qna/detail/" + qna.getId()
            );
        }
    }

    //문의글 목록 조회
    @Override
    public List<Qna> getQnaList(Long currentUserId, String currentUserRole) {
        return qnaMapper.selectQnaList(currentUserId,  currentUserRole);
    }

    //문의글 상세조회 - 매퍼에서 권한 체크 로직 처리
    @Override
    public Qna getQnaDetail(Long id, Long currentUserId, String currentUserRole) {
        Qna qna = qnaMapper.selectQnaById(id,currentUserId,currentUserRole);

        if(qna == null){
            return null;    //404
        }

        //비공개 Y인 경우 접근권한이 없으면 예외 발생
        if(IS_PRIVATE_Y.equals(qna.getIsPrivate())){
            boolean isOwner = Objects.equals(qna.getUserId(), currentUserId);
            boolean isAdmin = ADMIN_ROLE.equals(currentUserRole);

            //작성자도 아니고 관리자도 아니라면 접근 거부 예외 발생
            if(!isOwner && !isAdmin){
                throw new SecurityException("비공개 글은 작성자 또는 관리자 확인 가능합니다.");
            }
        }

        //댓글 목록 조회
        List<QnaReply> replies = qnaMapper.selectQnaReplies(id);
        qna.setReplies(replies);

        return qna;

//        //비공개 N인 경우 : 모든 사용자에게 허용
//        if("N".equals(qna.getIsPrivate())){
//            return qna;
//        }
//
//        //비공개 Y인 경우 : 작성자와 관리자만 허용
//        if(Objects.equals(qna.getUserId(), currentUserId) || ADMIN_ROLE.equals(currentUserRole)){
//            return qna;
//        }
//        return null;
    }

    //문의글 단순 조회 - 댓글/알림/권한 확인용
    @Override
    public Qna getQnaByIdSimple(Long id) {
        return qnaMapper.selectQnaByIdSimple(id);
    }


    //문의글 수정 - 매퍼에서 userId, status='PENDING' 조건으로 수정 진행
    @Override
    @Transactional
    public boolean modifyQna(Qna qna) {
        return qnaMapper.updateQna(qna) > 0;
    }

    //문의글 삭제 - 매퍼에서 userId, status='PENDING' 조건으로 삭제 진행
    @Override
    @Transactional
    public boolean removeQna(Long id, Long currentUserId) {
        return qnaMapper.deleteQna(id, currentUserId) > 0;
    }

//------------------------ QnaReply -------------------------------------------------------------------

    //답변/댓글 등록 (알림 생성 로직 포함)
    @Override
    @Transactional
    public void registerReply(QnaReply reply, Long currentUserId, String currentUserRole) {
        //원본 문의글 정보 조회
        Qna originalQna = getQnaByIdSimple(reply.getQnaId());
        if(originalQna == null){
            throw new IllegalArgumentException("존재하지 않거나 접근 권한이 없습니다");
        }

        //비공개 글에 대한 권한 체크 - 관리자 또는 작성자만 댓글 가능
        if(IS_PRIVATE_Y.equals(originalQna.getIsPrivate())
                && !ADMIN_ROLE.equals(currentUserRole)
                && !Objects.equals(currentUserId, originalQna.getUserId())){
            throw new SecurityException("비공개 글에 댓글을 등록할 권한이 없습니다.");    //비공개 글입니다.
        }

        //댓글 작성자 정보 설정
        reply.setUserId(currentUserId);
        //isAdmin - 관리자면 'Y', 아니라면 'N'
        reply.setIsAdmin(ADMIN_ROLE.equals(currentUserRole) ? "Y" : "N");

        //답변/댓글 등록
        qnaMapper.insertReply(reply);

        //관리자가 최초 답변을 달았을 경우에만 상태 변경
        if(QNA_STATUS_PENDING.equals(originalQna.getStatus()) && ADMIN_ROLE.equals(currentUserRole)){
            qnaMapper.updateQnaStatus(originalQna.getId(), QNA_STATUS_ANSWERED);
        }

        //알림 생성 - 헬퍼 메서드(sendNotification) 사용
        //a. 원본글 작성자에게 알림 (댓글 작성자가 원글 작성자와 다른 경우)
        if(!Objects.equals(reply.getUserId(), originalQna.getUserId())){
            notificationService.sendNotification(
                    originalQna.getUserId(),
                    "QNA_REPLY",
                    originalQna.getId(),
                    "작성하신 문의글에 새로운 댓글이 등록되었습니다.",
                    "/qna/detail/" + originalQna.getId()
            );
        }

        //b. 대댓글인 경우 부모 댓글 작성자에게도 알림
        if(reply.getParentReplyId() != null){
            QnaReply parentReply = qnaMapper.selectReplyById(reply.getParentReplyId());

            //부모 댓글 작성자가 현재 작성자도 아니고, 원본글 작성자도 아닐때만 알림 전송
            if(parentReply != null
                && !Objects.equals(reply.getUserId(), parentReply.getUserId())){

                notificationService.sendNotification(
                        parentReply.getUserId(),
                        "QNA_REPLY",
                        originalQna.getId(),
                        "작성하신 댓글에 새로운 댓글이 등록되었습니다.",
                        "/qna/detail/" + originalQna.getId()
                );
            }
        }

        //c. 관리자 전체에게 알림
        if(!ADMIN_ROLE.equals(currentUserRole)){
            List<Long> adminIds = userService.getAllAdminIds();

            for(Long adminId : adminIds){
                notificationService.sendNotification(
                        adminId,
                        "QNA_REPLY",
                        originalQna.getId(),
                        "새로운 댓글이 등록되었습니다." + originalQna.getTitle(),
                        "/qna/detail/" + originalQna.getId()
                );
            }
        }
    }

    //답변/댓글 수정
    @Override
    @Transactional
    public boolean modifyReply(QnaReply reply, Long currentUserId) {
        QnaReply existingReply = qnaMapper.selectReplyById(reply.getId());

        //권한 확인 - reply.userId와 currentUserId가 일치하는지 확인
        if(existingReply == null || !Objects.equals(existingReply.getUserId(), currentUserId)){
            return false;   //권한 없음
        }

        //수정
        reply.setUserId(currentUserId);
        return qnaMapper.updateReply(reply) > 0;
    }

    //답변/댓글 삭제
    @Override
    @Transactional
    public boolean removeReply(Long id, Long currentUserId, String currentUserRole) {
        QnaReply reply = qnaMapper.selectReplyById(id);
        if(reply == null) return false;

        //작성자 또는 관리자만 댓글 삭제 가능 - 권한 확인
        if(!Objects.equals(reply.getUserId(), currentUserId) && !ADMIN_ROLE.equals(currentUserRole)){
            return false;
        }
        //댓글 삭제
        int deleted = qnaMapper.deleteReply(id);

        if(deleted > 0){
            //원본 문의글 상태 확인
            Qna originalQna = getQnaByIdSimple(reply.getQnaId());

            //댓글이 남아있는지 확인
            if(originalQna != null && qnaMapper.getReplyCountByQnaId(reply.getQnaId()) == 0){
                //남은 댓글이 없으면 상태를 'PENDING' 으로 변경
                qnaMapper.updateQnaStatus(reply.getQnaId(), QNA_STATUS_PENDING);
            }
            return true;
        }
        return false;
    }
}
