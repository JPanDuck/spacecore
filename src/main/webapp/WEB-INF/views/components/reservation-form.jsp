<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<style>
    /* 예약 폼 내부 캘린더 전용 스타일 (작은 사이즈) */
    #reservation-form-wrapper #calendar-reservation {
        width: 100%;
        max-width: 280px;
        margin: 0 auto 30px;
    }

    #reservation-form-wrapper .fc {
        font-size: 9px;
    }

    #reservation-form-wrapper .fc-header-toolbar {
        padding: 3px 1px !important;
        margin-bottom: 4px !important;
        font-size: 9px !important;
    }

    #reservation-form-wrapper .fc-toolbar {
        margin-bottom: 3px !important;
    }

    #reservation-form-wrapper .fc-button {
        padding: 2px 5px !important;
        font-size: 9px !important;
        line-height: 1.1 !important;
        margin: 0 1px !important;
    }

    #reservation-form-wrapper .fc-button-group {
        margin: 0 !important;
    }

    #reservation-form-wrapper .fc-toolbar-title {
        font-size: 14px !important;
        margin: 0 !important;
        font-weight: bold;
    }

    #reservation-form-wrapper .fc-col-header {
        display: table !important;
        width: 100% !important;
        table-layout: fixed !important;
    }

    #reservation-form-wrapper .fc-col-header-cell {
        padding: 2px !important;
        font-size: 9px !important;
        text-align: center !important;
        display: table-cell !important;
        vertical-align: middle !important;
        width: auto !important;
    }

    #reservation-form-wrapper .fc-col-header-cell-cushion {
        padding: 0 !important;
        text-align: center !important;
        display: block !important;
    }

    #reservation-form-wrapper .fc-daygrid-day {
        padding: 0 !important;
        min-height: 22px !important;
        position: relative !important;
    }

    #reservation-form-wrapper .fc-daygrid-day-frame {
        padding: 0 !important;
        min-height: 22px !important;
        width: 100% !important;
        height: 100% !important;
        position: relative !important;
    }

    #reservation-form-wrapper .fc-daygrid-day-number {
        font-size: 15px !important;
        padding: 0 !important;
        line-height: 1 !important;
        margin: 0 !important;
        position: absolute !important;
        top: 50% !important;
        left: 50% !important;
        transform: translate(-50%, -50%) !important;
    }

    #reservation-form-wrapper .fc-daygrid-body {
        margin: 0 !important;
    }

    #reservation-form-wrapper .fc-daygrid-row {
        min-height: 22px !important;
        margin: 0 !important;
    }

    #reservation-form-wrapper .fc-dayGridMonth-view .fc-daygrid-body {
        min-height: 170px !important;
    }

    #reservation-form-wrapper .fc-scroller {
        overflow: visible !important;
        height: auto !important;
        padding: 0 !important;
    }

    #reservation-form-wrapper .fc-view-harness {
        height: auto !important;
        margin: 0 !important;
    }

    #reservation-form-wrapper .fc-day-selected {
        background-color: #e3f2fd !important;
        border: 1px solid #7b6cf6 !important;
    }

    #reservation-form-wrapper .fc-button {
        cursor: pointer !important;
        pointer-events: auto !important;
        z-index: 10 !important;
    }

    #reservation-form-wrapper .fc-button:active {
        opacity: 0.7;
    }

    #reservation-form-wrapper .time-slot {
        background: #fff; /* 기본은 흰색 */
    }

    #reservation-form-wrapper .time-slot.disabled {
        background-color: #f5f5f5 !important;
        color: #999 !important;
        cursor: not-allowed;
    }

    #reservation-form-wrapper .time-slot.selected:not(.disabled) {
        background-color: #7b6cf6 !important;
        color: white !important;
        font-weight: bold;
    }
</style>

<!-- 예약 폼 (오른쪽 사이드바용) -->
<div id="reservation-form-wrapper" style="position: sticky; top: 20px;">
    <div style="background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">
        <h3 style="margin-top: 0; color: #333;">예약하기</h3>

        <form id="reservationForm" action="/reservations/add" method="post">
            <!-- 숨겨진 필드 -->
            <input type="hidden" name="roomId" value="${room.id}">
            <input type="hidden" name="startAt" id="startAt">
            <input type="hidden" name="endAt" id="endAt">
            <input type="hidden" name="unit" value="HOUR">
            <input type="hidden" name="amount" id="amount">

            <!-- 날짜 선택 -->
            <div style="margin-bottom: 20px;">
                <label style="display: block; margin-bottom: 10px; font-weight: bold;">날짜 선택</label>
                <div id="calendar-reservation"></div>
            </div>

            <!-- 총 예약인원 -->
            <div style="margin-bottom: 20px;">
                <label style="display: block; margin-bottom: 10px; font-weight: bold;">
                    정원
                    <span style="font-size: 12px; color: #666;">
                        (Max ${room.capacity}명)
                    </span>
                </label>
            </div>

            <!-- 이용시간 선택 -->
            <div style="margin-bottom: 20px;">
                <label style="display: block; margin-bottom: 10px; font-weight: bold;">이용시간</label>
                <div id="selectedTimeInfo" style="margin-bottom: 10px; color: #4a90e2; font-size: 14px;"></div>
                <div class="time-slots" id="timeSlots" style="display: flex; flex-wrap: wrap; gap: 5px;">
                    <c:forEach var="hour" begin="9" end="21">
                        <div class="time-slot" data-hour="${hour}"
                             style="padding: 8px 12px; border: 1px solid #ddd; border-radius: 4px; cursor: pointer;">
                                ${hour}:00
                        </div>
                    </c:forEach>
                </div>
                <div class="error-message" id="timeError" style="color: red; font-size: 12px; margin-top: 5px;"></div>
            </div>

            <!-- 예약자 정보 -->
            <div style="margin-bottom: 20px;">
                <label style="display: block; margin-bottom: 10px; font-weight: bold;">예약자 정보</label>
                <input type="text" name="reservantName" placeholder="예약자 이름" required
                       style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; margin-bottom: 10px; box-sizing: border-box;">
                <input type="tel" name="phone" placeholder="010-1234-5678" required
                       pattern="[0-9]{10,11}" maxlength="11"
                       oninput="this.value = this.value.replace(/[^0-9]/g, '')"
                       style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box;">
            </div>

            <!-- 요청사항 -->
            <div style="margin-bottom: 20px;">
                <label style="display: block; margin-bottom: 10px; font-weight: bold;">요청사항 (선택)</label>
                <textarea name="memo" placeholder="요청사항을 입력해주세요" rows="3"
                          style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; resize: vertical; box-sizing: border-box;"></textarea>
            </div>

            <!-- 금액 정보 -->
            <div style="border-top: 1px solid #eee; padding-top: 15px; margin-bottom: 20px;">
                <div style="display: flex; justify-content: space-between; margin-bottom: 10px;">
                    <span>기본 요금</span>
                    <span><fmt:formatNumber value="${room.priceBase}" type="number"/>원</span>
                </div>
                <div style="display: flex; justify-content: space-between; margin-bottom: 10px;" id="hoursRow" style="display: none;">
                    <span>이용 시간</span>
                    <span id="hoursText">-</span>
                </div>
                <div style="display: flex; justify-content: space-between; font-size: 18px; font-weight: bold; color: #f15746; border-top: 2px solid #eee; padding-top: 10px;">
                    <span>총 결제 금액</span>
                    <span id="totalPrice">0원</span>
                </div>
            </div>

            <!-- 예약 버튼 -->
            <button type="submit" id="submitBtn" disabled
                    style="width: 100%; padding: 15px; background-color: #7b6cf6; color: white; border: none; border-radius: 6px; font-size: 16px; font-weight: bold; cursor: pointer;">
                바로 예약하기
            </button>
        </form>
    </div>
</div>

<script>
    function increasePeople() {
        const input = document.getElementById('peopleCount');
        const max = parseInt(input.getAttribute('max'));
        if (parseInt(input.value) < max) {
            input.value = parseInt(input.value) + 1;
        }
    }

    function decreasePeople() {
        const input = document.getElementById('peopleCount');
        if (parseInt(input.value) > 1) {
            input.value = parseInt(input.value) - 1;
        }
    }
</script>