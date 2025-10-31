<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!-- HEADER -->
<%@ include file="/WEB-INF/views/components/header.jsp" %>

<main class="container-1980 mt-40 mb-40">
    <!-- 페이지 헤더 -->
    <div class="flex-row" style="justify-content:space-between; align-items:center; margin-bottom:30px;">
        <h2 class="section-title" style="margin:0;">리뷰 상세보기</h2>
        <a href="${pageContext.request.contextPath}/reviews" class="btn btn-outline">← 목록으로</a>
    </div>

    <!-- 본문 카드 -->
    <div class="card-basic" style="padding:30px;">
        <div class="flex-row" style="justify-content:space-between; align-items:center;">
            <h3 style="font-weight:600; color:var(--choco); font-size:18px;">${review.userName}</h3>
            <span style="color:var(--amber); font-size:20px;">
                <c:forEach begin="1" end="${review.rating}">⭐</c:forEach>
            </span>
        </div>

        <p style="margin-top:15px; white-space:pre-line; color:var(--text-primary); line-height:1.6;">
            ${review.content}
        </p>

        <!-- 이미지 목록 -->
        <c:if test="${not empty review.imgUrl}">
            <div style="margin-top:20px; display:flex; flex-wrap:wrap; gap:12px;">
                <c:forEach var="imgPath" items="${fn:split(review.imgUrl, ',')}">
                    <img src="${imgPath}" alt="리뷰 이미지"
                         style="width:180px; height:180px; object-fit:cover; border-radius:10px;
                                border:1px solid var(--gray-300); box-shadow:0 2px 5px rgba(0,0,0,0.1);">
                </c:forEach>
            </div>
        </c:if>

        <p style="margin-top:20px; color:var(--gray-600); font-size:14px;">
            작성일: ${review.createdAt}
        </p>

        <div class="text-right mt-20">
            <a href="${pageContext.request.contextPath}/reviews" class="btn btn-outline">목록으로</a>
        </div>
    </div>
</main>

<!-- FOOTER -->
<%@ include file="/WEB-INF/views/components/footer.jsp" %>
