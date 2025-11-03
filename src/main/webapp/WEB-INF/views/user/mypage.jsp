<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>마이페이지</title>
    <style>
        body {
            font-family: "Pretendard", sans-serif;
            margin: 40px;
            line-height: 1.6;
        }
        table {
            border-collapse: collapse;
            width: 60%;
            margin-bottom: 20px;
        }
        th, td {
            border: 1px solid #ccc;
            padding: 10px;
            text-align: left;
        }
        th {
            background-color: #f8f8f8;
            width: 150px;
        }
        .actions a, .actions button {
            margin-right: 10px;
            text-decoration: none;
            color: #007bff;
            border: none;
            background: none;
            cursor: pointer;
            font-size: 14px;
        }
        .actions a:hover, .actions button:hover {
            text-decoration: underline;
        }
        button.delete-btn {
            color: #d9534f;
            font-weight: bold;
        }
        button.delete-btn:hover {
            color: #c9302c;
        }
    </style>
</head>

<body>
<h2>내 정보</h2>

<table>
    <tr><th>아이디</th><td>${user.username}</td></tr>
    <tr><th>이름</th><td>${user.name}</td></tr>
    <tr><th>이메일</th><td>${user.email}</td></tr>
    <tr><th>전화번호</th><td>${user.phone}</td></tr>
    <tr><th>역할</th><td>${user.role}</td></tr>
</table>

<div class="actions">
    <a href="/user/edit">정보 수정</a> |
    <a href="/user/change-password">비밀번호 변경</a> |
    <button type="button" class="delete-btn" onclick="deleteAccount()">회원 탈퇴</button>
</div>

<script>
    async function deleteAccount() {
        if (!confirm("⚠ 정말 탈퇴하시겠습니까?\n이 작업은 되돌릴 수 없습니다.")) return;

        try {
            const res = await fetch("/api/user/me", {
                method: "DELETE",
                credentials: "include", // ✅ 쿠키 인증 포함
                headers: { "Content-Type": "application/json" }
            });

            const msg = await res.text();
            alert(msg);

            if (res.ok) {
                // ✅ 쿠키 완전 삭제
                clearCookie("access_token");
                clearCookie("refresh_token");
                clearCookie("JSESSIONID");

                // ✅ localStorage 및 sessionStorage 완전 초기화
                localStorage.clear();
                sessionStorage.clear();

                // ✅ 삭제 반영 보장 후 로그인 페이지로 이동
                setTimeout(() => {
                    window.location.replace("/auth/login");
                }, 150);
            }
        } catch (err) {
            console.error("회원 탈퇴 요청 실패:", err);
            alert("회원 탈퇴 중 오류가 발생했습니다.");
        }
    }

    // ✅ 안전한 쿠키 삭제 (SameSite=Lax 옵션 포함)
    function clearCookie(name) {
        document.cookie = name + "=; Max-Age=0; path=/; SameSite=Lax;";
    }
</script>
</body>
</html>
