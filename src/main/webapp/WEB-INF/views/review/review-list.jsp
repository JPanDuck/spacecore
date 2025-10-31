<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>Space Core® | 리뷰 목록</title>

    <!-- CSS & 폰트 -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&family=Montserrat:wght@400;600&display=swap" rel="stylesheet">
</head>
<body>

<!-- HEADER -->
<%@ include file="/WEB-INF/views/components/header.jsp" %>

<!-- MAIN CONTENT -->
<main class="container-1980 mt-40 mb-40">

    <!-- 페이지 헤더: 제목 + 작성 버튼 -->
    <div class="flex-row" style="justify-content:space-between; align-items:center; margin-bottom:30px;">
        <h2 class="section-title" style="margin:0;">이용자 리뷰 목록</h2>
        <a href="${pageContext.request.contextPath}/reviews/create?roomId=${roomId}"
           class="btn btn-brown">리뷰 작성하기</a>
    </div>

    <!-- 리뷰 카드 목록 -->
    <div class="card-basic">
        <h3 class="card-title">등록된 리뷰</h3>

        <!-- 리뷰 요약 -->
        <div id="reviewSummary" class="text-center" style="margin-bottom:25px; font-weight:600; color:var(--choco);">
            불러오는 중...
        </div>

        <!-- 검색 -->
        <jsp:include page="/WEB-INF/views/components/search.jsp" />

        <!-- 리뷰 목록 -->
        <div id="reviewList" class="review-list">
            <c:forEach var="r" items="${data}">
                <div class="review-item">

                    <div class="review-header">
                        <strong class="review-author">${r.userName}</strong>
                        <span class="review-rating">
                            <c:forEach begin="1" end="${r.rating}">⭐</c:forEach>
                        </span>
                    </div>

                    <p class="review-content">${r.content}</p>

                    <div class="review-meta">
                        <span>
                            <c:choose>
                                <c:when test="${not empty r.imgUrl}">📷 이미지 있음</c:when>
                                <c:otherwise>이미지 없음</c:otherwise>
                            </c:choose>
                        </span>
                        <span class="review-date">${r.createdAt}</span>
                    </div>

                    <div class="text-right">
                        <a href="${pageContext.request.contextPath}/reviews/${r.id}"
                           class="btn btn-outline btn-sm">상세보기</a>
                    </div>

                </div>
            </c:forEach>

            <!-- 리뷰 없음 -->
            <c:if test="${empty data}">
                <p class="text-center" style="color:var(--gray-600); margin-top:30px;">
                    등록된 리뷰가 없습니다.
                </p>
            </c:if>
        </div>

        <!-- ✅ 페이지네이션 -->
        <div class="pagination-wrapper mt-40">
            <jsp:include page="/WEB-INF/views/components/pagination.jsp" />
        </div>
    </div>
</main>

<!-- FOOTER -->
<%@ include file="/WEB-INF/views/components/footer.jsp" %>

<!-- JS -->
<script src="${pageContext.request.contextPath}/js/reviewList.js"></script>
</body>
</html>
