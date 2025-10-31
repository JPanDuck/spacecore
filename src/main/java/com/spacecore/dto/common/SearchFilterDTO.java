package com.spacecore.dto.common;

import lombok.Data;
import java.util.HashMap;
import java.util.Map;

@Data
public class SearchFilterDTO {
    // ===============검색 + 페이징 요청 DTO=============
    private int page = 1;        // 기본 페이지
    private int limit = 10;       // 페이지 크기
    private String keyword;      // 검색어
    private String sortBy;       // 정렬 기준 (ex: date, name 등)
    private String sortDirection = "desc"; // 정렬 방향

    // 도메인별로 추가 필터를 유연하게 담는 필드
    private Map<String, Object> filters = new HashMap<>();
}
