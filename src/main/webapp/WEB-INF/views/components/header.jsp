<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!-- ✅ 아이콘 CSS -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/phosphor-icons@1.4.2/dist/phosphor.css">

<header class="app-header">
    <div class="container-1980 header-top">
        <div class="header-top-row">

            <!-- 좌측: 고객 서비스 -->
            <div class="header-left">
                <button id="supportToggle" class="header-link">
                    <i class="ph ph-plus"></i> 고객 서비스
                </button>
            </div>

            <!-- 중앙 로고 -->
            <div class="header-logo">
                <a href="${pageContext.request.contextPath}/">
                    <img src="${pageContext.request.contextPath}/img/Cleansmall.png" alt="로고">
                </a>
            </div>

            <!-- 우측 메뉴 -->
            <div class="header-icons" id="headerIcons">
                <a href="${pageContext.request.contextPath}/auth/login" class="nav-link">로그인</a>
                <a href="${pageContext.request.contextPath}/auth/register" class="nav-link">회원가입</a>
                <button id="menuToggle" class="icon-btn">
                    <i class="ph ph-list"></i><span class="menu-text">MENU</span>
                </button>
            </div>
        </div>
    </div>

    <!-- ✅ 고객 서비스 팝업 -->
    <div class="support-popup" id="supportPopup">
        <button class="menu-close" id="supportClose"><i class="ph ph-x"></i></button>
        <div class="support-content">
            <h3>문의하기</h3>
            <p>전화번호 : <strong>02-1234-5678</strong></p>
            <p>주소 : 서울특별시 강남구 테헤란로 123, 스페이스코어 빌딩</p>
        </div>
    </div>
    <div class="menu-overlay" id="supportOverlay"></div>

    <!-- ✅ 메뉴 팝업 -->
    <div class="menu-popup" id="menuPopup">
        <button class="menu-close" id="menuClose"><i class="ph ph-x"></i></button>
        <nav class="menu-content">
            <a href="${pageContext.request.contextPath}/about">회사 소개</a>
            <a href="${pageContext.request.contextPath}/office">오피스</a>
            <a href="${pageContext.request.contextPath}/reserve">예약하기</a>
            <a href="${pageContext.request.contextPath}/reviews">커뮤니티</a>
            <a href="${pageContext.request.contextPath}/support">고객센터</a>
            <hr>
            <div class="menu-extra" id="menuExtra"></div>
        </nav>
    </div>
    <div class="menu-overlay" id="menuOverlay"></div>
</header>

<!-- ✅ JS -->
<script>
    document.addEventListener("DOMContentLoaded", () => {
        const menuPopup = document.getElementById("menuPopup");
        const menuOverlay = document.getElementById("menuOverlay");
        const menuClose = document.getElementById("menuClose");
        const supportBtn = document.getElementById("supportToggle");
        const supportPopup = document.getElementById("supportPopup");
        const supportClose = document.getElementById("supportClose");
        const supportOverlay = document.getElementById("supportOverlay");
        const headerIcons = document.getElementById("headerIcons");
        const menuExtra = document.getElementById("menuExtra");

        const openPopup = (popup, overlay) => {
            popup.classList.add("active");
            overlay.classList.add("active");
            document.body.style.overflow = "hidden";
        };
        const closePopup = (popup, overlay) => {
            popup.classList.remove("active");
            overlay.classList.remove("active");
            document.body.style.overflow = "";
        };

        // ✅ 로그인 상태 표시
        const username = localStorage.getItem("username");
        if (username) {
            headerIcons.innerHTML = `
            <span class="welcome-text">환영합니다, <strong>${username}</strong>님</span>
            <a href="${pageContext.request.contextPath}/reservations" class="nav-link">예약조회</a>
            <a href="${pageContext.request.contextPath}/user/mypage" class="nav-link">마이페이지</a>
            <a href="#" class="nav-link logout-link">로그아웃</a>
            <button id="menuToggle" class="icon-btn"><i class="ph ph-list"></i><span class="menu-text">MENU</span></button>
        `;
            menuExtra.innerHTML = `
            <a href="${pageContext.request.contextPath}/user/mypage" class="nav-link">마이페이지</a>
            <a href="#" class="nav-link logout-link">로그아웃</a>
        `;
        } else {
            menuExtra.innerHTML = `
            <a href="${pageContext.request.contextPath}/auth/login" class="nav-link">로그인</a>
            <a href="${pageContext.request.contextPath}/auth/register" class="nav-link">회원가입</a>
        `;
        }

        // ✅ 메뉴 버튼 재바인딩
        const bindMenuEvents = () => {
            const menuBtn = document.getElementById("menuToggle");
            if (menuBtn) {
                menuBtn.addEventListener("click", () => openPopup(menuPopup, menuOverlay));
            }
        };
        bindMenuEvents();
        new MutationObserver(bindMenuEvents).observe(headerIcons, { childList: true });

        // ✅ 팝업 닫기
        menuClose.addEventListener("click", () => closePopup(menuPopup, menuOverlay));
        menuOverlay.addEventListener("click", () => closePopup(menuPopup, menuOverlay));
        supportBtn.addEventListener("click", () => openPopup(supportPopup, supportOverlay));
        supportClose.addEventListener("click", () => closePopup(supportPopup, supportOverlay));
        supportOverlay.addEventListener("click", () => closePopup(supportPopup, supportOverlay));

        // ✅ 완전한 로그아웃 처리 (토큰/세션/쿠키 포함)
        document.addEventListener("click", async (e) => {
            const logoutEl = e.target.closest(".logout-link");
            if (logoutEl) {
                e.preventDefault();
                try {
                    await fetch("${pageContext.request.contextPath}/api/auth/logout", {
                        method: "POST",
                        credentials: "include"
                    });

                    // 로컬 스토리지 + 쿠키 완전 삭제
                    localStorage.clear();
                    document.cookie.split(";").forEach(c => {
                        document.cookie = c
                            .replace(/^ +/, "")
                            .replace(/=.*/, "=;expires=" + new Date().toUTCString() + ";path=/");
                    });

                    alert("로그아웃 되었습니다.");
                    window.location.href = "${pageContext.request.contextPath}/";
                } catch (err) {
                    console.error("로그아웃 오류:", err);
                    alert("로그아웃 중 오류가 발생했습니다.");
                }
            }
        });
    });
</script>

<!-- ✅ CSS -->
<style>
    .support-popup {
        position: fixed;
        top: 0;
        right: -400px;
        width: 360px;
        height: 100vh;
        background: var(--cream-base);
        box-shadow: -2px 0 10px rgba(0,0,0,0.15);
        transition: right 0.4s ease;
        z-index: 999;
        padding: 40px 30px;
    }
    .support-popup.active { right: 0; }

    .support-content h3 {
        font-size: 20px;
        color: var(--choco);
        margin-bottom: 16px;
    }
    .support-content p {
        font-size: 14px;
        color: var(--text-primary);
        margin-bottom: 8px;
    }

    /* 텍스트 네비게이션 */
    .nav-link {
        font-size: 14px;
        font-weight: 500;
        color: var(--text-primary);
        transition: color 0.25s ease;
    }
    .nav-link:hover { color: var(--amber); }

    .welcome-text {
        font-size: 14px;
        color: var(--choco);
        margin-right: 8px;
    }

    /* 메뉴 구분선 */
    .menu-content hr {
        margin: 20px 0;
        border: none;
        border-top: 1px solid var(--gray-300);
        opacity: 0.5;
    }

    /* 메뉴 하단 */
    .menu-extra {
        margin-top: 14px;
        display: flex;
        flex-direction: column;
        gap: 6px;
    }

    /* 메뉴 버튼 (같은 크기 통일) */
    .icon-btn {
        background: none;
        border: none;
        cursor: pointer;
        font-size: 14px;
        color: var(--text-primary);
        transition: color 0.3s ease;
    }
    .icon-btn:hover { color: var(--amber); }

    .menu-text {
        font-size: 10px;
        font-weight: 700;
        margin-left: 4px;
        letter-spacing: 0.5px;
    }
</style>
