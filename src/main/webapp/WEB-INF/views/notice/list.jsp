<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<% String context = request.getContextPath(); %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>공지사항 | Space Core</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .notice-list-container {
            max-width: 1200px;
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

        .list-actions {
            display: flex;
            gap: 12px;
        }

        .notice-table {
            width: 100%;
            background: var(--white);
            border-radius: var(--radius-lg);
            overflow: hidden;
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--gray-200);
        }

        .notice-table thead {
            background: var(--cream-tan);
        }

        .notice-table th {
            padding: 18px 20px;
            text-align: left;
            font-weight: 600;
            color: var(--choco);
            font-size: 15px;
            border-bottom: 2px solid var(--mocha);
        }

        .notice-table td {
            padding: 18px 20px;
            border-bottom: 1px solid var(--gray-200);
            color: var(--text-primary);
        }

        .notice-table tbody tr:hover {
            background: var(--gray-100);
            transition: var(--transition);
        }

        .notice-table tbody tr:last-child td {
            border-bottom: none;
        }

        .notice-type {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 13px;
            font-weight: 600;
        }

        .notice-type.important {
            background: var(--amber);
            color: var(--white);
        }

        .notice-type.normal {
            background: var(--gray-200);
            color: var(--gray-700);
        }

        .notice-title {
            font-weight: 500;
            color: var(--choco);
            transition: var(--transition);
        }

        .notice-title:hover {
            color: var(--amber);
        }

        .notice-date {
            color: var(--gray-600);
            font-size: 14px;
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
    </style>
</head>
<body>
<%@ include file="/WEB-INF/views/components/header.jsp" %>

<div class="notice-list-container">
    <div class="list-header">
        <h1 class="list-title">공지사항</h1>
        <div class="list-actions">
            <sec:authorize access="hasRole('ADMIN')">
                <a href="/notices/add" class="btn btn-brown">공지 등록</a>
            </sec:authorize>
        </div>
    </div>

    <c:choose>
        <c:when test="${not empty noticeList && noticeList.size() > 0}">
            <table class="notice-table">
                <thead>
                    <tr>
                        <th style="width: 100px;">구분</th>
                        <th>제목</th>
                        <th style="width: 150px;">작성일</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="notice" items="${noticeList}">
                        <tr>
                            <td>
                                <span class="notice-type ${notice.pinned == 'Y' ? 'important' : 'normal'}">
                                    ${notice.pinned == 'Y' ? '중요' : '일반'}
                                </span>
                            </td>
                            <td>
                                <a href="/notices/detail/${notice.id}" class="notice-title">
                                    ${notice.title}
                                </a>
                            </td>
                            <td class="notice-date">
                                ${fn:replace(notice.createdAt, '-', '.')}
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:when>
        <c:otherwise>
            <div class="empty-state">
                <div class="empty-state-icon">📢</div>
                <div class="empty-state-text">등록된 공지사항이 없습니다.</div>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<%@ include file="/WEB-INF/views/components/footer.jsp" %>
</body>
</html>
