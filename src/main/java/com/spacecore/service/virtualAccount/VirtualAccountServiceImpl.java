package com.spacecore.service.virtualAccount;

import com.spacecore.domain.reservation.Reservation;
import com.spacecore.mapper.reservation.ReservationMapper;
import com.spacecore.mapper.virtualAccount.VirtualAccountMapper;
import com.spacecore.service.notification.NotificationService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ThreadLocalRandom;

@Service
@RequiredArgsConstructor
@Transactional
public class VirtualAccountServiceImpl implements VirtualAccountService {

    private final VirtualAccountMapper virtualAccountMapper;
    private final NotificationService notificationService;
    private final ReservationMapper reservationMapper;

    /// 은행별 가상계좌 발급
    @Override
    @Transactional
    public void createVA(Long reservationId, String bankName, LocalDateTime basisTime) {
        String accountNo = generateDummyAccountNo(bankName);
        LocalDateTime expiresAt = basisTime.plusDays(3);

        virtualAccountMapper.insert(reservationId, accountNo, bankName, expiresAt);
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
        // 1. 이번에 만료될 예약 ID들을 먼저 가져옵니다.
        List<Long> expiredReservationIds = virtualAccountMapper.findReservationIdsToExpire();

        // 2. 기존 로직대로 상태를 바꿉니다.
        int a = virtualAccountMapper.expireIssuedAccounts();
        int b = virtualAccountMapper.markReservationExpiredByVA();

        // 3. 예약 + 방을 조회하고 알림 발송
        for (Long reservationId : expiredReservationIds) {
            Reservation reservation = reservationMapper.findById(reservationId);
            if (reservation == null) {
                continue; // 방어 로직
            }

            /// 알림
            notificationService.sendNotification(
                    reservation.getUserId(),
                    "RESERVATION_EXPIRED",
                    reservation.getId(),
                    "예약이 만료되었습니다: " + reservation.getRoomName(),
                    "/reservation/detail/" + reservation.getId()
            );
        }

        return a + b;
    }


    /// 예약 ID로 가상계좌 ID 조회
    @Override
    public Long findVaIdByReservationId(Long reservationId) {
        return virtualAccountMapper.findVaIdByReservationId(reservationId);
    }

    @Override
    public Long findReservationIdByVaId(Long vaId) {
        return virtualAccountMapper.findReservationIdByVaId(vaId);
    }

    /// 은행 목록 조회
    @Override
    public List<String> getBankList() {
        return Arrays.asList("국민은행", "신한은행", "농협은행");
    }

    /// 예약 ID로 모든 은행의 계좌번호 조회
    @Override
    public Map<String, String> getAllAccountNos(Long reservationId) {
        List<Map<String, Object>> list = virtualAccountMapper.findAllAccountNosByReservationId(reservationId);

        Map<String, String> result = new HashMap<>();
        for (Map<String, Object> row : list) {
            String bankName = (String) row.get("BANK_NAME");  // 대문자로 (Oracle 기본)
            String accountNo = (String) row.get("ACCOUNT_NO");
            result.put(bankName, accountNo);
        }
        return result;
    }

    /// 모든 은행에 가상계좌 발급
    @Override
    public void createAllVAs(Long reservationId, LocalDateTime basisTime) {
        List<String> bankList = getBankList();
        for (String bankName : bankList) {
            String accountNo = generateDummyAccountNo(bankName);
            LocalDateTime expiresAt = basisTime.plusDays(3);
            virtualAccountMapper.insert(reservationId, accountNo, bankName, expiresAt);
        }
    }

//    ---------------------------------------------
    /// 더미 계좌번호 생성기 (은행별 - 동적)
    private String generateDummyAccountNo(String bankName) {
        // 은행명의 해시값을 이용해 prefix 생성 (항상 동일한 은행명은 동일한 prefix)
        int hash = bankName.hashCode();
        // 음수 제거하고 3자리 숫자로 변환
        String prefix = String.format("%03d", Math.abs(hash % 1000));

        int body = ThreadLocalRandom.current().nextInt(10000000, 100000000);
        return prefix + "-" + body;
    }
}

