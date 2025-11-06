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
            <a href="${pageContext.request.contextPath}/notices">공지사항</a>
            <a href="${pageContext.request.contextPath}/offices">오피스</a>
            <a href="${pageContext.request.contextPath}/reviews">커뮤니티</a>
            <a href="${pageContext.request.contextPath}/qna">Q&A</a>
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


        // 🚨 (추가) 안 읽은 알림 개수 조회 함수
        async function getUnreadNotificationCount() {
            try {
                const url = "${pageContext.request.contextPath}/api/notifications/unread/count";
                console.log(`[Notification] API 호출 시도: ${url}`); // 호출 URL 확인

                const res = await fetch(url, {
                    method: "GET",
                    credentials: "include"
                });
                const data = await res.json();
                console.log("[Notification] API 응답 데이터:", data); // 응답 데이터 전체 확인

                if (res.ok) {
                    // 만약 Controller가 {count: 5} 형태로 보낸다면, data.count로 바꿔야 함
                    const count = data.unreadCount || data.count || 0;
                    console.log(`[Notification] 최종 카운트 값: ${count}`); // 최종 카운트 값 확인
                    return count;
                } else {
                    console.error(`[Notification] API 응답 실패: 상태 ${res.status}`);
                }
            } catch (err) {
                console.error("[Notification] 안 읽은 알림 개수 조회 실패:", err);
            }
            return 0;
        }


        // ✅ 메뉴 버튼 재바인딩
        const bindMenuEvents = () => {
            const menuBtn = document.getElementById("menuToggle");
            if (menuBtn) {
                menuBtn.addEventListener("click", () => openPopup(menuPopup, menuOverlay));
            }
        };

        // ✅ 로그인 상태 확인 (토큰 검증 필수)
        async function checkLoginStatus() {
            const token = localStorage.getItem("accessToken");

            // 토큰이 없으면 무조건 비로그인 상태
            if (!token) {
                // localStorage 정리
                localStorage.removeItem("username");
                localStorage.removeItem("accessToken");
                localStorage.removeItem("refreshToken");
                localStorage.removeItem("role");
                showLoggedOutUI();
                return;
            }

            // 토큰이 있으면 서버에서 검증
            try {
                const res = await fetch("${pageContext.request.contextPath}/api/auth/validate", {
                    method: "GET",
                    credentials: "include"
                });

                if (res.ok) {
                    const data = await res.json();
                    if (data.valid === true) {
                        // 유효한 토큰이면 로그인 상태 표시
                        // data.name을 우선 사용, 없거나 빈 문자열이면 username 사용
                        let displayName = data.name;
                        if (!displayName || displayName.trim() === "") {
                            displayName = data.username || "사용자";
                        }
                        console.log("로그인 사용자 정보:", { name: data.name, username: data.username, displayName: displayName });

                        // 🚨 (추가) 알림 개수 비동기 조회 및 전달
                        const unreadCount = await getUnreadNotificationCount();

                        showLoggedInUI(displayName, unreadCount);
                        return;
                    }
                }
                // 토큰이 유효하지 않으면 정리
                localStorage.clear();
                showLoggedOutUI();
            } catch (err) {
                console.error("토큰 검증 실패:", err);
                localStorage.clear();
                showLoggedOutUI();
            }
        }

        function showLoggedInUI(userName, unreadCount) {
            // 알림 아이콘 HTML 생성
            const notificationCountHtml = (unreadCount > 0) 
                ? '<span class="notification-badge">' + unreadCount + '</span>' 
                : '';
            const notificationIconHtml = 
                '<a href="${pageContext.request.contextPath}/notifications" class="nav-link notification-icon" style="position: relative; display: inline-flex; align-items: center;">' +
                '<i class="ph ph-bell"></i>' + notificationCountHtml + '</a>';

            headerIcons.innerHTML = `
            <span class="welcome-text">환영합니다, <strong>${userName}</strong>님</span>
            <a href="${pageContext.request.contextPath}/reservations" class="nav-link">예약조회</a>
            ${notificationIconHtml}
            <a href="${pageContext.request.contextPath}/user/mypage" class="nav-link">마이페이지</a>

            <a href="#" class="nav-link logout-link">로그아웃</a>
            <button id="menuToggle" class="icon-btn"><i class="ph ph-list"></i><span class="menu-text">MENU</span></button>
        `;

            //🚨 (추가)
            var countHtml = (unreadCount > 0)
                ? ' <span class="notification-count">' + unreadCount + '</span>'
                : '';
            var notificationLinkHtml =
                '<a href="${pageContext.request.contextPath}/notifications" class="nav-link">' +
                '알림' + countHtml +
                '</a>';

            menuExtra.innerHTML = notificationLinkHtml + '\n' +
                '<a href="${pageContext.request.contextPath}/user/mypage" class="nav-link">마이페이지</a>\n' +
                '<a href="${pageContext.request.contextPath}/payments" class="nav-link">결제목록</a>\n' +
                '<a href="${pageContext.request.contextPath}/favorites/list" class="nav-link">즐겨찾기</a>\n' +
                '<a href="#" class="nav-link logout-link">로그아웃</a>';
            bindMenuEvents();
        }

        function showLoggedOutUI() {
            headerIcons.innerHTML = `
            <a href="${pageContext.request.contextPath}/auth/login" class="nav-link">로그인</a>
            <a href="${pageContext.request.contextPath}/auth/register" class="nav-link">회원가입</a>
            <button id="menuToggle" class="icon-btn"><i class="ph ph-list"></i><span class="menu-text">MENU</span></button>
        `;
            menuExtra.innerHTML = `
            <a href="${pageContext.request.contextPath}/auth/login" class="nav-link">로그인</a>
            <a href="${pageContext.request.contextPath}/auth/register" class="nav-link">회원가입</a>
        `;
            bindMenuEvents();
        }

        // 초기 바인딩
        bindMenuEvents();
        // 동적으로 추가된 요소를 위한 Observer
        new MutationObserver(bindMenuEvents).observe(headerIcons, {childList: true});

        // 초기 로그인 상태 확인
        checkLoginStatus();

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
        // ✅ /offices 전용 헤더 구성
        const currentPath = window.location.pathname;

        // /offices 페이지일 경우 헤더 재배치
        if (currentPath.includes("/offices")) {
            const headerRow = document.querySelector(".header-top-row");
            headerRow.classList.add("offices-header");

            // 기존 요소들 가져오기
            const logo = document.querySelector(".header-logo");
            const icons = document.querySelector(".header-icons");
            const searchBox = document.createElement("div");

            // 헤더 순서 재배치: 로고 - 검색영역 - 마이페이지 등
            headerRow.innerHTML = ""; // 기존 비우기
            headerRow.appendChild(logo);
            headerRow.appendChild(icons);
        }

    });
</script>

<!-- ✅ CSS -->
<style>
    /* 헤더 sticky 스타일 추가 */
    .app-header {
        position: sticky;
        top: 0;
        z-index: 1000;
        background: var(--cream-base);
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        transition: box-shadow 0.3s ease;
    }

    .support-popup {
        position: fixed;
        top: 0;
        right: -400px;
        width: 360px;
        height: 100vh;
        background: var(--cream-base);
        box-shadow: -2px 0 10px rgba(0, 0, 0, 0.15);
        transition: right 0.4s ease;
        z-index: 999;
        padding: 40px 30px;
    }

    .support-popup.active {
        right: 0;
    }

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

    .nav-link:hover {
        color: var(--amber);
    }

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

    .icon-btn:hover {
        color: var(--amber);
    }

    .menu-text {
        font-size: 10px;
        font-weight: 700;
        margin-left: 4px;
        letter-spacing: 0.5px;
    }

    /* 안 읽은 알림 개수 뱃지 스타일 */
    .notification-count {
        display: inline-flex;
        justify-content: center;
        align-items: center;
        min-width: 18px;
        height: 18px;
        padding: 0 4px;
        margin-left: 6px;
        background-color: var(--amber);
        color: white;
        border-radius: 9px;
        font-size: 11px;
        font-weight: 700;
        line-height: 1;
        vertical-align: middle;
    }

    /* 알림 아이콘 스타일 */
    .notification-icon {
        position: relative;
        display: inline-flex;
        align-items: center;
    }

    .notification-icon i {
        font-size: 20px;
    }

    .notification-badge {
        position: absolute;
        top: -6px;
        right: -6px;
        display: inline-flex;
        justify-content: center;
        align-items: center;
        min-width: 18px;
        height: 18px;
        padding: 0 4px;
        background-color: #e74c3c;
        color: white;
        border-radius: 9px;
        font-size: 11px;
        font-weight: 700;
        line-height: 1;
        border: 2px solid white;
    }
</style>
