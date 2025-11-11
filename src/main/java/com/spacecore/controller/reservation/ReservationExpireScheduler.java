package com.spacecore.controller.reservation;

import com.spacecore.service.virtualAccount.VirtualAccountService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Slf4j
@Component
@RequiredArgsConstructor
public class ReservationExpireScheduler {

    private final VirtualAccountService virtualAccountService;

    // 매일 0시
    @Scheduled(cron = "0 0 0 * * *")
    public void expireReservations(){
        int processed = virtualAccountService.expireReservation();
        log.info("예약 만료 처리 완료: {}건", processed);
    }
}
