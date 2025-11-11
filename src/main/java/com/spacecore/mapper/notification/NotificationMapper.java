package com.spacecore.mapper.notification;

import com.spacecore.domain.notification.Notification;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface NotificationMapper {
    //알림 등록
    int insertNotification(Notification notification);

    //사용자별 알림 목록 조회
    List<Notification> selectNotificationByUserId(Long userId);

    //알림 읽음 처리(단일) - readYn='Y'로 변경, 해당 알림이 userId 소유인지 확인
    int markAsRead(@Param("notiId") Long notiId, @Param("userId") Long userId);

    //알림 전체 읽음 처리
    int markAllAsRead(Long userId);

    //안읽은 알림 개수 조회
    int getUnreadCount(Long userId);
}
