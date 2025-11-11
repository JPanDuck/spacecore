package com.spacecore.controller.reservation;

import com.spacecore.domain.reservation.Reservation;
import com.spacecore.domain.room.RoomSlot;
import com.spacecore.service.reservation.ReservationService;
import com.spacecore.service.room.RoomSlotService;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/reservations")
public class ReservationRestController {

    private final ReservationService reservationService;
    private final RoomSlotService roomSlotService;

    /// 전체 조회
    @GetMapping
    public ResponseEntity<List<Reservation>> getAllReservations() {
        return ResponseEntity.ok(reservationService.findAll());
    }

    /// 상세 조회
    @GetMapping("/{id}")
    public ResponseEntity<Reservation> getReservationById(@PathVariable Long id) {
        Reservation reservation = reservationService.findById(id);
        return (reservation != null) ? ResponseEntity.ok(reservation)
                : ResponseEntity.notFound().build();
    }

    @PostMapping  // 이 줄 추가
    public ResponseEntity<Reservation> addReservation(@RequestBody Reservation reservation){
        Reservation created = reservationService.create(reservation);
        return ResponseEntity.status(201).body(created);
    }

    /// 수정
//    @PreAuthorize("hasRole('ADMIN')")
//    @PutMapping("/{id}")
//    public ResponseEntity<Reservation> editReservation(@PathVariable Long id,
//                                                       @RequestBody Reservation reservation){
//        reservation.setId(id);
//        return ResponseEntity.ok(reservationService.update(reservation));
//    }

    /// 예약 취소
    @PutMapping("/{id}/cancel")
    public ResponseEntity<Void> cancelReservation(@PathVariable Long id){
        reservationService.cancel(id);
        return ResponseEntity.noContent().build();
    }

    /// 입금 확정
    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/{id}/confirm")
    public ResponseEntity<Void> confirmReservation(@PathVariable Long id){
        reservationService.confirm(id);
        return ResponseEntity.noContent().build();
    }

    /// ------------------ 캘린더용 ---------------------
    /// 캘린더용 예약 상태 조회
    @GetMapping("/calendar/availability")
    public ResponseEntity<List<Map<String, Object>>> getCalendarAvailability(
            @RequestParam Long roomId,
            // 문자열 -> 날짜 데이터 변환
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)LocalDate start,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)LocalDate end){
        return ResponseEntity.ok(reservationService.findCalendarAvailability(roomId, start, end));
    }

    /// 날짜별 예약 불가 시간 조회
    @GetMapping("/availability/{roomId}")
    public ResponseEntity<List<Map<String, Object>>> getAvailability(@PathVariable Long roomId,
                                                                     @RequestParam @DateTimeFormat(iso= DateTimeFormat.ISO.DATE) LocalDate date){
        List<RoomSlot> slots = roomSlotService.findStatesOfDay(roomId, date);
        List<Map<String, Object>> result = new ArrayList<>();
        for (RoomSlot slot : slots) {
            if (slot.getStatus().equals("BLOCKED") || slot.getStatus().equals("RESERVED")){
                // slot_start부터 slot_end 전까지의 모든 시간을 비활성화
                int startHour = slot.getSlotStart().getHour();
                int endHour = slot.getSlotEnd().getHour();
                for (int hour = startHour; hour < endHour; hour++) {
                    Map<String, Object> item = new HashMap<>();
                    item.put("hour", hour);
                    item.put("status", slot.getStatus());
                    result.add(item);
                }
            }
        }
        return ResponseEntity.ok(result);
    }
}
