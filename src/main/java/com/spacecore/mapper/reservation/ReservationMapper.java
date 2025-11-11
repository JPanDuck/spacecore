package com.spacecore.mapper.reservation;

import com.spacecore.domain.reservation.Reservation;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDateTime;
import java.util.List;

@Mapper
public interface ReservationMapper {
    /// 예약 전체 목록 조회
    List<Reservation> findAll();

    /// 내 예약 목록
    List<Reservation> findByUserId(@Param("userId") Long userId);

    /// 단건 조회
    Reservation findById(@Param("id") Long id);

    /// 예약 생성
    int insert(Reservation reservation);

    /// 예약 수정
//    int update(Reservation reservation);

    /// 예약 취소
    /// 예약 상태만 변경 (확정/취소/만료 등)
    int updateStatus(@Param("id") Long id, @Param("status") String status);

    /// 시간 범위의 예약 대기 상태 예약 ID 목록 조회
    List<Long> findAwaitingReservationIds(
            @Param("roomId") Long roomId,
            @Param("startAt") LocalDateTime startAt,
            @Param("endAt") LocalDateTime endAt
    );
}
