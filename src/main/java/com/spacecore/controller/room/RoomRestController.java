package com.spacecore.controller.room;

import com.spacecore.domain.room.Room;
import com.spacecore.domain.room.RoomImage;
import com.spacecore.mapper.room.RoomImageMapper;
import com.spacecore.service.room.RoomService;
import com.spacecore.service.room.RoomSlotService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/rooms")
public class RoomRestController {

    private final RoomService roomService;
    private final RoomSlotService roomSlotService;
    private final RoomImageMapper roomImageMapper;

    /// 룸 전체 조회
    @GetMapping
    public ResponseEntity<List<Room>> getAllRooms(){
        return ResponseEntity.ok(roomService.list());
    }

    /// 룸 상세 조회
    @GetMapping("/{id}")
    public ResponseEntity<Room> getRoomById(@PathVariable Long id){
        Room room = roomService.get(id);
        return (room != null) ? ResponseEntity.ok(room) : ResponseEntity.notFound().build();
    }

    /// 룸 이미지 조회
    @GetMapping("/{id}/images")
    public ResponseEntity<List<RoomImage>> getRoomImages(@PathVariable Long id){
        List<RoomImage> images = roomImageMapper.findImagesByRoomId(id);
        return ResponseEntity.ok(images);
    }

    /// 생성
    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping
    public ResponseEntity<Room> addRoom(@RequestBody Room room){
        Long id = roomService.create(room);
        room.setId(id);
        return ResponseEntity.status(201).body(room);
    }

    /// 수정
    @PreAuthorize("hasRole('ADMIN')")
    @PutMapping("/{id}")
    public ResponseEntity<Room> editRoom(@PathVariable Long id, @RequestBody Room room){
        room.setId(id);
        roomService.update(room);
        return ResponseEntity.ok(room);
    }

    /// 삭제
    @PreAuthorize("hasRole('ADMIN')")
    @DeleteMapping("/{id}")
    public ResponseEntity<Room> deleteRoom(@PathVariable Long id){
        roomService.delete(id);
        return ResponseEntity.noContent().build();
    }

    /// 차단
    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/{id}/block")
    public ResponseEntity<Map<String, Object>> blockTimeSlot(
            @PathVariable Long id,
            @RequestParam("date") String dateStr,
            @RequestParam(value = "startHour", required = false) Integer startHour,
            @RequestParam(value = "endHour", required = false) Integer endHour) {

        LocalDate date = LocalDate.parse(dateStr);
        LocalDateTime startAt = (startHour != null && endHour != null)
                ? date.atTime(startHour, 0) : date.atTime(9, 0);
        LocalDateTime endAt = (startHour != null && endHour != null)
                ? date.atTime(endHour, 0) : date.atTime(22, 0);

        roomSlotService.block(id, startAt, endAt);
        return ResponseEntity.ok(Map.of("success", true, "date", dateStr));
    }

    /// 차단 해제
    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/{id}/unblock")
    public ResponseEntity<Map<String, Object>> unblockTimeSlot(
            @PathVariable Long id,
            @RequestParam(value = "startAt", required = false) String startAtStr,
            @RequestParam(value = "endAt", required = false) String endAtStr,
            @RequestParam(value = "date", required = false) String dateStr) {

        LocalDateTime startAt, endAt;
        if (startAtStr != null && !startAtStr.trim().isEmpty() &&
                endAtStr != null && !endAtStr.trim().isEmpty()) {
            startAt = LocalDateTime.parse(startAtStr);
            endAt = LocalDateTime.parse(endAtStr);
        } else if (dateStr != null && !dateStr.trim().isEmpty()) {
            LocalDate date = LocalDate.parse(dateStr);
            startAt = date.atTime(9, 0);
            endAt = date.atTime(22, 0);
        } else {
            throw new IllegalArgumentException("startAt/endAt 또는 date 파라미터가 필요합니다.");
        }

        roomSlotService.unblock(id, startAt, endAt);
        String date = dateStr != null ? dateStr : startAt.toLocalDate().toString();
        return ResponseEntity.ok(Map.of("success", true, "date", date));
    }
}