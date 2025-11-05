<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ include file="/WEB-INF/views/components/header.jsp" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

<style>
    .room-list-container {
        max-width: 1200px;
        margin: 40px auto;
        padding: 0 20px;
    }
    .room-table {
        width: 100%;
        border-collapse: collapse;
        background: white;
        border-radius: 8px;
        overflow: hidden;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    }
    .room-table th {
        background: var(--choco);
        color: white;
        padding: 12px;
        text-align: left;
        font-weight: 600;
    }
    .room-table td {
        padding: 12px;
        border-bottom: 1px solid var(--gray-200);
    }
    .room-table tr:hover {
        background: var(--gray-100);
    }
    .room-table img.thumb {
        width: 60px;
        height: 60px;
        object-fit: cover;
        border-radius: 4px;
    }
    .status-badge {
        display: inline-block;
        padding: 4px 12px;
        border-radius: 12px;
        font-size: 12px;
        font-weight: 600;
    }
    .status-ACTIVE { background: #d4edda; color: #155724; }
    .status-INACTIVE { background: #f8d7da; color: #721c24; }
</style>

<main class="room-list-container">
    <h2 style="margin-bottom: 30px;">룸 목록</h2>

    <div class="toolbar" style="margin-bottom: 20px;">
        <a href="${pageContext.request.contextPath}/offices/${selectedOfficeId}/rooms/add" class="btn btn-brown">[룸 등록]</a>
    </div>

    <table class="room-table">
        <thead>
            <tr>
                <th>썸네일</th>
                <th>ID</th>
                <th>지점명</th>
                <th>룸명</th>
                <th>정원</th>
                <th>기본요금</th>
                <th>상태</th>
                <th>관리</th>
            </tr>
        </thead>
        <tbody id="roomTableBody">
            <c:forEach var="room" items="${roomList}">
                <tr data-room-id="${room.id}">
                    <td>
                        <c:set var="thumb" value="${empty room.thumbnail ? '/static/img/placeholder-room.jpg' : room.thumbnail}" />
                        <img class="thumb" src="${pageContext.request.contextPath}${thumb}" alt="thumbnail">
                    </td>
                    <td>${room.id}</td>
                    <td>
                        <c:forEach var="office" items="${officeList}">
                            <c:if test="${office.id == room.officeId}">
                                ${office.name}
                            </c:if>
                        </c:forEach>
                    </td>
                    <td>${room.name}</td>
                    <td>${room.capacity}명</td>
                    <td><fmt:formatNumber value="${room.priceBase}" type="number"/>원</td>
                    <td>
                        <c:choose>
                            <c:when test="${room.status == 'ACTIVE'}">
                                <span class="status-badge status-ACTIVE">활성</span>
                            </c:when>
                            <c:when test="${room.status == 'INACTIVE'}">
                                <span class="status-badge status-INACTIVE">비활성</span>
                            </c:when>
                            <c:otherwise>
                                <span class="status-badge">${room.status}</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <div style="display: flex; gap: 8px;">
                            <a href="${pageContext.request.contextPath}/reservations/add/${room.id}" class="btn btn-outline" style="padding: 6px 12px; font-size: 12px;">예약하기</a>
                            <a href="${pageContext.request.contextPath}/offices/${room.officeId}/rooms/detail/${room.id}" class="btn btn-outline" style="padding: 6px 12px; font-size: 12px;">상세</a>
                            <a href="${pageContext.request.contextPath}/offices/${room.officeId}/rooms/edit/${room.id}" class="btn btn-outline" style="padding: 6px 12px; font-size: 12px;">수정</a>
                            <form action="${pageContext.request.contextPath}/offices/${room.officeId}/rooms/delete/${room.id}" method="post" style="display: inline;">
                                <button type="submit" class="btn btn-outline" style="padding: 6px 12px; font-size: 12px; background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb;">삭제</button>
                            </form>
                        </div>
                    </td>
                </tr>
            </c:forEach>

            <c:if test="${empty roomList}">
                <tr><td colspan="8" style="text-align: center; padding: 40px;">데이터 없음</td></tr>
            </c:if>
        </tbody>
    </table>

    <!-- 페이지네이션 -->
    <div class="pagination mt-40" id="paginationArea"></div>
</main>

<script>
(function() {
    const itemsPerPage = 10;
    let currentPage = 1;
    const allRows = Array.from(document.querySelectorAll('#roomTableBody tr'));
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
            html += `<li><a href="#" data-page="${currentPage - 1}">이전</a></li>`;
        }

        // 페이지 번호
        for (let i = 1; i <= totalPages; i++) {
            html += `<li class="${i === currentPage ? 'active' : ''}">
                        <a href="#" data-page="${i}">${i}</a></li>`;
        }

        // 다음 버튼
        if (currentPage < totalPages) {
            html += `<li><a href="#" data-page="${currentPage + 1}">다음</a></li>`;
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
