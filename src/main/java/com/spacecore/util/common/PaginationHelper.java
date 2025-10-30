package com.spacecore.util.common;

import java.util.HashMap;
import java.util.Map;

public class PaginationHelper {

    public static Map<String, Object> getPageInfo(int totalCount, int currentPage, int pageSize, int blockSize) {
        Map<String, Object> pageInfo = new HashMap<>();

        int totalPages = (int) Math.ceil((double) totalCount / pageSize);
        if (currentPage > totalPages) currentPage = totalPages == 0 ? 1 : totalPages;

        int startPage = ((currentPage - 1) / blockSize) * blockSize + 1;
        int endPage = Math.min(startPage + blockSize - 1, totalPages);

        int startRow = (currentPage - 1) * pageSize + 1;
        int endRow = currentPage * pageSize;

        pageInfo.put("totalCount", totalCount);
        pageInfo.put("totalPages", totalPages);
        pageInfo.put("currentPage", currentPage);
        pageInfo.put("pageSize", pageSize);
        pageInfo.put("startPage", startPage);
        pageInfo.put("endPage", endPage);
        pageInfo.put("hasPrev", startPage > 1);
        pageInfo.put("hasNext", endPage < totalPages);
        pageInfo.put("startRow", startRow);
        pageInfo.put("endRow", endRow);

        return pageInfo;
    }
}
