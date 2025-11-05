package com.spacecore.controller.notification;

import com.spacecore.domain.notification.Notification;
import com.spacecore.security.CustomUserDetails;
import com.spacecore.service.notification.NotificationService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

/**
 * View
 * JSP 페이지 반환하는 역할
 * */

@Controller
@RequestMapping("/notifications")
@RequiredArgsConstructor
public class NotificationController {
    private final NotificationService notificationService;

    //알림 목록 페이지
    @GetMapping
    public String notificationList(Model model, @AuthenticationPrincipal CustomUserDetails user) {
        Long currentUserId = user.getId();

        List<Notification> notifications = notificationService.getNotificationsByUserId(currentUserId);
        int unreadCount = notificationService.getUnreadCount(currentUserId);

        model.addAttribute("notifications", notifications);
        model.addAttribute("unreadCount", unreadCount);

        return "notification/list";
    }
}
