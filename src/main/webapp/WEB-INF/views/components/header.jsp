<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<header class="app-header">
    <div class="container-1980 header-top">
        <!-- 상단: 로고 중앙 -->
        <div class="header-top-row">
            <div class="header-logo">
                <a href="${pageContext.request.contextPath}/index">
                    <img src="${pageContext.request.contextPath}/img/Cleansmall.png"
                         alt="로고">
                </a>
            </div>

            <div class="header-actions">
                <button class="btn btn-outline" onclick="location.href='${pageContext.request.contextPath}/login'">로그인</button>
                <button class="btn btn-brown" onclick="location.href='${pageContext.request.contextPath}/signup'">회원가입</button>
            </div>
        </div>
    </div>

    <!-- 하단: 네비게이션 메뉴 -->
    <nav class="header-nav">
        <a href="${pageContext.request.contextPath}/about">회사 소개</a>
        <a href="${pageContext.request.contextPath}/office">오피스</a>
        <a href="${pageContext.request.contextPath}/reserve">예약하기</a>
        <a href="${pageContext.request.contextPath}/community">커뮤니티</a>
        <a href="${pageContext.request.contextPath}/support">고객센터</a>
    </nav>

    <div class="divider-line"></div>
</header>
