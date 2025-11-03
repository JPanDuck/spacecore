<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>비밀번호 변경 | SpaceCore</title>
    <style>
        body {
            font-family: "Pretendard", sans-serif;
            background-color: #fafafa;
            margin: 50px;
        }
        h2 { color: #333; }
        label {
            display: block;
            margin-top: 10px;
            font-weight: bold;
        }
        input {
            width: 250px;
            padding: 8px;
            margin-top: 5px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        button {
            margin-top: 20px;
            padding: 10px 20px;
            background-color: #7b6cf6;
            color: #fff;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: bold;
        }
        button:hover {
            background-color: #6957f2;
        }
        a {
            display: inline-block;
            margin-top: 20px;
            text-decoration: none;
            color: #7b6cf6;
        }
    </style>

    <script>
        async function changePassword() {
            const currentPassword = document.getElementById("current").value.trim();
            const newPassword = document.getElementById("new").value.trim();

            if (!currentPassword || !newPassword) {
                alert("모든 필드를 입력해주세요.");
                return;
            }

            try {
                const res = await fetch("/api/user/change-password", {
                    method: "PUT",
                    headers: { "Content-Type": "application/json" },
                    body: JSON.stringify({ currentPassword, newPassword })
                });

                const msg = await res.text();
                alert(msg);

                if (res.ok) {
                    // ✅ JWT 쿠키는 서버에서 삭제되므로 localStorage도 정리
                    localStorage.removeItem("access_token");
                    localStorage.removeItem("refresh_token");
                    localStorage.removeItem("username");
                    localStorage.removeItem("role");
                    localStorage.removeItem("isLoggedIn");

                    // ✅ 메인페이지로 이동
                    window.location.href = "/index";
                }
            } catch (error) {
                console.error("비밀번호 변경 중 오류:", error);
                alert("비밀번호 변경 중 오류가 발생했습니다.");
            }
        }
    </script>
</head>

<body>
<h2>비밀번호 변경</h2>

<label for="current">현재 비밀번호</label>
<input type="password" id="current" placeholder="현재 비밀번호 입력">

<label for="new">새 비밀번호</label>
<input type="password" id="new" placeholder="새 비밀번호 입력">

<button onclick="changePassword()">비밀번호 변경</button>

<br><br>
<a href="/user/mypage">마이페이지로 돌아가기</a>
</body>
</html>
