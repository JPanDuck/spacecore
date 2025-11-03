<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>비밀번호 찾기 | Space Core</title>

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

        .find-card {
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
<div class="find-card">
    <h2>비밀번호 찾기</h2>

    <form id="findForm" onsubmit="findPassword(event)">
        <label for="username">아이디</label>
        <input type="text" id="username" placeholder="아이디를 입력하세요" required>

        <label for="email">이메일</label>
        <input type="email" id="email" placeholder="등록된 이메일을 입력하세요" required>

        <button type="submit">확인</button>
    </form>

    <p id="message"></p>

    <div class="footer-link">
        로그인 화면으로 돌아가기 →
        <a href="${pageContext.request.contextPath}/auth/login">로그인</a>
    </div>
</div>

<script>
    async function findPassword(event) {
        event.preventDefault();

        const username = document.getElementById("username").value.trim();
        const email = document.getElementById("email").value.trim();
        const messageArea = document.getElementById("message");

        messageArea.textContent = "";

        if (!username || !email) {
            messageArea.textContent = "아이디와 이메일을 모두 입력하세요.";
            messageArea.style.color = "red";
            return;
        }

        try {
            const response = await fetch("${pageContext.request.contextPath}/api/auth/find-password", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ username, email })
            });

            const text = await response.text();

            if (response.ok) {
                messageArea.style.color = "green";
                messageArea.textContent = text;

                // ✅ 비밀번호 재설정 페이지로 이동
                setTimeout(() => {
                    const params = new URLSearchParams({ username, email });
                    window.location.href =
                        "${pageContext.request.contextPath}/auth/reset-password?" + params.toString();
                }, 1200);
            } else {
                messageArea.style.color = "red";
                messageArea.textContent = text;
            }

        } catch (err) {
            console.error("비밀번호 찾기 오류:", err);
            messageArea.style.color = "red";
            messageArea.textContent = "서버 오류가 발생했습니다.";
        }
    }
</script>
</body>
</html>
