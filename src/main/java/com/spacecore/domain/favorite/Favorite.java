package com.spacecore.domain.favorite;

import lombok.Data;

import java.time.LocalDate;
@Data
public class Favorite {
    private Long id;
    private Long userId;
    private Long roomId;
    private LocalDate createdAt;
}
