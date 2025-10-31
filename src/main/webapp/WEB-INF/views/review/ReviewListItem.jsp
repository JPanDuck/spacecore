<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

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
            <img src="${r.imgUrl}" alt="리뷰 이미지" class="rounded" style="width:140px; margin-top:10px;">
        </c:if>
        <p style="font-size:13px; color:var(--gray-600); margin-top:8px;">${r.createdAt}</p>
    </div>
</c:forEach>
