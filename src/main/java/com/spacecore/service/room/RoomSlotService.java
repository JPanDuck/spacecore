package com.spacecore.service.room;


import com.spacecore.domain.room.RoomSlot;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

public interface RoomSlotService {


    /// 슬롯 생성 (시간 범위를 1시간 단위로 나눠서 생성)
    void createSlots(Long reservationId, Long roomId, LocalDateTime startAt, LocalDateTime endAt, String status);

    /// 하루(09~22) 슬롯 상태 조회: DB에 있는 것만 가져옴
    List<RoomSlot> findStatesOfDay(Long roomId, LocalDate date);

    /// 관리자: 특정 시간대 차단(BLOCK) 생성
    void block(Long roomId, LocalDateTime startAt, LocalDateTime endAt);

    /// 관리자: 특정 시간대 차단 해제
    void unblock(Long roomId, LocalDateTime startAt, LocalDateTime endAt);
}