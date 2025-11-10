<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!-- ✅ 아이콘 - SVG 폴백 직접 사용 (CDN 시도 없음) -->
<script>
    // CDN 시도 없이 바로 SVG 폴백 활성화
    (function() {
        document.documentElement.classList.add('phosphor-failed');
    })();
</script>
<style>
    /* Phosphor 아이콘 폰트가 로드되지 않을 경우를 대비한 폴백 */
    .ph {
        display: inline-block;
        font-style: normal;
        font-variant: normal;
        text-rendering: auto;
        line-height: 1;
        font-family: 'Phosphor', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
    }
    /* 아이콘이 보이지 않을 경우를 대비한 기본 스타일 */
    i.ph {
        font-size: inherit;
        width: 1em;
        height: 1em;
        display: inline-block;
        visibility: visible !important;
        opacity: 1 !important;
    }
    /* 하트 아이콘 SVG 폴백 (CDN 실패 시 사용) */
    .phosphor-failed .ph-heart,
    .phosphor-failed .ph-heart-fill {
        display: inline-block;
        width: 1em;
        height: 1em;
        background-size: contain;
        background-repeat: no-repeat;
        background-position: center;
    }
    .phosphor-failed .ph-heart {
        background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 256 256'%3E%3Cpath fill='%238C8278' d='M128,216a7.8,7.8,0,0,1-3.6-.9C76.5,186.7,24,146,24,104a56,56,0,0,1,104-24,56,56,0,0,1,104,24c0,42-52.5,82.7-100.4,111.1A7.8,7.8,0,0,1,128,216Z'/%3E%3C/svg%3E");
    }
    .phosphor-failed .ph-heart-fill {
        background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 256 256'%3E%3Cpath fill='%23e74c3c' d='M128,216a7.8,7.8,0,0,1-3.6-.9C76.5,186.7,24,146,24,104a56,56,0,0,1,104-24,56,56,0,0,1,104,24c0,42-52.5,82.7-100.4,111.1A7.8,7.8,0,0,1,128,216Z'/%3E%3C/svg%3E");
    }
    /* 벨(종) 아이콘 SVG 폴백 (CDN 실패 시 사용) - 색칠된 종 모양 */
    .phosphor-failed .ph-bell,
    .phosphor-failed i.ph-bell {
        display: inline-block !important;
        width: 1em !important;
        height: 1em !important;
        background-size: contain !important;
        background-repeat: no-repeat !important;
        background-position: center !important;
        background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 256 256'%3E%3Cpath fill='%238C8278' d='M168,224a8,8,0,0,1-8,8H96a8,8,0,0,1,0-16h64A8,8,0,0,1,168,224Zm53.85-32A15.8,15.8,0,0,1,208,200H48a15.8,15.8,0,0,1-13.85-8,15.7,15.7,0,0,1-1.71-12.12l19.84-66.12a4,4,0,0,0,.06-1.64C44.15,87.47,40,75.23,40,64a88,88,0,0,1,176,0c0,11.23-4.15,23.47-6.34,28.12a4,4,0,0,0,.06,1.64l19.84,66.12A15.7,15.7,0,0,1,221.85,192ZM128,24a40,40,0,0,0-40,40,8,8,0,0,1-16,0,56,56,0,0,1,112,0,8,8,0,0,1-16,0A40,40,0,0,0,128,24Z'/%3E%3C/svg%3E") !important;
        font-size: 13px !important;
        line-height: 1 !important;
        visibility: visible !important;
        opacity: 1 !important;
    }
    /* 벨 아이콘 스타일 강화 (항상 적용) */
    .notification-icon i.ph-bell {
        display: inline-block !important;
        visibility: visible !important;
        opacity: 1 !important;
        font-size: 13px !important;
        line-height: 1 !important;
        min-width: 15px;
        min-height: 15px;
    }
    /* CDN 실패 시 벨 아이콘 보이도록 추가 보장 */
    .phosphor-failed .notification-icon i.ph-bell::before {
        display: none !important;
    }
    /* 프로필(사용자) 아이콘 SVG 폴백 (CDN 실패 시 사용) - 원형 배경 스타일 */
    .phosphor-failed .ph-user-circle,
    .phosphor-failed i.ph-user-circle {
        display: inline-block !important;
        width: 1em !important;
        height: 1em !important;
        background-size: contain !important;
        background-repeat: no-repeat !important;
        background-position: center !important;
        background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 256 256'%3E%3Ccircle fill='none' stroke='%238C8278' stroke-width='16' cx='128' cy='128' r='96'/%3E%3Ccircle fill='%238C8278' cx='128' cy='96' r='32'/%3E%3Cpath fill='%238C8278' d='M64,192a64,64,0,0,1,128,0'/%3E%3C/svg%3E") !important;
        font-size: 20px !important;
        line-height: 1 !important;
        visibility: visible !important;
        opacity: 1 !important;
    }
    /* 프로필 아이콘 스타일 강화 */
    .mypage-icon i.ph-user-circle {
        display: inline-block !important;
        visibility: visible !important;
        opacity: 1 !important;
        font-size: 20px !important;
        line-height: 1 !important;
        min-width: 20px;
        min-height: 20px;
    }
    /* CDN 실패 시 프로필 아이콘 보이도록 추가 보장 */
    .phosphor-failed .mypage-icon i.ph-user-circle::before {
        display: none !important;
    }
</style>

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
            <p>주소 : 서울특별시 구로구 시흥대로163길 33 <br> <b>주호타워 3층</b></p>
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
            <a href="${pageContext.request.contextPath}/qna">Q&A</a>
            <a href="${pageContext.request.contextPath}/chatbot/faq">자주묻는 질문</a>
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

        // ✅ 쿠키에서 토큰 읽기
        function getCookie(name) {
            const value = `; ${document.cookie}`;
            const parts = value.split(`; ${name}=`);
            if (parts.length === 2) return parts.pop().split(';').shift();
            return null;
        }

        // ✅ 로그인 상태 확인 (토큰 검증 필수)
        async function checkLoginStatus() {
            console.log("[Token Debug] ========== 토큰 검증 시작 ==========");
            
            // localStorage와 쿠키 모두 확인
            const localStorageToken = localStorage.getItem("accessToken");
            const cookieToken = getCookie("access_token");
            const allCookies = document.cookie;
            
            console.log("[Token Debug] localStorage에서 accessToken 확인:", localStorageToken ? "존재함 (길이: " + localStorageToken.length + ")" : "없음");
            console.log("[Token Debug] 쿠키에서 access_token 확인:", cookieToken ? "존재함 (길이: " + cookieToken.length + ")" : "없음");
            console.log("[Token Debug] 모든 쿠키:", allCookies || "없음");

            // localStorage나 쿠키에 토큰이 없어도 세션 기반 인증을 확인하기 위해 서버 검증 시도
            // (서버는 쿠키의 토큰이나 세션을 모두 확인할 수 있음)
            console.log("[Token Debug] 토큰이 없어도 세션 기반 인증 확인을 위해 서버 검증 시도");

            // 서버에서 검증 (세션 기반 인증도 확인)
            try {
                const validateUrl = "${pageContext.request.contextPath}/api/auth/validate";
                console.log("[Token Debug] 토큰 검증 API 호출:", validateUrl);
                
                const res = await fetch(validateUrl, {
                    method: "GET",
                    credentials: "include"
                });

                console.log("[Token Debug] 검증 API 응답 상태:", res.status, res.statusText);
                console.log("[Token Debug] 응답 헤더:", {
                    contentType: res.headers.get("content-type"),
                    cookies: document.cookie
                });

                // 응답 본문 읽기 (성공/실패 모두)
                let responseText = '';
                let data = null;
                
                try {
                    responseText = await res.text();
                    console.log("[Token Debug] 검증 API 응답 본문 (raw):", responseText);
                    
                    if (responseText) {
                        try {
                            data = JSON.parse(responseText);
                            console.log("[Token Debug] 검증 API 응답 데이터 (parsed):", data);
                        } catch (parseErr) {
                            console.warn("[Token Debug] JSON 파싱 실패, 텍스트로 처리:", parseErr);
                            data = { valid: false, message: responseText };
                        }
                    }
                } catch (readErr) {
                    console.error("[Token Debug] 응답 읽기 실패:", readErr);
                }

                if (res.ok && data && data.valid === true) {
                    console.log("[Token Debug] ✅ 세션 기반 인증 성공 (토큰 없이도 인증됨)");
                    // 유효한 세션이면 사용자 정보 가져오기
                    let displayName = data.username || "사용자";
                    
                    // /api/auth/me 엔드포인트에서 name과 role 정보 가져오기
                    let userRole = data.role || 'USER';
                    console.log("[Token Debug] 초기 사용자 정보:", { displayName, userRole });
                    
                    try {
                        const meUrl = "${pageContext.request.contextPath}/api/auth/me";
                        console.log("[Token Debug] 사용자 정보 API 호출:", meUrl);
                        
                        const meRes = await fetch(meUrl, {
                            method: "GET",
                            credentials: "include"
                        });
                        
                        console.log("[Token Debug] 사용자 정보 API 응답 상태:", meRes.status);
                        
                        if (meRes.ok) {
                            const meData = await meRes.json();
                            console.log("[Token Debug] 사용자 정보 API 응답 데이터:", meData);
                            
                            // name이 있으면 name 사용, 없으면 username 사용
                            displayName = (meData.name && meData.name.trim() !== "") ? meData.name : (meData.username || displayName);
                            // role 정보 업데이트
                            if (meData.role) {
                                userRole = meData.role;
                            }
                            console.log("[Token Debug] 최종 사용자 정보:", { displayName, userRole });
                        } else {
                            console.warn("[Token Debug] ⚠️ 사용자 정보 API 실패:", meRes.status);
                            const errorText = await meRes.text();
                            console.warn("[Token Debug] 에러 내용:", errorText);
                        }
                    } catch (meErr) {
                        console.error("[Token Debug] ❌ 사용자 정보 조회 실패:", meErr);
                        console.error("[Token Debug] 에러 상세:", {
                            message: meErr.message,
                            stack: meErr.stack
                        });
                    }
                    
                    console.log("[Token Debug] 최종 로그인 사용자 정보:", { displayName: displayName, role: userRole });

                    // 🚨 (추가) 알림 개수 비동기 조회 및 전달
                    const unreadCount = await getUnreadNotificationCount();
                    console.log("[Token Debug] 알림 개수:", unreadCount);

                    console.log("[Token Debug] showLoggedInUI 호출 전:", { displayName, unreadCount, userRole });
                    try {
                        showLoggedInUI(displayName, unreadCount, userRole);
                        console.log("[Token Debug] ✅ showLoggedInUI 호출 성공");
                    } catch (uiErr) {
                        console.error("[Token Debug] ❌ showLoggedInUI 호출 실패:", uiErr);
                        console.error("[Token Debug] 에러 상세:", {
                            name: uiErr.name,
                            message: uiErr.message,
                            stack: uiErr.stack
                        });
                    }
                    console.log("[Token Debug] ========== 세션 기반 인증 성공 ==========");
                    return;
                } else {
                    if (res.status === 401) {
                        console.warn("[Token Debug] ⚠️ 인증 실패 (401) - 세션도 없음");
                    } else {
                        console.warn("[Token Debug] ⚠️ 응답이 유효하지 않음:", { status: res.status, data: data });
                    }
                }
                
                // 토큰이 유효하지 않으면 정리
                console.log("[Token Debug] ❌ 토큰 무효 - localStorage 정리 및 비로그인 상태로 전환");
                localStorage.clear();
                showLoggedOutUI();
            } catch (err) {
                console.error("[Token Debug] ❌ 토큰 검증 중 예외 발생:", err);
                console.error("[Token Debug] 에러 상세:", {
                    name: err.name,
                    message: err.message,
                    stack: err.stack
                });
                localStorage.clear();
                showLoggedOutUI();
            }
            console.log("[Token Debug] ========== 토큰 검증 종료 ==========");
        }

        function showLoggedInUI(userName, unreadCount, userRole) {
            console.log("[Header] showLoggedInUI 호출됨:", { userName, unreadCount, userRole });
            
            // userName이 비어있거나 undefined인 경우 기본값 설정
            if (!userName || userName.trim() === "") {
                userName = "사용자";
            }
            
            // role이 없으면 기본값 'USER' 설정
            userRole = userRole || 'USER';
            
            console.log("[Header] 최종 파라미터:", { userName, unreadCount, userRole });
            
            // 알림 아이콘 HTML 생성
            const notificationCountHtml = (unreadCount > 0) 
                ? '<span class="notification-badge">' + unreadCount + '</span>' 
                : '';
            const notificationIconHtml = 
                '<a href="${pageContext.request.contextPath}/notifications" class="nav-link notification-icon" style="position: relative; display: inline-flex; align-items: center; justify-content: center;">' +
                '<i class="ph ph-bell" style="display: inline-block !important; visibility: visible !important; opacity: 1 !important; font-size: 13px !important; line-height: 1 !important;"></i>' + notificationCountHtml + '</a>';
            
            console.log("[Header] 벨 아이콘 HTML:", notificationIconHtml);

            // 마이페이지 아이콘 HTML 생성 (원형 배경 스타일)
            const mypageIconHtml = 
                '<a href="${pageContext.request.contextPath}/user/mypage" class="nav-link mypage-icon" style="position: relative; display: inline-flex; align-items: center; justify-content: center;">' +
                '<i class="ph ph-user-circle" style="display: inline-block !important; visibility: visible !important; opacity: 1 !important; font-size: 20px !important; line-height: 1 !important;"></i></a>';

            // JSP EL과 충돌 방지를 위해 문자열 연결 방식 사용
            headerIcons.innerHTML = 
                '<span class="welcome-text">환영합니다, <strong>' + userName + '</strong>님</span>' +
                notificationIconHtml +''+
                mypageIconHtml +
                '<a href="#" class="nav-link logout-link">로그아웃</a>' +
                '<button id="menuToggle" class="icon-btn"><i class="ph ph-list"></i><span class="menu-text">MENU</span></button>';
            // ========================== 메뉴 하단
            //🚨 (추가)
            var countHtml = (unreadCount > 0)
                ? ' <span class="notification-count">' + unreadCount + '</span>'
                : '';
            var notificationLinkHtml =
                '<a href="${pageContext.request.contextPath}/notifications" class="nav-link">' +
                '알림' + countHtml +
                '</a>';

            // FAQ 관리 링크는 ADMIN만 표시
            var faqAdminLink = '';
            var userAdminLink = '';
            if (userRole === 'ADMIN') {
                faqAdminLink = '<a href="${pageContext.request.contextPath}/chatbot/admin/list" class="nav-link">FAQ 관리</a>\n';
                userAdminLink = '<a href="${pageContext.request.contextPath}/admin/list" class="nav-link">사용자 관리</a>\n';
            }

            // 마이페이지 링크 HTML 생성
            const mypageLinkHtml = '<a href="${pageContext.request.contextPath}/user/mypage" class="nav-link">마이페이지</a>\n';

            menuExtra.innerHTML = notificationLinkHtml + '\n' +
                mypageLinkHtml +
                '<a href="${pageContext.request.contextPath}/reservations" class="nav-link">예약조회</a>' +
                '<a href="${pageContext.request.contextPath}/payments" class="nav-link">결제목록</a>\n' +
                '<a href="${pageContext.request.contextPath}/favorites/list" class="nav-link">즐겨찾기</a>\n' +
                faqAdminLink +
                userAdminLink +
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
        font-size: 15px;
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
