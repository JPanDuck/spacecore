package com.spacecore.controller.reservation;

import com.spacecore.domain.reservation.Reservation;
import com.spacecore.domain.room.Room;
import com.spacecore.domain.room.RoomSlot;

import com.spacecore.mapper.virtualAccount.VirtualAccountMapper;
import org.springframework.security.access.prepost.PreAuthorize;
import com.spacecore.service.reservation.ReservationService;
import com.spacecore.service.room.RoomService;
import com.spacecore.service.room.RoomSlotService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Controller
@RequiredArgsConstructor
@RequestMapping("/reservations")
public class ReservationController {

    private final ReservationService reservationService;
    private final RoomService roomService;
    private final RoomSlotService roomSlotService;
    private final VirtualAccountMapper virtualAccountMapper;

    /// 목록 페이지
    @GetMapping({"", "/"})
    public String ReservationList(Model model) {
        model.addAttribute("reservationList", reservationService.findAll());
        return "reservation/list";
    }

    /// 상세페이지
    @GetMapping("/detail/{id}")
    public String ReservationDetail(@PathVariable Long id, Model model) {
        Reservation reservation = reservationService.findById(id);
        model.addAttribute("reservation", reservation);

        // 가상계좌 ID 조회 추가
        Long vaId = virtualAccountMapper.findVaIdByReservationId(id);
        model.addAttribute("vaId", vaId);

        return "reservation/detail";
    }

    /// 등록 폼
    @GetMapping("/add/{roomId}")
    public String addForm(
            @PathVariable("roomId") Long roomId,
            @RequestParam(value = "date", required = false) String date,
            Model model
    ) {
        // roomId가 없으면 룸 목록 페이지로 리다이렉트
        if (roomId == null) {
            return "redirect:/offices";
        }

        // Service를 통해 룸 정보 조회
        Room room = roomService.get(roomId);
        if (room == null) {
            throw new IllegalArgumentException("방을 찾을 수 없습니다. 방 ID : " + roomId);
        }
        model.addAttribute("room", room);

        // 선택한 날짜가 있으면, 해당 날짜의 예약 불가능한 시간대 조회 (Service 사용)
        List<RoomSlot> bookedSlots;
        if (date != null && !date.isEmpty()) {
            LocalDate selectedDate = LocalDate.parse(date);
            bookedSlots = roomSlotService.findStatesOfDay(roomId, selectedDate);
        } else {
            // 날짜가 없으면 오늘 날짜로 조회
            LocalDate today = LocalDate.now();
            bookedSlots = roomSlotService.findStatesOfDay(roomId, today);
        }
        // null 방지: 빈 리스트로 초기화 (JSP에서 null 체크 없이 사용 가능)
        if (bookedSlots == null) {
            bookedSlots = new ArrayList<>();
        }
        model.addAttribute("bookedSlots", bookedSlots);

        model.addAttribute("reservation", new Reservation());
        return "reservation/add";
    }

    /// 등록 처리
    @PostMapping("/add")
    public String addReservation(@ModelAttribute Reservation reservation) {
        // 예약 생성 + 슬롯잠금 + VA발급
        reservationService.create(reservation);
        return "redirect:/reservations/";
    }

    /// 수정 폼
    @GetMapping("/edit/{id}")
    public String editForm(@PathVariable Long id, Model model) {
        model.addAttribute("reservation", reservationService.findById(id));
        return "reservation/edit";
    }

    /// 수정
    @PostMapping("/edit")
    public String editReservation(@ModelAttribute Reservation reservation) {
        // 수정 + 슬롯 재 잠금
        reservationService.update(reservation);
        return "redirect:/reservations/detail/" + reservation.getId();
    }

    /// 취소(버튼)
    @PostMapping("/cancel/{id}")
    public String cancelReservation(@PathVariable("id") Long id) {
        reservationService.cancel(id);
        return "redirect:/reservations/detail/" + id;
    }

    /// 입금확정(버튼)
    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/confirm/{id}")
    public String confirmReservation(@PathVariable("id") Long id) {
        reservationService.confirm(id);
        return "redirect:/reservations/detail/" + id;
    }
}
