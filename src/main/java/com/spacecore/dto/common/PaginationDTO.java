package com.spacecore.dto.common;

import lombok.Data;
import java.util.List;
import java.util.Map;

/**
 * ✅ 모든 리스트형 데이터에 공통으로 사용하는 페이지 DTO
 * - reviews, users, offices 등 모든 서비스에서 재사용 가능
 */
@Data
public class PaginationDTO<T> {

    /** 실제 데이터 목록 */
    private List<T> data;

    /** 페이지 정보 (현재 페이지, 총 개수, 전체 페이지, 정렬 옵션 등) */
    private PageInfo pageInfo;

    /** 내부 클래스: 페이지 정보 객체 */
    @Data
    public static class PageInfo {
        private int currentPage;    // 현재 페이지
        private int totalCount;     // 전체 데이터 개수
        private int totalPages;     // 전체 페이지 수
        private int size;           // 한 페이지당 표시할 개수
        private String sortField;   // 정렬 기준 (createdAt, rating 등)
        private String sortOrder;   // 정렬 방향 (ASC / DESC)
    }
}
