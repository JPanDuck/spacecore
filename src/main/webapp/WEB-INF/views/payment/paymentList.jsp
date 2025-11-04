<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<html>
<head>
    <title>결제 목록</title>
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
<h2>결제 목록</h2>
<table border="1">
    <tr>
        <th>ID</th><th>VA ID</th><th>금액</th><th>상태</th><th>날짜</th><th>상세</th>
    </tr>
    <c:forEach var="p" items="${paymentList}">
        <tr>
            <td>${p.id}</td>
            <td>${p.vaId}</td>
            <td>${p.amount}</td>
            <td>
                <c:choose>
                    <c:when test="${p.status == 'CONFIRMED'}">확정</c:when>
                    <c:when test="${p.status == 'CANCELLED'}">취소</c:when>
                    <c:when test="${p.status == 'PENDING'}">대기</c:when>
                    <c:otherwise>${p.status}</c:otherwise>
                </c:choose>
            </td>
            <td>${p.createdAt}</td>
            <td><a href="/payments/detail/${p.id}">보기</a></td>
        </tr>
    </c:forEach>
</table>
<a href="/reservations/">예약 목록으로</a>
</body>
</html>
