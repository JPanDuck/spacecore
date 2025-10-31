package com.spacecore.util.common;

import com.spacecore.dto.common.PageInfoDTO;

public class PaginationHelper {

    public static PageInfoDTO createPageInfo(int totalCount, int currentPage, int pagelimit) {
        int totalPages = (int) Math.ceil((double) totalCount / pagelimit);
        boolean hasNext = currentPage < totalPages;
        boolean hasPrevious = currentPage > 1;

        return new PageInfoDTO(currentPage, totalPages, totalCount, hasNext, hasPrevious);
    }
}
