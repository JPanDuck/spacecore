package com.spacecore.service.payment;

import com.spacecore.domain.payment.Payment;

import java.util.List;
import java.util.Map;

public interface PaymentService {

    /// 전체 조회
    List<Map<String, Object>> findAll();

    /// 상세 조회
    Payment findById(Long id);

    /// 사용자별 결제 목록 조회
    List<Map<String, Object>> findByUserId(Long userId);


    /// 입금 확정(결제 완료)
    void insertConfirm(Long vaId, Long amount);

    /// 결제 취소
    void insertCancel(Long vaId, Long amount);
}
