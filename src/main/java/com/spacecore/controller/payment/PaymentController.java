package com.spacecore.controller.payment;

import com.spacecore.service.payment.PaymentService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequiredArgsConstructor
@RequestMapping("/payments")
public class PaymentController {
    private final PaymentService paymentService;

    /// 결제 목록 페이지
    @GetMapping({"","/"})
    public String paymentList(Model model){
        model.addAttribute("paymentList", paymentService.findAll());  // 이 줄 추가
        return "payment/paymentList";
    }

    @GetMapping("/detail/{id}")
    public String detail(@PathVariable Long id, Model model) {
        model.addAttribute("payment", paymentService.findById(id));
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
