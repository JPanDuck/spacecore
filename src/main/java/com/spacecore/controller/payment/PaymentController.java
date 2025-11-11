package com.spacecore.controller.payment;

import com.spacecore.domain.payment.Payment;
import com.spacecore.domain.reservation.Reservation;
import com.spacecore.mapper.payment.PaymentMapper;
import com.spacecore.mapper.virtualAccount.VirtualAccountMapper;
import com.spacecore.security.CustomUserDetails;
import com.spacecore.service.payment.PaymentService;
import com.spacecore.service.reservation.ReservationService;
import com.spacecore.service.virtualAccount.VirtualAccountService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequiredArgsConstructor
@RequestMapping("/payments")
public class PaymentController {
    private final PaymentService paymentService;
    private final VirtualAccountService virtualAccountService;
    private final ReservationService reservationService;

    /// 결제 목록 페이지
    @GetMapping({"","/"})
    @PreAuthorize("isAuthenticated()")
    public String paymentList(@AuthenticationPrincipal CustomUserDetails user, Model model){
        // 관리자는 전체 결제 조회, 일반 사용자는 본인 결제만 조회
        if ("ADMIN".equals(user.getRole())) {
            model.addAttribute("paymentList", paymentService.findAll());
        } else {
            Long currentUserId = user.getId();
            model.addAttribute("paymentList", paymentService.findByUserId(currentUserId));
        }
        return "payment/paymentList";
    }

    @GetMapping("/detail/{id}")
    @PreAuthorize("isAuthenticated()")
    public String detail(
            @PathVariable Long id,
            @AuthenticationPrincipal CustomUserDetails user,
            Model model) {
        Payment payment = paymentService.findById(id);

        // VirtualAccount를 통해 예약 ID 찾기
        Long reservationId = virtualAccountService.findReservationIdByVaId(payment.getVaId());
        Reservation reservation = reservationService.findById(reservationId);

        // 관리자가 아니면 본인 결제만 접근 가능
        if (!"ADMIN".equals(user.getRole())) {
            Long currentUserId = user.getId();
            if (!reservation.getUserId().equals(currentUserId)) {
                throw new IllegalArgumentException("접근 권한이 없습니다.");
            }
        }

        model.addAttribute("payment", payment);
        return "payment/paymentDetail";
    }

    /// 결제 확인(입금) 수동 처리 버튼
    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/{vaId}/confirm")
    public String confirm(@PathVariable Long vaId, @RequestParam Long amount){
        paymentService.insertConfirm(vaId, amount);
        return "redirect:/payments/";
    }

    /// 결제 취소 처리
    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/{vaId}/cancel")
    public String cancel(@PathVariable Long vaId, @RequestParam Long amount){
        paymentService.insertCancel(vaId, amount);
        return "redirect:/payments/";
    }
}
