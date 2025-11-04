<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원가입 | Space Core</title>
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

        input[type="text"], input[type="password"], input[type="email"] {
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

        .msg {
            font-size: 13px;
            margin-top: 6px;
            display: none;
        }

        .text-red { color: #d93025; }
        .text-green { color: #0b8043; }

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

    <form id="registerForm">
        <div class="form-group">
            <label for="name">이름</label>
            <input type="text" id="name" name="name" placeholder="이름을 입력하세요" required>
        </div>

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
            <p id="passwordLengthMsg" class="msg text-red">비밀번호는 최소 8자 이상이어야 합니다.</p>
        </div>

        <div class="form-group">
            <label for="confirmPassword">비밀번호 확인</label>
            <input type="password" id="confirmPassword" name="confirmPassword" placeholder="비밀번호를 다시 입력하세요" required>
            <p id="passwordMatchMsg" class="msg"></p>
        </div>

        <button type="submit" class="register-btn">회원가입</button>
    </form>

    <div class="footer-link">
        이미 계정이 있으신가요?
        <a href="${pageContext.request.contextPath}/auth/login">로그인</a>
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
    const pw = document.getElementById("password");
    const cpw = document.getElementById("confirmPassword");
    const lengthMsg = document.getElementById("passwordLengthMsg");
    const matchMsg = document.getElementById("passwordMatchMsg");

    // ✅ 비밀번호 길이 체크
    pw.addEventListener("input", () => {
        lengthMsg.style.display = pw.value.length > 0 && pw.value.length < 8 ? "block" : "none";
    });

    // ✅ 비밀번호 일치 여부 실시간 체크
    cpw.addEventListener("input", () => {
        const p = pw.value.trim(), c = cpw.value.trim();

        if (c.length === 0) {
            matchMsg.style.display = "none";
            return;
        }

        matchMsg.style.display = "block";
        if (p.length < 8) {
            matchMsg.textContent = "비밀번호는 8자 이상이어야 합니다.";
            matchMsg.className = "msg text-red";
        } else if (p === c) {
            matchMsg.textContent = "비밀번호가 일치합니다.";
            matchMsg.className = "msg text-green";
        } else {
            matchMsg.textContent = "비밀번호가 일치하지 않습니다.";
            matchMsg.className = "msg text-red";
        }
    });

    // ✅ 회원가입 폼 제출
    document.getElementById("registerForm").addEventListener("submit", async (e) => {
        e.preventDefault();

        const name = document.getElementById("name").value.trim();
        const username = document.getElementById("username").value.trim();
        const email = document.getElementById("email").value.trim();
        const password = pw.value.trim();
        const confirmPassword = cpw.value.trim();

        if (password.length < 8) {
            lengthMsg.style.display = "block";
            pw.focus();
            return;
        }

        if (password !== confirmPassword) {
            matchMsg.textContent = "비밀번호가 일치하지 않습니다.";
            matchMsg.className = "msg text-red";
            matchMsg.style.display = "block";
            cpw.focus();
            return;
        }

        try {
            const res = await fetch("${pageContext.request.contextPath}/api/auth/register", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ name, username, email, password })
            });

            const text = await res.text();

            if (!res.ok) {
                // 💡 서버에서 409(CONFLICT)면 중복으로 판단
                if (res.status === 409) {
                    alert("❌ 아이디 또는 이메일이 이미 존재합니다.");
                } else {
                    alert(text || "회원가입 실패");
                }
                return;
            }

            alert("🎉 회원가입이 완료되었습니다!");
            window.location.href = "${pageContext.request.contextPath}/";

        } catch (err) {
            console.error("회원가입 오류:", err);
            alert("⚠️ 서버 오류가 발생했습니다.");
        }
    });
</script>
</body>
</html>
