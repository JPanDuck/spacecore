<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원가입 | Space Core</title>

    <!-- ✅ 공통 스타일 -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <style>
        /* =========================
           REGISTER PAGE STYLE
        ========================== */
        body {
            background: linear-gradient(180deg, var(--cream-base), var(--cream-tan));
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            font-family: "Noto Sans KR", "Montserrat", sans-serif;
        }

        .register-card {
            width: 460px;
            background: var(--white);
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-md);
            padding: 60px 50px;
            text-align: center;
        }

        .register-card h2 {
            font-size: 28px;
            font-weight: 700;
            color: var(--choco);
            margin-bottom: 20px;
        }

        .register-card p {
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
        input[type="password"],
        input[type="email"] {
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

        .register-btn {
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

        .register-btn:hover {
            background: var(--amber);
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
<div class="register-card">
    <h2>회원가입</h2>
    <p><strong>Space Core</strong>에 오신 것을 환영합니다.<br>아래 정보를 입력해 계정을 만들어주세요.</p>

    <form action="${pageContext.request.contextPath}/register" method="post">
        <div class="form-group">
            <label for="username">아이디</label>
            <input type="text" id="username" name="username" placeholder="아이디를 입력하세요" required>
        </div>

        <div class="form-group">
            <label for="email">이메일</label>
            <input type="email" id="email" name="email" placeholder="example@spacecore.com" required>
        </div>

        <div class="form-group">
            <label for="password">비밀번호</label>
            <input type="password" id="password" name="password" placeholder="비밀번호를 입력하세요" required>
        </div>

        <div class="form-group">
            <label for="confirmPassword">비밀번호 확인</label>
            <input type="password" id="confirmPassword" name="confirmPassword" placeholder="비밀번호를 다시 입력하세요" required>
        </div>

        <button type="submit" class="register-btn">회원가입</button>
    </form>

    <div class="footer-link">
        이미 계정이 있으신가요? <a href="${pageContext.request.contextPath}/login">로그인</a>
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

<!-- ✅ 비밀번호 일치 검증 -->
<script>
    const form = document.querySelector("form");
    const pw = document.getElementById("password");
    const pwCheck = document.getElementById("confirmPassword");

    form.addEventListener("submit", (e) => {
        if (pw.value !== pwCheck.value) {
            e.preventDefault();
            alert("비밀번호가 일치하지 않습니다. 다시 확인해주세요.");
            pwCheck.focus();
        }
    });
</script>
</body>
</html>
