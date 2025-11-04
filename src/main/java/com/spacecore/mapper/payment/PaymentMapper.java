package com.spacecore.mapper.payment;

import com.spacecore.domain.payment.Payment;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface PaymentMapper {

    // 전체 결제 목록 조회
    List<Payment> findAll();

    // 단건 조회
    Payment findById(Long id);

    /// 입금확정 로그
    int insertConfirm(@Param("vaId") Long vaId,
                      @Param("amount") Long amount
    );

    /// 결제취소 로그
    int insertCancel(@Param("vaId") Long vaId,
                      @Param("amount") Long amount
    );
}
