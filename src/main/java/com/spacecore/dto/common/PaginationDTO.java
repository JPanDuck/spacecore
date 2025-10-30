package com.spacecore.dto.common;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.List;
import java.util.Map;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class PaginationDTO<T> {
    private List<T> data;              // 실제 데이터 목록
    private Map<String, Object> pageInfo;  // 페이지 관련 정보 (helper로 계산)
}
