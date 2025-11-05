<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<html>
<head>
    <title>예약 상세</title>
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
</head>
<body>
<h2>예약 상세</h2>
<p>예약번호: ${reservation.id}</p>
<p>방 이름: <c:out value="${reservation.roomName != null ? reservation.roomName : reservation.roomId}"/></p>
<p>예약자: <c:out value="${reservation.userName != null ? reservation.userName : reservation.userId}"/></p>
<p>시작:
    <c:if test="${reservation.startAt != null}">
        ${reservation.startAt.year}년 ${reservation.startAt.monthValue}월 ${reservation.startAt.dayOfMonth}일 ${reservation.startAt.hour}시
    </c:if>
</p>
<p>종료:
    <c:if test="${reservation.endAt != null}">
        ${reservation.endAt.year}년 ${reservation.endAt.monthValue}월 ${reservation.endAt.dayOfMonth}일 ${reservation.endAt.hour}시
    </c:if>
</p>
<p>금액: <fmt:formatNumber value="${reservation.amount}" type="number"/>원</p>
<p>상태:
    <c:choose>
        <c:when test="${reservation.status == 'AWAITING_PAYMENT'}">결제 대기</c:when>
        <c:when test="${reservation.status == 'CONFIRMED'}">확정</c:when>
        <c:when test="${reservation.status == 'CANCELLED'}">취소</c:when>
        <c:when test="${reservation.status == 'EXPIRED'}">만료</c:when>
        <c:otherwise>${reservation.status}</c:otherwise>
    </c:choose>
</p>

<hr/>

<!-- 가상계좌 조회 -->
<a href="/virtual-accounts/detail/${reservation.id}">가상계좌 조회</a>

<!-- 관리자 버튼 (isAdmin == true일 때만) (sec 대신) -->
<sec:authorize access="hasRole('ADMIN')">
    <!-- 입금확정: 확정 상태가 아닐 때만 -->
    <c:if test="${reservation.status != 'CONFIRMED'}">
        <form action="/payments/${vaId}/confirm" method="post" style="display:inline;">
            <input type="hidden" name="vaId" value="${vaId}">
            <input type="hidden" name="amount" value="${reservation.amount}">
            <button type="submit">입금확정</button>
        </form>
    </c:if>

    <!-- 예약취소: 취소되지 않았을 때만 -->
    <c:if test="${reservation.status != 'CANCELLED'}">
        <form action="/reservations/cancel/${reservation.id}" method="post" style="display:inline;">
            <input type="hidden" name="id" value="${reservation.id}">
            <button type="submit">예약취소</button>
        </form>
    </c:if>
</sec:authorize>

<!-- 사용자 버튼 -->
    <!-- 예약취소: 취소되지 않고 확정되지 않았을 때만 -->
<sec:authorize access="hasRole('User')">
    <c:if test="${reservation.status != 'CANCELLED' && reservation.status != 'CONFIRMED'}">
        <form action="/reservations/cancel/${reservation.id}" method="post" style="display:inline;">
            <input type="hidden" name="id" value="${reservation.id}">
            <button type="submit">예약취소</button>
        </form>
    </c:if>
</sec:authorize>
<hr/>
<a href="/reservations/">목록으로</a>
</body>
</html>
