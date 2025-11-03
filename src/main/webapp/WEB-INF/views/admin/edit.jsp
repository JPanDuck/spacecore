<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>사용자 정보 수정</title>
</head>
<body>
<h1>사용자 정보 수정</h1>

<form action="/admin/users/${user.id}/edit" method="post">
    <table border="1" cellpadding="8">
        <tr><th>ID</th><td>${user.id}</td></tr>
        <tr><th>아이디</th><td>${user.username}</td></tr>
        <tr><th>이름</th><td><input type="text" name="name" value="${user.name}" required></td></tr>
        <tr><th>이메일</th><td><input type="email" name="email" value="${user.email}" required></td></tr>
        <tr><th>전화번호</th><td><input type="text" name="phone" value="${user.phone}"></td></tr>
        <tr>
            <th>상태</th>
            <td>
                <select name="status">
                    <option value="ACTIVE" ${user.status == 'ACTIVE' ? 'selected' : ''}>활성</option>
                    <option value="SUSPENDED" ${user.status == 'SUSPENDED' ? 'selected' : ''}>정지</option>
                </select>
            </td>
        </tr>
    </table>

    <button type="submit">수정 완료</button>
</form>

<p>
    <a href="/admin/users/${user.id}">뒤로가기</a>
</p>

</body>
</html>
