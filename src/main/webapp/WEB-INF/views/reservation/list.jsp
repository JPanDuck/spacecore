<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head>
    <title>예약 목록</title>
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
<h2>예약 목록</h2>
<table border="1">
    <tr>
        <th>ID</th>
        <th>사용자</th>
        <th>룸</th>
        <th>시작시간</th>
        <th>종료시간</th>
        <th>상태</th>
        <th>액션</th>
    </tr>
    <c:forEach var="r" items="${reservationList}">
        <tr>
            <td>${r.id}</td>
            <td><c:out value="${r.userName != null ? r.userName : '없음'}"/></td>
            <td><c:out value="${r.roomName != null ? r.roomName : '없음'}"/></td>
            <td>
                <c:if test="${r.startAt != null}">
                    ${r.startAt.year}년 ${r.startAt.monthValue}월 ${r.startAt.dayOfMonth}일 ${r.startAt.hour}시
                </c:if>
            </td>
            <td>
                <c:if test="${r.endAt != null}">
                    ${r.endAt.year}년 ${r.endAt.monthValue}월 ${r.endAt.dayOfMonth}일 ${r.endAt.hour}시
                </c:if>
            </td>
            <td>
                <c:choose>
                    <c:when test="${r.status == 'AWAITING_PAYMENT'}">결제 대기</c:when>
                    <c:when test="${r.status == 'CONFIRMED'}">확정</c:when>
                    <c:when test="${r.status == 'CANCELLED'}">취소</c:when>
                    <c:when test="${r.status == 'EXPIRED'}">만료</c:when>
                    <c:otherwise>${r.status}</c:otherwise>
                </c:choose>
            </td>
            <td>
                <a href="/reservations/detail/${r.id}">상세</a>
            </td>
        </tr>
    </c:forEach>
</table>
<div style="margin: 10px 0;">
    <input type="number" id="roomId-input" placeholder="룸 ID" style="width: 100px; margin-right: 10px;">
    <button onclick="location.href='/reservations/add/' + document.getElementById('roomId-input').value">
        예약하기
    </button>
</div>
</body>
</html>
