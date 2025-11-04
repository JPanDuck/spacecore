package com.spacecore.mapper.room;

import com.spacecore.domain.room.RoomSlot;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.security.core.parameters.P;


import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@Mapper
public interface RoomSlotMapper {

    ///  일자 상태 조회 : DB에 저장된 슬롯 조회용
    List<RoomSlot> findStatesOfDay(
            @Param("roomId") Long roomId,
            @Param("dayStart") LocalDateTime dayStart,
            @Param("dayEnd") LocalDateTime dayEnd
    );

    /// 선택 구간에 RESERVED/BLOCKED 존재 개수
    int countConflicts(
            @Param("roomId") Long roomId,
            @Param("startAt") LocalDateTime startAt,
            @Param("endAt") LocalDateTime endAt
    );

    /// 단일 슬롯 INSERT (예약 /차단 공통)
    int insertSlot(RoomSlot roomSlot);

    /// 예약ID로 생성된 슬롯 전체 삭제 (예약 취소 시)
    int deleteByReservationId(@Param("reservationId") Long reservationId);

    ///  관리자 차단 해제 (범위로 BLOCKED 삭제)
    int deleteBlockedRange(
            @Param("roomId") Long roomId,
            @Param("startAt") LocalDateTime startAt,
            @Param("endAt") LocalDateTime endAt
    );
}
