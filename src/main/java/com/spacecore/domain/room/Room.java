package com.spacecore.domain.room;

import lombok.Data;

import java.sql.Blob;
import java.time.LocalDate;
import java.util.List;

@Data
public class Room {
    private Long id;
    private Long officeId;
    private String name;
    private Long capacity;
    private Long priceBase;
    private Long minReservationHours; // 최소 예약 시간 (시간 단위)
    private String description;    // 공간소개
    private String facilityInfo;    // 시설안내
    private String precautions;     // 유의사항
    private String status;
    private LocalDate createdAt;

    // 대표 이미지 URL (목록용)
    private String thumbnail;

    // 여러장 이미지 (상세용)
    private List<RoomImage> images;
}
