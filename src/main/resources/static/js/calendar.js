// calendar.js - FullCalendar 초기화 및 날짜 선택 처리
(function() {
    'use strict';

    // FullCalendar가 로드될 때까지 대기
    function initCalendar() {
        // FullCalendar가 로드되었는지 확인
        if (typeof FullCalendar === 'undefined') {
            console.warn('FullCalendar가 아직 로드되지 않았습니다. 잠시 후 다시 시도합니다.');
            setTimeout(initCalendar, 100);
            return;
        }

        const roomId = window.ROOM_ID;
        const calendarEl = document.getElementById('calendar');

        // 캘린더 영역이 없거나 roomId가 없으면 종료
        if (!calendarEl) {
            console.error('캘린더 요소를 찾을 수 없습니다.');
            return;
        }

        if (!roomId) {
            console.error('roomId를 찾을 수 없습니다.');
            return;
        }

        console.log('캘린더 초기화 시작 - roomId:', roomId, 'element:', calendarEl);

        // 현재 년도 (변경 불가)
        const currentYear = new Date().getFullYear();

        try {
            // FullCalendar 초기화
            const calendar = new FullCalendar.Calendar(calendarEl, {
                // 초기 뷰: 월별 캘린더
                initialView: 'dayGridMonth',

                // 한국어 설정
                locale: 'ko',

                // 헤더 툴바 제거 (커스텀 컨트롤 사용)
                headerToolbar: false,

                // 날짜 선택 가능 (단일 날짜만)
                selectable: true,
                selectMirror: true,
                selectOverlap: false,

                // 단일 날짜만 선택 가능
                selectConstraint: {
                    start: new Date(currentYear, 0, 1).toISOString().split('T')[0],
                    end: new Date(currentYear, 11, 31).toISOString().split('T')[0]
                },

                // 날짜 선택 스타일
                select: function(info) {
                    // 선택된 날짜
                    const selectedDate = info.startStr;
                    
                    // 선택 해제
                    calendar.unselect();
                    
                    // 날짜 업데이트
                    updateTimeSlotsForDate(selectedDate);
                },

                // 날짜 클릭 이벤트 (더 명확한 선택)
                dateClick: function(info) {
                    // 과거 날짜는 선택 불가
                    const clickedDate = new Date(info.dateStr + 'T00:00:00');
                    const today = new Date();
                    today.setHours(0, 0, 0, 0);
                    
                    if (clickedDate < today) {
                        return; // 과거 날짜는 선택 불가
                    }

                    // 선택된 날짜로 시간 슬롯 업데이트
                    updateTimeSlotsForDate(info.dateStr);
                },

                // 예약 데이터 로드
                events: function(fetchInfo, successCallback, failureCallback) {
                    // 백엔드 API 호출
                    const contextPath = window.location.pathname.split('/')[1] || '';
                    const basePath = contextPath ? '/' + contextPath : '';
                    fetch(basePath + '/api/reservations/calendar/availability?roomId=' + roomId +
                        '&start=' + fetchInfo.startStr +
                        '&end=' + fetchInfo.endStr)
                        .then(response => response.json())
                        .then(data => {
                            successCallback(data);
                        })
                        .catch(error => {
                            console.error('예약 데이터 로드 실패:', error);
                            // 에러가 있어도 빈 배열 반환하여 캘린더가 표시되도록 함
                            successCallback([]);
                        });
                },

                // 이벤트 클릭 (예약 상세 정보 보기 - 선택사항)
                eventClick: function(info) {
                    // 예약된 시간대 클릭 시 (선택사항)
                }
            });

            console.log('캘린더 객체 생성 완료:', calendar);
            
            // 캘린더 렌더링
            calendar.render();
            console.log('캘린더 렌더링 완료');
            
            // 날짜 선택 시 시간 슬롯 업데이트 함수
            function updateTimeSlotsForDate(dateStr) {
                // 선택된 날짜 표시 업데이트
                updateSelectedDateDisplay(dateStr);

                // 모든 시간 슬롯의 datetime 속성을 선택한 날짜로 업데이트
                document.querySelectorAll('.time-slot').forEach(slot => {
                    const hour = parseInt(slot.dataset.hour);
                    const dateTime = dateStr + 'T' + String(hour).padStart(2, '0') + ':00:00';
                    slot.dataset.datetime = dateTime;
                });

                // 선택된 날짜 하이라이트 (CSS 클래스 추가)
                document.querySelectorAll('.fc-day').forEach(day => {
                    day.classList.remove('fc-day-selected');
                });
                const selectedDay = calendarEl.querySelector(`[data-date="${dateStr}"]`);
                if (selectedDay) {
                    selectedDay.classList.add('fc-day-selected');
                }
            }

            // 선택된 날짜 표시 업데이트
            function updateSelectedDateDisplay(dateStr) {
                const dateDisplay = document.getElementById('selectedDateText');
                if (!dateDisplay) return;

                const date = new Date(dateStr + 'T00:00:00');
                const year = date.getFullYear();
                const month = date.getMonth() + 1;
                const day = date.getDate();
                const dayNames = ['일', '월', '화', '수', '목', '금', '토'];
                const dayName = dayNames[date.getDay()];

                dateDisplay.textContent = `${year}년 ${month}월 ${day}일 (${dayName})`;
            }

            // 월 표시 업데이트
            function updateMonthDisplay() {
                const monthDisplay = document.getElementById('monthDisplay');
                if (!monthDisplay) return;

                const view = calendar.view;
                const currentDate = view.currentStart;
                const year = currentDate.getFullYear();
                const month = currentDate.getMonth() + 1;

                monthDisplay.textContent = `${year}년 ${month}월`;
            }

            // 이전 달 버튼
            const btnPrevMonth = document.getElementById('btnPrevMonth');
            if (btnPrevMonth) {
                btnPrevMonth.addEventListener('click', function() {
                    const currentDate = calendar.view.currentStart;
                    const newDate = new Date(currentDate.getFullYear(), currentDate.getMonth() - 1, 1);
                    
                    // 현재 년도 범위 체크
                    if (newDate.getFullYear() === currentYear) {
                        calendar.prev();
                        updateMonthDisplay();
                    }
                });
            }

            // 다음 달 버튼
            const btnNextMonth = document.getElementById('btnNextMonth');
            if (btnNextMonth) {
                btnNextMonth.addEventListener('click', function() {
                    const currentDate = calendar.view.currentStart;
                    const newDate = new Date(currentDate.getFullYear(), currentDate.getMonth() + 1, 1);
                    
                    // 현재 년도 범위 체크
                    if (newDate.getFullYear() === currentYear) {
                        calendar.next();
                        updateMonthDisplay();
                    }
                });
            }

            // 오늘 버튼
            const btnToday = document.getElementById('btnToday');
            if (btnToday) {
                btnToday.addEventListener('click', function() {
                    const today = new Date();
                    calendar.today(); // 캘린더를 오늘로 이동
                    updateMonthDisplay();
                    
                    const year = today.getFullYear();
                    const month = today.getMonth() + 1;
                    const day = today.getDate();
                    const dateStr = `${year}-${String(month).padStart(2, '0')}-${String(day).padStart(2, '0')}`;
                    
                    // 오늘 날짜 선택
                    updateTimeSlotsForDate(dateStr);
                });
            }

            // 캘린더 날짜 변경 시 월 표시 업데이트
            calendar.on('datesSet', function(info) {
                updateMonthDisplay();
                
                // 년도 변경 방지 (현재 년도가 아니면 현재 년도로 이동)
                const viewYear = info.start.getFullYear();
                if (viewYear !== currentYear) {
                    const today = new Date();
                    calendar.gotoDate(today);
                    updateMonthDisplay();
                }
            });

            // 초기 월 표시
            updateMonthDisplay();

        } catch (error) {
            console.error('캘린더 초기화 중 오류 발생:', error);
            console.error('오류 스택:', error.stack);
        }
    }

    // DOM이 로드된 후 초기화
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initCalendar);
    } else {
        // DOM이 이미 로드된 경우
        initCalendar();
    }
})();
