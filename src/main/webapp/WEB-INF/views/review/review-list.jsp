<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>Space Core® | 리뷰 목록</title>

    <!-- ✅ CSS & 폰트 -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&family=Montserrat:wght@400;600&display=swap"
          rel="stylesheet">
</head>
<body data-context="${pageContext.request.contextPath}">

<!-- ✅ HEADER -->
<%@ include file="/WEB-INF/views/components/header.jsp" %>

<main class="container-1980 mt-40 mb-40">

    <!-- ✅ 제목 + 리뷰 작성 버튼 -->
    <div class="flex-row" style="justify-content:space-between; align-items:center; margin-bottom:30px;">
        <h2 class="section-title" style="margin:0;">이용자 리뷰 목록</h2>
        <a href="${pageContext.request.contextPath}/reviews/create" class="btn btn-brown">✍️ 리뷰 작성하기</a>
    </div>

    <div class="card-basic">
        <h3 class="card-title">등록된 리뷰</h3>

        <!-- ✅ 메시지 표시 (서버 측) -->
        <%
            String messageParam = request.getParameter("message");
            if (messageParam != null && !messageParam.trim().isEmpty()) {
                String decodedMessage = java.net.URLDecoder.decode(messageParam, "UTF-8");
        %>
        <div style="background-color: #fff3cd; border: 1px solid #ffc107; color: #856404; padding: 12px; border-radius: 8px; margin-bottom: 20px; font-size: 14px;">
            ⚠️ <%= decodedMessage %>
        </div>
        <%
            }
        %>
        
        <!-- ✅ 메시지 표시 (JavaScript용) -->
        <div id="messageAlert" style="display:none; background-color: #fff3cd; border: 1px solid #ffc107; color: #856404; padding: 12px; border-radius: 8px; margin-bottom: 20px; font-size: 14px;">
        </div>

        <!-- ✅ 리뷰 요약 -->
        <div id="reviewSummary"
             class="text-center"
             style="margin-bottom:25px; font-weight:600; color:var(--choco);">
        </div>

        <!-- ✅ 검색 필터 -->
        <form id="filterForm" class="flex-row mb-40" style="justify-content:flex-end;">
            <input type="text" id="keyword" name="keyword" placeholder="키워드 검색"
                   style="border:1px solid var(--gray-300); padding:8px 12px; border-radius:8px; width:200px; font-size:14px;">

            <select id="rating" name="rating"
                    style="margin-left:8px; border:1px solid var(--gray-300); padding:8px 12px; border-radius:8px;">
                <option value="">전체 평점</option>
                <option value="5">⭐ 5점</option>
                <option value="4">⭐ 4점</option>
                <option value="3">⭐ 3점</option>
                <option value="2">⭐ 2점</option>
                <option value="1">⭐ 1점</option>
            </select>

            <input type="text" id="userName" name="userName" placeholder="작성자"
                   style="margin-left:8px; border:1px solid var(--gray-300); padding:8px 12px; border-radius:8px; width:150px; font-size:14px;">

            <button type="button" id="searchBtn" class="btn btn-brown" style="margin-left:8px;">검색</button>
            <button type="button" id="resetBtn" class="btn btn-outline-brown" style="margin-left:8px;">초기화</button>
        </form>

        <!-- ✅ JS에서 데이터 렌더링 -->
        <div id="reviewList" class="review-list"></div>

        <!-- ✅ 페이지네이션 -->
        <div id="pagination" class="mt-40"></div>
    </div>
</main>

<!-- ✅ FOOTER -->
<%@ include file="/WEB-INF/views/components/footer.jsp" %>

<!-- ✅ JS -->
<script src="${pageContext.request.contextPath}/js/reviewList.js"></script>

<!-- ✨ Scroll Animation (괄호 오류 수정본) -->
<script>
    const fadeEls = document.querySelectorAll('.scroll-fade');
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(e => {
            if (e.isIntersecting) e.target.classList.add('active');
        });
    }, {threshold: 0.2});
    fadeEls.forEach(el => observer.observe(el));
</script>

</body>
</html>
