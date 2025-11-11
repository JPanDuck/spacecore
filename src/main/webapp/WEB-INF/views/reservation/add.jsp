<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>예약하기</title>
    <style>
        body {
            font-family: "Pretendard", sans-serif;
            background-color: #fafafa;
            margin: 50px;
        }

        h2 {
            color: #333;
        }

        label {
            display: block;
            margin-top: 10px;
            font-weight: bold;
        }

        input {
            width: 250px;
            padding: 8px;
            margin-top: 5px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }

        button {
            margin-top: 20px;
            padding: 10px 20px;
            background-color: #7b6cf6;
            color: #fff;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: bold;
        }

        button:hover {
            background-color: #6957f2;
        }

        a {
            display: inline-block;
            margin-top: 20px;
            text-decoration: none;
            color: #7b6cf6;
        }

        #calendar {
            width: 100%;
            max-width: 280px;
            margin: 0 auto 30px;
        }

        .fc {
            font-size: 9px; /* 기본 폰트 크기 */
        }

        /* 헤더 최소화 */
        .fc-header-toolbar {
            padding: 3px 1px !important;
            margin-bottom: 4px !important;
            font-size: 9px !important;
        }

        .fc-toolbar {
            margin-bottom: 3px !important;
        }

        .fc-button {
            padding: 2px 5px !important;
            font-size: 9px !important;
            line-height: 1.1 !important;
            margin: 0 1px !important;
        }

        .fc-button-group {
            margin: 0 !important;
        }

        .fc-toolbar-title {
            font-size: 14px !important; /* 11px → 14px로 키우기 */
            margin: 0 !important;
            font-weight: bold; /* 굵게 */
        }

        /* 요일 헤더 - 가로 정렬 */
        .fc-col-header {
            display: table !important;
            width: 100% !important;
            table-layout: fixed !important;
        }

        .fc-col-header-cell {
            padding: 2px !important;
            font-size: 9px !important;
            text-align: center !important;
            display: table-cell !important;
            vertical-align: middle !important;
            width: auto !important;
        }

        .fc-col-header-cell-cushion {
            padding: 0 !important;
            text-align: center !important;
            display: block !important;
        }

        .fc-daygrid-day {
            padding: 0 !important;
            min-height: 22px !important;
            position: relative !important; /* absolute 위치 기준 */
        }

        .fc-daygrid-day-frame {
            padding: 0 !important;
            min-height: 22px !important;
            width: 100% !important;
            height: 100% !important;
            position: relative !important; /* absolute 위치 기준 */
        }

        .fc-daygrid-day-number {
            font-size: 15px !important;
            padding: 0 !important;
            line-height: 1 !important;
            margin: 0 !important;
            position: absolute !important;
            top: 50% !important;
            left: 50% !important;
            transform: translate(-50%, -50%) !important;
        }

        /* 행 간격 최소화 */
        .fc-daygrid-body {
            margin: 0 !important;
        }

        .fc-daygrid-row {
            min-height: 22px !important;
            margin: 0 !important;
        }

        /* 월 전체 높이 작게 */
        .fc-dayGridMonth-view .fc-daygrid-body {
            min-height: 170px !important;
        }

        .fc-scroller {
            overflow: visible !important;
            height: auto !important;
            padding: 0 !important;
        }

        .fc-view-harness {
            height: auto !important;
            margin: 0 !important;
        }

        /* 선택된 날짜 하이라이트 */
        .fc-day-selected {
            background-color: #e3f2fd !important;
            border: 1px solid #7b6cf6 !important;
        }

        /* 캘린더 버튼 클릭 가능하게 */
        .fc-button {
            cursor: pointer !important;
            pointer-events: auto !important;
            z-index: 10 !important;
        }

        .fc-button:active {
            opacity: 0.7;
        }

        /* 시간 슬롯 선택 시 색상 */
        .time-slot {
            cursor: pointer;
            transition: all 0.2s;
        }

        .time-slot.selected {
            background-color: #7b6cf6 !important;
            color: white !important;
            font-weight: bold;
        }

        .time-slot.disabled {
            background-color: #f5f5f5 !important;
            color: #999 !important;
            cursor: not-allowed;
            /* 날짜 셀 클릭 가능하게 */

            .fc-daygrid-day {
                cursor: pointer !important;
                pointer-events: auto !important;
            }

            .fc-daygrid-day-number {
                pointer-events: none !important; /* 숫자 클릭 방지, 셀 클릭만 가능 */
            }
        }
    </style>
    <%-- FullCalendar CSS--%>
    <link href='https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.css' rel='stylesheet'/>
</head>
<body>
<h1>예약하기</h1>

<div class="container">
    <!-- 왼쪽: 예약 정보 입력 -->
    <div class="left-section">
        <form id="reservationForm" action="/reservations/add" method="post">
            <!-- 숨겨진 필드 -->
            <input type="hidden" name="roomId" value="<c:out value='${room.id}' default=''/>">
            <input type="hidden" name="userId" id="userId" value="1"> <!-- 임시: 나중에 세션에서 가져오기 -->
            <input type="hidden" name="startAt" id="startAt">
            <input type="hidden" name="endAt" id="endAt">
            <input type="hidden" name="unit" value="HOUR">
            <input type="hidden" name="amount" id="amount">

            <div id="calendar"></div>

            <!-- 이용시간 선택 -->
            <div class="time-selection">
                <h3>이용시간</h3>
                <div class="time-info">
                    최소 <strong>
                    <c:choose>
                        <c:when test="${room != null && room.minReservationHours != null}">
                            ${room.minReservationHours}
                        </c:when>
                        <c:otherwise>1</c:otherwise>
                    </c:choose>시간</strong> 이상 예약
                    <span id="selectedTimeInfo" style="margin-left: 10px; color: #4a90e2;"></span>
                </div>
                <div class="time-slots" id="timeSlots">
                    <!-- 09:00부터 21:00까지 (22:00은 종료시간이므로 선택 불가) -->
                    <c:forEach var="hour" begin="9" end="21">
                        <div class="time-slot"
                             data-hour="${hour}"
                             data-datetime="">
                                ${hour}:00
                        </div>
                    </c:forEach>
                </div>
                <div class="error-message" id="timeError"></div>
            </div>

            <!-- 예약자 정보 -->
            <div class="form-section">
                <h3>예약자 정보</h3>
                <div class="form-field">
                    <label>예약자 이름</label>
                    <input type="text" name="reservantName" required>
                </div>
                <div class="form-field">
                    <label>휴대폰 번호</label>
                    <input type="tel" name="phone" placeholder="010-1234-5678"
                           pattern="[0-9]{10,11}"
                           maxlength="11"
                           oninput="this.value = this.value.replace(/[^0-9]/g, '')"
                           required>
                </div>
            </div>

            <!-- 메모 -->
            <div class="form-section">
                <h3>요청사항 (선택)</h3>
                <div class="form-field">
                    <input type="text" name="memo" placeholder="요청사항을 입력해주세요">
                </div>
            </div>
        </form>
    </div>

    <!-- 오른쪽: 룸 정보 및 결제 -->
    <div class="right-section">
        <div class="room-card">
            <div class="room-name"><c:out value="${room != null ? room.name : '룸 정보 없음'}"/></div>
            <div style="color: #666; font-size: 14px;">정원: <c:out value="${room != null ? room.capacity : 0}"/>명</div>

            <div class="price-info">
                <div class="price-row">
                    <span>
                        <fmt:formatNumber
                                value="${room != null && room.priceBase != null ? room.priceBase : 0}"
                                type="number"
                        />원
                    </span>
                </div>
                <div class="price-row" id="hoursRow" style="display: none;">
                    <span>이용 시간</span>
                    <span id="hoursText">-</span>
                </div>
                <div class="total-price">
                    <span>총 결제 금액</span>
                    <span id="totalPrice" style="color: #f15746;">0원</span>
                </div>

                <button type="button" class="submit-btn" id="submitBtn" disabled>
                    예약하기
                </button>
            </div>
        </div>
    </div>
</div>
<!-- 서버 데이터를 전역 변수로 설정 -->
<script>
    window.MIN_HOURS = <c:choose>
        <c:when test="${not empty room && not empty room.minReservationHours}">
        <c:out value="${room.minReservationHours}"/>
        </c:when>
        <c:otherwise>1</c:otherwise>
    </c:choose>;

    window.BASE_PRICE = <c:choose>
        <c:when test="${not empty room && not empty room.priceBase}">
        <c:out value="${room.priceBase}"/>
        </c:when>
        <c:otherwise>0</c:otherwise>
    </c:choose>;

    window.ROOM_ID = <c:choose>
        <c:when test="${not empty room && not empty room.id}">
        <c:out value="${room.id}"/>
        </c:when>
        <c:otherwise>null</c:otherwise>
    </c:choose>;

    window.BOOKED_SLOTS = [
        <c:forEach var="slot" items="${bookedSlots}" varStatus="status">
        <c:if test="${slot.status == 'RESERVED' || slot.status == 'BLOCKED'}">
        <c:forEach var="hour" begin="${slot.slotStart.hour}" end="${slot.slotEnd.hour - 1}">
        {hour: ${hour}, status: '${slot.status}'}<c:if test="${!status.last}">, </c:if>
        </c:forEach>
        </c:if>
        </c:forEach>
    ];
</script>

<!-- FullCalendar -->
<script src='https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.js'></script>
<script src='https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/locales/ko.js'></script>


<script src="/js/time-selection.js" defer></script>
<script src="/js/calendar.js" defer></script>
</html>