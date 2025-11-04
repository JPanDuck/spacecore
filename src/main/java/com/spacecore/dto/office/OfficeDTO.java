package com.spacecore.dto.office;


import lombok.Data;

import javax.validation.constraints.NotBlank;


// 지점 등록/ 수정용 DTO
@Data
public class OfficeDTO {
    @NotBlank(message = "지점명 필수")
    private String name;
    private String address;

    private String status;


}
