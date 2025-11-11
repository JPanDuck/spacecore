// time-selection.js (간소화 버전)
(function() {
    'use strict';

    const minHours = window.MIN_HOURS || 1;
    const basePrice = window.BASE_PRICE || 0;
    let selectedSlots = [];
    let firstClickHour = null;
    const bookedSlots = window.BOOKED_SLOTS || [];

    // DOM 로드 후 초기화
    document.addEventListener('DOMContentLoaded', function() {
        initTimeSlots();
        attachEventListeners();
    });

    // 시간 슬롯 초기화 (예약 폼 내부만 처리)
    // 관리자 차단 폼과 간섭하지 않도록 #reservation-form-wrapper 내부만 선택
    function initTimeSlots() {
        const reservationFormWrapper = document.getElementById('reservation-form-wrapper');
        if (!reservationFormWrapper) return; // 예약 폼이 없으면 종료
        
        const today = new Date().toISOString().split('T')[0];
        reservationFormWrapper.querySelectorAll('.time-slot').forEach(slot => {
            const hour = parseInt(slot.dataset.hour);
            slot.dataset.datetime = `${today}T${String(hour).padStart(2, '0')}:00:00`;

            // 예약 불가능한 시간 체크 (RESERVED 또는 BLOCKED 상태)
            if (bookedSlots.some(bs => bs.hour === hour && (bs.status === 'RESERVED' || bs.status === 'BLOCKED'))) {
                slot.classList.add('reserved', 'disabled');
            }
        });
    }

    // 이벤트 리스너 연결 (예약 폼 내부만 처리)
    // 관리자 차단 폼과 간섭하지 않도록 #reservation-form-wrapper 내부만 선택
    function attachEventListeners() {
        const reservationFormWrapper = document.getElementById('reservation-form-wrapper');
        if (!reservationFormWrapper) return; // 예약 폼이 없으면 종료
        
        // 예약 폼 내부의 시간 슬롯에만 클릭 이벤트 연결
        reservationFormWrapper.querySelectorAll('.time-slot').forEach(slot => {
            slot.addEventListener('click', function() {
                if (!this.classList.contains('disabled')) {
                    handleTimeSlotClick(this);
                }
            });
        });

        // 예약 폼 제출 버튼 이벤트
        const submitBtn = document.getElementById('submitBtn');
        if (!submitBtn) return;
        
        submitBtn.addEventListener('click', function() {
            const form = document.getElementById('reservationForm');
            if (!form) return; // 폼이 없으면 종료
            
            const reservantName = form.querySelector('input[name="reservantName"]')?.value.trim();
            const phone = form.querySelector('input[name="phone"]')?.value.trim();

            // 필수 입력 검증
            if (!reservantName) {
                alert('예약자 이름을 입력해주세요.');
                form.querySelector('input[name="reservantName"]').focus();
                return;
            }

            if (!phone) {
                alert('휴대폰 번호를 입력해주세요.');
                form.querySelector('input[name="phone"]').focus();
                return;
            }

            // 휴대폰 번호 형식 검증 (10-11자리 숫자)
            if (!/^[0-9]{10,11}$/.test(phone)) {
                alert('휴대폰 번호는 10-11자리 숫자여야 합니다.');
                form.querySelector('input[name="phone"]').focus();
                return;
            }

            // 최소 시간 검증
            if (selectedSlots.length < minHours) {
                alert(`최소 ${minHours}시간 이상 예약해야 합니다.`);
                return;
            }

            // 모든 검증 통과 시 제출
            form.submit();
        });
    }

    // 시간 슬롯 클릭 처리
    function handleTimeSlotClick(clickedSlot) {
        const clickedHour = parseInt(clickedSlot.dataset.hour);

        // 첫 클릭 또는 같은 시간 재클릭
        if (firstClickHour === null || firstClickHour === clickedHour) {
            clearSelection();
            if (firstClickHour !== clickedHour) {
                firstClickHour = clickedHour;
                selectedSlots = [clickedHour];
                clickedSlot.classList.add('selected');
            } else {
                firstClickHour = null;
            }
            updateSelection();
            return;
        }

        // 두 번째 클릭 - 범위 선택 (예약 폼 내부만 처리)
        const startHour = Math.min(firstClickHour, clickedHour);
        const endHour = Math.max(firstClickHour, clickedHour);

        clearSelection();
        selectedSlots = [];
        
        // 예약 폼 내부에서만 시간 슬롯 찾기 (관리자 차단 폼 제외)
        const reservationFormWrapper = document.getElementById('reservation-form-wrapper');
        if (reservationFormWrapper) {
            for (let h = startHour; h <= endHour; h++) {
                selectedSlots.push(h);
                const slot = reservationFormWrapper.querySelector(`[data-hour="${h}"]`);
                if (slot && !slot.classList.contains('disabled')) {
                    slot.classList.add('selected');
                }
            }
        }

        firstClickHour = null;
        updateSelection();
    }

    // 선택 초기화 (예약 폼 내부만 처리)
    // 관리자 차단 폼과 간섭하지 않도록 #reservation-form-wrapper 내부만 선택
    function clearSelection() {
        const reservationFormWrapper = document.getElementById('reservation-form-wrapper');
        if (reservationFormWrapper) {
            reservationFormWrapper.querySelectorAll('.time-slot').forEach(slot => {
                slot.classList.remove('selected');
            });
        }
        selectedSlots = [];
    }

    // 선택 상태 업데이트 및 검증 (예약 폼 내부만 처리)
    function updateSelection() {
        // 선택된 시간대 표시 (예약 폼 내부만)
        // 관리자 차단 폼과 간섭하지 않도록 #reservation-form-wrapper 내부만 선택
        const reservationFormWrapper = document.getElementById('reservation-form-wrapper');
        if (reservationFormWrapper) {
            selectedSlots.forEach(hour => {
                const slot = reservationFormWrapper.querySelector(`[data-hour="${hour}"]`);
                if (slot && !slot.classList.contains('disabled')) {
                    slot.classList.add('selected');
                }
            });
        }

        // 예약 폼의 UI 요소들 가져오기
        const elements = {
            timeInfo: document.getElementById('selectedTimeInfo'),
            hoursRow: document.getElementById('hoursRow'),
            totalPrice: document.getElementById('totalPrice'),
            submitBtn: document.getElementById('submitBtn'),
            timeError: document.getElementById('timeError'),
            startAt: document.getElementById('startAt'),
            endAt: document.getElementById('endAt'),
            amount: document.getElementById('amount'),
            hoursText: document.getElementById('hoursText')
        };

        // 선택 없음
        if (selectedSlots.length === 0) {
            if (elements.timeInfo) elements.timeInfo.textContent = '';
            if (elements.hoursRow) elements.hoursRow.style.display = 'none';
            if (elements.totalPrice) elements.totalPrice.textContent = '0원';
            if (elements.submitBtn) elements.submitBtn.disabled = true;
            if (elements.timeError) elements.timeError.textContent = '';
            return;
        }

        // 최소 시간 검증
        const selectedHours = selectedSlots.length;
        if (selectedHours < minHours) {
            if (elements.timeError) elements.timeError.textContent = `최소 ${minHours}시간 이상 예약해야 합니다. (현재: ${selectedHours}시간)`;
            if (elements.submitBtn) elements.submitBtn.disabled = true;
            return;
        }

        // 선택한 첫 번째 시간 슬롯에서 날짜 가져오기 (예약 폼 내부만)
        if (!reservationFormWrapper) return;
        
        const startHour = Math.min(...selectedSlots);
        const firstSlot = reservationFormWrapper.querySelector(`[data-hour="${startHour}"]`);
        if (!firstSlot || !firstSlot.dataset.datetime) {
            if (elements.timeError) elements.timeError.textContent = '날짜를 선택해주세요.';
            if (elements.submitBtn) elements.submitBtn.disabled = true;
            return;
        }

        // datetime에서 날짜 추출 (예: "2025-11-05T09:00:00" -> "2025-11-05")
        const selectedDate = firstSlot.dataset.datetime.split('T')[0];
        const selectedDateTime = new Date(firstSlot.dataset.datetime);

        // 과거 날짜 검증
        const now = new Date();
        const today = new Date(now.getFullYear(), now.getMonth(), now.getDate());
        const selectedDateOnly = new Date(selectedDateTime.getFullYear(), selectedDateTime.getMonth(), selectedDateTime.getDate());

        if (selectedDateOnly < today) {
            if (elements.timeError) elements.timeError.textContent = '과거 날짜는 예약할 수 없습니다.';
            if (elements.submitBtn) elements.submitBtn.disabled = true;
            return;
        }

        // 오늘 날짜인 경우 2시간 후 검증
        if (selectedDateOnly.getTime() === today.getTime()) {
            const twoHoursLater = new Date(now.getTime() + 2 * 60 * 60 * 1000);
            if (selectedDateTime < twoHoursLater) {
                const minHour = twoHoursLater.getHours();
                if (elements.timeError) elements.timeError.textContent = `오늘은 현재 시간으로부터 2시간 후(${minHour}시)부터 예약 가능합니다.`;
                if (elements.submitBtn) elements.submitBtn.disabled = true;
                return;
            }
        }

        const endHour = Math.max(...selectedSlots) + 1;
        const startTime = `${String(startHour).padStart(2, '0')}:00`;
        const endTime = `${String(endHour).padStart(2, '0')}:00`;
        const totalAmount = basePrice * selectedHours;

        // UI 업데이트
        if (elements.timeError) elements.timeError.textContent = '';
        if (elements.timeInfo) elements.timeInfo.textContent = `${startTime} ~ ${endTime} (${selectedHours}시간)`;
        if (elements.totalPrice) elements.totalPrice.textContent = `${totalAmount.toLocaleString()}원`;
        if (elements.hoursRow) elements.hoursRow.style.display = 'flex';
        if (elements.hoursText) elements.hoursText.textContent = `${selectedHours}시간`;
        if (elements.submitBtn) elements.submitBtn.disabled = false;

        // 폼 데이터 설정 - 선택한 날짜 사용
        if (elements.startAt) elements.startAt.value = `${selectedDate}T${String(startHour).padStart(2, '0')}:00:00`;
        if (elements.endAt) elements.endAt.value = `${selectedDate}T${String(endHour).padStart(2, '0')}:00:00`;
        if (elements.amount) elements.amount.value = totalAmount;
    }
})();
// 날짜 선택 시 bookedSlots 업데이트 함수 (예약 폼 내부만 처리)
// calendar.js에서 날짜 변경 시 호출되어 예약 불가능한 시간대를 업데이트
window.updateBookedSlots = function(newBookedSlots) {
    selectedSlots = [];
    firstClickHour = null;

    const reservationFormWrapper = document.getElementById('reservation-form-wrapper');
    if (!reservationFormWrapper) return;

    // selected와 reserved만 제거, disabled는 유지 (오늘 날짜 2시간 후 체크용)
    reservationFormWrapper.querySelectorAll('.time-slot').forEach(slot => {
        slot.classList.remove('selected', 'reserved');
        // reserved인 경우에만 disabled도 제거 (나중에 다시 추가됨)
        if (slot.classList.contains('reserved')) {
            slot.classList.remove('disabled');
        }
    });

    // 예약/차단 시간 반영
    const booked = window.BOOKED_SLOTS || [];
    booked.length = 0;
    newBookedSlots.forEach(item => booked.push({hour: item.hour, status: item.status}));

    booked.forEach(item => {
        reservationFormWrapper
            .querySelectorAll('[data-hour="' + item.hour + '"]')
            .forEach(slot => slot.classList.add('reserved', 'disabled'));
    });
};