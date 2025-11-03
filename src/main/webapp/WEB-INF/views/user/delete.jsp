<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>회원 탈퇴</title>
    <style>
        body {
            font-family: "Pretendard", sans-serif;
            margin: 40px;
            line-height: 1.6;
            color: #333;
        }
        h2 {
            color: #d9534f;
            margin-bottom: 10px;
        }
        p {
            margin-bottom: 20px;
        }
        button {
            background-color: #d9534f;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 6px;
            cursor: pointer;
            font-weight: bold;
            transition: background-color 0.2s ease;
        }
        button:hover {
            background-color: #c9302c;
        }
        a {
            color: #555;
            text-decoration: none;
        }
        a:hover {
            text-decoration: underline;
        }
        .spinner {
            display: none;
            margin-top: 10px;
            color: #777;
            font-size: 14px;
        }
    </style>
</head>

<body>
<h2>회원 탈퇴</h2>
<p style="color:red;">
    ⚠ 탈퇴 시 모든 계정 정보와 데이터가 <strong>즉시 삭제</strong>되며 복구할 수 없습니다.<br>
    신중히 진행해 주세요.
</p>

<!-- ✅ form 없이 버튼만 사용 -->
<button type="button" onclick="deleteAccount()">회원 탈퇴</button>
<div class="spinner" id="spinner">처리 중입니다...</div>
<br><br>
<a href="/user/mypage">취소하고 돌아가기</a>

<script>
    async function deleteAccount() {
        if (!confirm("⚠ 정말로 탈퇴하시겠습니까?\n이 작업은 되돌릴 수 없습니다.")) return;

        const spinner = document.getElementById("spinner");
        spinner.style.display = "block";

        try {
            const res = await fetch("/api/user/me", {
                method: "DELETE",
                headers: { "Content-Type": "application/json" },
                credentials: "include" // ✅ JWT 쿠키 인증 포함
            });

            const msg = await res.text();
            spinner.style.display = "none";

            if (res.ok) {
                alert(msg || "회원 탈퇴가 완료되었습니다.");

                // ✅ 쿠키 완전 삭제
                clearCookie("access_token");
                clearCookie("refresh_token");
                clearCookie("JSESSIONID");

                // ✅ localStorage 및 sessionStorage 완전 초기화
                localStorage.clear();
                sessionStorage.clear();

                // ✅ 0.15초 지연 후 로그인 페이지로 이동 (삭제 반영 보장)
                setTimeout(() => {
                    window.location.replace("/auth/login");
                }, 150);
            } else {
                alert(msg || "회원 탈퇴 중 오류가 발생했습니다.");
            }
        } catch (err) {
            spinner.style.display = "none";
            console.error("회원 탈퇴 요청 실패:", err);
            alert("서버 통신 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
        }
    }

    // ✅ 안전한 쿠키 삭제 (Java 11 / Spring Boot 2.7.x 호환)
    function clearCookie(name) {
        document.cookie = name + "=; Max-Age=0; path=/; SameSite=Lax;";
    }
</script>
</body>
</html>
