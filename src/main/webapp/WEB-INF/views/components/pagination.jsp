<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div id="pagination" class="pagination">
    <c:if test="${pageInfo.hasPrevious}">
        <a href="${pageContext.request.contextPath}${baseUrl}${fn:contains(baseUrl, '?') ? '&' : '?'}page=${pageInfo.currentPage - 1}"
           class="btn btn-outline">&lt; 이전</a>
    </c:if>
    <c:forEach var="i" begin="1" end="${pageInfo.totalPages}">
        <a href="${pageContext.request.contextPath}${baseUrl}${fn:contains(baseUrl, '?') ? '&' : '?'}page=${i}"
           class="btn ${pageInfo.currentPage == i ? 'btn-brown' : 'btn-outline'}">${i}</a>
    </c:forEach>
    <c:if test="${pageInfo.hasNext}">
        <a href="${pageContext.request.contextPath}${baseUrl}${fn:contains(baseUrl, '?') ? '&' : '?'}page=${pageInfo.currentPage + 1}"
           class="btn btn-outline">다음 &gt;</a>
    </c:if>
</div>