package com.spacecore.service.virtualAccount;

import com.spacecore.mapper.virtualAccount.VirtualAccountMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.concurrent.ThreadLocalRandom;

@Service
@RequiredArgsConstructor
@Transactional
public class VirtualAccountServiceImpl implements VirtualAccountService {

    private final VirtualAccountMapper virtualAccountMapper;


    /// 예약용 가상계좌 발급 (3일 유효, 더미계좌)
    @Override
    @Transactional
    public void createVA(Long reservationId, LocalDateTime basisTime) {
        String accountNo = generateDummyAccountNo();
        String BankCode = "999";
        LocalDateTime expiresAt =basisTime.plusDays(3); // 3일 유효

        virtualAccountMapper.insert(reservationId,accountNo,BankCode,expiresAt);
    }

    /// 예약으로 유효 VA 계좌번호 조회
    @Override
    public String getAccountNo(Long reservationId) {
        return virtualAccountMapper.findAccountNoByReservationId(reservationId);
    }

    /// 만료 (ISSUED -> EXPIRED, 예약 EXPIRED 전환)
    @Override
    @Transactional
    public int expireReservation() {
        int a = virtualAccountMapper.expireIssuedAccounts(); // ISSUED -> EXPIRED 전환
        int b = virtualAccountMapper.markReservationExpiredByVA(); // 예약 EXPIRED 전환
        return a + b;
    }

//    ---------------------------------------------
    /// 더미 계좌번호 생성기
    private String generateDummyAccountNo() {
        // 8자리 난수
        int body = ThreadLocalRandom.current().nextInt(10000000, 100000000);
        return "090-" + body;
    }
}

