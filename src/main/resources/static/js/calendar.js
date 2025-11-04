// calendar.js - FullCalendar 초기화 및 날짜 선택 처리
(function() {
    'use strict';

    document.addEventListener('DOMContentLoaded', function() {
        const roomId = window.ROOM_ID;
        const calendarEl = document.getElementById('calendar');

        // 캘린더 영역이 없거나 roomId가 없으면 종료
        if (!calendarEl || !roomId) {
            return;
        }

        // FullCalendar 초기화
        const calendar = new FullCalendar.Calendar(calendarEl, {
            // 초기 뷰: 월별 캘린더
            initialView: 'dayGridMonth',

            // 한국어 설정
            locale: 'ko',

            // 헤더 툴바 (월/주/일 전환 버튼)
            headerToolbar: {
                left: 'prev,next today',
                center: 'title',
                right: 'dayGridMonth,timeGridWeek,timeGridDay'
            },

            // 예약 데이터 로드 (FullCalendar가 자동으로 호출)
            events: function(fetchInfo, successCallback, failureCallback) {
                // 백엔드 API 호출
                fetch('/api/reservations/calendar/availability?roomId=' + roomId +
                    '&start=' + fetchInfo.startStr +
                    '&end=' + fetchInfo.endStr)
                    .then(response => response.json())
                    .then(data => {
                        // FullCalendar에 이벤트 데이터 전달
                        successCallback(data);
                    })
                    .catch(error => {
                        console.error('예약 데이터 로드 실패:', error);
                        failureCallback(error);
                    });
            },

            // 날짜 클릭 이벤트
            dateClick: function(info) {
                // 선택한 날짜로 시간 슬롯 업데이트
                const selectedDate = info.dateStr; // "2025-11-09" 형식
                updateTimeSlotsForDate(selectedDate);
            },

            // 이벤트 클릭 (예약 상세 정보 보기 - 선택사항)
            eventClick: function(info) {
                // 예약된 시간대 클릭 시 (선택사항)
                // info.event.extendedProps로 예약 ID 등 추가 정보 접근 가능
            }
        });

        // 캘린더 렌더링
        calendar.render();

        // 날짜 선택 시 시간 슬롯 업데이트 함수
        function updateTimeSlotsForDate(dateStr) {
            // 모든 시간 슬롯의 datetime 속성을 선택한 날짜로 업데이트
            document.querySelectorAll('.time-slot').forEach(slot => {
                const hour = parseInt(slot.dataset.hour);
                const dateTime = dateStr + 'T' + String(hour).padStart(2, '0') + ':00:00';
                slot.dataset.datetime = dateTime;
            });

            // 선택한 날짜의 예약 상태 다시 조회 (AJAX - 선택사항)
            // 필요시 서버에서 해당 날짜의 예약 불가능한 시간대 다시 조회 가능
            // fetch('/api/reservations/availability?roomId=' + roomId + '&date=' + dateStr)
            //     .then(response => response.json())
            //     .then(data => {
            //         // bookedSlots 업데이트 및 UI 갱신
            //     });
        }
    });
})();