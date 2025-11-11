package com.spacecore.service.virtualAccount;


import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

public interface VirtualAccountService {

    /// 예약용 가상계좌 발급 (3일 유효, 더미계좌)
    void createVA(Long resId, String bankName, LocalDateTime basisTime);

    /// 예약으로 유효 VA 계좌번호 조회
    String getAccountNo(Long reservationId);

    /// 만료 (ISSUED -> EXPIRED, 예약 EXPIRED 전환)
    int expireReservation();

    /// 예약 ID로 가상계좌 ID 조회
    Long findVaIdByReservationId(Long reservationId);

    /// 가상계좌 ID로 예약 ID 조회
    Long findReservationIdByVaId(Long vaId);

    /// 은행 목록 조회
    List<String> getBankList();


    /// 예약 ID로 모든 은행의 계좌번호 조회
    Map<String, String> getAllAccountNos(Long reservationId);

    /// 모든 은행에 가상계좌 발급
    void createAllVAs(Long reservationId, LocalDateTime basisTime);
}