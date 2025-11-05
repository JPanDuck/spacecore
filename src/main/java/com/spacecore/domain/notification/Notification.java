package com.spacecore.domain.notification;

import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Builder
@Data
public class Notification {
    private Long notiId;
    private Long userId;    //알림을 받을 사용자 ID
    private String type;    //알림 유형('COMMENT', 'RE_CONFIRMED', 'RE_UPDATED', 'RE_CANCELED')
    private Long refId;     //참조 대상 ID (문의글, 댓글, 또는 대댓글 식별자)
    private String message;
    private String targetUrl;   //알림 클릭 시 이동할 URL
    private String readYn;  //읽음 여부(Y: 읽음, N: 안읽음)
    private LocalDateTime createdAt;

    //JSTL - LocalDate 사용 불가로 String 으로 변환 / 출력 전용
    public String getCreatedAtStr() {
        return createdAt != null ? createdAt.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")) : "";
    }
}
