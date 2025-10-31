package com.spacecore.dto.common;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class PageInfoDTO {
    // ===============현재 페이지 상태를 프론트로 넘기는 DTO=============
    private int currentPage; //현재페이지
    private int totalPages; //전체페이지
    private int totalCount; //총 합
    private boolean hasNext; //다음
    private boolean hasPrevious; //이전
}
