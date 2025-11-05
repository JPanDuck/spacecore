package com.spacecore.service.notification;

import com.spacecore.domain.notification.Notification;
import com.spacecore.mapper.notification.NotificationMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class NotificationServiceImpl implements NotificationService {

    private final NotificationMapper notificationMapper;

    //알림 등록 - targetUrl 포함해서 전달 / registerReply 에서 알림생성까지 하나의 트랜젝션
    @Override
    public void registerNotification(Notification notification) {
        notificationMapper.insertNotification(notification);
    }

    //사용자별 알림 목록 조회
    @Override
    public List<Notification> getNotificationsByUserId(Long userId) {
        return notificationMapper.selectNotificationByUserId(userId);
    }

    //알림 읽음 처리(단일)
    @Override
    @Transactional
    public boolean markAsRead(Long notiId, Long userId) {
        return notificationMapper.markAsRead(notiId, userId) > 0;
    }

    //알림 전체 읽음 처리
    @Override
    @Transactional
    public void markAllAsRead(Long userId) {
        notificationMapper.markAllAsRead(userId);
    }

    //안읽은 알림 개수 조회
    @Override
    public int getUnreadCount(Long userId) {
        return notificationMapper.getUnreadCount(userId);
    }

    //알림 생성 및 발송 헬퍼 메서드 (범용)
    @Override
    public void sendNotification(Long receiverId, String type, Long refId, String message, String targetUrl) {
        Notification notification = Notification.builder()
                .userId(receiverId)
                .type(type)
                .refId(refId)
                .message(message)
                .targetUrl(targetUrl)
                .readYn("N")    //읽지않음 상태 명시
                .build();

        //내부의 등록 로직 호출
        this.registerNotification(notification);
    }
}