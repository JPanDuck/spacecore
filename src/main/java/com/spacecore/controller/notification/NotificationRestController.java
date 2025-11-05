package com.spacecore.controller.notification;

import com.spacecore.domain.notification.Notification;
import com.spacecore.security.CustomUserDetails;
import com.spacecore.service.notification.NotificationService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/notifications")
@RequiredArgsConstructor
public class NotificationRestController {
    private final NotificationService notificationService;

    //사용자별 알림 목록 조회 (AJAX용)
    @GetMapping
    public ResponseEntity<List<Notification>> getNotifications(@AuthenticationPrincipal CustomUserDetails user) {
        Long currentUserId = user.getId();
        List<Notification> notifications = notificationService.getNotificationsByUserId(currentUserId);
        return ResponseEntity.ok(notifications);
    }

    //안읽은 알림 개수 조회
    @GetMapping("/unread/count")
    public ResponseEntity<Map<String, Integer>> getUnreadCount(@AuthenticationPrincipal CustomUserDetails user){
        Long currentUserId = user.getId();
        int count = notificationService.getUnreadCount(currentUserId);
        return ResponseEntity.ok(Map.of("unreadCount", count));
    }

    //특정 알림 읽음 처리 (단일)
    @PutMapping("/{notiId}/read")
    public ResponseEntity<?> mardAsRead(@PathVariable Long notiId, @AuthenticationPrincipal CustomUserDetails user){
        Long currentUserId = user.getId();

        boolean success = notificationService.markAsRead(notiId, currentUserId);
        if(success){
            return ResponseEntity.ok().build();
        }else {
            return ResponseEntity.status(HttpStatus.FORBIDDEN)
                    .body(Map.of("message", "알림을 찾을 수 없거나 접근 권한이 없습니다."));
        }
    }

    //모든 알림 읽음 처리 (전체)
    @PutMapping("/read-all")
    public ResponseEntity<?> markAllAsRead(@AuthenticationPrincipal CustomUserDetails user){
        Long currentUserId = user.getId();

        notificationService.markAllAsRead(currentUserId);
        return ResponseEntity.ok().build();
    }
}
