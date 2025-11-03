<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>사용자 목록</title>
    <link rel="stylesheet" href="/css/admin.css">
</head>
<body>
<h1>사용자 관리</h1>

<c:if test="${not empty message}">
    <p style="color: green; font-weight: bold;">${message}</p>
</c:if>

<table border="1" cellpadding="8" cellspacing="0">
    <thead>
    <tr>
        <th>ID</th>
        <th>아이디</th>
        <th>이름</th>
        <th>이메일</th>
        <th>전화번호</th>
        <th>상태</th>
        <th>관리</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="user" items="${users}">
        <tr>
            <td>${user.id}</td>
            <td>${user.username}</td>
            <td>${user.name}</td>
            <td>${user.email}</td>
            <td>${user.phone}</td>
            <td>${user.status}</td>
            <td>
                <a href="/admin/users/${user.id}">상세</a> |
                <a href="/admin/users/${user.id}/edit">수정</a> |
                <form action="/admin/users/${user.id}/delete" method="post" style="display:inline;">
                    <button type="submit" onclick="return confirm('정말 삭제하시겠습니까?')">삭제</button>
                </form>
            </td>
        </tr>
    </c:forEach>
    </tbody>
</table>

</body>
</html>
