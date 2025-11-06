<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file="/WEB-INF/views/components/header.jsp" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

<style>
    .reservation-list-container {
        max-width: 1200px;
        margin: 40px auto;
        padding: 0 20px;
    }
    .reservation-table {
        width: 100%;
        border-collapse: collapse;
        background: white;
        border-radius: 8px;
        overflow: hidden;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    }
    .reservation-table th {
        background: var(--choco);
        color: white;
        padding: 12px;
        text-align: left;
        font-weight: 600;
    }
    .reservation-table td {
        padding: 12px;
        border-bottom: 1px solid var(--gray-200);
    }
    .reservation-table tr:hover {
        background: var(--gray-100);
    }
    .status-badge {
        display: inline-block;
        padding: 4px 12px;
        border-radius: 12px;
        font-size: 12px;
        font-weight: 600;
    }
    .status-AWAITING_PAYMENT { background: #fff3cd; color: #856404; }
    .status-CONFIRMED { background: #d4edda; color: #155724; }
    .status-CANCELLED { background: #f8d7da; color: #721c24; }
    .status-EXPIRED { background: #e2e3e5; color: #383d41; }
</style>

<main class="reservation-list-container">
    <h2 style="margin-bottom: 30px;">예약 목록</h2>
    
    <c:if test="${param.error != null}">
        <div style="background: #f8d7da; color: #721c24; padding: 12px; border-radius: 8px; margin-bottom: 20px;">
            ${param.error}
        </div>
    </c:if>
    
    <table class="reservation-table" id="reservationTable">
        <thead>
            <tr>
                <th>ID</th>
                <th>사용자</th>
                <th>룸</th>
                <th>시작시간</th>
                <th>종료시간</th>
                <th>상태</th>
                <th>액션</th>
            </tr>
        </thead>
        <tbody id="reservationTableBody">
            <c:forEach var="r" items="${reservationList}">
                <tr data-reservation-id="${r.id}">
                    <td>${r.id}</td>
                    <td><c:out value="${r.userName != null ? r.userName : '없음'}"/></td>
                    <td><c:out value="${r.roomName != null ? r.roomName : '없음'}"/></td>
                    <td>
                        <c:if test="${r.startAt != null}">
                            ${r.startAt.year}년 ${r.startAt.monthValue}월 ${r.startAt.dayOfMonth}일 ${r.startAt.hour}시
                        </c:if>
                    </td>
                    <td>
                        <c:if test="${r.endAt != null}">
                            ${r.endAt.year}년 ${r.endAt.monthValue}월 ${r.endAt.dayOfMonth}일 ${r.endAt.hour}시
                        </c:if>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${r.status == 'AWAITING_PAYMENT'}">
                                <span class="status-badge status-AWAITING_PAYMENT">결제 대기</span>
                            </c:when>
                            <c:when test="${r.status == 'CONFIRMED'}">
                                <span class="status-badge status-CONFIRMED">확정</span>
                            </c:when>
                            <c:when test="${r.status == 'CANCELLED'}">
                                <span class="status-badge status-CANCELLED">취소</span>
                            </c:when>
                            <c:when test="${r.status == 'EXPIRED'}">
                                <span class="status-badge status-EXPIRED">만료</span>
                            </c:when>
                            <c:otherwise>
                                <span class="status-badge">${r.status}</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <a href="${pageContext.request.contextPath}/reservations/detail/${r.id}" class="btn btn-outline">상세</a>
                        <c:if test="${r.status == 'CONFIRMED'}">
                            <a href="${pageContext.request.contextPath}/reviews/create?roomId=${r.roomId}" class="btn btn-brown" style="margin-left: 8px;">리뷰 작성</a>
                        </c:if>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <!-- 페이지네이션 -->
    <div class="pagination mt-40" id="paginationArea"></div>

</main>

<script>
(function() {
    const itemsPerPage = 10;
    let currentPage = 1;
    const allRows = Array.from(document.querySelectorAll('#reservationTableBody tr'));
    const totalItems = allRows.length;
    const totalPages = Math.ceil(totalItems / itemsPerPage);

    function renderPage(page) {
        currentPage = page;
        const start = (page - 1) * itemsPerPage;
        const end = start + itemsPerPage;
        
        allRows.forEach((row, index) => {
            if (index >= start && index < end) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        });

        renderPagination();
    }

    function renderPagination() {
        const paginationArea = document.getElementById('paginationArea');
        if (!paginationArea) return;

        if (totalPages <= 1) {
            paginationArea.innerHTML = '';
            return;
        }

        let html = '<ul class="pagination-list">';
        
        // 이전 버튼
        if (currentPage > 1) {
            html += '<li><a href="#" data-page="' + (currentPage - 1) + '">이전</a></li>';
        }

        // 페이지 번호
        for (let i = 1; i <= totalPages; i++) {
            const activeClass = (i === currentPage) ? 'active' : '';
            html += '<li class="' + activeClass + '">' +
                    '<a href="#" data-page="' + i + '">' + i + '</a></li>';
        }

        // 다음 버튼
        if (currentPage < totalPages) {
            html += '<li><a href="#" data-page="' + (currentPage + 1) + '">다음</a></li>';
        }

        html += '</ul>';
        paginationArea.innerHTML = html;

        // 이벤트 리스너
        paginationArea.querySelectorAll('a[data-page]').forEach(a => {
            a.addEventListener('click', e => {
                e.preventDefault();
                const page = parseInt(a.dataset.page);
                renderPage(page);
            });
        });
    }

    // 초기 렌더링
    renderPage(1);
})();
</script>

<%@ include file="/WEB-INF/views/components/footer.jsp" %>
