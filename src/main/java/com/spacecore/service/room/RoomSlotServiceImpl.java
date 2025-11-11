package com.spacecore.service.room;

import com.spacecore.domain.room.RoomSlot;
import com.spacecore.mapper.room.RoomSlotMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class RoomSlotServiceImpl implements RoomSlotService {

    private final RoomSlotMapper roomSlotMapper;


    /// 룸슬롯 생성
    @Override
    @Transactional
    public void createSlots(Long reservationId, Long roomId, LocalDateTime startAt, LocalDateTime endAt, String status) {
        // 1시간 단위로 잘라 슬롯 생성
        long hours = java.time.Duration.between(startAt, endAt).toHours();
        for (int i = 0; i < hours; i++) {
            LocalDateTime start = startAt.plusHours(i);
            LocalDateTime end = start.plusHours(1);
            RoomSlot slot = new RoomSlot();
            slot.setRoomId(roomId);
            slot.setReservationId(reservationId);
            slot.setSlotUnit("HOUR");
            slot.setSlotStart(start);
            slot.setSlotEnd(end);
            slot.setStatus(status);

            try {
                roomSlotMapper.insertSlot(slot);
            } catch (org.springframework.dao.DuplicateKeyException e) {
                // 동시 요청으로 이미 같은 시간대 슬롯이 생성된 경우 무시
                // (이미 다른 요청이 생성했으므로 정상 동작)
            }
        }
    }

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
        // 충돌(예약만) 존재 시 거절
        int conflicts = roomSlotMapper.countConflicts(roomId, startAt, endAt);
        if (conflicts > 0) {
            throw new IllegalStateException("이미 예약된 시간이 포함되어 있습니다.");
        }

        // 기존 BLOCKED 슬롯이 있으면 먼저 삭제 (병합/확장을 위해)
        roomSlotMapper.deleteBlockedRange(roomId, startAt, endAt);

        // BLOCKED 슬롯 생성 (createSlots 메서드 사용)
        createSlots(null, roomId, startAt, endAt, "BLOCKED");
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
