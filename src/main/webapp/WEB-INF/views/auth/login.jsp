<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>로그인 | Space Core</title>

    <!-- 공통 스타일 -->
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

        .google-btn {
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
        }

        .google-btn:hover {
            background: var(--cream-tan);
        }

        .google-btn img {
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

    <!-- 로그인 폼 -->
    <form action="${pageContext.request.contextPath}/login" method="post">
        <div class="form-group">
            <label for="username">아이디</label>
            <input type="text" id="username" name="username" placeholder="아이디를 입력하세요" required>
        </div>

        <div class="form-group">
            <label for="password">비밀번호</label>
            <input type="password" id="password" name="password" placeholder="비밀번호를 입력하세요" required>
        </div>

        <button type="submit" class="login-btn">로그인</button>
    </form>

    <!-- 소셜 로그인 -->
    <div class="divider">또는</div>
    <button type="button" class="google-btn"
            onclick="location.href='${pageContext.request.contextPath}/oauth2/authorization/google'">
        <img src="${pageContext.request.contextPath}/img/google_logo.png" alt="Google Logo">
        Google 계정으로 로그인
    </button>

    <!-- 회원가입 링크 -->
    <div class="footer-link">
        계정이 없으신가요? <a href="${pageContext.request.contextPath}/register">회원가입</a>
    </div>

    <!-- 메인으로 돌아가기 버튼 -->
    <div style="margin-top: 20px;">
        <a href="${pageContext.request.contextPath}/index"
           class="btn btn-outline"
           style="width: 100%; height: 44px; font-size: 15px; font-weight: 600;">
            ← 메인으로 돌아가기
        </a>
    </div>
</div>
</body>
</html>
