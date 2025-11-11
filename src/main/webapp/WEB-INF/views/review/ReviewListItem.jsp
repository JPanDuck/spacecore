<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:forEach var="r" items="${data}">
    <div class="rounded shadow" style="padding:20px; border:1px solid var(--gray-300); background:var(--white);">
        <div class="flex-row" style="justify-content:space-between;">
            <strong style="color:var(--choco);">${r.userName}</strong>
            <span style="color:var(--amber);">
                <c:forEach begin="1" end="${r.rating}" var="i">⭐</c:forEach>
            </span>
        </div>
        <p style="margin:10px 0; color:var(--text-primary); white-space:pre-line;">${r.content}</p>
        <c:if test="${not empty r.imgUrl}">
            <div style="margin-top:10px; display:flex; flex-wrap:wrap; gap:8px;">
                <c:forEach var="imgPath" items="${fn:split(r.imgUrl, ',')}">
                    <c:choose>
                        <c:when test="${fn:startsWith(imgPath, 'http://') || fn:startsWith(imgPath, 'https://')}">
                            <!-- 절대 URL -->
                            <img src="${imgPath}" alt="리뷰 이미지" class="rounded" 
                                 style="width:140px; height:140px; object-fit:cover; border:1px solid var(--gray-300); cursor:pointer;" 
                                 onclick="window.open(this.src, '_blank')">
                        </c:when>
                        <c:when test="${fn:startsWith(imgPath, '/img/reviews/') || fn:startsWith(imgPath, '/uploads/')}">
                            <!-- 절대 경로 -->
                            <img src="${pageContext.request.contextPath}${imgPath}" alt="리뷰 이미지" class="rounded" 
                                 style="width:140px; height:140px; object-fit:cover; border:1px solid var(--gray-300); cursor:pointer;" 
                                 onclick="window.open(this.src, '_blank')">
                        </c:when>
                        <c:otherwise>
                            <!-- 상대 경로 -->
                            <img src="${pageContext.request.contextPath}/img/reviews/${imgPath}" alt="리뷰 이미지" class="rounded" 
                                 style="width:140px; height:140px; object-fit:cover; border:1px solid var(--gray-300); cursor:pointer;" 
                                 onclick="window.open(this.src, '_blank')">
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
            </div>
        </c:if>
        <p style="font-size:13px; color:var(--gray-600); margin-top:8px;">${r.createdAt}</p>
    </div>
</c:forEach>
