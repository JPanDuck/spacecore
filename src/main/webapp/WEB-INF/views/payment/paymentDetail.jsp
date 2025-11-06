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

    .payment-detail-container {
        max-width: 800px;
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

    .payment-detail-card {
        background: white;
        padding: 30px;
        border-radius: 12px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        margin-bottom: 30px;
    }

    .detail-section {
        margin-bottom: 24px;
        padding-bottom: 24px;
        border-bottom: 1px solid var(--gray-200);
    }

    .detail-section:last-child {
        border-bottom: none;
        margin-bottom: 0;
        padding-bottom: 0;
    }

    .detail-label {
        font-size: 14px;
        font-weight: 600;
        color: var(--gray-600);
        margin-bottom: 8px;
    }

    .detail-value {
        font-size: 18px;
        color: var(--choco);
        font-weight: 600;
    }

    .detail-value.amount {
        font-size: 24px;
        color: var(--choco);
    }

    .status-badge {
        display: inline-block;
        padding: 8px 16px;
        border-radius: 12px;
        font-size: 14px;
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

    .back-link {
        display: inline-block;
        margin-top: 20px;
        padding: 12px 24px;
        background: var(--mocha);
        color: white;
        text-decoration: none;
        border-radius: 8px;
        font-weight: 600;
        transition: background 0.3s ease;
    }

    .back-link:hover {
        background: var(--amber);
    }

    .detail-info-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 24px;
    }

    @media (max-width: 768px) {
        .detail-info-grid {
            grid-template-columns: 1fr;
        }
    }
</style>

<main class="payment-detail-container">
    <div class="payment-header">
        <h1>
            <i class="ph ph-credit-card" style="color: var(--choco);"></i>
            결제 상세
        </h1>
    </div>

    <c:choose>
        <c:when test="${empty payment}">
            <div class="empty-state">
                <i class="ph ph-credit-card"></i>
                <h2>결제 정보를 찾을 수 없습니다</h2>
                <p>요청하신 결제 정보가 존재하지 않습니다.</p>
                <a href="<%=context%>/payments/" class="back-link">결제 목록으로</a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="payment-detail-card">
                <div class="detail-section">
                    <div class="detail-label">결제 ID</div>
                    <div class="detail-value">${payment.id}</div>
                </div>

                <div class="detail-section">
                    <div class="detail-label">가상계좌 ID</div>
                    <div class="detail-value">${payment.vaId}</div>
                </div>

                <div class="detail-section">
                    <div class="detail-label">결제 금액</div>
                    <div class="detail-value amount">
                        <fmt:formatNumber value="${payment.amount}" type="number" />원
                    </div>
                </div>

                <div class="detail-section">
                    <div class="detail-label">결제 상태</div>
                    <div>
                        <c:choose>
                            <c:when test="${payment.status == 'CONFIRMED'}">
                                <span class="status-badge status-CONFIRMED">확정</span>
                            </c:when>
                            <c:when test="${payment.status == 'CANCELLED'}">
                                <span class="status-badge status-CANCELLED">취소</span>
                            </c:when>
                            <c:when test="${payment.status == 'PENDING'}">
                                <span class="status-badge status-PENDING">대기</span>
                            </c:when>
                            <c:otherwise>
                                <span class="status-badge">${payment.status}</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="detail-section">
                    <div class="detail-label">결제일</div>
                    <div class="detail-value">
                        <c:if test="${payment.createdAt != null}">
                            ${payment.createdAt.year}년 ${payment.createdAt.monthValue}월 ${payment.createdAt.dayOfMonth}일
                        </c:if>
                    </div>
                </div>
            </div>

            <a href="<%=context%>/payments/" class="back-link">결제 목록으로</a>
        </c:otherwise>
    </c:choose>
</main>

<%@ include file="/WEB-INF/views/components/footer.jsp" %>
