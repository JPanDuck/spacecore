package com.spacecore.controller.office;


import com.spacecore.domain.office.Office;
import com.spacecore.domain.room.Room;
import com.spacecore.dto.review.ReviewSummaryDTO;
import com.spacecore.mapper.room.RoomImageMapper;
import com.spacecore.service.office.OfficeService;
import com.spacecore.service.review.ReviewService;
import com.spacecore.service.room.RoomService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
@RequiredArgsConstructor
@RequestMapping("/offices")
public class OfficeController {

    private final OfficeService officeService;
    private final RoomService roomService;
    private final RoomImageMapper roomImageMapper;
    private final ReviewService reviewService;

    @Value("${naver.map.client.id}")
    private String naverMapClientId;

    /// 주소에서 지역 추출 (서울, 경기, 부산 등)
    private String extractRegion(String address) {
        if (address == null || address.isEmpty()) {
            return "기타";
        }
        
        // 한국 주요 지역 매핑
        if (address.startsWith("서울") || address.startsWith("서울특별시")) {
            return "서울";
        } else if (address.startsWith("경기") || address.startsWith("경기도")) {
            return "경기";
        } else if (address.startsWith("부산") || address.startsWith("부산광역시")) {
            return "부산";
        } else if (address.startsWith("인천") || address.startsWith("인천광역시")) {
            return "인천";
        } else if (address.startsWith("대구") || address.startsWith("대구광역시")) {
            return "대구";
        } else if (address.startsWith("대전") || address.startsWith("대전광역시")) {
            return "대전";
        } else if (address.startsWith("광주") || address.startsWith("광주광역시")) {
            return "광주";
        } else if (address.startsWith("울산") || address.startsWith("울산광역시")) {
            return "울산";
        } else if (address.startsWith("세종") || address.startsWith("세종특별자치시")) {
            return "세종";
        } else if (address.startsWith("강원") || address.startsWith("강원도")) {
            return "강원";
        } else if (address.startsWith("충북") || address.startsWith("충청북도")) {
            return "충북";
        } else if (address.startsWith("충남") || address.startsWith("충청남도")) {
            return "충남";
        } else if (address.startsWith("전북") || address.startsWith("전라북도")) {
            return "전북";
        } else if (address.startsWith("전남") || address.startsWith("전라남도")) {
            return "전남";
        } else if (address.startsWith("경북") || address.startsWith("경상북도")) {
            return "경북";
        } else if (address.startsWith("경남") || address.startsWith("경상남도")) {
            return "경남";
        } else if (address.startsWith("제주") || address.startsWith("제주특별자치도")) {
            return "제주";
        }
        
        return "기타";
    }

    /// 목록 페이지
    @GetMapping({"","/"})
    public String officeList(@RequestParam(value = "page", defaultValue = "1") int page,
                             @RequestParam(value = "limit", defaultValue = "12") int limit,
                             @RequestParam(value = "region", required = false) String region,
                             HttpServletRequest request,
                             Model model) {
        // 전체 지점 조회
        List<Office> allOfficeList = officeService.list();
        
        // 지역 목록 추출 (필터링 전 전체 목록에서 추출 - 필터 옵션용)
        java.util.Set<String> regionSet = allOfficeList.stream()
            .map(o -> extractRegion(o.getAddress()))
            .collect(Collectors.toSet());
        java.util.List<String> regionList = new java.util.ArrayList<>(regionSet);
        java.util.Collections.sort(regionList);
        model.addAttribute("availableRegions", regionList);
        
        // 필터링 시작
        List<Office> officeList = new java.util.ArrayList<>(allOfficeList);
        
        // 지역 필터 적용
        if (region != null && !region.isEmpty() && !"전체".equals(region)) {
            final String targetRegion = region;
            officeList = officeList.stream()
                .filter(o -> {
                    String officeRegion = extractRegion(o.getAddress());
                    return targetRegion.equals(officeRegion);
                })
                .collect(Collectors.toList());
        }
        
        // 상태 필터 적용
        String[] statusFilters = request.getParameterValues("status");
        if (statusFilters != null && statusFilters.length > 0) {
            List<String> statusList = java.util.Arrays.asList(statusFilters);
            officeList = officeList.stream()
                .filter(o -> o.getStatus() != null && statusList.contains(o.getStatus()))
                .collect(Collectors.toList());
        } else {
            // 기본값: ACTIVE만 표시
            officeList = officeList.stream()
                .filter(o -> o.getStatus() != null && "ACTIVE".equals(o.getStatus()))
                .collect(Collectors.toList());
        }
        
        // 지역순 정렬 (기본 정렬)
        officeList = officeList.stream()
            .sorted(Comparator.comparing(o -> extractRegion(o.getAddress()), Comparator.nullsLast(Comparator.naturalOrder())))
            .collect(Collectors.toList());
        
        // Pagination
        int totalCount = officeList.size();
        int totalPages = (int) Math.ceil((double) totalCount / limit);
        int offset = (page - 1) * limit;
        int endIndex = Math.min(offset + limit, totalCount);
        
        List<Office> pagedList = officeList.subList(Math.min(offset, totalCount), endIndex);
        
        // PageInfo 생성
        com.spacecore.dto.common.PageInfoDTO pageInfo = new com.spacecore.dto.common.PageInfoDTO(
            page, totalPages, totalCount, page < totalPages, page > 1
        );
        
        // 각 지점의 리뷰 요약 정보 계산 (지점에 속한 모든 룸의 리뷰 합산)
        Map<Long, ReviewSummaryDTO> officeReviewMap = new HashMap<>();
        for (Office office : pagedList) {
            List<Room> rooms = roomService.listByOffice(office.getId());
            int totalReviewCount = 0;
            double totalRating = 0.0;
            int roomsWithReviews = 0;
            
            for (Room room : rooms) {
                ReviewSummaryDTO roomSummary = reviewService.getReviewSummary(room.getId());
                if (roomSummary != null && roomSummary.getTotalCount() != null && roomSummary.getTotalCount() > 0) {
                    totalReviewCount += roomSummary.getTotalCount();
                    if (roomSummary.getAvgRating() != null) {
                        totalRating += roomSummary.getAvgRating() * roomSummary.getTotalCount();
                        roomsWithReviews++;
                    }
                }
            }
            
            ReviewSummaryDTO officeSummary = new ReviewSummaryDTO();
            officeSummary.setTotalCount(totalReviewCount);
            if (totalReviewCount > 0) {
                officeSummary.setAvgRating(Math.round((totalRating / totalReviewCount) * 10.0) / 10.0);
            } else {
                officeSummary.setAvgRating(0.0);
            }
            officeReviewMap.put(office.getId(), officeSummary);
        }
        
        model.addAttribute("officeList", pagedList);
        model.addAttribute("allOfficeList", allOfficeList); // 지도 모달용 전체 목록
        model.addAttribute("officeReviewMap", officeReviewMap);
        model.addAttribute("pageInfo", pageInfo);
        model.addAttribute("baseUrl", "/offices");
        
        // 네이버 지도 클라이언트 ID
        model.addAttribute("clientId", naverMapClientId);
        
        return "office/list";
    }

    /// 등록 폼
    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/add")
    public String addForm(Model model) {
        model.addAttribute("office", new Office());
        return "office/add";
    }

    /// 등록 처리
    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/add")
    public String addOffice(@ModelAttribute Office office) {
        officeService.create(office);
        return "redirect:/offices/";
    }

    /// 수정 폼
    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/edit/{id}")
    public String editForm(@PathVariable Long id, Model model){
        model.addAttribute("office", officeService.get(id));
        return "office/edit";
    }

    /// 수정
    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/edit")
    public String editOffice(@ModelAttribute Office office){
        officeService.update(office);
        return "redirect:/offices/detail/"+office.getId();
    }

    ///  삭제
    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/delete/{id}")
    public String deleteOffice(@PathVariable("id") Long id){
        officeService.delete(id);
        return "redirect:/offices/";
    }
}