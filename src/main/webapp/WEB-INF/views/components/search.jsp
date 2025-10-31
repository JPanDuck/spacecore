<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- ✅ 검색 필터만 남긴 컴포넌트 -->
<div class="search-container">
    <form id="filterForm"
          class="filter-form flex-row"
          onsubmit="event.preventDefault(); loadReviews(1);"
          style="gap:10px; flex-wrap:wrap; justify-content:center;">
        <c:forEach var="field" items="${filterFields}">
            <c:choose>
                <c:when test="${field == 'keyword'}">
                    <input id="keyword" type="text" name="keyword" value="${param.keyword}" placeholder="내용 검색"
                           class="input" style="flex:1; min-width:200px; height:40px; padding:0 12px;
                           border:1px solid var(--gray-300); border-radius:var(--radius-md);">
                </c:when>

                <c:when test="${field == 'userName'}">
                    <input id="userName" type="text" name="userName" value="${param.userName}" placeholder="작성자명"
                           class="input" style="width:150px; height:40px; padding:0 12px;
                           border:1px solid var(--gray-300); border-radius:var(--radius-md);">
                </c:when>

                <c:when test="${field == 'rating'}">
                    <select id="rating" name="rating" class="input" style="width:130px; height:40px;
                            border:1px solid var(--gray-300); border-radius:var(--radius-md);">
                        <option value="">별점 전체</option>
                        <option value="5" ${param.rating == '5' ? 'selected' : ''}>⭐ 5점</option>
                        <option value="4" ${param.rating == '4' ? 'selected' : ''}>⭐ 4점</option>
                        <option value="3" ${param.rating == '3' ? 'selected' : ''}>⭐ 3점</option>
                        <option value="2" ${param.rating == '2' ? 'selected' : ''}>⭐ 2점</option>
                        <option value="1" ${param.rating == '1' ? 'selected' : ''}>⭐ 1점</option>
                    </select>
                </c:when>
            </c:choose>
        </c:forEach>

        <!-- ✅ 버튼 -->
        <button id="searchBtn" type="button" class="btn btn-brown">검색</button>
        <button id="resetBtn" type="button" class="btn btn-outline">초기화</button>
    </form>
</div>

<style>
    .search-container {
        margin-top: 25px;
        margin-bottom: 25px;
        text-align: center;
    }
    .filter-form {
        display: inline-flex;
        flex-wrap: wrap;
        justify-content: center;
        gap: 10px;
    }
    @media (max-width: 768px) {
        .filter-form {
            flex-direction: column;
            align-items: center;
        }
        .filter-form .input,
        .filter-form select,
        .filter-form button {
            width: 100% !important;
        }
    }
</style>
