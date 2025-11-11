// calendar.js - FullCalendar 초기화 및 날짜 선택 처리
(function () {
    'use strict';

    document.addEventListener('DOMContentLoaded', function () {
        const roomId = window.ROOM_ID;

        // 예약 폼 캘린더 (#calendar-reservation)
        const reservationCalendarEl = document.getElementById('calendar-reservation');
        if (reservationCalendarEl) {
            initReservationCalendar(reservationCalendarEl, roomId);
        }

        // 관리자 캘린더 (#calendar)
        const adminCalendarEl = document.getElementById('calendar');
        if (adminCalendarEl) {
            initAdminCalendar(adminCalendarEl, roomId);
        }
    });

    // 예약 폼 캘린더 초기화
    function initReservationCalendar(calendarEl, roomId) {
        console.log('🔍 예약 폼 캘린더 초기화 시작');

        if (!roomId) {
            console.error('❌ ROOM_ID가 설정되지 않았습니다!');
            return;
        }

        // 날짜 선택 함수
        function selectDate(dateStr) {
            if (!dateStr) {
                const today = new Date();
                dateStr = today.getFullYear() + '-' +
                    String(today.getMonth() + 1).padStart(2, '0') + '-' +
                    String(today.getDate()).padStart(2, '0');
            }

            let dateEl = calendarEl.querySelector('.fc-daygrid-day[data-date="' + dateStr + '"]');

            if (dateEl) {
                // 예약 폼 내부의 날짜만 선택
                calendarEl.querySelectorAll('.fc-daygrid-day').forEach(day => {
                    day.classList.remove('fc-day-selected');
                });
                dateEl.classList.add('fc-day-selected');
                updateTimeSlotsForDate(dateStr, calendarEl);
            } else {
                setTimeout(function() {
                    selectDate(dateStr);
                }, 100);
            }
        }

        function selectToday() {
            const today = new Date();
            const todayStr = today.getFullYear() + '-' +
                String(today.getMonth() + 1).padStart(2, '0') + '-' +
                String(today.getDate()).padStart(2, '0');

            let todayEl = calendarEl.querySelector('.fc-daygrid-day[data-date="' + todayStr + '"]');
            if (!todayEl) {
                todayEl = document.querySelector('.fc-daygrid-day[data-date="' + todayStr + '"]');
            }

            if (todayEl) {
                calendarEl.querySelectorAll('.fc-daygrid-day').forEach(day => {
                    day.classList.remove('fc-day-selected');
                });
                todayEl.classList.add('fc-day-selected');
                updateTimeSlotsForDate(todayStr, calendarEl);
            } else {
                setTimeout(function() {
                    selectToday();
                }, 100);
            }
        }

        // FullCalendar 초기화
        const calendar = new FullCalendar.Calendar(calendarEl, {
            initialView: 'dayGridMonth',
            views: {
                dayGridMonth: {
                    fixedWeekCount: true,
                    weekNumbers: false,
                    dayMaxEvents: false,
                }
            },
            height: 'auto',
            contentHeight: 'auto',
            locale: 'ko',
            customButtons: {
                jumpToday: {
                    text: '오늘',
                    click: function() {
                        calendar.today();
                        setTimeout(selectToday, 100);
                    }
                }
            },
            headerToolbar: {
                left: 'prev,next jumpToday',
                center: 'title',
                right: ''
            },
            buttonText: {
                month: '월'
            },

            dateClick: function (info) {
                const clickedDate = new Date(info.dateStr);
                const today = new Date();
                today.setHours(0, 0, 0, 0);
                clickedDate.setHours(0, 0, 0, 0);

                if (clickedDate < today) {
                    alert('과거 날짜는 예약할 수 없습니다.');
                    return;
                }

                calendarEl.querySelectorAll('.fc-daygrid-day').forEach(day => {
                    day.classList.remove('fc-day-selected');
                });
                info.dayEl.classList.add('fc-day-selected');
                updateTimeSlotsForDate(info.dateStr, calendarEl);
            },
            dayCellContent: function (info) {
                return info.dayNumberText.replace(/일/g, '');
            },
            datesSet: function (arg) {
                if (!window.reservationCalendarInitialized) {
                    window.reservationCalendarInitialized = true;
                    setTimeout(selectToday, 50);
                }

                const today = new Date();
                today.setHours(0, 0, 0, 0);
                const start = new Date(arg.start);
                const end = new Date(arg.end);
                start.setHours(0, 0, 0, 0);
                end.setHours(0, 0, 0, 0);

                if (today >= start && today < end) {
                    setTimeout(selectToday, 100);
                }
            }
        });

        calendar.render();
        console.log('✅ 예약 폼 캘린더 렌더링 완료');

        // 날짜 선택 시 시간 슬롯 업데이트
        function updateTimeSlotsForDate(dateStr, calendarEl) {
            const date = new Date(dateStr);
            const month = date.getMonth() + 1;
            const day = date.getDate();
            const dateInfoEl = document.getElementById('selectedTimeInfo');
            if (dateInfoEl) {
                dateInfoEl.textContent = `${month}월 ${day}일`;
            }

            const selectedDateOnly = new Date(dateStr);
            selectedDateOnly.setHours(0, 0, 0, 0);
            const today = new Date();
            today.setHours(0, 0, 0, 0);
            const isToday = selectedDateOnly.getTime() === today.getTime();
            const now = new Date();
            const twoHoursLater = new Date(now.getTime() + 2 * 60 * 60 * 1000);

            // 예약 폼 내부의 time-slot만 업데이트
            const reservationForm = document.getElementById('reservation-form-wrapper');
            if (reservationForm) {
                reservationForm.querySelectorAll('.time-slot').forEach(slot => {
                    slot.classList.remove('selected', 'reserved', 'disabled'); // ← 먼저 초기화
                    const hour = parseInt(slot.dataset.hour, 10);
                    const dateTime = `${dateStr}T${String(hour).padStart(2, '0')}:00:00`;
                    slot.dataset.datetime = dateTime;

                    if (isToday) {
                        const slotTime = new Date(dateTime);
                        if (slotTime < twoHoursLater) {
                            slot.classList.add('disabled');
                        }
                    }
                });
            }

            fetch('/api/reservations/availability/' + roomId + '?date=' + dateStr)
                .then(response => response.json())
                .then(data => {
                    if (reservationForm) {
                        // 위에서 이미 초기화했으므로 여기서는 반복 초기화 필요 없음

                        data.forEach(item => {
                            reservationForm.querySelectorAll(`[data-hour="${item.hour}"]`).forEach(slot => {
                                slot.classList.add('reserved', 'disabled');
                            });
                        });

                        if (isToday) {
                            reservationForm.querySelectorAll('.time-slot').forEach(slot => {
                                // 예약된 시간은 이미 disabled이므로 제외
                                if (!slot.classList.contains('reserved')) {
                                    const hour = parseInt(slot.dataset.hour);
                                    const dateTime = dateStr + 'T' + String(hour).padStart(2, '0') + ':00:00';
                                    const slotTime = new Date(dateTime);
                                    if (slotTime < twoHoursLater) {
                                        slot.classList.add('disabled');
                                    }
                                }
                            });
                        }
                    }

                    if (window.updateBookedSlots) {
                        window.updateBookedSlots(data);
                    }
                })
                .catch(error => {
                    console.error('예약 상태 조회 실패:', error);
                });
        }
    }
    /*------------------------------------------------------------------------------------------------------------------*/
    // 관리자 캘린더 초기화
    function initAdminCalendar(calendarEl, roomId) {
        console.log('🔍 관리자 캘린더 초기화 시작');

        if (!roomId) {
            console.error('❌ ROOM_ID가 설정되지 않았습니다!');
            return;
        }

        function selectDate(dateStr) {
            if (!dateStr) {
                const today = new Date();
                dateStr = today.getFullYear() + '-' +
                    String(today.getMonth() + 1).padStart(2, '0') + '-' +
                    String(today.getDate()).padStart(2, '0');
            }

            let dateEl = calendarEl.querySelector('.fc-daygrid-day[data-date="' + dateStr + '"]');

            if (dateEl) {
                calendarEl.querySelectorAll('.fc-daygrid-day').forEach(day => {
                    day.classList.remove('fc-day-selected');
                });
                dateEl.classList.add('fc-day-selected');
                updateAdminTimeSlots(dateStr);
            } else {
                setTimeout(function() {
                    selectDate(dateStr);
                }, 100);
            }
        }

        function selectToday() {
            const today = new Date();
            const todayStr = today.getFullYear() + '-' +
                String(today.getMonth() + 1).padStart(2, '0') + '-' +
                String(today.getDate()).padStart(2, '0');

            let todayEl = calendarEl.querySelector('.fc-daygrid-day[data-date="' + todayStr + '"]');
            if (!todayEl) {
                todayEl = document.querySelector('.fc-daygrid-day[data-date="' + todayStr + '"]');
            }

            if (todayEl) {
                calendarEl.querySelectorAll('.fc-daygrid-day').forEach(day => {
                    day.classList.remove('fc-day-selected');
                });
                todayEl.classList.add('fc-day-selected');
                updateAdminTimeSlots(todayStr);
            } else {
                setTimeout(function() {
                    selectToday();
                }, 100);
            }
        }

        const calendar = new FullCalendar.Calendar(calendarEl, {
            initialView: 'dayGridMonth',
            views: {
                dayGridMonth: {
                    fixedWeekCount: true,
                    weekNumbers: false,
                    dayMaxEvents: false,
                }
            },
            height: 'auto',
            contentHeight: 'auto',
            locale: 'ko',
            customButtons: {
                jumpToday: {
                    text: '오늘',
                    click: function() {
                        calendar.today();
                        setTimeout(selectToday, 100);
                    }
                }
            },
            headerToolbar: {
                left: 'prev,next jumpToday',
                center: 'title',
                right: ''
            },
            buttonText: {
                month: '월'
            },

            dateClick: function (info) {
                // 룸 상세일 때는 URL에 date 붙여 바로 갱신
                if (window.location.pathname.includes('/rooms/detail/')) {
                    const url = new URL(window.location.href);
                    url.searchParams.set('date', info.dateStr);
                    window.history.pushState({}, '', url);
                    selectDate(info.dateStr);
                    return;
                }
            },
            dayCellContent: function (info) {
                return info.dayNumberText.replace(/일/g, '');
            },
            datesSet: function (arg) {
                const urlParams = new URLSearchParams(window.location.search);
                const urlDate = urlParams.get('date');

                if (!window.adminCalendarInitialized) {
                    window.adminCalendarInitialized = true;
                    if (urlDate) {
                        setTimeout(function() {
                            selectDate(urlDate);
                        }, 100);
                    } else {
                        setTimeout(selectToday, 100);
                    }
                } else if (window.location.pathname.includes('/rooms/detail/')) {
                    // 이미 초기화된 후에도 URL 파라미터가 있으면 업데이트
                    if (urlDate) {
                        setTimeout(function() {
                            selectDate(urlDate);
                        }, 100);
                    }
                }
            }
        });

        calendar.render();
        console.log('✅ 관리자 캘린더 렌더링 완료');

        function updateAdminTimeSlots(dateStr) {
            console.log('updateAdminTimeSlots 호출됨:', dateStr, 'roomId:', roomId);
            const date = new Date(dateStr);
            const month = date.getMonth() + 1;
            const day = date.getDate();
            const dateInfoEl = document.getElementById('adminSelectedTimeInfo');
            if (dateInfoEl) {
                dateInfoEl.textContent = `${month}월 ${day}일`;
            }

            // 관리자 영역의 time-slot만 업데이트
            const adminSection = document.querySelector('.admin-section');
            if (!adminSection) {
                console.error('관리자 섹션을 찾을 수 없습니다');
                return;
            }

            // 오늘인지 확인
            const selectedDateOnly = new Date(dateStr);
            selectedDateOnly.setHours(0, 0, 0, 0);
            const today = new Date();
            today.setHours(0, 0, 0, 0);
            const isToday = selectedDateOnly.getTime() === today.getTime();
            const now = new Date();
            const twoHoursLater = new Date(now.getTime() + 2 * 60 * 60 * 1000);

            // 모든 시간 슬롯 초기화 및 datetime 설정
            adminSection.querySelectorAll('.admin-time-slot').forEach(slot => {
                const hour = parseInt(slot.dataset.hour, 10);
                const dateTime = `${dateStr}T${String(hour).padStart(2, '0')}:00:00`;
                slot.dataset.datetime = dateTime;

                slot.classList.remove('selected', 'reserved', 'disabled', 'blocked'); // ← blocked까지 초기화

                if (isToday) {
                    const slotTime = new Date(dateTime);
                    if (slotTime < twoHoursLater) {
                        slot.classList.add('disabled');
                    }
                }
            });

            // 예약 상태 조회
            fetch('/api/reservations/availability/' + roomId + '?date=' + dateStr)
                .then(response => response.json())
                .then(data => {
                    const blocked = [];

                    data.forEach(item => {
                        if (item.status === 'RESERVED') {
                            adminSection.querySelectorAll('[data-hour="' + item.hour + '"]').forEach(slot => {
                                slot.classList.add('reserved', 'disabled');
                            });
                        } else if (item.status === 'BLOCKED') {
                            adminSection.querySelectorAll('[data-hour="' + item.hour + '"]').forEach(slot => {
                                slot.classList.add('blocked');
                            });
                            blocked.push(item.hour);
                        }
                    });

                    // 차단 목록 업데이트
                    const container = document.getElementById('blockedSlotsContainer');
                    if (container) {
                        if (blocked.length === 0) {
                            container.innerHTML = '<div>선택일에 차단된 시간이 없습니다.</div>';
                        } else {
                            // 1시간 단위로 개별 표시
                            blocked.sort((a, b) => a - b);
                            const officeId = document.querySelector('form[id="blockForm"]')?.action.match(/\/offices\/(\d+)\//)?.[1];
                            let html = '<table border="1" cellspacing="0" cellpadding="6" style="margin-top:8px; width: 100%;"><tr><th>시작</th><th>종료</th><th>해제</th></tr>';
                            blocked.forEach(hour => {
                                const s = dateStr + 'T' + String(hour).padStart(2, '0') + ':00:00';
                                const e = dateStr + 'T' + String(hour + 1).padStart(2, '0') + ':00:00';
                                html += '<tr><td>' + s + '</td><td>' + e + '</td><td>';
                                html += '<form action="/offices/' + officeId + '/rooms/unblock-all/' + roomId + '" method="post" style="display:inline;">';
                                html += '<input type="hidden" name="startAt" value="' + s + '"><input type="hidden" name="endAt" value="' + e + '"><input type="hidden" name="date" value="' + dateStr + '">';
                                html += '<button type="submit" style="background:#28a745; color: white; border: none; padding: 5px 10px; border-radius: 4px; cursor: pointer;">해제</button></form></td></tr>';
                            });
                            html += '</table>';
                            container.innerHTML = html;
                        }
                    }

                    // 오늘인 경우 2시간 후 재체크 (예약된 시간 제외)
                    if (isToday) {
                        adminSection.querySelectorAll('.admin-time-slot').forEach(slot => {
                            if (!slot.classList.contains('reserved')) {
                                const hour = parseInt(slot.dataset.hour);
                                const dateTime = dateStr + 'T' + String(hour).padStart(2, '0') + ':00:00';
                                const slotTime = new Date(dateTime);
                                if (slotTime < twoHoursLater) {
                                    slot.classList.add('disabled');
                                }
                            }
                        });
                    }
                })
                .catch(error => {
                    console.error('예약 상태 조회 실패:', error);
                });
        }
    }
})();