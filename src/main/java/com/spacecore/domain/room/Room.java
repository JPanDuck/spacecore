package com.spacecore.domain.room;

import lombok.Data;

import java.sql.Blob;
import java.time.LocalDate;

@Data
public class Room {
    private Long id;
    private Long officeId;
    private String name;
    private Blob img;
    private Long capacity;
    private Long priceBase;
    private String status;
    private LocalDate createdAt;
}
