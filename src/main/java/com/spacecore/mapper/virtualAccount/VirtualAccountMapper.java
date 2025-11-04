package com.spacecore.mapper.virtualAccount;


import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDateTime;

@Mapper
public interface VirtualAccountMapper {

    /// 가상계좌 신규 발급
    int insert(
            @Param("reservationId") Long reservationId,
            @Param("accountNo") String accountNo,       // 계좌번호(더미)
            @Param("bankCode") String bankCode,         // 은행코드(더미)
            @Param("expiresAt")LocalDateTime expires    // 만료시각(3일 후)
    );

    /// 가상계좌 ID로 예약 ID 조회 (입금 확인 시 사용)
    Long findReservationIdByVaId(@Param("vaId") Long vaId);

    /// 예약 ID로 가상계좌 ID 조회
    Long findVaIdByReservationId(@Param("reservationId") Long reservationId);

    /// 예약 ID로 계좌번호 조회
    String findAccountNoByReservationId(@Param("reservationId") Long reservationId);

    /// 만료시각 지난 ISSUED 계좌들을 EXPIRED 처리
    int expireIssuedAccounts();

    /// 만료된 가상계좌에 연결된 예약을 EXPIRED로 변경
    int markReservationExpiredByVA();

    /// 가상계좌 상태 변경 (입금 확인 시 USED로 변경)
    int updateStatus(@Param("vaId") Long vaId, @Param("status") String status);
}
