<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>사용자 상세정보</title>
</head>
<body>
<h1>사용자 상세정보</h1>

<c:if test="${not empty message}">
    <p style="color: green; font-weight: bold;">${message}</p>
</c:if>

<table border="1" cellpadding="8">
    <tr><th>ID</th><td>${user.id}</td></tr>
    <tr><th>아이디</th><td>${user.username}</td></tr>
    <tr><th>이름</th><td>${user.name}</td></tr>
    <tr><th>이메일</th><td>${user.email}</td></tr>
    <tr><th>전화번호</th><td>${user.phone}</td></tr>
    <tr><th>상태</th><td>${user.status}</td></tr>
</table>

<hr>

<form action="/admin/users/${user.id}/reset-password" method="post">
    <button type="submit">비밀번호 초기화</button>
</form>

<p>
    <a href="/admin/users/${user.id}/edit">수정</a> |
    <a href="/admin/users">목록으로</a>
</p>

</body>
</html>
