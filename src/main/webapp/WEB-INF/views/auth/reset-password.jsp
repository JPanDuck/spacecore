<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>비밀번호 재설정 | Space Core</title>

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

        .reset-card {
            width: 420px;
            background: var(--white);
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-md);
            padding: 50px;
            text-align: center;
        }

        h2 {
            color: var(--choco);
            font-size: 26px;
            margin-bottom: 20px;
        }

        label {
            display: block;
            text-align: left;
            font-weight: 600;
            color: var(--choco);
            margin-bottom: 6px;
            font-size: 15px;
        }

        input {
            width: 100%;
            padding: 12px 14px;
            border: 1px solid var(--sirocco);
            border-radius: var(--radius-md);
            font-size: 15px;
            margin-bottom: 20px;
            background: var(--cream-base);
            color: var(--text-primary);
        }

        input:focus {
            outline: none;
            border-color: var(--mocha);
            background: var(--white);
        }

        button {
            width: 100%;
            background: var(--mocha);
            color: white;
            border: none;
            border-radius: 9999px;
            padding: 12px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: 0.3s ease;
        }

        button:hover {
            background: var(--amber);
        }

        #message {
            margin-top: 16px;
            font-weight: 600;
            font-size: 14px;
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
<div class="reset-card">
    <h2>비밀번호 재설정</h2>

    <p style="color: var(--gray-600); font-size: 14px; margin-bottom: 30px; line-height: 1.6;">
        새로운 비밀번호를 입력해주세요.<br>
        비밀번호는 8자 이상이어야 합니다.
    </p>

    <form id="resetForm" onsubmit="resetPassword(event)">
        <label for="newPassword">새 비밀번호</label>
        <input type="password" id="newPassword" placeholder="새 비밀번호를 입력하세요 (8자 이상)" required minlength="8">

        <label for="confirmPassword">비밀번호 확인</label>
        <input type="password" id="confirmPassword" placeholder="비밀번호를 다시 입력하세요" required>

        <div id="passwordMatch" style="margin-top: -16px; margin-bottom: 16px; font-size: 12px; color: var(--gray-500);"></div>

        <button type="submit">비밀번호 변경</button>
    </form>

    <p id="message" style="min-height: 20px; margin-top: 16px; font-weight: 600; font-size: 14px;"></p>

    <div class="footer-link">
        로그인 화면으로 돌아가기 →
        <a href="${pageContext.request.contextPath}/auth/login">로그인</a>
    </div>
</div>

<script>
    // 비밀번호 일치 확인
    document.getElementById('confirmPassword').addEventListener('input', function() {
        const newPassword = document.getElementById('newPassword').value;
        const confirmPassword = this.value;
        const matchDiv = document.getElementById('passwordMatch');

        if (confirmPassword.length === 0) {
            matchDiv.textContent = '';
            matchDiv.style.color = '';
            return;
        }

        if (newPassword === confirmPassword) {
            matchDiv.textContent = '✓ 비밀번호가 일치합니다';
            matchDiv.style.color = '#27ae60';
        } else {
            matchDiv.textContent = '✗ 비밀번호가 일치하지 않습니다';
            matchDiv.style.color = '#e74c3c';
        }
    });

    async function resetPassword(event) {
        event.preventDefault();

        const urlParams = new URLSearchParams(window.location.search);
        const username = urlParams.get("username");
        const email = urlParams.get("email");

        const newPassword = document.getElementById("newPassword").value.trim();
        const confirmPassword = document.getElementById("confirmPassword").value.trim();
        const messageArea = document.getElementById("message");

        messageArea.textContent = "";

        if (!newPassword || !confirmPassword) {
            messageArea.style.color = "red";
            messageArea.textContent = "모든 필드를 입력하세요.";
            return;
        }

        if (newPassword.length < 8) {
            messageArea.style.color = "red";
            messageArea.textContent = "비밀번호는 8자 이상이어야 합니다.";
            return;
        }

        if (newPassword !== confirmPassword) {
            messageArea.style.color = "red";
            messageArea.textContent = "비밀번호가 일치하지 않습니다.";
            return;
        }

        try {
            const response = await fetch("${pageContext.request.contextPath}/api/auth/reset-password", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ username, email, newPassword, confirmPassword })
            });

            const text = await response.text();

            if (response.ok) {
                messageArea.style.color = "green";
                messageArea.textContent = text;

                // ✅ 1.5초 후 로그인 페이지로 이동
                setTimeout(() => {
                    window.location.href = "${pageContext.request.contextPath}/auth/login";
                }, 1500);
            } else {
                messageArea.style.color = "red";
                messageArea.textContent = text;
            }

        } catch (err) {
            console.error("비밀번호 재설정 오류:", err);
            messageArea.style.color = "red";
            messageArea.textContent = "서버 오류가 발생했습니다.";
        }
    }
</script>
</body>
</html>
