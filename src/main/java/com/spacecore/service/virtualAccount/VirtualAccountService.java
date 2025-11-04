package com.spacecore.service.virtualAccount;


import java.time.LocalDateTime;

public interface VirtualAccountService {

    /// 예약용 가상계좌 발급 (3일 유효, 더미계좌)
    void createVA(Long reservationId, LocalDateTime basisTime);

    /// 예약으로 유효 VA 계좌번호 조회
    String getAccountNo(Long reservationId);

    /// 만료 (ISSUED -> EXPIRED, 예약 EXPIRED 전환)
    int expireReservation();
}
