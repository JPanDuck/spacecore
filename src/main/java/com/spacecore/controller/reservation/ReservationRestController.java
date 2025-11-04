package com.spacecore.controller.reservation;

import com.spacecore.domain.reservation.Reservation;
import com.spacecore.service.reservation.ReservationService;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/reservations")
public class ReservationRestController {

    private final ReservationService reservationService;

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

    /// 예약 생성
    @PostMapping
    public ResponseEntity<Reservation> addReservation(@RequestBody Reservation reservation){
        reservationService.create(reservation);
        return ResponseEntity.status(201).body(reservation);
    }

    /// 수정
    @PreAuthorize("hasRole('ADMIN')")
    @PutMapping("/{id}")
    public ResponseEntity<Reservation> editReservation(@PathVariable Long id,
                                                       @RequestBody Reservation reservation){
        reservation.setId(id);
        return ResponseEntity.ok(reservationService.update(reservation));
    }

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
}
