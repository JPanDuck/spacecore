package com.spacecore.service.payment;


import com.spacecore.domain.payment.Payment;
import com.spacecore.mapper.payment.PaymentMapper;
import com.spacecore.mapper.reservation.ReservationMapper;
import com.spacecore.mapper.room.RoomSlotMapper;
import com.spacecore.mapper.virtualAccount.VirtualAccountMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
@Transactional
public class PaymentServiceImpl implements PaymentService {

    private final PaymentMapper paymentMapper;
    private final VirtualAccountMapper virtualAccountMapper;
    private final ReservationMapper reservationMapper;
    private final RoomSlotMapper roomSlotMapper;

    /// 전체 조회
    @Override
    public List<Map<String, Object>> findAll() {
        return paymentMapper.findAll();
    }

    /// 상세 조회
    @Override
    public Payment findById(Long id) {
        return paymentMapper.findById(id);
    }

    @Override
    public List<Map<String, Object>> findByUserId(Long userId) {
        return paymentMapper.findByUserId(userId);
    }

    /// 입금 확정 (관리자가 입금 확인 버튼 클릭 시)
    @Override
    @Transactional
    public void insertConfirm(Long vaId, Long amount) {
        // Payment 로그 기록 (입금 확인 이력 저장)
        paymentMapper.insertConfirm(vaId, amount);

        // 가상계좌 ID로 예약 ID 찾기
        Long reservationId = virtualAccountMapper.findReservationIdByVaId(vaId);

        // 예약 ID가 없으면 예외 발생
        if (reservationId == null) {
            throw new IllegalArgumentException("가상계좌를 찾을 수 없습니다. 가상계좌 ID: " + vaId);
        }

        // 예약 상태를 'CONFIRMED'(확정)로 변경
        reservationMapper.updateStatus(reservationId, "CONFIRMED");

        // 가상계좌 상태를 'USED'(사용됨)로 변경
        virtualAccountMapper.updateStatus(vaId, "USED");
    }

    /// 결제 취소
    @Override
    @Transactional
    public void insertCancel(Long vaId, Long amount) {
        // Payment 로그 기록
        paymentMapper.insertCancel(vaId, amount);

        // 가상계좌 ID로 예약 ID 찾기
        Long reservationId = virtualAccountMapper.findReservationIdByVaId(vaId);

        if (reservationId == null) {
            throw new IllegalArgumentException("가상계좌를 찾을 수 없습니다. 가상계좌 ID: " + vaId);
        }

        // 예약 상태를 'CANCELLED'로 변경
        reservationMapper.updateStatus(reservationId, "CANCELLED");

        // 슬롯 삭제 추가
        roomSlotMapper.deleteByReservationId(reservationId);
    }
}

