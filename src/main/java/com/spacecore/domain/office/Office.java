package com.spacecore.domain.office;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class Office {
    private Long id;
    private String name;
    private String address;
    private String status;
    private LocalDateTime createdAt;

    private Double latitude;    //위도
    private Double longitude;   //경도
}
