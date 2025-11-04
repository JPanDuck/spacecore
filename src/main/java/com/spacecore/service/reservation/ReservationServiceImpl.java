package com.spacecore.service.reservation;

import com.spacecore.domain.reservation.Reservation;
import com.spacecore.domain.room.RoomSlot;
import com.spacecore.domain.room.Room;
import com.spacecore.mapper.reservation.ReservationMapper;
import com.spacecore.mapper.room.RoomSlotMapper;
import com.spacecore.mapper.room.RoomMapper;
import com.spacecore.service.virtualAccount.VirtualAccountService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
@Transactional
public class ReservationServiceImpl implements ReservationService {

    private final ReservationMapper reservationMapper;
    private final RoomSlotMapper roomSlotMapper;
    private final RoomMapper roomMapper;
    private final VirtualAccountService virtualAccountService;

    /// 전체 목록 조회
    @Override
    public List<Reservation> findAll() {
        return reservationMapper.findAll();
    }

    /// 사용자별 목록 조회
    @Override
    public List<Reservation> findByUser(Long userId) {
        return reservationMapper.findByUserId(userId);
    }

    /// 단건 조회
    @Override
    public Reservation findById(Long id) {
        return reservationMapper.findById(id);
    }

    @Override
    public void create(Reservation reservation) {

        Room room = roomMapper.findById(reservation.getRoomId());

        // 방 존재 검증
        if (room == null) {
            throw new IllegalArgumentException("방을 찾을 수 없습니다. 방 ID : " + reservation.getRoomId());
        }

        int minHours = (room.getMinReservationHours() != null && room.getMinReservationHours() > 0)
                ? room.getMinReservationHours().intValue()
                : 1;


        // 1~4시간, 1시간 단위 연속 (예약 최대 4시간)
        validateHourRange(reservation.getStartAt(), reservation.getEndAt(), minHours);

        // 구간 충돌 검사(확정된 예약 또는 차단 존재 여부)
        int conflicts = roomSlotMapper.countConflicts(reservation.getRoomId(),
                reservation.getStartAt(), reservation.getEndAt());
        if (conflicts > 0) {
            throw new IllegalStateException("선택한 시간에 이미 결제 완료된 예약 또는 차단된 시간이 포함되어 있습니다. 다른 시간을 선택해주세요.");
        }

        // 예약 대기 상태의 슬롯이 있으면 삭제
        List<Long> awaitingReservationIds = reservationMapper.findAwaitingReservationIds(
                reservation.getRoomId(),
                reservation.getStartAt(),
                reservation.getEndAt()
        );
        for (Long reservationId : awaitingReservationIds) {
            roomSlotMapper.deleteByReservationId(reservationId);
        }

        // 금액 계싼 = (기본요금 * 시간 수)
        long hours = Duration.between(reservation.getStartAt(), reservation.getEndAt()).toHours();
        long basePrice = room.getPriceBase();
        reservation.setUnit("HOUR");
        reservation.setAmount(basePrice * hours);
        reservation.setStatus("AWAITING_PAYMENT");

        // 예약 생성
        reservationMapper.insert(reservation);

        // 슬롯 생성(RESERVED) - 1시간 단위 INSERT 반복
        for (int i = 0; i < hours; i++) {
            LocalDateTime start = reservation.getStartAt().plusHours(i);
            LocalDateTime end = start.plusHours(1);
            RoomSlot roomSlot = new RoomSlot();
            roomSlot.setRoomId(reservation.getRoomId());
            roomSlot.setReservationId(reservation.getId());
            roomSlot.setSlotUnit("HOUR");
            roomSlot.setSlotStart(start);
            roomSlot.setSlotEnd(end);
            roomSlot.setStatus("RESERVED");
            roomSlotMapper.insertSlot(roomSlot);
        }
        // 가상계좌 발급 (3일 유효)
        virtualAccountService.createVA(reservation.getId(), LocalDateTime.now());
    }

    @Override
    public Reservation update(Reservation reservation) {
        // 예약 ID로 기존 예약 정보 조회 (존재 여부 및 현재 상태 확인)
        Reservation existingReservation = reservationMapper.findById(reservation.getId());

        // 예약이 존재하지 않으면 예외 발생
        if (existingReservation == null) {
            throw new IllegalArgumentException("예약을 찾을 수 없습니다. 예약 ID: " + reservation.getId());
        }

        // 이미 취소된 예약은 수정 불가
        if ("CANCELLED".equals(existingReservation.getStatus())) {
            throw new IllegalStateException("취소된 예약은 수정할 수 없습니다.");
        }

        // 이미 만료된 예약은 수정 불가
        if ("EXPIRED".equals(existingReservation.getStatus())) {
            throw new IllegalStateException("만료된 예약은 수정할 수 없습니다.");
        }

        // 이미 확정된 예약은 수정 불가 (결제 완료 후에는 수정 불가)
        if ("CONFIRMED".equals(existingReservation.getStatus())) {
            throw new IllegalStateException("확정된 예약은 수정할 수 없습니다.");
        }

        // Room 정보 조회 (최소 예약 시간을 가져오기 위해)
        Room room = roomMapper.findById(reservation.getRoomId());

        // 방이 존재하지 않으면 예외 발생
        if (room == null) {
            throw new IllegalArgumentException("방을 찾을 수 없습니다. 방 ID: " + reservation.getRoomId());
        }

        // 최소 예약 시간 가져오기 (기본값 1시간)
        int minHours = (room.getMinReservationHours() != null && room.getMinReservationHours() > 0)
                ? room.getMinReservationHours().intValue()
                : 1;

        // 새로운 예약 시간 범위 검증 (최소 시간: Room 설정값, 최대 시간: 무제한, 운영시간: 09:00~22:00)
        validateHourRange(reservation.getStartAt(), reservation.getEndAt(), minHours);

        // 새로운 시간대 충돌 검사 (확정된 예약이나 차단 시간과 겹치는지 확인)
        int conflicts = roomSlotMapper.countConflicts(reservation.getRoomId(),
                reservation.getStartAt(), reservation.getEndAt());

        // 충돌이 있는 경우 예외 발생 (단, 기존 예약 시간과 완전히 동일하면 허용)
        boolean isSameTime = existingReservation.getStartAt().equals(reservation.getStartAt())
                && existingReservation.getEndAt().equals(reservation.getEndAt());

        if (conflicts > 0 && !isSameTime) {
            throw new IllegalStateException("선택한 시간에 이미 결제 완료된 예약 또는 차단된 시간이 포함되어 있습니다. 다른 시간을 선택해주세요.");
        }

        // 기존 예약으로 생성된 슬롯들을 모두 삭제 (새로운 시간으로 변경하기 전에 해제)
        roomSlotMapper.deleteByReservationId(reservation.getId());

        // 새로운 시간 범위에 따른 금액 재계산
        long hours = Duration.between(reservation.getStartAt(), reservation.getEndAt()).toHours();
        long basePrice = room.getPriceBase();
        reservation.setUnit("HOUR");
        reservation.setAmount(basePrice * hours);

        // 예약 상태는 기존 상태 유지 (수정해도 상태는 그대로)
        reservation.setStatus(existingReservation.getStatus());

        // 예약 정보 업데이트 (DB에 반영)
        reservationMapper.update(reservation);

        // 새로운 시간대에 맞춰 슬롯 생성(RESERVED) - 1시간 단위 INSERT 반복
        for (int i = 0; i < hours; i++) {
            LocalDateTime start = reservation.getStartAt().plusHours(i);
            LocalDateTime end = start.plusHours(1);
            RoomSlot roomSlot = new RoomSlot();
            roomSlot.setRoomId(reservation.getRoomId());
            roomSlot.setReservationId(reservation.getId());
            roomSlot.setSlotUnit("HOUR");
            roomSlot.setSlotStart(start);
            roomSlot.setSlotEnd(end);
            roomSlot.setStatus("RESERVED");
            roomSlotMapper.insertSlot(roomSlot);
        }

        // 수정된 예약 정보 반환 (업데이트 후 최신 정보)
        return reservationMapper.findById(reservation.getId());
    }

    @Override
    public void cancel(Long id) {
        Reservation reservation = reservationMapper.findById(id);

        // 예약 존재 검증
        if (reservation == null) {
            throw new IllegalArgumentException("예약을 찾을 수 없습니다. 예약 ID : " + id);
        }

        // 취소, 만료 검증
        if ("CANCELLED".equals(reservation.getStatus())) {
            throw new IllegalStateException("이미 취소된 예약입니다.");
        }

        if ("EXPIRED".equals(reservation.getStatus())) {
            throw new IllegalStateException("이미 만료된 예약입니다. 취소할 수 없습니다.");
        }

        // 예약 상태 변경
        reservationMapper.updateStatus(id, "CANCELLED");

        // 해당 예약을 생성된 슬롯 모두 삭제
        roomSlotMapper.deleteByReservationId(id);
    }

    @Override
    public void confirm(Long id) {
        Reservation reservation = reservationMapper.findById(id);

        // 예약 존재 검증
        if (reservation == null) {
            throw new IllegalArgumentException("예약을 찾을 수 없습니다. 예약 ID : " + id);
        }

        // 예약 확정 중복 검증
        if ("CONFIRMED".equals(reservation.getStatus())) {
            throw new IllegalArgumentException("이미 확정된 예약입니다.");
        }

        // 취소, 만료 검증
        if ("CANCELLED".equals(reservation.getStatus())) {
            throw new IllegalStateException("이미 취소된 예약입니다.");
        }

        if ("EXPIRED".equals(reservation.getStatus())) {
            throw new IllegalStateException("만료된 예약은 확정할 수 없습니다.");
        }

        // 예약 상태 변경
        reservationMapper.updateStatus(id, "CONFIRMED");
    }

    /// 시간 범위 검증 유틸리티 메서드 (예약 시간이 유효한지 검사)
    /// 관리자 차단용
    private void validateHourRange(LocalDateTime startAt, LocalDateTime endAt, int minHours) {
        /// 종료 시간이 시작 시간보다 빠른 경우 방지 (시간 역전 방지)
        if (endAt.isBefore(startAt)) {
            throw new IllegalArgumentException("종료 시각이 시작 시각보다 빠릅니다.");
        }

        /// 시작 시간과 종료 시간 사이의 차이를 시간 단위로 계산
        long hours = Duration.between(startAt, endAt).toHours();

        /// 최소 예약 시간 검사 (Room 설정값 사용)
        if (hours < minHours) {
            throw new IllegalArgumentException(
                    String.format("최소 예약 시간은 %d시간입니다.", minHours));
        }

        /// 운영시간 체크
        int startHour = startAt.getHour();  // 시작 시간의 시각 (0~23)
        int endHour = endAt.getHour();      // 종료 시간의 시각

        /// 시작 시간이 09시 이전이면 에러
        if (startHour < 9) {
            throw new IllegalArgumentException("예약 시작 시간은 09:00 이후여야 합니다.");
        }

        /// 종료 시간이 22시 이후이면 에러
        if (endHour > 22 || (endHour == 22 && endAt.getMinute() > 0)) {
            throw new IllegalArgumentException("예약 종료 시간은 22:00 이전이어야 합니다.");
        }

        /// 연속성 체크: 1시간 단위로 연속 선택되어 있는지 확인
        if (!endAt.equals(startAt.plusHours(hours))) {
            throw new IllegalArgumentException("시간은 1시간 단위 연속 선택만 허용됩니다.");
        }
    }

    /// ------------------ 캘린더용 ---------------------

    /// 캘린더용 날짜 범위 조회
    @Override
    public List<Map<String, Object>> findCalendarAvailability(Long roomId, LocalDate startDate, LocalDate endDate) {
        List<Map<String, Object>> events = new ArrayList<>();

        // 날짜 범위를 하루씩 반복
        LocalDate currentDate = startDate;
        while (!currentDate.isAfter(endDate)) {
            LocalDateTime dayStart = currentDate.atTime(9,0);
            LocalDateTime dayEnd = currentDate.atTime(23,0);
            List<RoomSlot> slots = roomSlotMapper.findStatesOfDay(roomId, dayStart, dayEnd);

            // 각 슬롯을 FullCalendar events 형식으로 변환
            for (RoomSlot slot : slots) {
                Map<String, Object> event = new HashMap<>();
                event.put("start", slot.getSlotStart().toString());
                event.put("end", slot.getSlotEnd().toString());
                event.put("title", slot.getStatus().equals("BLOCKED") ? "차단" : "예약됨");
                event.put("color", slot.getStatus().equals("BLOCKED") ? "#ff6b6b" : "#4ecdc4");
                events.add(event);
            }
            currentDate = currentDate.plusDays(1);
        }
        return events;
    }
}
