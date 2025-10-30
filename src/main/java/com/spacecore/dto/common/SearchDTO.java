package com.spacecore.dto.common;

import lombok.Data;

@Data
public class SearchDTO {
    // 검색 필터
    private String keyword;       // 내용, 사용자명 검색 등
    private Long roomId;          // 특정 방 기준 검색
    private Long userId;          // 특정 사용자 검색
    private Integer minRating;    // 평점 최소값
    private Integer maxRating;    // 평점 최대값

    // 페이징
    private int page = 1;         // 기본 페이지
    private int size = 10;        // 페이지당 데이터 수

    // 정렬
    private String sortBy = "createdAt"; // 기본 정렬 기준
    private String sortDir = "DESC";     // 정렬 방향
}
