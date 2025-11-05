<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    String context = request.getContextPath();
%>

<!-- ✅ 공통 헤더 -->
<%@ include file="/WEB-INF/views/components/header.jsp" %>
<link rel="stylesheet" href="<%=context%>/css/style.css">
<link href='https://cdn.jsdelivr.net/npm/fullcalendar@5.11.5/main.min.css' rel='stylesheet' />

<!-- ✅ 방 정보 기본 변수 세팅 -->
<c:set var="roomId" value="${room != null && room.id != null ? room.id : 0}" />
<c:set var="minHours" value="${room != null && room.minReservationHours != null ? room.minReservationHours : 1}" />
<c:set var="basePrice" value="${room != null && room.priceBase != null ? room.priceBase : 0}" />

    <style>
    .reservation-container {
        max-width: 1400px;
        margin: 40px auto;
        padding: 20px;
    }

    /* 상단 헤더 */
    .reservation-header {
        background: white;
        padding: 30px;
        border-radius: 12px;
        margin-bottom: 30px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    }
    .reservation-header h1 {
        color: var(--choco);
        margin: 0 0 20px 0;
        font-size: 28px;
    }
    .room-info-header {
        display: flex;
        align-items: center;
        gap: 20px;
        padding: 20px;
        background: var(--gray-50);
        border-radius: 8px;
    }
    .room-info-header .room-name {
        font-size: 20px;
        font-weight: 600;
        color: var(--choco);
    }
    .room-info-header .room-details {
        color: var(--gray-600);
        font-size: 14px;
    }

    /* 메인 레이아웃 */
    .reservation-layout {
        display: grid;
        grid-template-columns: 1fr 400px;
        gap: 30px;
    }

    @media (max-width: 1024px) {
        .reservation-layout {
            grid-template-columns: 1fr;
        }
    }

    /* 왼쪽: 예약 정보 입력 */
    .reservation-form-section {
        background: white;
        padding: 30px;
        border-radius: 12px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    }
    .form-section {
        margin-bottom: 30px;
    }
    .form-section h2 {
        color: var(--choco);
        font-size: 20px;
        margin-bottom: 20px;
        padding-bottom: 10px;
        border-bottom: 2px solid var(--choco);
    }

    /* 선택된 날짜 표시 */
    .selected-date-display {
        background: linear-gradient(135deg, var(--choco) 0%, var(--amber) 100%);
        color: white;
        padding: 20px 24px;
        border-radius: 8px;
        margin-bottom: 20px;
        box-shadow: 0 4px 12px rgba(91, 59, 49, 0.2);
    }
    .date-display-content {
        display: flex;
        align-items: center;
        gap: 12px;
        font-size: 18px;
        font-weight: 600;
    }
    .date-display-content i {
        font-size: 24px;
    }
    #selectedDateText {
        flex: 1;
    }

    /* 캘린더 컨트롤 */
    .calendar-controls {
        display: flex;
        align-items: center;
        gap: 12px;
        margin-bottom: 20px;
        padding: 16px 20px;
        background: var(--gray-50);
        border-radius: 8px;
    }
    .btn-calendar-nav {
        width: 40px;
        height: 40px;
        display: flex;
        align-items: center;
        justify-content: center;
        background: white;
        border: 1px solid var(--gray-300);
        border-radius: 8px;
        cursor: pointer;
        transition: all 0.2s;
        color: var(--gray-700);
        font-size: 18px;
    }
    .btn-calendar-nav:hover {
        background: var(--choco);
        border-color: var(--choco);
        color: white;
        transform: translateY(-1px);
        box-shadow: 0 2px 8px rgba(0,0,0,0.15);
    }
    .calendar-month-display {
        flex: 1;
        text-align: center;
        font-size: 18px;
        font-weight: 600;
        color: var(--choco);
    }
    .btn-today {
        display: flex;
        align-items: center;
        gap: 8px;
        padding: 10px 20px;
        background: var(--choco);
        color: white;
        border: none;
        border-radius: 8px;
        font-size: 14px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.2s;
        white-space: nowrap;
    }
    .btn-today:hover {
        background: var(--amber);
        transform: translateY(-1px);
        box-shadow: 0 2px 8px rgba(0,0,0,0.15);
    }

    /* 캘린더 */
    .calendar-wrapper {
        margin-bottom: 30px;
        padding: 20px;
        background: var(--gray-50);
        border-radius: 8px;
    }
    #calendar {
        background: white;
        border-radius: 8px;
        padding: 20px;
    }
    /* FullCalendar 커스텀 스타일 */
    .fc {
        font-family: inherit;
    }
    .fc-day {
        cursor: pointer;
        transition: all 0.2s;
    }
    .fc-day:hover {
        background: rgba(139, 90, 58, 0.05) !important;
    }
    .fc-day-today {
        background: rgba(139, 90, 58, 0.1) !important;
        font-weight: 600;
    }
    .fc-day-selected {
        background: var(--choco) !important;
        color: white !important;
        font-weight: 600;
    }
    .fc-day-selected:hover {
        background: var(--amber) !important;
    }
    .fc-day-past {
        opacity: 0.5;
        cursor: not-allowed;
    }
    .fc-day-past:hover {
        background: inherit !important;
    }
    .fc-daygrid-day-number {
        padding: 8px;
        font-weight: 500;
    }
    .fc-day-selected .fc-daygrid-day-number {
        color: white;
    }
    .fc-col-header-cell {
        background: var(--gray-50);
        padding: 12px 0;
        font-weight: 600;
        color: var(--choco);
        border-bottom: 2px solid var(--choco);
    }
    .fc-daygrid-day-frame {
        min-height: 80px;
        display: flex;
        align-items: center;
        justify-content: center;
    }
    .fc-event {
        background: #e74c3c;
        border: none;
        padding: 2px 4px;
        border-radius: 4px;
        font-size: 12px;
    }

    /* 시간 선택 */
    .time-selection {
        margin-bottom: 30px;
    }
    .time-info {
        margin-bottom: 16px;
        font-size: 14px;
        color: var(--gray-600);
    }
    .time-info strong {
        color: var(--choco);
        font-size: 16px;
    }
    .time-slots {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(80px, 1fr));
        gap: 12px;
        margin-bottom: 16px;
    }
    .time-slot {
        padding: 12px 16px;
        text-align: center;
        border: 2px solid var(--gray-300);
        border-radius: 8px;
        background: white;
        cursor: pointer;
        transition: all 0.2s;
        font-size: 14px;
        font-weight: 500;
        color: var(--gray-700);
    }
    .time-slot:hover:not(.disabled):not(.selected) {
        border-color: var(--choco);
        background: var(--gray-50);
    }
    .time-slot.selected {
        background: var(--choco);
        color: white;
        border-color: var(--choco);
    }
    .time-slot.disabled {
        background: var(--gray-100);
        color: var(--gray-400);
        cursor: not-allowed;
        border-color: var(--gray-200);
    }
    .time-slot.reserved {
        background: #fee;
        color: #c33;
        border-color: #c33;
    }
    #selectedTimeInfo {
        color: var(--choco);
        font-weight: 600;
        margin-left: 8px;
    }
    .error-message {
        color: #e74c3c;
        font-size: 14px;
        margin-top: 8px;
        min-height: 20px;
    }

    /* 입력 필드 */
    .form-field {
        margin-bottom: 20px;
    }
    .form-field label {
            display: block;
        margin-bottom: 8px;
        font-weight: 600;
        color: var(--gray-800);
        font-size: 14px;
    }
    .form-field input,
    .form-field textarea {
        width: 100%;
        padding: 12px 16px;
        border: 1px solid var(--gray-300);
        border-radius: 8px;
        font-size: 14px;
        transition: all 0.2s;
        box-sizing: border-box;
    }
    .form-field input:focus,
    .form-field textarea:focus {
        outline: none;
        border-color: var(--choco);
        box-shadow: 0 0 0 3px rgba(139, 90, 58, 0.1);
    }
    .form-field textarea {
        min-height: 100px;
        resize: vertical;
        font-family: inherit;
    }

    /* 오른쪽: 결제 정보 */
    .payment-section {
        position: sticky;
        top: 20px;
        background: white;
        padding: 30px;
        border-radius: 12px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        height: fit-content;
    }
    .payment-section h2 {
        color: var(--choco);
        font-size: 20px;
        margin-bottom: 24px;
        padding-bottom: 10px;
        border-bottom: 2px solid var(--choco);
    }

    .price-breakdown {
        margin-bottom: 24px;
    }
    .price-row {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 12px 0;
        border-bottom: 1px solid var(--gray-200);
        font-size: 14px;
        color: var(--gray-700);
    }
    .price-row:last-child {
        border-bottom: none;
    }
    .price-row strong {
        color: var(--gray-800);
    }
    .total-price {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 20px 0;
            margin-top: 20px;
        border-top: 2px solid var(--choco);
        font-size: 20px;
        font-weight: 600;
    }
    .total-price span:last-child {
        color: var(--choco);
        font-size: 24px;
    }

    /* 예약하기 버튼 */
    .submit-btn {
        width: 100%;
        padding: 16px 24px;
        background: var(--choco);
        color: white;
            border: none;
        border-radius: 8px;
        font-size: 16px;
        font-weight: 600;
            cursor: pointer;
        transition: all 0.3s;
        margin-top: 20px;
    }
    .submit-btn:hover:not(:disabled) {
        background: var(--amber);
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(0,0,0,0.2);
    }
    .submit-btn:disabled {
        background: var(--gray-300);
        color: var(--gray-500);
        cursor: not-allowed;
        opacity: 0.6;
        }
    </style>

<main class="reservation-container">
    <!-- 상단 헤더 -->
    <div class="reservation-header">
<h1>예약하기</h1>
        <div class="room-info-header">
            <div>
                <div class="room-name">
                    <c:out value="${room != null ? room.name : '객실 정보 없음'}" default="객실 정보 없음"/>
                </div>
                <div class="room-details">
                    정원: <c:out value="${room != null ? room.capacity : 0}" default="0"/>명 |
                    기본 요금:
                    <fmt:formatNumber value="${basePrice}" type="number"/>원/시간
                </div>
            </div>
        </div>
    </div>

    <div class="reservation-layout">
    <!-- 왼쪽: 예약 정보 입력 -->
        <div class="reservation-form-section">
            <form id="reservationForm" action="<%=context%>/reservations/add" method="post">
            <!-- 숨겨진 필드 -->
                <input type="hidden" name="roomId" value="${roomId}">
                <input type="hidden" name="userId" id="userId" value="1">
            <input type="hidden" name="startAt" id="startAt">
            <input type="hidden" name="endAt" id="endAt">
            <input type="hidden" name="unit" value="HOUR">
            <input type="hidden" name="amount" id="amount">

                <!-- 날짜 선택 -->
                <div class="form-section">
                    <h2>날짜 선택</h2>

                    <div class="selected-date-display" id="selectedDateDisplay">
                        <div class="date-display-content">
                            <i class="ph ph-calendar"></i>
                            <span id="selectedDateText">날짜를 선택해주세요</span>
                        </div>
                    </div>

                    <div class="calendar-controls">
                        <button type="button" class="btn-calendar-nav" id="btnPrevMonth">
                            <i class="ph ph-caret-left"></i>
                        </button>
                        <div class="calendar-month-display" id="monthDisplay">2025년 11월</div>
                        <button type="button" class="btn-calendar-nav" id="btnNextMonth">
                            <i class="ph ph-caret-right"></i>
                        </button>
                        <button type="button" class="btn-today" id="btnToday">
                            <i class="ph ph-calendar-check"></i>
                            오늘
                        </button>
                    </div>

                    <div class="calendar-wrapper">
                        <div id="calendar"></div>
                    </div>
                </div>

                <!-- 시간 선택 -->
                <div class="form-section">
                    <h2>이용시간 선택</h2>
                    <div class="time-selection">
                        <div class="time-info">
                            최소<strong>${minHours}</strong>시간 이상 예약 가능
                            <span id="selectedTimeInfo"></span>
                </div>
                <div class="time-slots" id="timeSlots">
                    <c:forEach var="hour" begin="9" end="21">
                                <div class="time-slot" data-hour="${hour}" data-datetime="">
                                ${hour}:00
                        </div>
                    </c:forEach>
                </div>
                <div class="error-message" id="timeError"></div>
                    </div>
            </div>

            <!-- 예약자 정보 -->
            <div class="form-section">
                    <h2>예약자 정보</h2>
                <div class="form-field">
                        <label for="reservantName">예약자 이름</label>
                        <input type="text" id="reservantName" name="reservantName" required placeholder="예약자 이름을 입력하세요">
                </div>
                <div class="form-field">
                        <label for="phone">휴대폰 번호</label>
                        <input type="tel" id="phone" name="phone" placeholder="010-1234-5678" pattern="[0-9]{10,11}" maxlength="11" oninput="this.value = this.value.replace(/[^0-9]/g, '')" required>
                    </div>
            </div>

                <!-- 요청사항 -->
            <div class="form-section">
                    <h2>요청사항 (선택)</h2>
                <div class="form-field">
                        <textarea id="memo" name="memo" placeholder="요청사항을 입력하세요"></textarea>
                    </div>
            </div>
        </form>
    </div>

        <!-- 오른쪽: 결제 정보 -->
        <div class="payment-section">
            <h2>결제 정보</h2>
            <div class="price-breakdown">
                <div class="price-row">
                    <span>기본 요금</span>
                    <strong><fmt:formatNumber value="${basePrice}" type="number"/>원</strong>
                </div>
                <div class="price-row" id="hoursRow" style="display: none;">
                    <span>이용 시간</span>
                    <strong id="hoursText">-</strong>
                </div>
                </div>
                <div class="total-price">
                    <span>총 결제 금액</span>
                <span id="totalPrice">0원</span>
                </div>
                <button type="button" class="submit-btn" id="submitBtn" disabled>
                    예약하기
                </button>
            </div>
        </div>
</main>

<!-- ✅ 서버 데이터 JS 전역 변수화 -->
<script>
    window.MIN_HOURS = ${minHours};
    window.BASE_PRICE = ${basePrice};
    window.ROOM_ID = ${roomId};
    window.BOOKED_SLOTS = [
        <%
            java.util.List<com.spacecore.domain.room.RoomSlot> bookedSlotsList =
                (java.util.List<com.spacecore.domain.room.RoomSlot>) request.getAttribute("bookedSlots");

            if (bookedSlotsList != null && !bookedSlotsList.isEmpty()) {
                boolean isFirst = true;
                for (com.spacecore.domain.room.RoomSlot slot : bookedSlotsList) {
                    if (slot != null &&
                        (slot.getStatus() != null &&
                         (slot.getStatus().equals("RESERVED") || slot.getStatus().equals("BLOCKED"))) &&
                        slot.getSlotStart() != null && slot.getSlotEnd() != null) {

                        int startHour = slot.getSlotStart().getHour();
                        int endHour = slot.getSlotEnd().getHour();
                        String status = slot.getStatus() != null ? slot.getStatus() : "";
                        for (int hour = startHour; hour < endHour; hour++) {
                            if (!isFirst) {
                                out.print(",");
                            }
                            out.print("{hour: " + hour + ", status: '" + status + "'}");
                            isFirst = false;
                        }
                    }
                }
            }
        %>
    ];
</script>

<!-- ✅ 외부 JS 로드 -->
<script src="<%=context%>/js/time-selection.js"></script>

<!-- ✅ FullCalendar 직접 로드 시도 (fallback) -->
<!-- CSS는 이미 11번째 줄에 있음 -->
<script src="https://cdn.jsdelivr.net/npm/fullcalendar@5.11.5/main.min.js" 
        onerror="console.error('FullCalendar 직접 로드 실패');"
        defer></script>
<script src="https://cdn.jsdelivr.net/npm/fullcalendar@5.11.5/locales/ko.js" 
        onerror="console.warn('FullCalendar locale 직접 로드 실패');"
        defer></script>

<!-- ✅ 캘린더 초기화 -->
<script>
// FullCalendar 스크립트 동적 로드 (여러 CDN fallback)
function loadFullCalendar() {
    return new Promise(function(resolve, reject) {
        // 이미 로드되어 있는지 확인
        if (typeof window.FullCalendar !== 'undefined' || typeof FullCalendar !== 'undefined') {
            console.log('FullCalendar 이미 로드됨');
            resolve();
            return;
        }

        // 여러 CDN URL 시도 (FullCalendar 5.x 사용 - 더 안정적)
        const cdnUrls = [
            'https://cdn.jsdelivr.net/npm/fullcalendar@5.11.5/main.min.js',
            'https://cdnjs.cloudflare.com/ajax/libs/fullcalendar/5.11.5/main.min.js',
            'https://unpkg.com/fullcalendar@5.11.5/main.min.js'
        ];
        
        const localeUrls = [
            'https://cdn.jsdelivr.net/npm/fullcalendar@5.11.5/locales/ko.js',
            'https://cdnjs.cloudflare.com/ajax/libs/fullcalendar/5.11.5/locales/ko.min.js',
            'https://unpkg.com/fullcalendar@5.11.5/locales/ko.js'
        ];

        let currentCdnIndex = 0;
        let currentLocaleIndex = 0;

        // locales/ko.js 로드 함수 (먼저 정의)
        function loadLocaleScript() {
            if (currentLocaleIndex >= localeUrls.length) {
                console.warn('모든 CDN에서 locale 로드 실패, locale 없이 진행');
                resolve(); // 로케일은 선택사항이므로 계속 진행
                return;
            }

            const localeScript = document.createElement('script');
            localeScript.src = localeUrls[currentLocaleIndex];
            localeScript.crossOrigin = 'anonymous';
            
            localeScript.onload = function() {
                console.log('FullCalendar locales/ko.js 로드 완료');
                resolve();
            };
            
            localeScript.onerror = function() {
                console.warn('Locale CDN 로드 실패: ' + localeUrls[currentLocaleIndex]);
                currentLocaleIndex++;
                loadLocaleScript(); // 다음 CDN 시도
            };
            
            document.head.appendChild(localeScript);
        }

        // main.min.js 로드 함수
        function tryLoadMainScript() {
            if (currentCdnIndex >= cdnUrls.length) {
                console.error('모든 CDN에서 FullCalendar 로드 실패');
                reject(new Error('FullCalendar 로드 실패: 모든 CDN 접근 불가'));
                return;
            }

            const mainScript = document.createElement('script');
            mainScript.src = cdnUrls[currentCdnIndex];
            mainScript.crossOrigin = 'anonymous';
            
            mainScript.onload = function() {
                console.log('FullCalendar main.min.js 로드 완료 (CDN: ' + cdnUrls[currentCdnIndex] + ')');
                
                // 스크립트가 완전히 실행될 때까지 약간 대기
                setTimeout(function() {
                    console.log('FullCalendar 객체 확인:', {
                        'window.FullCalendar': typeof window.FullCalendar,
                        'window.fullCalendar': typeof window.fullCalendar,
                        'FullCalendar': typeof FullCalendar
                    });
                    
                    // locales/ko.js 로드
                    loadLocaleScript();
                }, 100);
            };
            
            mainScript.onerror = function() {
                console.warn('CDN 로드 실패: ' + cdnUrls[currentCdnIndex]);
                currentCdnIndex++;
                tryLoadMainScript(); // 다음 CDN 시도
            };
            
            document.head.appendChild(mainScript);
        }

        // main.min.js 로드 시작
        tryLoadMainScript();
    });
}

let waitCount = 0;
const MAX_WAIT_COUNT = 100; // 최대 10초 대기

function waitForFullCalendar() {
    waitCount++;
    
    // FullCalendar 5.x는 window.FullCalendar로 접근
    // FullCalendar 6.x는 window.FullCalendar 또는 FullCalendar로 접근
    const FC = window.FullCalendar || window.fullCalendar || (typeof FullCalendar !== 'undefined' ? FullCalendar : null);
    
    if (!FC || !FC.Calendar) {
        if (waitCount >= MAX_WAIT_COUNT) {
            console.error('FullCalendar 로드 타임아웃!', {
                'window.FullCalendar': typeof window.FullCalendar,
                'window.fullCalendar': typeof window.fullCalendar,
                'FullCalendar': typeof FullCalendar,
                'window keys': Object.keys(window).filter(k => k.toLowerCase().includes('calendar')),
                '전체 window 객체': Object.keys(window).slice(0, 20)
            });
            alert('캘린더 로드에 실패했습니다. 페이지를 새로고침해주세요.');
            return;
        }
        
        if (waitCount % 10 === 0) {
            console.log('FullCalendar 로드 대기 중... (' + waitCount + '/100)', {
                'window.FullCalendar': typeof window.FullCalendar,
                'window.fullCalendar': typeof window.fullCalendar,
                'FullCalendar': typeof FullCalendar
            });
        }
        setTimeout(waitForFullCalendar, 100);
        return;
    }

    console.log('FullCalendar 로드 완료!', FC);
    const roomId = window.ROOM_ID;
    const calendarEl = document.getElementById('calendar');
    if (!calendarEl || !roomId) {
        console.error('캘린더 요소 또는 roomId를 찾을 수 없습니다.', { calendarEl, roomId });
        return;
    }

    const currentYear = new Date().getFullYear();
    const calendar = new FC.Calendar(calendarEl, {
        initialView: 'dayGridMonth',
        locale: 'ko',
        headerToolbar: false,
        selectable: true,
        selectMirror: true,
        dateClick: function(info) {
            const clickedDate = new Date(info.dateStr + 'T00:00:00');
            const today = new Date();
            today.setHours(0, 0, 0, 0);
            if (clickedDate < today) return;
            updateTimeSlotsForDate(info.dateStr);
        },
        events: function(fetchInfo, successCallback, failureCallback) {
            fetch('<%=context%>/api/reservations/calendar/availability?roomId=' + roomId +
                '&start=' + fetchInfo.startStr + '&end=' + fetchInfo.endStr)
                .then(function(res) {
                    return res.json();
                })
                .then(function(data) {
                    successCallback(data);
                })
                .catch(function(error) {
                    console.error('예약 데이터 로드 실패:', error);
                    successCallback([]);
                });
        },
        selectConstraint: {
            start: new Date(currentYear, 0, 1).toISOString().split('T')[0],
            end: new Date(currentYear, 11, 31).toISOString().split('T')[0]
        }
    });

    calendar.render();
    updateMonthDisplay();

    function updateTimeSlotsForDate(dateStr) {
        const dateDisplay = document.getElementById('selectedDateText');
        if (dateDisplay) {
            const date = new Date(dateStr + 'T00:00:00');
            const year = date.getFullYear();
            const month = date.getMonth() + 1;
            const day = date.getDate();
            const dayNames = ['일', '월', '화', '수', '목', '금', '토'];
            const dayName = dayNames[date.getDay()];
            dateDisplay.textContent = year + '년 ' + month + '월 ' + day + '일 (' + dayName + ')';
        }

        document.querySelectorAll('.time-slot').forEach(function(slot) {
            const hour = parseInt(slot.dataset.hour);
            const dateTime = dateStr + 'T' + String(hour).padStart(2, '0') + ':00:00';
            slot.dataset.datetime = dateTime;
        });

        document.querySelectorAll('.fc-day').forEach(function(day) {
            day.classList.remove('fc-day-selected');
        });
        const selectedDay = calendarEl.querySelector('[data-date="' + dateStr + '"]');
        if (selectedDay) {
            selectedDay.classList.add('fc-day-selected');
        }
    }

    function updateMonthDisplay() {
        const monthDisplay = document.getElementById('monthDisplay');
        if (monthDisplay) {
            const view = calendar.view;
            const currentDate = view.currentStart;
            const year = currentDate.getFullYear();
            const month = currentDate.getMonth() + 1;
            monthDisplay.textContent = year + '년 ' + month + '월';
        }
    }

    // 이전 달 버튼
    const btnPrevMonth = document.getElementById('btnPrevMonth');
    if (btnPrevMonth) {
        btnPrevMonth.onclick = function() {
            const currentDate = calendar.view.currentStart;
            const newDate = new Date(currentDate.getFullYear(), currentDate.getMonth() - 1, 1);
            if (newDate.getFullYear() === currentYear) {
                calendar.prev();
                updateMonthDisplay();
            }
        };
    }

    // 다음 달 버튼
    const btnNextMonth = document.getElementById('btnNextMonth');
    if (btnNextMonth) {
        btnNextMonth.onclick = function() {
            const currentDate = calendar.view.currentStart;
            const newDate = new Date(currentDate.getFullYear(), currentDate.getMonth() + 1, 1);
            if (newDate.getFullYear() === currentYear) {
                calendar.next();
                updateMonthDisplay();
            }
        };
    }

    // 오늘 버튼
    const btnToday = document.getElementById('btnToday');
    if (btnToday) {
        btnToday.onclick = function() {
            const today = new Date();
            calendar.today();
            updateMonthDisplay();
            const year = today.getFullYear();
            const month = today.getMonth() + 1;
            const day = today.getDate();
            const dateStr = year + '-' + String(month).padStart(2, '0') + '-' + String(day).padStart(2, '0');
            updateTimeSlotsForDate(dateStr);
        };
    }

    // 캘린더 날짜 변경 시 월 표시 업데이트 및 년도 제한
    calendar.on('datesSet', function(info) {
        updateMonthDisplay();
        const viewYear = info.start.getFullYear();
        if (viewYear !== currentYear) {
            const today = new Date();
            calendar.gotoDate(today);
            updateMonthDisplay();
        }
    });
}

// 페이지 로드 후 FullCalendar 로드 및 초기화
document.addEventListener('DOMContentLoaded', function() {
    console.log('DOM 로드 완료, FullCalendar 로드 시작');
    waitCount = 0; // 카운터 초기화
    loadFullCalendar()
        .then(function() {
            console.log('FullCalendar 스크립트 로드 완료, 초기화 시작');
            // 스크립트 로드 후 즉시 한 번 확인
            setTimeout(function() {
                waitForFullCalendar();
            }, 200);
        })
        .catch(function(error) {
            console.error('FullCalendar 로드 실패:', error);
            alert('캘린더를 불러올 수 없습니다. 페이지를 새로고침해주세요.');
        });
});
</script>

<%@ include file="/WEB-INF/views/components/footer.jsp" %>
