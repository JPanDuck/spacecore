package com.spacecore.service.reservation;


import com.spacecore.domain.reservation.Reservation;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

public interface ReservationService {

    ///  예약 전체 목록 조회
    List<Reservation> findAll();

    /// 내 예약 목록 (로그인 전 : userId 파라미터)
    List<Reservation> findByUser(Long userId);

    /// 예약 단건 조회
    Reservation findById(Long id);

    /// 예약 신규 생성
    void create(Reservation reservation);

    /// 예약 수정
    Reservation update(Reservation reservation);

    /// 예약 취소 (예약 상태 변경)
    void cancel(Long id);

    ///  예약 확정 (예약 상태 변경)
    void confirm(Long id);

    /// ------------------ 캘린더용 ---------------------

    /// 캘린더용 날짜 범위 조회
    List<Map<String, Object>> findCalendarAvailability(Long roomId, LocalDate startDate, LocalDate endDate);

    /// 사용자와 객실로 예약 조회 (리뷰 작성 권한 확인용)
    List<Reservation> findByUserIdAndRoomId(Long userId, Long roomId);
}
