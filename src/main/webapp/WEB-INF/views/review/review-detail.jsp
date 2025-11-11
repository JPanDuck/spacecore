<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!-- HEADER -->
<%@ include file="/WEB-INF/views/components/header.jsp" %>

 <!-- CSS -->
 <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
<main class="container-1980 mt-40 mb-40">
    <!-- 페이지 헤더 -->
    <div class="flex-row" style="justify-content:space-between; align-items:center; margin-bottom:30px;">
        <h2 class="section-title" style="margin:0;">리뷰 상세보기</h2>
        <a href="${pageContext.request.contextPath}/reviews" class="btn btn-outline">← 목록으로</a>
    </div>

    <!-- 본문 카드 -->
    <div class="card-basic" style="padding:30px;">
        <!-- 작성자 정보 및 평점 -->
        <div class="flex-row" style="justify-content:space-between; align-items:center; margin-bottom:20px; padding-bottom:15px; border-bottom:2px solid var(--gray-200);">
            <div>
                <h3 style="font-weight:600; color:var(--choco); font-size:20px; margin:0 0 5px 0;">${review.userName}</h3>
                <p style="margin:0; color:var(--gray-600); font-size:14px;">
                    작성일: ${review.createdAt}
                </p>
            </div>
            <span style="color:var(--amber); font-size:24px; font-weight:bold;">
                <c:forEach begin="1" end="${review.rating}">⭐</c:forEach>
            </span>
        </div>

        <!-- 리뷰 내용 -->
        <div style="margin-bottom:20px;">
            <p style="white-space:pre-line; color:var(--text-primary); line-height:1.8; font-size:16px; margin:0;">
                ${review.content}
            </p>
        </div>

        <!-- 이미지 목록 -->
        <c:if test="${not empty review.imgUrl}">
            <div style="margin-top:20px; display:flex; flex-wrap:wrap; gap:12px;">
                <c:forEach var="imgPath" items="${fn:split(review.imgUrl, ',')}">
                    <c:choose>
                        <c:when test="${fn:startsWith(imgPath, 'http://') || fn:startsWith(imgPath, 'https://')}">
                            <!-- 절대 URL -->
                            <img src="${imgPath}" alt="리뷰 이미지"
                                 style="width:180px; height:180px; object-fit:cover; border-radius:10px;
                                        border:1px solid var(--gray-300); box-shadow:0 2px 5px rgba(0,0,0,0.1);
                                        cursor:pointer;" onclick="window.open(this.src, '_blank')">
                        </c:when>
                        <c:when test="${fn:startsWith(imgPath, '/img/reviews/') || fn:startsWith(imgPath, '/uploads/')}">
                            <!-- 절대 경로 (/img/reviews/ 또는 /uploads/) -->
                            <img src="${pageContext.request.contextPath}${imgPath}" alt="리뷰 이미지"
                                 style="width:180px; height:180px; object-fit:cover; border-radius:10px;
                                        border:1px solid var(--gray-300); box-shadow:0 2px 5px rgba(0,0,0,0.1);
                                        cursor:pointer;" onclick="window.open(this.src, '_blank')">
                        </c:when>
                        <c:when test="${fn:startsWith(imgPath, 'data:')}">
                            <!-- base64 이미지 -->
                            <img src="${imgPath}" alt="리뷰 이미지"
                                 style="width:180px; height:180px; object-fit:cover; border-radius:10px;
                                        border:1px solid var(--gray-300); box-shadow:0 2px 5px rgba(0,0,0,0.1);
                                        cursor:pointer;" onclick="window.open(this.src, '_blank')">
                        </c:when>
                        <c:otherwise>
                            <!-- 상대 경로인 경우 -->
                            <img src="${pageContext.request.contextPath}/img/reviews/${imgPath}" alt="리뷰 이미지"
                                 style="width:180px; height:180px; object-fit:cover; border-radius:10px;
                                        border:1px solid var(--gray-300); box-shadow:0 2px 5px rgba(0,0,0,0.1);
                                        cursor:pointer;" onclick="window.open(this.src, '_blank')">
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
            </div>
        </c:if>

        <!-- 하단 버튼 -->
        <div class="text-right mt-20" style="padding-top:20px; border-top:1px solid var(--gray-200);">
            <a href="${pageContext.request.contextPath}/reviews" class="btn btn-outline">← 목록으로</a>
        </div>
    </div>
</main>

<!-- FOOTER -->
<%@ include file="/WEB-INF/views/components/footer.jsp" %>
