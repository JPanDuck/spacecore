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
        h2 { color: #333; }
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
    </style>
    <%-- FullCalendar CSS--%>
    <link href='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.10/main.min.css' rel='stylesheet' />
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

            <div id="calendar" style="margin-bottom: 30px;"></div>

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

    window.ROOM_ID = <c:out value="${room.id}"/>;

    window.BOOKED_SLOTS = [
        <c:forEach var="slot" items="${bookedSlots}" varStatus="status">
        <c:if test="${slot.status == 'RESERVED' || slot.status == 'BLOCKED'}">
        <c:forEach var="hour" begin="${slot.slotStart.hour}" end="${slot.slotEnd.hour - 1}">
        {hour: ${hour}, status: '${slot.status}'}<c:if test="${!status.last}">,</c:if>
        </c:forEach>
        </c:if>
        </c:forEach>
    ];
</script>

<!-- FullCalendar -->
<script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.10/main.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.10/locales/ko.js"></script>

<!-- 외부 JavaScript 파일 -->
<script src="/js/time-selection.js"></script>
<script src="/js/calendar.js"></script>
</body>
</html>