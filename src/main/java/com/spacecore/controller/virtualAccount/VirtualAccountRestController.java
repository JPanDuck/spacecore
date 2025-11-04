package com.spacecore.controller.virtualAccount;

import com.spacecore.service.virtualAccount.VirtualAccountService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/virtual-account")
public class VirtualAccountRestController {

    private final VirtualAccountService virtualAccountService;

    /// 특정 예약에 가상계좌 발급 (수동발급)
    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/add/{reservationId}")
    public ResponseEntity<Void> addVA(@PathVariable Long reservationId){
        virtualAccountService.createVA(reservationId, LocalDateTime.now());
        return ResponseEntity.status(201).build();
    }

    /// 예약 ID로 계좌번호 조회
    @GetMapping("/{reservationId}")
    public ResponseEntity<String> GetVA(@PathVariable Long reservationId){
        String accountNo = virtualAccountService.getAccountNo(reservationId);
        return (accountNo != null) ? ResponseEntity.ok(accountNo)
                                   : ResponseEntity.notFound().build();
    }

    /// 수동으로 VA 만료처리
    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/expire")
    public ResponseEntity<Void> ExpireVA(){
        virtualAccountService.expireReservation();
        return ResponseEntity.status(201).build();
    }


}
