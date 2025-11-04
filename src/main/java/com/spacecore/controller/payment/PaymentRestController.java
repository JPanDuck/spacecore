package com.spacecore.controller.payment;

import com.spacecore.service.payment.PaymentService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/payments")
public class PaymentRestController {

    private final PaymentService paymentService;

    /// 입금 확정 (가상계좌 결제 완료)
    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/{vaId}/confirm")
    public ResponseEntity<Void> confirm(@PathVariable Long vaId, @RequestParam Long amount){
        paymentService.insertConfirm(vaId, amount);
        return ResponseEntity.noContent().build();
    }

    /// 결제 취소
    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/{vaId}/cancel")
    public ResponseEntity<Void> cancel(@PathVariable Long vaId, @RequestParam Long amount){
        paymentService.insertCancel(vaId, amount);
        return ResponseEntity.noContent().build();
    }

}
