package com.spacecore.domain.room;

import lombok.Data;

import java.time.LocalDate;

@Data
public class RoomImage {
    private Long id;
    private Long roomId;
    private Long fileId;
    private String filePath;
    private String isPrimary;
    private int sortOrder;
    private LocalDate createdAt;
}