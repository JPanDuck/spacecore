<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    String context = request.getContextPath();
%>
<%@ include file="/WEB-INF/views/components/header.jsp" %>
<link rel="stylesheet" href="<%=context%>/css/style.css">

<style>
    body {
        background: var(--cream-base);
    }

    .payment-list-container {
        max-width: 1200px;
        margin: 40px auto;
        padding: 20px;
    }

    .payment-header {
        background: white;
        padding: 30px;
        border-radius: 12px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        margin-bottom: 30px;
    }

    .payment-header h1 {
        color: var(--choco);
        font-size: 28px;
        margin: 0;
        display: flex;
        align-items: center;
        gap: 12px;
    }

    .payment-table {
        width: 100%;
        border-collapse: collapse;
        background: white;
        border-radius: 12px;
        overflow: hidden;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    }

    .payment-table th {
        background: var(--choco);
        color: white;
        padding: 16px;
        text-align: left;
        font-weight: 600;
        font-size: 14px;
    }

    .payment-table td {
        padding: 16px;
        border-bottom: 1px solid var(--gray-200);
        font-size: 14px;
    }

    .payment-table tr:hover {
        background: var(--gray-100);
    }

    .payment-table tr:last-child td {
        border-bottom: none;
    }

    .status-badge {
        display: inline-block;
        padding: 6px 14px;
        border-radius: 12px;
        font-size: 12px;
        font-weight: 600;
    }

    .status-CONFIRMED {
        background: #d4edda;
        color: #155724;
    }

    .status-CANCELLED {
        background: #f8d7da;
        color: #721c24;
    }

    .status-PENDING {
        background: #fff3cd;
        color: #856404;
    }

    .payment-amount {
        font-weight: 600;
        color: var(--choco);
    }

    .payment-link {
        color: var(--mocha);
        text-decoration: none;
        font-weight: 500;
        transition: color 0.3s ease;
    }

    .payment-link:hover {
        color: var(--amber);
        text-decoration: underline;
    }

    .empty-state {
        text-align: center;
        padding: 60px 20px;
        background: white;
        border-radius: 12px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    }

    .empty-state i {
        font-size: 64px;
        color: var(--gray-400);
        margin-bottom: 20px;
    }

    .empty-state h2 {
        color: var(--gray-600);
        font-size: 20px;
        margin-bottom: 12px;
    }

    .empty-state p {
        color: var(--gray-500);
        font-size: 14px;
    }

    .pagination {
        margin-top: 30px;
        display: flex;
        justify-content: center;
    }

    .pagination-list {
        display: flex;
        list-style: none;
        gap: 8px;
        padding: 0;
        margin: 0;
    }

    .pagination-list li {
        display: inline-block;
    }

    .pagination-list a {
        display: block;
        padding: 8px 12px;
        background: white;
        color: var(--choco);
        text-decoration: none;
        border-radius: 6px;
        border: 1px solid var(--gray-300);
        transition: all 0.3s ease;
    }

    .pagination-list a:hover {
        background: var(--choco);
        color: white;
        border-color: var(--choco);
    }

    .pagination-list li.active a {
        background: var(--choco);
        color: white;
        border-color: var(--choco);
    }

    @media (max-width: 768px) {
        .payment-table {
            font-size: 12px;
        }

        .payment-table th,
        .payment-table td {
            padding: 12px 8px;
        }
    }
</style>

<main class="payment-list-container">
    <div class="payment-header">
        <h1>
            <i class="ph ph-credit-card" style="color: var(--choco);"></i>
            결제 목록
        </h1>
    </div>

    <c:choose>
        <c:when test="${empty paymentList}">
            <div class="empty-state">
                <i class="ph ph-credit-card"></i>
                <h2>결제 내역이 없습니다</h2>
                <p>아직 결제한 내역이 없습니다.</p>
            </div>
        </c:when>
        <c:otherwise>
            <table class="payment-table" id="paymentTable">
                <thead>
                    <tr>
                        <th>결제 ID</th>
                        <th>가상계좌 ID</th>
                        <th>결제 금액</th>
                        <th>상태</th>
                        <th>결제일</th>
                        <th>상세</th>
                    </tr>
                </thead>
                <tbody id="paymentTableBody">
                    <c:forEach var="p" items="${paymentList}">
                        <tr data-payment-id="${p.id}">
                            <td>${p.id}</td>
                            <td>${p.vaId}</td>
                            <td class="payment-amount">
                                <fmt:formatNumber value="${p.amount}" type="number" />원
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${p.status == 'CONFIRMED'}">
                                        <span class="status-badge status-CONFIRMED">확정</span>
                                    </c:when>
                                    <c:when test="${p.status == 'CANCELLED'}">
                                        <span class="status-badge status-CANCELLED">취소</span>
                                    </c:when>
                                    <c:when test="${p.status == 'PENDING'}">
                                        <span class="status-badge status-PENDING">대기</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-badge">${p.status}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:if test="${p.createdAt != null}">
                                    ${p.createdAt.year}년 ${p.createdAt.monthValue}월 ${p.createdAt.dayOfMonth}일
                                </c:if>
                            </td>
                            <td>
                                <a href="<%=context%>/payments/detail/${p.id}" class="payment-link">보기</a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <!-- 페이지네이션 -->
            <div class="pagination" id="paginationArea"></div>
        </c:otherwise>
    </c:choose>
</main>

<script>
(function() {
    const itemsPerPage = 10;
    let currentPage = 1;
    const allRows = Array.from(document.querySelectorAll('#paymentTableBody tr'));
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
    if (totalItems > 0) {
        renderPage(1);
    }
})();
</script>

<%@ include file="/WEB-INF/views/components/footer.jsp" %>
