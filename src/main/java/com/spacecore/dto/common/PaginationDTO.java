package com.spacecore.dto.common;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class PaginationDTO<T> {
    // ===============데이터 + 페이지정보 응답 DTO=============
    private List<T> data;        // 실제 데이터
    private PageInfoDTO pageInfo; // 페이지 정보
}
