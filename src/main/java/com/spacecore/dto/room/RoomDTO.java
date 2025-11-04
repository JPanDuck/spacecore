package com.spacecore.dto.room;

import lombok.Data;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;


// 룸 등록/ 수정용 DTO
@Data
public class RoomDTO {
    @NotNull(message = "지점ID는 필수")
    private Long officeId;              // 지점 FK
    @NotBlank(message = "룸명은 필수")
    private String name;                // 룸명
    private Integer capacity;           // 수용 인원
    private Integer priceBase;          // 기본 금액

    private String status;
}
