<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>로그인 | Space Core</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <style>
        body {
            background: linear-gradient(180deg, var(--cream-base), var(--cream-tan));
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            font-family: "Noto Sans KR", "Montserrat", sans-serif;
        }

        .login-card {
            width: 420px;
            background: var(--white);
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-md);
            padding: 60px 50px;
            text-align: center;
        }

        .login-card h2 {
            font-size: 28px;
            font-weight: 700;
            color: var(--choco);
            margin-bottom: 20px;
        }

        .login-card p {
            color: var(--gray-600);
            margin-bottom: 40px;
            font-size: 15px;
            line-height: 1.6;
        }

        .form-group {
            text-align: left;
            margin-bottom: 24px;
        }

        label {
            display: block;
            font-weight: 600;
            color: var(--choco);
            margin-bottom: 6px;
            font-size: 15px;
        }

        input[type="text"],
        input[type="password"] {
            width: 100%;
            padding: 12px 14px;
            border: 1px solid var(--sirocco);
            border-radius: var(--radius-md);
            font-size: 15px;
            background: var(--cream-base);
            color: var(--text-primary);
            transition: border-color 0.2s ease, background 0.2s ease;
        }

        input:focus {
            outline: none;
            border-color: var(--mocha);
            background: var(--white);
        }

        .login-btn {
            width: 100%;
            background: var(--mocha);
            color: var(--white);
            border: none;
            border-radius: 9999px;
            padding: 14px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            margin-top: 10px;
            transition: 0.3s ease;
        }

        .login-btn:hover {
            background: var(--amber);
        }

        .divider {
            position: relative;
            margin: 32px 0;
            color: var(--gray-600);
            font-size: 14px;
        }

        .divider::before,
        .divider::after {
            content: "";
            position: absolute;
            top: 50%;
            width: 40%;
            height: 1px;
            background: var(--gray-300);
        }

        .divider::before { left: 0; }
        .divider::after { right: 0; }

        .google-btn,
        .kakao-btn,
        .naver-btn {
            width: 100%;
            border: 1px solid var(--gray-300);
            background: #fff;
            border-radius: 9999px;
            padding: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            cursor: pointer;
            transition: 0.3s ease;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 12px;
        }

        .google-btn:hover {
            background: var(--cream-tan);
        }

        .kakao-btn {
            background: #FEE500;
            border-color: #FEE500;
            color: #000;
        }

        .kakao-btn:hover {
            background: #FDD835;
            border-color: #FDD835;
        }

        .naver-btn {
            background: #03C75A;
            border-color: #03C75A;
            color: #fff;
        }

        .naver-btn:hover {
            background: #02B350;
            border-color: #02B350;
        }

        .google-btn img,
        .kakao-btn img,
        .naver-btn img {
            width: 40px;
            height: 40px;
        }

        .footer-link {
            margin-top: 24px;
            font-size: 14px;
            color: var(--gray-600);
        }

        .footer-link a {
            color: var(--mocha);
            font-weight: 600;
            text-decoration: none;
        }

        .footer-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>

<body>
<div class="login-card">
    <h2>로그인</h2>
    <p>당신의 업무 공간<br><strong>Space Core</strong>에 오신 것을 환영합니다.</p>

    <!-- ✅ 에러 메시지 표시 -->
    <%
        String errorParam = request.getParameter("error");
        if (errorParam != null && !errorParam.trim().isEmpty()) {
            String decodedError = java.net.URLDecoder.decode(errorParam, "UTF-8");
    %>
    <div style="background-color: #fff3cd; border: 1px solid #ffc107; color: #856404; padding: 12px; border-radius: 8px; margin-bottom: 20px; font-size: 14px;">
        ⚠️ <%= decodedError %>
    </div>
    <%
        }
    %>

    <!-- ✅ 로그인 폼 -->
    <form id="loginForm" onsubmit="handleLogin(event)">
        <div class="form-group">
            <label for="username">아이디</label>
            <input type="text" id="username" name="username" placeholder="아이디를 입력하세요" required>
        </div>

        <div class="form-group">
            <label for="password">비밀번호</label>
            <input type="password" id="password" name="password" placeholder="비밀번호를 입력하세요" required>
        </div>

        <div style="text-align: right; margin-bottom: 16px;">
            <a href="${pageContext.request.contextPath}/auth/find-password" 
               style="color: var(--mocha); font-size: 13px; font-weight: 500; text-decoration: none;">
                비밀번호 찾기
            </a>
        </div>

        <button type="submit" class="login-btn">로그인</button>
    </form>

    <div class="divider">또는</div>

    <!-- ✅ 구글 로그인 -->
    <button type="button" class="google-btn"
            onclick="location.href='${pageContext.request.contextPath}/oauth2/authorization/google'">
        <img src="${pageContext.request.contextPath}/img/google_logo.png" alt="Google Logo">
        Google 계정으로 로그인
    </button>

    <!-- ✅ 카카오 로그인 -->
    <button type="button" class="kakao-btn"
            onclick="location.href='${pageContext.request.contextPath}/oauth2/authorization/kakao'">
        <svg width="40" height="40" viewBox="0 0 40 40" fill="none" xmlns="http://www.w3.org/2000/svg">
            <rect width="40" height="40" rx="20" fill="#FEE500"/>
            <path d="M20 12C14.4772 12 10 15.5817 10 20C10 22.9091 11.6364 25.4545 14 27.0909L13 30L16.5 28.5C17.5909 28.8182 18.7727 29 20 29C25.5228 29 30 25.4183 30 20C30 14.5817 25.5228 12 20 12Z" fill="#000"/>
        </svg>
        카카오 계정으로 로그인
    </button>

    <!-- ✅ 네이버 로그인 -->
    <button type="button" class="naver-btn"
            onclick="location.href='${pageContext.request.contextPath}/oauth2/authorization/naver'">
        <img src="${pageContext.request.contextPath}/img/Naver.svg" alt="Naver Logo">
        네이버 계정으로 로그인
    </button>

    <div class="footer-link">
        계정이 없으신가요? <a href="${pageContext.request.contextPath}/auth/register">회원가입</a>
    </div>

    <div style="margin-top: 20px;">
        <a href="${pageContext.request.contextPath}/"
           class="btn btn-outline"
           style="width: 100%; height: 44px; font-size: 15px; font-weight: 600;">
            ← 메인으로 돌아가기
        </a>
    </div>
</div>

<script>
    // ✅ 로그인 처리 함수
    async function handleLogin(event) {
        event.preventDefault();

        const username = document.getElementById("username").value.trim();
        const password = document.getElementById("password").value.trim();

        if (!username || !password) {
            alert("아이디와 비밀번호를 입력하세요.");
            return;
        }

        try {
            const response = await fetch("${pageContext.request.contextPath}/api/auth/login", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ username, password }),
                credentials: "include" // ✅ 쿠키(Access/Refresh Token) 자동 포함
            });

            if (!response.ok) {
                const error = await response.text();
                alert(error || "로그인 실패");
                localStorage.clear(); // 실패 시 캐시 초기화
                return;
            }

            const data = await response.json();

            // ✅ JWT 쿠키 외에도 localStorage에 정보 저장
            localStorage.setItem("accessToken", data.accessToken);
            localStorage.setItem("refreshToken", data.refreshToken);
            localStorage.setItem("username", data.username);
            localStorage.setItem("role", data.role);

            // name이 있으면 name 사용, 없으면 username 사용, 둘 다 없으면 "사용자"
            const userName = (data.name && data.name.trim() !== "") ? data.name : (data.username || "사용자");
            alert(userName + '님, 환영합니다!');
            location.href = "${pageContext.request.contextPath}/";
        } catch (err) {
            console.error("로그인 오류:", err);
            alert("서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
        }
    }

    // ✅ 이미 로그인된 사용자 자동 리다이렉트 (서버 검증 포함)
    document.addEventListener("DOMContentLoaded", async () => {
        const token = localStorage.getItem("accessToken");
        const username = localStorage.getItem("username");

        if (token && username) {
            try {
                const res = await fetch("${pageContext.request.contextPath}/api/auth/validate", {
                    method: "GET",
                    credentials: "include"
                });

                // 서버에서 실제 유효한 JWT인지 확인
                if (res.ok) {
                    window.location.href = "${pageContext.request.contextPath}/auth/index";
                } else {
                    localStorage.clear(); // 만료/삭제된 토큰이면 초기화
                }
            } catch (err) {
                console.warn("토큰 검증 실패:", err);
                localStorage.clear();
            }
        }
    });
</script>
</body>
</html>
