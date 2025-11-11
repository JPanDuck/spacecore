package com.spacecore.service.notification;

import com.spacecore.domain.notification.Notification;

import java.util.List;

public interface NotificationService {
    //알림 등록 (이벤트 발생 시 호출)
    void registerNotification(Notification notification);

    //사용자별 알림 목록 조회
    List<Notification> getNotificationsByUserId(Long userId);

    //읽음 처리 (단일)
    boolean markAsRead(Long notiId, Long userId);

    //알림 전체 읽음 처리
    void markAllAsRead(Long userId);

    //안읽은 알림 개수 조회
    int getUnreadCount(Long userId);

    //알림 생성 및 발송 헬퍼 메서드 (범용)
    void sendNotification(Long receiverId, String type, Long refId, String message, String targetUrl);
}
