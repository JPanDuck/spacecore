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

    // 시간 슬롯 초기화
    function initTimeSlots() {
        const today = new Date().toISOString().split('T')[0];
        document.querySelectorAll('.time-slot').forEach(slot => {
            const hour = parseInt(slot.dataset.hour);
            slot.dataset.datetime = `${today}T${String(hour).padStart(2, '0')}:00:00`;

            // 예약 불가능한 시간 체크
            if (bookedSlots.some(bs => bs.hour === hour && (bs.status === 'RESERVED' || bs.status === 'BLOCKED'))) {
                slot.classList.add('reserved', 'disabled');
            }
        });
    }

    // 이벤트 리스너 연결
    function attachEventListeners() {
        document.querySelectorAll('.time-slot').forEach(slot => {
            slot.addEventListener('click', function() {
                if (!this.classList.contains('disabled')) {
                    handleTimeSlotClick(this);
                }
            });
        });

        document.getElementById('submitBtn').addEventListener('click', function() {
            if (selectedSlots.length >= minHours) {
                document.getElementById('reservationForm').submit();
            }
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

        // 두 번째 클릭 - 범위 선택
        const startHour = Math.min(firstClickHour, clickedHour);
        const endHour = Math.max(firstClickHour, clickedHour);

        clearSelection();
        selectedSlots = [];
        for (let h = startHour; h <= endHour; h++) {
            selectedSlots.push(h);
            const slot = document.querySelector(`[data-hour="${h}"]`);
            if (slot && !slot.classList.contains('disabled')) {
                slot.classList.add('selected');
            }
        }

        firstClickHour = null;
        updateSelection();
    }

    // 선택 초기화
    function clearSelection() {
        document.querySelectorAll('.time-slot').forEach(slot => {
            slot.classList.remove('selected');
        });
        selectedSlots = [];
    }

    // 선택 상태 업데이트 및 검증
    function updateSelection() {
        // 선택된 시간대 표시
        selectedSlots.forEach(hour => {
            const slot = document.querySelector(`[data-hour="${hour}"]`);
            if (slot && !slot.classList.contains('disabled')) {
                slot.classList.add('selected');
            }
        });

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
            elements.timeInfo.textContent = '';
            elements.hoursRow.style.display = 'none';
            elements.totalPrice.textContent = '0원';
            elements.submitBtn.disabled = true;
            elements.timeError.textContent = '';
            return;
        }

        // 최소 시간 검증
        const selectedHours = selectedSlots.length;
        if (selectedHours < minHours) {
            elements.timeError.textContent = `최소 ${minHours}시간 이상 예약해야 합니다. (현재: ${selectedHours}시간)`;
            elements.submitBtn.disabled = true;
            return;
        }

        // 검증 통과
        const today = new Date().toISOString().split('T')[0];
        const startHour = Math.min(...selectedSlots);
        const endHour = Math.max(...selectedSlots) + 1;
        const startTime = `${String(startHour).padStart(2, '0')}:00`;
        const endTime = `${String(endHour).padStart(2, '0')}:00`;
        const totalAmount = basePrice * selectedHours;

        // UI 업데이트
        elements.timeError.textContent = '';
        elements.timeInfo.textContent = `${startTime} ~ ${endTime} (${selectedHours}시간)`;
        elements.totalPrice.textContent = `${totalAmount.toLocaleString()}원`;
        elements.hoursRow.style.display = 'flex';
        elements.hoursText.textContent = `${selectedHours}시간`;
        elements.submitBtn.disabled = false;

        // 폼 데이터 설정
        elements.startAt.value = `${today}T${String(startHour).padStart(2, '0')}:00:00`;
        elements.endAt.value = `${today}T${String(endHour).padStart(2, '0')}:00:00`;
        elements.amount.value = totalAmount;
    }
})();