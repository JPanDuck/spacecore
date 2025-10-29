package com.spacecore.domain.office;

import lombok.Data;

import java.time.LocalDate;

@Data
public class Office {
    private Long id;
    private String name;
    private String address;
    private String status;
    private LocalDate createdAt;
}
