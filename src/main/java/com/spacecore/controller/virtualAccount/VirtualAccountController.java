package com.spacecore.controller.virtualAccount;


import com.spacecore.service.virtualAccount.VirtualAccountService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequiredArgsConstructor
@RequestMapping("/virtual-accounts")
public class VirtualAccountController {

    private final VirtualAccountService virtualAccountService;

    /// 예약과 연결된 가상계좌 상세 조회
    @GetMapping("/detail/{reservationId}")
    public String VADetail(@PathVariable Long reservationId, Model model){
        String accountNo = virtualAccountService.getAccountNo(reservationId);
        model.addAttribute("reservationId", reservationId);
        model.addAttribute("accountNo", accountNo);
        return "virtualAccount/virtualAccountDetail";
    }

    /// 수동으로 VA 만료처리
    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/expire")
    public String expire(){
        virtualAccountService.expireReservation();
        return "redirect:/virtual-accounts/";
    }
}
