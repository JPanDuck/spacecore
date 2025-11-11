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
    <title>예약 목록 | Space Core</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .reservation-list-container {
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

        .reservation-table {
            width: 100%;
            background: var(--white);
            border-radius: var(--radius-lg);
            overflow: hidden;
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--gray-200);
        }

        .reservation-table thead {
            background: var(--cream-tan);
        }

        .reservation-table th {
            padding: 18px 20px;
            text-align: left;
            font-weight: 600;
            color: var(--choco);
            font-size: 15px;
            border-bottom: 2px solid var(--mocha);
        }

        .reservation-table td {
            padding: 18px 20px;
            border-bottom: 1px solid var(--gray-200);
            color: var(--text-primary);
            font-size: 14px;
        }

        .reservation-table tbody tr:hover {
            background: var(--gray-100);
            transition: var(--transition);
        }

        .reservation-table tbody tr:last-child td {
            border-bottom: none;
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

        .room-name {
            font-weight: 500;
            color: var(--choco);
        }

        .reservant-name {
            color: var(--text-primary);
        }

        .datetime {
            color: var(--gray-700);
            font-size: 13px;
        }

        .amount {
            font-weight: 600;
            color: var(--amber);
        }
    </style>
</head>
<body>
<%@ include file="/WEB-INF/views/components/header.jsp" %>

<div class="reservation-list-container">
    <div class="list-header">
        <h1 class="list-title">예약 목록</h1>
    </div>

    <c:choose>
        <c:when test="${not empty reservationList && reservationList.size() > 0}">
            <table class="reservation-table">
                <thead>
                    <tr>
                        <th style="width: 80px;">예약번호</th>
                        <th style="width: 120px;">예약자</th>
                        <th>객실</th>
                        <th style="width: 180px;">시작 시간</th>
                        <th style="width: 180px;">종료 시간</th>
                        <th style="width: 120px;">금액</th>
                        <th style="width: 100px;">상태</th>
                        <th style="width: 150px;">작업</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="reservation" items="${reservationList}">
                        <tr>
                            <td>${reservation.id}</td>
                            <td class="reservant-name">
                                <c:choose>
                                    <c:when test="${not empty reservation.reservantName}">
                                        ${reservation.reservantName}
                                    </c:when>
                                    <c:otherwise>
                                        ${reservation.userName != null ? reservation.userName : '-'}
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <span class="room-name">
                                    <c:choose>
                                        <c:when test="${not empty reservation.roomName}">
                                            ${reservation.roomName}
                                        </c:when>
                                        <c:otherwise>
                                            -
                                        </c:otherwise>
                                    </c:choose>
                                </span>
                            </td>
                            <td class="datetime">
                                <c:if test="${not empty reservation.startAt}">
                                    ${reservation.startAt.year}.${reservation.startAt.monthValue}.${reservation.startAt.dayOfMonth} 
                                    ${reservation.startAt.hour}시
                                    <c:if test="${reservation.startAt.minute > 0}">${reservation.startAt.minute}분</c:if>
                                </c:if>
                                <c:if test="${empty reservation.startAt}">-</c:if>
                            </td>
                            <td class="datetime">
                                <c:if test="${not empty reservation.endAt}">
                                    ${reservation.endAt.year}.${reservation.endAt.monthValue}.${reservation.endAt.dayOfMonth} 
                                    ${reservation.endAt.hour}시
                                    <c:if test="${reservation.endAt.minute > 0}">${reservation.endAt.minute}분</c:if>
                                </c:if>
                                <c:if test="${empty reservation.endAt}">-</c:if>
                            </td>
                            <td class="amount">
                                <fmt:formatNumber value="${reservation.amount}" type="number"/>원
                            </td>
                            <td>
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
                            </td>
                            <td>
                                <div style="display: flex; gap: 8px; align-items: center;">
                                    <a href="/reservations/detail/${reservation.id}" class="detail-link">상세</a>
                                    <sec:authorize access="hasRole('USER') and !hasRole('ADMIN')">
                                        <c:if test="${reservation.status == 'CONFIRMED' && reservation.roomId != null}">
                                            <a href="/reviews/create?roomId=${reservation.roomId}" 
                                               style="color: var(--amber); font-weight: 500; text-decoration: none; font-size: 13px; padding: 4px 8px; border: 1px solid var(--amber); border-radius: var(--radius-md); transition: var(--transition);"
                                               onmouseover="this.style.background='var(--amber)'; this.style.color='var(--white)';"
                                               onmouseout="this.style.background='transparent'; this.style.color='var(--amber)';">리뷰 작성</a>
                                        </c:if>
                                    </sec:authorize>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:when>
        <c:otherwise>
            <div class="empty-state">
                <div class="empty-state-icon">📅</div>
                <div class="empty-state-text">등록된 예약이 없습니다.</div>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<%@ include file="/WEB-INF/views/components/footer.jsp" %>
</body>
</html>
