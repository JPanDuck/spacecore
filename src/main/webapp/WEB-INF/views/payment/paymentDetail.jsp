<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<% String context = request.getContextPath(); %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>결제 상세 | Space Core</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .payment-detail-container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 40px 20px;
        }

        .detail-header {
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid var(--cream-tan);
        }

        .detail-title {
            font-size: 32px;
            font-weight: 700;
            color: var(--choco);
            margin-bottom: 12px;
        }

        .payment-number {
            color: var(--gray-600);
            font-size: 14px;
        }

        .detail-content {
            background: var(--white);
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--gray-200);
            padding: 0;
            margin-bottom: 30px;
            overflow: hidden;
        }

        .summary-section {
            background: linear-gradient(135deg, var(--cream-tan) 0%, var(--white) 100%);
            padding: 30px 40px;
            border-bottom: 2px solid var(--mocha);
            display: flex;
            justify-content: flex-start;
            align-items: center;
            gap: 40px;
        }

        .summary-left {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .summary-info {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .summary-label {
            font-size: 13px;
            color: var(--gray-600);
            font-weight: 500;
        }

        .summary-value {
            font-size: 20px;
            font-weight: 700;
            color: var(--choco);
        }

        .summary-status {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-left: auto;
        }

        .content-body {
            padding: 40px;
        }

        .info-section {
            margin-bottom: 30px;
        }

        .info-section:last-child {
            margin-bottom: 0;
        }

        .section-title {
            font-size: 18px;
            font-weight: 600;
            color: var(--choco);
            margin-bottom: 16px;
            padding-bottom: 12px;
            border-bottom: 1px solid var(--gray-200);
        }

        .info-grid {
            display: grid;
            grid-template-columns: 150px 1fr;
            gap: 16px 20px;
            align-items: start;
        }

        .info-label {
            font-weight: 600;
            color: var(--gray-700);
            font-size: 14px;
        }

        .info-value {
            color: var(--text-primary);
            font-size: 15px;
            word-break: break-word;
        }

        .status-badge {
            display: inline-block;
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 600;
        }

        .status-badge.confirmed {
            background: var(--amber);
            color: var(--white);
        }

        .status-badge.cancelled {
            background: var(--gray-400);
            color: var(--white);
        }

        .status-badge.pending {
            background: var(--safari);
            color: var(--choco);
        }

        .detail-actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 30px;
            border-top: 1px solid var(--gray-200);
        }

        .divider {
            height: 1px;
            background: var(--gray-200);
            margin: 30px 0;
        }

        .datetime {
            color: var(--text-primary);
        }
    </style>
</head>
<body>
<%@ include file="/WEB-INF/views/components/header.jsp" %>

<div class="payment-detail-container">
    <div class="detail-header">
        <h1 class="detail-title">결제 상세</h1>
        <div class="payment-number">결제번호: ${payment.id}</div>
    </div>

    <c:choose>
        <c:when test="${not empty payment}">
            <div class="detail-content">
                <!-- 요약 섹션 -->
                <div class="summary-section">
                    <div class="summary-left">
                        <div class="summary-info">
                            <div class="summary-label">결제번호</div>
                            <div class="summary-value">#${payment.id}</div>
                        </div>
                        <div class="summary-info">
                            <div class="summary-label">결제 금액</div>
                            <div class="summary-value" style="color: var(--amber);">
                                <fmt:formatNumber value="${payment.amount}" type="number"/>원
                            </div>
                        </div>
                        <div class="summary-info">
                            <div class="summary-label">가상계좌 ID</div>
                            <div class="summary-value">${payment.vaId}</div>
                        </div>
                    </div>
                    <div class="summary-status">
                        <c:choose>
                            <c:when test="${payment.status == 'CONFIRMED'}">
                                <span class="status-badge confirmed">확정</span>
                            </c:when>
                            <c:when test="${payment.status == 'CANCELLED'}">
                                <span class="status-badge cancelled">취소</span>
                            </c:when>
                            <c:when test="${payment.status == 'PENDING'}">
                                <span class="status-badge pending">대기</span>
                            </c:when>
                            <c:otherwise>
                                <span class="status-badge">${payment.status}</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- 기본 정보 -->
                <div class="content-body">
                    <div class="info-section">
                        <h2 class="section-title">결제 정보</h2>
                        <div class="info-grid">
                            <div class="info-label">결제번호</div>
                            <div class="info-value">${payment.id}</div>

                            <div class="info-label">가상계좌 ID</div>
                            <div class="info-value">${payment.vaId}</div>

                            <div class="info-label">결제 금액</div>
                            <div class="info-value">
                                <strong style="color: var(--amber); font-size: 18px;">
                                    <fmt:formatNumber value="${payment.amount}" type="number"/>원
                                </strong>
                            </div>

                            <div class="info-label">상태</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${payment.status == 'CONFIRMED'}">
                                        <span class="status-badge confirmed">확정</span>
                                    </c:when>
                                    <c:when test="${payment.status == 'CANCELLED'}">
                                        <span class="status-badge cancelled">취소</span>
                                    </c:when>
                                    <c:when test="${payment.status == 'PENDING'}">
                                        <span class="status-badge pending">대기</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-badge">${payment.status}</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="info-label">생성일</div>
                            <div class="info-value datetime">
                                <c:choose>
                                    <c:when test="${not empty payment.createdAt}">
                                        ${payment.createdAt.year}년 ${payment.createdAt.monthValue}월 ${payment.createdAt.dayOfMonth}일 
                                        ${payment.createdAt.hour}시 
                                        <c:if test="${payment.createdAt.minute > 0}">${payment.createdAt.minute}분</c:if>
                                    </c:when>
                                    <c:otherwise>
                                        -
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 액션 버튼 -->
            <div class="detail-actions">
                <a href="/payments" class="btn btn-outline">목록으로</a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="detail-content">
                <div class="content-body" style="text-align: center; padding: 60px 20px;">
                    <p style="color: var(--gray-600); font-size: 16px;">결제 정보가 없습니다.</p>
                </div>
            </div>
            <div class="detail-actions">
                <a href="/payments" class="btn btn-outline">목록으로</a>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<%@ include file="/WEB-INF/views/components/footer.jsp" %>
</body>
</html>
