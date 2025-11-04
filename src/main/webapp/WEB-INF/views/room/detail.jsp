<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>룸 상세</title>
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
<h2>룸 상세</h2>

<!-- 이미지 슬라이더 자리 (JS 나중에) -->
<div class="slider-box">
    이미지 슬라이더 자리 (업로더/JS 연동 후 노출)
</div>

<div class="info">
    <ul>
        <li><b>ID:</b> ${room.id}</li>
        <li><b>지점명:</b>
            <c:forEach var="office" items="${officeList}">
                <c:if test="${office.id == room.officeId}">
                    ${office.name}
                </c:if>
            </c:forEach>
        </li>
        <li><b>룸명:</b> ${room.name}</li>
        <li><b>정원:</b> ${room.capacity}</li>
        <li><b>기본요금:</b> ${room.priceBase}</li>
        <li><b>상태:</b>
            <c:choose>
                <c:when test="${room.status == 'ACTIVE'}">활성</c:when>
                <c:when test="${room.status == 'INACTIVE'}">비활성</c:when>
                <c:otherwise>${room.status}</c:otherwise>
            </c:choose>
        </li>
        <li><b>생성일:</b> ${room.createdAt}</li>
    </ul>
</div>

<p>
    <a href="/offices/${room.officeId}/rooms/edit/${room.id}">[수정]</a> |
    <a href="/offices/${room.officeId}/rooms">[목록]</a>
</p>

</body>
</html>
