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
    <title>예약 상세 | Space Core</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .reservation-detail-container {
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

        .reservation-number {
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

        .status-badge.awaiting {
            background: var(--safari);
            color: var(--choco);
        }

        .status-badge.confirmed {
            background: var(--amber);
            color: var(--white);
        }

        .status-badge.cancelled {
            background: var(--gray-400);
            color: var(--white);
        }

        .status-badge.expired {
            background: var(--gray-500);
            color: var(--white);
        }

        .account-section {
            background: var(--cream-tan);
            padding: 24px;
            border-radius: var(--radius-md);
            margin-top: 20px;
        }

        .account-title {
            font-size: 16px;
            font-weight: 600;
            color: var(--choco);
            margin-bottom: 12px;
        }

        .account-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .account-item {
            padding: 12px;
            background: var(--white);
            border-radius: var(--radius-md);
            margin-bottom: 12px;
            border: 1px solid var(--gray-200);
        }

        .account-item:last-child {
            margin-bottom: 0;
        }

        .account-bank {
            font-weight: 600;
            color: var(--choco);
            margin-bottom: 4px;
        }

        .account-number {
            color: var(--text-primary);
            font-family: 'Courier New', monospace;
            font-size: 16px;
            letter-spacing: 1px;
        }

        .detail-actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 30px;
            border-top: 1px solid var(--gray-200);
        }

        .action-buttons {
            display: flex;
            gap: 12px;
        }

        .divider {
            height: 1px;
            background: var(--gray-200);
            margin: 30px 0;
        }

        .memo-section {
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid var(--gray-200);
        }

        .memo-content {
            color: var(--text-primary);
            line-height: 1.8;
            white-space: pre-wrap;
            word-wrap: break-word;
        }
    </style>
</head>
<body>
<%@ include file="/WEB-INF/views/components/header.jsp" %>

<div class="reservation-detail-container">
    <div class="detail-header">
        <h1 class="detail-title">예약 상세</h1>
        <div class="reservation-number">예약번호: ${reservation.id}</div>
    </div>

    <div class="detail-content">
        <!-- 요약 섹션 -->
        <div class="summary-section">
            <div class="summary-left">
                <div class="summary-info">
                    <div class="summary-label">예약번호</div>
                    <div class="summary-value">#${reservation.id}</div>
                </div>
                <div class="summary-info">
                    <div class="summary-label">객실</div>
                    <div class="summary-value">
                        <c:choose>
                            <c:when test="${not empty reservation.roomName}">
                                ${reservation.roomName}
                            </c:when>
                            <c:otherwise>
                                객실 ID: ${reservation.roomId}
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="summary-info">
                    <div class="summary-label">결제 금액</div>
                    <div class="summary-value" style="color: var(--amber);">
                        <fmt:formatNumber value="${reservation.amount}" type="number"/>원
                    </div>
                </div>
            </div>
            <div class="summary-status">
                <c:choose>
                    <c:when test="${reservation.status == 'AWAITING_PAYMENT'}">
                        <span class="status-badge awaiting">결제 대기</span>
                    </c:when>
                    <c:when test="${reservation.status == 'CONFIRMED'}">
                        <span class="status-badge confirmed">확정</span>
                    </c:when>
                    <c:when test="${reservation.status == 'CANCELLED'}">
                        <span class="status-badge cancelled">취소</span>
                    </c:when>
                    <c:when test="${reservation.status == 'EXPIRED'}">
                        <span class="status-badge expired">만료</span>
                    </c:when>
                    <c:otherwise>
                        <span class="status-badge">${reservation.status}</span>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- 기본 정보 -->
        <div class="content-body">
            <div class="info-section">
                <h2 class="section-title">예약 정보</h2>
            <div class="info-grid">
                <div class="info-label">객실</div>
                <div class="info-value">
                    <c:choose>
                        <c:when test="${not empty reservation.roomName}">
                            ${reservation.roomName}
                        </c:when>
                        <c:otherwise>
                            객실 ID: ${reservation.roomId}
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="info-label">예약자</div>
                <div class="info-value">
                    <c:choose>
                        <c:when test="${not empty reservation.reservantName}">
                            ${reservation.reservantName}
                        </c:when>
                        <c:otherwise>
                            ${reservation.userName != null ? reservation.userName : '-'}
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="info-label">시작 시간</div>
                <div class="info-value">
                    <c:if test="${not empty reservation.startAt}">
                        ${reservation.startAt.year}년 ${reservation.startAt.monthValue}월 ${reservation.startAt.dayOfMonth}일 
                        ${reservation.startAt.hour}시 
                        <c:if test="${reservation.startAt.minute > 0}">${reservation.startAt.minute}분</c:if>
                    </c:if>
                    <c:if test="${empty reservation.startAt}">
                        -
                    </c:if>
                </div>

                <div class="info-label">종료 시간</div>
                <div class="info-value">
                    <c:if test="${not empty reservation.endAt}">
                        ${reservation.endAt.year}년 ${reservation.endAt.monthValue}월 ${reservation.endAt.dayOfMonth}일 
                        ${reservation.endAt.hour}시 
                        <c:if test="${reservation.endAt.minute > 0}">${reservation.endAt.minute}분</c:if>
                    </c:if>
                    <c:if test="${empty reservation.endAt}">
                        -
                    </c:if>
                </div>

            </div>
        </div>

        <!-- 메모 -->
        <c:if test="${not empty reservation.memo}">
            <div class="memo-section">
                <div class="info-label" style="margin-bottom: 12px;">메모</div>
                <div class="memo-content">${reservation.memo}</div>
            </div>
        </c:if>

        <!-- 가상계좌 정보 -->
        <c:if test="${allAccountNos != null && !allAccountNos.isEmpty()}">
            <div class="divider"></div>
            <div class="account-section">
                <div class="account-title">입금 계좌 정보</div>
                <p style="color: var(--gray-600); font-size: 14px; margin-bottom: 16px;">
                    아래 계좌 중 하나로 입금해주세요
                </p>
                <ul class="account-list">
                    <c:forEach var="entry" items="${allAccountNos}">
                        <li class="account-item">
                            <div class="account-bank">${entry.key}</div>
                            <div class="account-number">${entry.value}</div>
                        </li>
                    </c:forEach>
                </ul>
            </div>
        </c:if>
        </div>
    </div>

    <!-- 액션 버튼 -->
    <div class="detail-actions">
        <a href="/reservations" class="btn btn-outline">목록으로</a>
        
        <div class="action-buttons">
            <!-- 관리자 버튼 -->
            <sec:authorize access="hasRole('ADMIN')">
                <c:if test="${reservation.status != 'CONFIRMED'}">
                    <form action="/payments/${vaId}/confirm" method="post" style="display: inline;">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <input type="hidden" name="vaId" value="${vaId}">
                        <input type="hidden" name="amount" value="${reservation.amount}">
                        <button type="submit" class="btn btn-brown">입금확정</button>
                    </form>
                </c:if>
                <c:if test="${reservation.status != 'CANCELLED'}">
                    <form action="/reservations/cancel/${reservation.id}" method="post" style="display: inline;">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <input type="hidden" name="id" value="${reservation.id}">
                        <button type="submit" class="btn" 
                                style="background: var(--gray-400); color: var(--white);"
                                onclick="return confirm('정말 예약을 취소하시겠습니까?');">예약취소</button>
                    </form>
                </c:if>
            </sec:authorize>

            <!-- 사용자 버튼 (관리자 제외) -->
            <sec:authorize access="hasRole('USER') and !hasRole('ADMIN')">
                <c:if test="${reservation.status != 'CANCELLED' && reservation.status != 'CONFIRMED'}">
                    <form action="/reservations/cancel/${reservation.id}" method="post" style="display: inline;">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <input type="hidden" name="id" value="${reservation.id}">
                        <button type="submit" class="btn" 
                                style="background: var(--gray-400); color: var(--white);"
                                onclick="return confirm('정말 예약을 취소하시겠습니까?');">예약취소</button>
                    </form>
                </c:if>
            </sec:authorize>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/views/components/footer.jsp" %>
</body>
</html>
