<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>지점 목록 | SpaceCore</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>

<body>

<!-- ✅ 헤더 -->
<%@ include file="../components/header.jsp" %>

<main class="container-1980 mt-40 mb-40">

    <!-- 제목 -->
    <div class="flex-row" style="justify-content:space-between; align-items:center;">
        <h2 class="section-title visible">공유오피스 지점 목록</h2>
        <sec:authorize access="hasRole('ADMIN')">
            <a href="${pageContext.request.contextPath}/offices/add" class="btn btn-brown" style="height:42px;">지점 등록</a>
        </sec:authorize>
    </div>

    <!-- 리스트 카드 -->
    <div class="card-basic shadow mt-20">
        <c:choose>
            <c:when test="${not empty officeList}">
                <table class="table-basic w-full">
                    <thead>
                    <tr style="background: var(--cream-tan);">
                        <th>ID</th>
                        <th>지점명</th>
                        <th>주소</th>
                        <th>상태</th>
                        <th>관리</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="o" items="${officeList}">
                        <tr>
                            <td>${o.id}</td>
                            <td>
                                <a href="${pageContext.request.contextPath}/offices/${o.id}/rooms" style="color:var(--amber); font-weight:600;">
                                    ${o.name}
                                </a>
                            </td>
                            <td>${o.address}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${o.status == 'ACTIVE'}">
                                        <span style="color: var(--amber); font-weight:600;">활성</span>
                                    </c:when>
                                    <c:when test="${o.status == 'INACTIVE'}">
                                        <span style="color: var(--gray-600);">비활성</span>
                                    </c:when>
                                    <c:otherwise>${o.status}</c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/offices/detail/${o.id}" class="btn btn-outline btn-sm">상세</a>
                                <sec:authorize access="hasRole('ADMIN')">
                                    <a href="${pageContext.request.contextPath}/offices/edit/${o.id}" class="btn btn-brown btn-sm">수정</a>
                                    <form action="${pageContext.request.contextPath}/offices/delete/${o.id}" method="post" style="display:inline;">
                                        <button type="submit" class="btn btn-outline btn-sm"
                                            onclick="return confirm('정말 삭제하시겠습니까?');">삭제</button>
                                    </form>
                                </sec:authorize>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <div class="text-center text-gray mt-40">등록된 지점이 없습니다.</div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- ✅ 페이지네이션 -->
    <jsp:include page="/WEB-INF/views/components/pagination.jsp">
        <jsp:param name="pageInfo" value="${pageInfo}" />
        <jsp:param name="baseUrl" value="/offices" />
    </jsp:include>

</main>

<!-- ✅ 푸터 -->
<%@ include file="../components/footer.jsp" %>

</body>
</html>
