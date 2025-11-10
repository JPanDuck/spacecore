package com.spacecore.domain.favorite;

import lombok.Data;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Data
public class Favorite {
    private Long id;
    private Long userId;
    private Long officeId;
    private Long roomId;
    private LocalDateTime createdAt;

    //JSTL - LocalDate 사용 불가로 String 으로 변환 / 출력 전용
    public String getCreatedAtStr() {
        return createdAt != null ? createdAt.format(DateTimeFormatter.ofPattern("yyyy-MM-dd")) : "";
    }
}