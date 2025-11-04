package com.spacecore.service.room;

import com.spacecore.domain.room.RoomSlot;
import com.spacecore.mapper.room.RoomSlotMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class RoomSlotServiceImpl implements RoomSlotService {

    private final RoomSlotMapper roomSlotMapper;

    @Override
    public List<RoomSlot> findStatesOfDay(Long roomId, LocalDate date) {
        LocalDateTime dayStart = date.atTime(9, 0);
        LocalDateTime dayEnd = date.atTime(23, 0);
        return roomSlotMapper.findStatesOfDay(roomId, dayStart, dayEnd);
    }

    @Override
    @Transactional
    public void block(Long roomId, LocalDateTime startAt, LocalDateTime endAt) {
        // (최대 09~22) 범위 검증
        validateHourRange(startAt, endAt, 1, 13);
        // 충돌(예약/차단) 존재 시 거절
        int conflicts = roomSlotMapper.countConflicts(roomId, startAt, endAt);
        if (conflicts > 0) {
            throw new IllegalStateException("이미 예약된 시간이 포함되어 있습니다.");
        }

        // 1시간 단위로 잘라 BLOCKED 슬롯 생성
        long hours = java.time.Duration.between(startAt, endAt).toHours();
        List<RoomSlot> batch = new ArrayList<>();
        for (int i = 0; i < hours; i++) {
            LocalDateTime start = startAt.plusHours(i);
            LocalDateTime end = start.plusHours(1);
            RoomSlot slot = new RoomSlot();
            slot.setRoomId(roomId);                          // 방 ID 지정
            slot.setReservationId(null);                     // 차단은 예약ID 없음
            slot.setSlotUnit("HOUR");                        // 1시간 단위
            slot.setSlotStart(start);                            // 시작 시각
            slot.setSlotEnd(end);                              // 종료 시각
            slot.setStatus("BLOCKED");                       // 상태: 차단
            batch.add(slot);                                  // 리스트에 추가
        }
        for (RoomSlot slot : batch) {
            roomSlotMapper.insertSlot(slot);
        }

    }

    @Override
    @Transactional
    public void unblock(Long roomId, LocalDateTime startAt, LocalDateTime endAt) {
        /// 1~13시간 범위 검증
        validateHourRange(startAt, endAt, 1, 13);
        /// BLOCKED 범위 삭제
        roomSlotMapper.deleteBlockedRange(roomId, startAt, endAt);
    }
    /// 시간 범위 검증 유틸(연속, 최소/최대)
    private void validateHourRange(LocalDateTime startAt, LocalDateTime endAt,
                                   int minHours, int maxHours) {
        /// 종료 시간이 시작 시간보다 빠른 경우 방지 (시간 역전 방지)
        if (endAt.isBefore(startAt)) {
            throw new IllegalArgumentException("종료 시각이 시작 시각보다 빠릅니다.");
        }
        /// 시작 시간과 종료 시간 사이의 차이를 시간 단위로 계산
        long hours = java.time.Duration.between(startAt, endAt).toHours();
        /// 범위 체크
        if (hours < minHours || hours > maxHours) {
            throw new IllegalArgumentException("허용 시간 범위를 벗어났습니다.");
        }
        /// 연속성 체크
        if (!endAt.equals(startAt.plusHours(hours))) {
            throw new IllegalArgumentException("시간은 1시간 단위 연속 선택만 허용됩니다.");
        }
    }
}
