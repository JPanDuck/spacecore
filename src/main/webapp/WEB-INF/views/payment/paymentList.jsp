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
    <title>결제 목록 | Space Core</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .payment-list-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 40px 20px;
        }

        .list-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid var(--cream-tan);
        }

        .list-title {
            font-size: 32px;
            font-weight: 700;
            color: var(--choco);
        }

        .payment-table {
            width: 100%;
            background: var(--white);
            border-radius: var(--radius-lg);
            overflow: hidden;
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--gray-200);
        }

        .payment-table thead {
            background: var(--cream-tan);
        }

        .payment-table th {
            padding: 18px 20px;
            text-align: left;
            font-weight: 600;
            color: var(--choco);
            font-size: 15px;
            border-bottom: 2px solid var(--mocha);
        }

        .payment-table td {
            padding: 18px 20px;
            border-bottom: 1px solid var(--gray-200);
            color: var(--text-primary);
            font-size: 14px;
        }

        .payment-table tbody tr:hover {
            background: var(--gray-100);
            transition: var(--transition);
        }

        .payment-table tbody tr:last-child td {
            border-bottom: none;
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

        .detail-link {
            color: var(--amber);
            font-weight: 500;
            text-decoration: none;
            transition: var(--transition);
        }

        .detail-link:hover {
            color: var(--mocha);
            text-decoration: underline;
        }

        .empty-state {
            text-align: center;
            padding: 80px 20px;
            color: var(--gray-600);
        }

        .empty-state-icon {
            font-size: 48px;
            margin-bottom: 16px;
            opacity: 0.5;
        }

        .empty-state-text {
            font-size: 16px;
        }

        .amount {
            font-weight: 600;
            color: var(--amber);
        }

        .username {
            color: var(--text-primary);
        }

        .reservant-name {
            color: var(--choco);
            font-weight: 500;
        }

        .datetime {
            color: var(--gray-700);
            font-size: 13px;
        }
    </style>
</head>
<body>
<%@ include file="/WEB-INF/views/components/header.jsp" %>

<div class="payment-list-container">
    <div class="list-header">
        <h1 class="list-title">결제 목록</h1>
    </div>

    <c:choose>
        <c:when test="${not empty paymentList && paymentList.size() > 0}">
            <table class="payment-table">
                <thead>
                    <tr>
                        <th style="width: 80px;">결제번호</th>
                        <th style="width: 120px;">로그인 ID</th>
                        <th style="width: 120px;">이용자</th>
                        <th style="width: 100px;">가상계좌 ID</th>
                        <th style="width: 120px;">금액</th>
                        <th style="width: 100px;">상태</th>
                        <th style="width: 180px;">확정 시간</th>
                        <th style="width: 80px;">상세</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="payment" items="${paymentList}">
                        <tr>
                            <td>${payment.id}</td>
                            <td class="username">
                                <c:out value="${payment.username != null ? payment.username : '-'}"/>
                            </td>
                            <td class="reservant-name">
                                <c:out value="${payment.reservantName != null ? payment.reservantName : '-'}"/>
                            </td>
                            <td>
                                ${payment.vaId != null ? payment.vaId : '-'}
                            </td>
                            <td class="amount">
                                <fmt:formatNumber value="${payment.amount}" type="number"/>원
                            </td>
                            <td>
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
                            </td>
                            <td class="datetime">
                                <c:choose>
                                    <c:when test="${not empty payment.createdAt}">
                                        ${fn:substring(payment.createdAt, 0, 19)}
                                    </c:when>
                                    <c:otherwise>
                                        -
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <a href="/payments/detail/${payment.id}" class="detail-link">보기</a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:when>
        <c:otherwise>
            <div class="empty-state">
                <div class="empty-state-icon">💳</div>
                <div class="empty-state-text">등록된 결제 내역이 없습니다.</div>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<%@ include file="/WEB-INF/views/components/footer.jsp" %>
</body>
</html>
