package com.spacecore.controller.room;

import com.spacecore.domain.file.File;
import com.spacecore.domain.room.Room;
import com.spacecore.domain.room.RoomImage;
import com.spacecore.domain.room.RoomSlot;
import com.spacecore.mapper.file.FileMapper;
import com.spacecore.mapper.room.RoomImageMapper;
import com.spacecore.security.CustomUserDetails;
import com.spacecore.service.office.OfficeService;
import com.spacecore.service.review.ReviewService;
import com.spacecore.service.room.RoomService;
import com.spacecore.service.room.RoomSlotService;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Controller
@RequiredArgsConstructor
@RequestMapping("/offices/{officeId}/rooms")
public class RoomController {

    private final RoomService roomService;
    private final OfficeService officeService;
    private final RoomSlotService roomSlotService;
    private final ReviewService reviewService;
    private final RoomImageMapper roomImageMapper;
    private final FileMapper fileMapper;

    @Value("${naver.map.client.id}")
    private String naverMapClientId;

    private static final String UPLOAD_DIR = "src/main/resources/static/img/rooms/";

    /// 오피스에 해당하는 룸 전체 페이지
    @GetMapping({"","/"})
    public String roomList(@PathVariable("officeId") Long officeId, 
                           @RequestParam(value = "page", defaultValue = "1") int page,
                           @RequestParam(value = "limit", defaultValue = "10") int limit,
                           @RequestParam(value = "sort", defaultValue = "recommended") String sort,
                           @RequestParam(value = "minPrice", required = false) Long minPrice,
                           @RequestParam(value = "maxPrice", required = false) Long maxPrice,
                           @RequestParam(value = "capacity", required = false) String capacity,
                           HttpServletRequest request,
                           Model model) {
        // 해당 오피스의 룸만 조회
        List<Room> roomList = roomService.listByOffice(officeId);
        
        // 필터링 적용
        if (minPrice != null) {
            roomList = roomList.stream()
                .filter(r -> r.getPriceBase() != null && r.getPriceBase() >= minPrice)
                .collect(Collectors.toList());
        }
        if (maxPrice != null) {
            roomList = roomList.stream()
                .filter(r -> r.getPriceBase() != null && r.getPriceBase() <= maxPrice)
                .collect(Collectors.toList());
        }
        if (capacity != null && !capacity.isEmpty()) {
            if (capacity.equals("1-5")) {
                roomList = roomList.stream()
                    .filter(r -> r.getCapacity() != null && r.getCapacity() >= 1 && r.getCapacity() <= 5)
                    .collect(Collectors.toList());
            } else if (capacity.equals("6-10")) {
                roomList = roomList.stream()
                    .filter(r -> r.getCapacity() != null && r.getCapacity() >= 6 && r.getCapacity() <= 10)
                    .collect(Collectors.toList());
            } else if (capacity.equals("11+")) {
                roomList = roomList.stream()
                    .filter(r -> r.getCapacity() != null && r.getCapacity() >= 11)
                    .collect(Collectors.toList());
            }
        }
        
        // 상태 필터 (기본값: ACTIVE만)
        String[] statusFilters = request.getParameterValues("status");
        if (statusFilters != null && statusFilters.length > 0) {
            List<String> statusList = java.util.Arrays.asList(statusFilters);
            roomList = roomList.stream()
                .filter(r -> r.getStatus() != null && statusList.contains(r.getStatus()))
                .collect(Collectors.toList());
        } else {
            // 기본값: ACTIVE만 표시
            roomList = roomList.stream()
                .filter(r -> r.getStatus() != null && "ACTIVE".equals(r.getStatus()))
                .collect(Collectors.toList());
        }
        
        // 정렬 적용
        if ("price_asc".equals(sort)) {
            roomList = roomList.stream()
                .sorted(Comparator.comparing(Room::getPriceBase, Comparator.nullsLast(Comparator.naturalOrder())))
                .collect(Collectors.toList());
        } else if ("price_desc".equals(sort)) {
            roomList = roomList.stream()
                .sorted(Comparator.comparing(Room::getPriceBase, Comparator.nullsLast(Comparator.reverseOrder())))
                .collect(Collectors.toList());
        } else if ("name_asc".equals(sort)) {
            roomList = roomList.stream()
                .sorted(Comparator.comparing(Room::getName, Comparator.nullsLast(Comparator.naturalOrder())))
                .collect(Collectors.toList());
        }
        
        // 썸네일 로드
        for (Room room : roomList) {
            try {
                String thumbnail = roomImageMapper.findThumbnailPathByRoomId(room.getId());
                room.setThumbnail(thumbnail != null ? thumbnail : null);
            } catch (Exception e) {
                // 썸네일 로드 실패 시 null로 설정
                room.setThumbnail(null);
            }
        }
        
        // 리뷰 요약 정보를 Map으로 저장 (JSP에서 사용)
        java.util.Map<Long, com.spacecore.dto.review.ReviewSummaryDTO> reviewMap = new java.util.HashMap<>();
        for (Room room : roomList) {
            reviewMap.put(room.getId(), reviewService.getReviewSummary(room.getId()));
        }
        model.addAttribute("reviewMap", reviewMap);
        
        // Pagination
        int totalCount = roomList.size();
        int totalPages = (int) Math.ceil((double) totalCount / limit);
        int offset = (page - 1) * limit;
        int endIndex = Math.min(offset + limit, totalCount);
        
        List<Room> pagedList = roomList.subList(Math.min(offset, totalCount), endIndex);
        
        // PageInfo 생성
        com.spacecore.dto.common.PageInfoDTO pageInfo = new com.spacecore.dto.common.PageInfoDTO(
            page, totalPages, totalCount, page < totalPages, page > 1
        );
        
        model.addAttribute("roomList", pagedList);
        model.addAttribute("officeList", officeService.list());
        model.addAttribute("selectedOfficeId", officeId);
        model.addAttribute("pageInfo", pageInfo);
        model.addAttribute("baseUrl", "/offices/" + officeId + "/rooms");
        
        // 현재 지점 정보 추가 (지도용)
        com.spacecore.domain.office.Office currentOffice = officeService.get(officeId);
        model.addAttribute("currentOffice", currentOffice);
        
        // 네이버 지도 클라이언트 ID
        model.addAttribute("naverMapClientId", naverMapClientId);
        model.addAttribute("clientId", naverMapClientId);
        
        return "room/list";
    }

    /// 상세 페이지
    @GetMapping("/detail/{id}")
    public String roomDetail(@PathVariable Long id,
                             @RequestParam(value="date", required=false) String date,
                             Model model) {
        Room room = roomService.get(id);
        model.addAttribute("room", room);
        model.addAttribute("officeList", officeService.list());
        
        // 해당 룸의 지점 정보
        model.addAttribute("office", officeService.get(room.getOfficeId()));
        
        // 룸 이미지 로드
        model.addAttribute("roomImages", roomImageMapper.findImagesByRoomId(id));

        // 선택일 없으면 오늘
        LocalDate target = (date != null && !date.isEmpty())
                ? LocalDate.parse(date)
                : LocalDate.now();

        // 예약 폼용: 예약 불가능한 시간대 조회 (RESERVED + BLOCKED)
        List<RoomSlot> allSlots = roomSlotService.findStatesOfDay(id, target);
        if (allSlots == null) {
            allSlots = new ArrayList<>();
        }
        model.addAttribute("bookedSlots", allSlots); // 예약 폼 모듈에서 사용


        // 관리자용: BLOCKED만 필터링
        List<RoomSlot> blockedSlots = allSlots.stream()
                .filter(s -> s != null && "BLOCKED".equals(s.getStatus()))
                .collect(Collectors.toList());

        model.addAttribute("targetDate", target);
        model.addAttribute("targetDateStr", target.toString());
        model.addAttribute("blockedSlots", blockedSlots); // 관리자 차단 목록용
        
        // 리뷰 요약 정보 추가
        model.addAttribute("reviewSummary", reviewService.getReviewSummary(id));
        
        // 네이버 지도 클라이언트 ID
        model.addAttribute("naverMapClientId", naverMapClientId);
        
        return "room/detail";
    }

    /// 등록 폼
    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/add")
    public String addForm(@PathVariable("officeId") Long officeId, Model model) {
        model.addAttribute("offices", officeService.list());
        model.addAttribute("room", new Room());
        model.addAttribute("officeId", officeId);
        return "room/add";
    }

    /// 등록 처리
    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/add")
    public String addRoom(@ModelAttribute Room room){
        roomService.create(room);
        return "redirect:/offices/" + room.getOfficeId() + "/rooms";
    }

    /// 수정 폼
    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/edit/{id}")
    public String editForm(@PathVariable Long id, Model model) {
        model.addAttribute("room", roomService.get(id));
        model.addAttribute("offices", officeService.list());
        return "room/edit";
    }

    /// 수정
    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/edit")
    public String editRoom(@ModelAttribute Room room,
                          @RequestParam(value = "thumbnailFile", required = false) MultipartFile thumbnailFile,
                          @AuthenticationPrincipal CustomUserDetails userDetails) throws IOException {
        roomService.update(room);
        
        // 썸네일 파일이 업로드된 경우 처리
        if (thumbnailFile != null && !thumbnailFile.isEmpty()) {
            // 기존 썸네일의 is_primary를 'N'으로 변경
            roomImageMapper.unsetPrimaryByRoomId(room.getId());
            
            // 파일 저장
            String fileName = saveThumbnailImage(thumbnailFile);
            String filePath = UPLOAD_DIR + fileName;
            String fileUrl = "/img/rooms/" + fileName;
            
            // files 테이블에 저장
            File file = new File();
            file.setUserId(userDetails != null ? userDetails.getId() : null);
            file.setCategory("room");
            file.setOriginalName(thumbnailFile.getOriginalFilename());
            file.setStoredName(fileName);
            file.setFilePath(filePath);
            file.setFileUrl(fileUrl);
            file.setContentType(thumbnailFile.getContentType());
            file.setFileSize(thumbnailFile.getSize());
            
            fileMapper.insert(file);
            
            // room_images 테이블에 저장
            RoomImage roomImage = new RoomImage();
            roomImage.setRoomId(room.getId());
            roomImage.setFileId(file.getId());
            roomImage.setIsPrimary("Y");
            roomImage.setSortOrder(0);
            
            roomImageMapper.insertOne(roomImage);
        }
        
        return "redirect:/offices/" + room.getOfficeId() + "/rooms";
    }
    
    private String saveThumbnailImage(MultipartFile file) throws IOException {
        // 업로드 디렉토리 생성
        Path uploadPath = Paths.get(UPLOAD_DIR);
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }

        // 고유한 파일명 생성
        String originalFilename = file.getOriginalFilename();
        String extension = originalFilename != null && originalFilename.contains(".") 
            ? originalFilename.substring(originalFilename.lastIndexOf(".")) 
            : "";
        String fileName = UUID.randomUUID().toString() + extension;

        // 파일 저장
        Path filePath = uploadPath.resolve(fileName);
        Files.copy(file.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);

        return fileName;
    }

    /// 삭제
    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/delete/{id}")
    public String deleteRoom(@PathVariable("id") Long id){
        Room room = roomService.get(id);  // 삭제 전에 officeId 가져오기
        Long officeId = room.getOfficeId();
        roomService.delete(id);
        return "redirect:/offices/" + officeId + "/rooms";
    }

    /**------------------------------------ 관리자 시간 차단 기능 ------------------------------------*/

    /// 관리자: 시간대 차단
    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/block/{id}")
    public String blockTimeSlot(
            @PathVariable("id") Long roomId,
            @RequestParam("date") String dateStr,  // 선택된 날짜 (필수)
            @RequestParam(value = "startHour", required = false) Integer startHour,  // 시작 시간 (시간 단위, 9~21)
            @RequestParam(value = "endHour", required = false) Integer endHour) {    // 종료 시간 (시간 단위, 10~22)

        LocalDate date = LocalDate.parse(dateStr);
        LocalDateTime startAt;
        LocalDateTime endAt;

        // startHour, endHour가 있으면 해당 시간으로 차단, 없으면 09:00~22:00 전체 차단
        if (startHour != null && endHour != null) {
            startAt = date.atTime(startHour, 0);      // 예: 2025-11-19 09:00
            endAt = date.atTime(endHour, 0);         // 예: 2025-11-19 12:00
        } else {
            // 시간 파라미터가 없으면 선택된 날짜의 09:00~22:00 전체 차단
            startAt = date.atTime(9, 0);
            endAt = date.atTime(22, 0);
        }

        roomSlotService.block(roomId, startAt, endAt);
        Room room = roomService.get(roomId);
        return "redirect:/offices/" + room.getOfficeId() + "/rooms/detail/" + roomId + "?date=" + dateStr;
    }

    /// 관리자: 시간대 차단 해제 (개별 또는 전체)
    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/unblock-all/{id}")
    public String unblockTimeSlot(
            @PathVariable("id") Long roomId,
            @RequestParam(value = "startAt", required = false) String startAtStr,
            @RequestParam(value = "endAt", required = false) String endAtStr,
            @RequestParam(value = "date", required = false) String dateStr) {

        LocalDateTime startAt;
        LocalDateTime endAt;

        // startAt/endAt이 있고 비어있지 않으면 개별 해제, 없으면 date로 전체 해제
        if (startAtStr != null && !startAtStr.trim().isEmpty() &&
                endAtStr != null && !endAtStr.trim().isEmpty()) {
            startAt = LocalDateTime.parse(startAtStr);
            endAt = LocalDateTime.parse(endAtStr);
        } else if (dateStr != null && !dateStr.trim().isEmpty()) {
            // 날짜 전체 해제 (09:00 ~ 22:00)
            LocalDate date = LocalDate.parse(dateStr);
            startAt = date.atTime(9, 0);
            endAt = date.atTime(22, 0);
        } else {
            throw new IllegalArgumentException("startAt/endAt 또는 date 파라미터가 필요합니다.");
        }

        roomSlotService.unblock(roomId, startAt, endAt);

        Room room = roomService.get(roomId);
        String redirectUrl = "/offices/" + room.getOfficeId() + "/rooms/detail/" + roomId;
        if (dateStr != null && !dateStr.trim().isEmpty()) {
            redirectUrl += "?date=" + dateStr;
        } else if (startAtStr != null && !startAtStr.trim().isEmpty()) {
            // startAt에서 날짜 추출
            redirectUrl += "?date=" + startAt.toLocalDate();
        }
        return "redirect:" + redirectUrl;
    }
}

