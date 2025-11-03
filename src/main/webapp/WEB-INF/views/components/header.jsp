<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<header class="app-header">
    <div class="container-1980 header-top">
        <div class="header-top-row">

            <!-- ✅ 중앙 로고 -->
            <div class="header-logo">
                <a href="${pageContext.request.contextPath}/auth/index">
                    <img src="${pageContext.request.contextPath}/img/Cleansmall.png" alt="로고">
                </a>
            </div>

            <!-- ✅ 우측 프로필 or 로그인 영역 -->
            <div class="header-user-area" id="headerUserArea">
                <a href="${pageContext.request.contextPath}/auth/login" class="btn btn-outline">로그인</a>
                <a href="${pageContext.request.contextPath}/auth/register" class="btn btn-brown">회원가입</a>
            </div>
        </div>
    </div>

    <!-- 네비게이션 -->
    <nav class="header-nav">
        <a href="${pageContext.request.contextPath}/about">회사 소개</a>
        <a href="${pageContext.request.contextPath}/office">오피스</a>
        <a href="${pageContext.request.contextPath}/reserve">예약하기</a>
        <a href="${pageContext.request.contextPath}/reviews">커뮤니티</a>
        <a href="${pageContext.request.contextPath}/support">고객센터</a>
    </nav>

    <div class="divider-line"></div>
</header>

<!-- ✅ 로그인 상태 제어 -->
<script>
    document.addEventListener("DOMContentLoaded", function() {
        var token = localStorage.getItem("accessToken");
        var username = localStorage.getItem("username");
        var role = localStorage.getItem("role");
        var headerUserArea = document.getElementById("headerUserArea");

        if (token && username) {
            var roleName = role === "ADMIN" ? "관리자" : "회원";

            headerUserArea.innerHTML =
                "<div class='profile-card'>" +
                "<div class='profile-info'>" +
                "<p><strong>" + roleName + "</strong> " + username + "님 환영합니다.</p>" +
                "</div>" +
                "<div class='profile-actions'>" +
                "<button class='btn mypage-btn' onclick=\"location.href='" +
                "${pageContext.request.contextPath}/user/mypage'\">마이페이지</button>" +
                "<button id='logoutBtn' class='btn logout-btn'>로그아웃</button>" +
                "</div>" +
                "</div>";

        } else {
            headerUserArea.innerHTML =
                "<a href='" + "${pageContext.request.contextPath}/auth/login" + "' class='btn btn-outline'>로그인</a>" +
                "<a href='" + "${pageContext.request.contextPath}/auth/register" + "' class='btn btn-brown'>회원가입</a>";
        }

        // ✅ 로그아웃 처리
        document.body.addEventListener("click", async function(e) {
            if (e.target.id === "logoutBtn") {
                try {
                    await fetch("${pageContext.request.contextPath}/api/auth/logout", {
                        method: "POST",
                        credentials: "include"
                    });

                    localStorage.clear();
                    document.cookie.split(";").forEach(function(c) {
                        document.cookie = c.replace(/^ +/, "")
                            .replace(/=.*/, "=;expires=" + new Date().toUTCString() + ";path=/");
                    });

                    alert("로그아웃 되었습니다.");
                    window.location.reload();
                } catch (err) {
                    console.error("로그아웃 오류:", err);
                    alert("로그아웃 중 오류가 발생했습니다.");
                }
            }
        });
    });
</script>
