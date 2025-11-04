package com.spacecore.service.payment;

import com.spacecore.domain.payment.Payment;

import java.util.List;

public interface PaymentService {

    /// 전체 조회
    List<Payment> findAll();

    /// 상세 조회
    Payment findById(Long id);


    /// 입금 확정(결제 완료)
    void insertConfirm(Long vaId, Long amount);

    /// 결제 취소
    void insertCancel(Long vaId, Long amount);
}
