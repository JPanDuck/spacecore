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
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&family=Montserrat:wght@400;600&display=swap" rel="stylesheet">
</head>
<body>

<!-- ✅ HEADER -->
<%@ include file="/WEB-INF/views/components/header.jsp" %>

<!-- ✅ MAIN CONTENT -->
<main class="container-1980 mt-40 mb-40">

    <!-- 상단 헤더: 제목 + 작성 버튼 -->
    <div class="flex-row" style="justify-content:space-between; align-items:center; margin-bottom:30px;">
        <h2 class="section-title" style="margin:0;">이용자 리뷰 목록</h2>
        <a href="${pageContext.request.contextPath}/reviews/create"
           class="btn btn-brown">✍️ 리뷰 작성하기</a>
    </div>

    <!-- 리뷰 카드 목록 -->
    <div class="card-basic">
        <h3 class="card-title">등록된 리뷰</h3>

        <!-- 리뷰 요약 -->
        <c:if test="${not empty summary}">
            <div class="text-center" style="margin-bottom:25px; font-weight:600; color:var(--choco);">
                평균 평점: ⭐ ${summary.avgRating} / 5.0
                <br>
                총 ${summary.totalCount}개의 리뷰가 등록되어 있습니다.
            </div>
        </c:if>

        <!-- 🔍 검색 필터 -->
        <form method="get" action="${pageContext.request.contextPath}/reviews"
              class="flex-row mb-40" style="justify-content:flex-end;">
            <input type="text" name="keyword" placeholder="키워드 검색" value="${filter.keyword}"
                   style="border:1px solid var(--gray-300); padding:8px 12px; border-radius:8px; width:200px; font-size:14px;">
            <button type="submit" class="btn btn-brown" style="margin-left:8px;">검색</button>
        </form>

        <!-- 리뷰 목록 -->
        <div class="review-list">
            <c:choose>
                <c:when test="${not empty reviewList}">
                    <c:forEach var="r" items="${reviewList}">
                        <div class="review-item" style="margin-bottom:30px;">

                            <div class="review-header flex-row" style="justify-content:space-between; align-items:center;">
                                <div>
                                    <strong class="review-author" style="color:var(--choco);">${r.userName}</strong>
                                    <span class="review-rating" style="color:var(--amber); font-size:15px;">
                                        ⭐ ${r.rating}점
                                    </span>
                                </div>
                                <span class="review-date" style="font-size:14px; color:var(--gray-600);">${r.createdAt}</span>
                            </div>

                            <p class="review-content" style="margin-top:15px; line-height:1.6;">
                                ${r.content}
                            </p>

                            <c:if test="${not empty r.imgUrl}">
                                <div style="margin-top:15px;">
                                    <img src="${pageContext.request.contextPath}/uploads/${r.imgUrl}"
                                         alt="리뷰 이미지"
                                         style="width:100%; max-width:600px; border-radius:10px; box-shadow:var(--shadow-sm);">
                                </div>
                            </c:if>

                        </div>
                    </c:forEach>
                </c:when>

                <c:otherwise>
                    <p class="text-center" style="color:var(--gray-600); margin-top:40px;">
                        등록된 리뷰가 없습니다 💤
                    </p>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- 📄 페이지네이션 -->
        <c:if test="${not empty pageInfo}">
            <ul class="pagination-list mt-40">
                <c:if test="${pageInfo.hasPrevious}">
                    <li><a href="${pageContext.request.contextPath}/reviews?page=${pageInfo.currentPage - 1}">이전</a></li>
                </c:if>

                <c:forEach var="i" begin="1" end="${pageInfo.totalPages}">
                    <li class="${i == pageInfo.currentPage ? 'active' : ''}">
                        <a href="${pageContext.request.contextPath}/reviews?page=${i}">${i}</a>
                    </li>
                </c:forEach>

                <c:if test="${pageInfo.hasNext}">
                    <li><a href="${pageContext.request.contextPath}/reviews?page=${pageInfo.currentPage + 1}">다음</a></li>
                </c:if>
            </ul>
        </c:if>

    </div>
</main>

<!-- ✅ FOOTER -->
<%@ include file="/WEB-INF/views/components/footer.jsp" %>

<!-- ✅ JS -->
<script src="${pageContext.request.contextPath}/js/reviewList.js"></script>

<!-- ✨ Scroll Animation -->
<script>
    const fadeEls = document.querySelectorAll('.scroll-fade');
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(e => {
            if (e.isIntersecting) e.target.classList.add('active'));
        });
    }, { threshold: 0.2 });
    fadeEls.forEach(el => observer.observe(el));
</script>

</body>
</html>
