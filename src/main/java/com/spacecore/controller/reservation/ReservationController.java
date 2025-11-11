package com.spacecore.controller.reservation;

import com.spacecore.domain.reservation.Reservation;
import com.spacecore.domain.room.Room;

import com.spacecore.domain.room.RoomSlot;
import com.spacecore.security.CustomUserDetails;
import com.spacecore.service.virtualAccount.VirtualAccountService;
import org.springframework.security.access.prepost.PreAuthorize;
import com.spacecore.service.reservation.ReservationService;
import com.spacecore.service.room.RoomService;
import com.spacecore.service.room.RoomSlotService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Controller
@RequiredArgsConstructor
@RequestMapping("/reservations")
public class ReservationController {

    private final ReservationService reservationService;
    private final RoomService roomService;
    private final RoomSlotService roomSlotService;
    private final VirtualAccountService virtualAccountService;

    /// 목록 페이지
    @GetMapping({"", "/"})
    @PreAuthorize("isAuthenticated()")
    public String ReservationList(@AuthenticationPrincipal CustomUserDetails user, Model model) {
        // 관리자는 전체 예약 조회, 일반 사용자는 본인 예약만 조회
        if ("ADMIN".equals(user.getRole())) {
            model.addAttribute("reservationList", reservationService.findAll());
        } else {
            Long currentUserId = user.getId();
            model.addAttribute("reservationList", reservationService.findByUser(currentUserId));
        }
        return "reservation/list";
    }

    /// 상세 페이지
    @GetMapping("/detail/{id}")
    @PreAuthorize("isAuthenticated()")
    public String ReservationDetail(
            @PathVariable Long id,
            @AuthenticationPrincipal CustomUserDetails user,
            Model model) {
        Reservation reservation = reservationService.findById(id);

        // 관리자가 아니면 본인 예약만 접근 가능
        if (!"ADMIN".equals(user.getRole())) {
            Long currentUserId = user.getId();
            if (!reservation.getUserId().equals(currentUserId)) {
                throw new IllegalArgumentException("접근 권한이 없습니다.");
            }
        }

        model.addAttribute("reservation", reservation);

        // 가상계좌 ID 조회 (Service 사용)
        Long vaId = virtualAccountService.findVaIdByReservationId(id);
        model.addAttribute("vaId", vaId);

        // 모든 은행의 계좌번호 조회
        Map<String, String> allAccountNos = virtualAccountService.getAllAccountNos(id);
        model.addAttribute("allAccountNos", allAccountNos);

        return "reservation/detail";
    }

    /// 등록 폼
    @PreAuthorize("isAuthenticated()")  // 이 줄 추가
    @GetMapping("/add")
    public String addForm(
            @RequestParam("roomId") Long roomId,  // @PathVariable에서 @RequestParam으로 변경
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
        // 은행 목록은 제거 (선택 안 함)

        return "reservation/add";
    }

    /// 등록 처리
    @PreAuthorize("hasAnyRole('USER', 'ADMIN')")
    @PostMapping("/add")
    public String addReservation(
            @ModelAttribute Reservation reservation,
            @AuthenticationPrincipal CustomUserDetails user) {
        // 현재 로그인한 사용자 ID 설정
        reservation.setUserId(user.getId());

        // 예약 생성 + 슬롯잠금 + VA발급
        reservationService.create(reservation);
        return "redirect:/reservations/";
    }

    /// 수정 폼
    @GetMapping("/edit/{id}")
    @PreAuthorize("isAuthenticated()")
    public String editForm(
            @PathVariable Long id,
            @AuthenticationPrincipal CustomUserDetails user,
            Model model) {
        Reservation reservation = reservationService.findById(id);

        // 관리자가 아니면 본인 예약만 접근 가능
        if (!"ADMIN".equals(user.getRole())) {
            Long currentUserId = user.getId();
            if (!reservation.getUserId().equals(currentUserId)) {
                throw new IllegalArgumentException("접근 권한이 없습니다.");
            }
        }

        model.addAttribute("reservation", reservation);
        return "reservation/edit";
    }

//    /// 수정
//    @PostMapping("/edit")
//    @PreAuthorize("isAuthenticated()")
//    public String editReservation(
//            @ModelAttribute Reservation reservation,
//            @AuthenticationPrincipal CustomUserDetails user) {
//        Reservation existing = reservationService.findById(reservation.getId());
//
//        // 관리자가 아니면 본인 예약만 수정 가능
//        if (!"ADMIN".equals(user.getRole())) {
//            Long currentUserId = user.getId();
//            if (!existing.getUserId().equals(currentUserId)) {
//                throw new IllegalArgumentException("접근 권한이 없습니다.");
//            }
//        }
//
//        reservationService.update(reservation);
//        return "redirect:/reservations/detail/" + reservation.getId();
//    }

    /// 취소(버튼)
    @PostMapping("/cancel/{id}")
    @PreAuthorize("isAuthenticated()")
    public String cancelReservation(
            @PathVariable("id") Long id,
            @AuthenticationPrincipal CustomUserDetails user) {
        Reservation reservation = reservationService.findById(id);

        // 관리자가 아니면 본인 예약만 취소 가능
        if (!"ADMIN".equals(user.getRole())) {
            Long currentUserId = user.getId();
            if (!reservation.getUserId().equals(currentUserId)) {
                throw new IllegalArgumentException("접근 권한이 없습니다.");
            }
        }

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
