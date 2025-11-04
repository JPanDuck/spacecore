<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>룸 목록</title>
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
<h2>룸 목록</h2>

<div class="toolbar">
    <a href="/offices/${selectedOfficeId}/rooms/add">[룸 등록]</a>
</div>

<table>
    <thead>
    <tr>
        <th>썸네일</th>
        <th>ID</th>
        <th>지점명</th>
        <th>룸명</th>
        <th>정원</th>
        <th>기본요금</th>
        <th>상태</th>
        <th>관리</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="room" items="${roomList}">
        <tr>
            <td>
                <c:set var="thumb" value="${empty room.thumbnail ? '/static/img/placeholder-room.jpg' : room.thumbnail}" />
                <img class="thumb" src="${thumb}" alt="thumbnail">
            </td>
            <td>${room.id}</td>
            <td>
                <c:forEach var="office" items="${officeList}">
                    <c:if test="${office.id == room.officeId}">
                        ${office.name}
                    </c:if>
                </c:forEach>
            </td>
            <td>${room.name}</td>
            <td>${room.capacity}</td>
            <td><fmt:formatNumber value="${room.priceBase}" type="number"/></td>
            <td>
                <c:choose>
                    <c:when test="${room.status == 'ACTIVE'}">활성</c:when>
                    <c:when test="${room.status == 'INACTIVE'}">비활성</c:when>
                    <c:otherwise>${room.status}</c:otherwise>
                </c:choose>
            </td>
            <td>
                <a href="/reservations/add/${room.id}">예약하기</a>
            </td>
            <td>
                <a href="/offices/${room.officeId}/rooms/detail/${room.id}">상세</a>
                <a href="/offices/${room.officeId}/rooms/edit/${room.id}">수정</a>
                <form action="/offices/${room.officeId}/rooms/delete/${room.id}" method="post">
                    <button type="submit">삭제</button>
                </form>
            </td>
        </tr>
    </c:forEach>

    <c:if test="${empty roomList}">
        <tr><td colspan="8">데이터 없음</td></tr>
    </c:if>
    </tbody>
</table>

</body>
</html>
