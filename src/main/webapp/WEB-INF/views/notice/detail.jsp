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
    <title>${notice.title} | Space Core</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .notice-detail-container {
            max-width: 900px;
            margin: 0 auto;
            padding: 40px 20px;
        }

        .detail-header {
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid var(--cream-tan);
        }

        .detail-title {
            font-size: 28px;
            font-weight: 700;
            color: var(--choco);
            margin-bottom: 16px;
            line-height: 1.4;
        }

        .detail-meta {
            display: flex;
            align-items: center;
            gap: 16px;
            color: var(--gray-600);
            font-size: 14px;
        }

        .detail-type {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 13px;
            font-weight: 600;
        }

        .detail-type.important {
            background: var(--amber);
            color: var(--white);
        }

        .detail-type.normal {
            background: var(--gray-200);
            color: var(--gray-700);
        }

        .detail-content {
            background: var(--white);
            padding: 40px;
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--gray-200);
            margin-bottom: 30px;
            min-height: 300px;
            line-height: 1.8;
            color: var(--text-primary);
            white-space: pre-wrap;
            word-wrap: break-word;
        }

        .detail-actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 20px;
            border-top: 1px solid var(--gray-200);
        }

        .action-buttons {
            display: flex;
            gap: 12px;
        }

        .btn-group {
            display: flex;
            gap: 12px;
        }
    </style>
</head>
<body>
<%@ include file="/WEB-INF/views/components/header.jsp" %>

<div class="notice-detail-container">
    <div class="detail-header">
        <h1 class="detail-title">${notice.title}</h1>
        <div class="detail-meta">
            <span class="detail-type ${notice.pinned == 'Y' ? 'important' : 'normal'}">
                ${notice.pinned == 'Y' ? '중요' : '일반'}
            </span>
            <span>작성일: ${fn:replace(notice.createdAt, '-', '.')}</span>
        </div>
    </div>

    <div class="detail-content">
        ${notice.content}
    </div>

    <div class="detail-actions">
        <a href="/notices" class="btn btn-outline">목록으로</a>
        <sec:authorize access="hasRole('ADMIN')">
            <div class="btn-group">
                <a href="/notices/edit/${notice.id}" class="btn btn-brown">수정</a>
                <form action="/notices/delete/${notice.id}" method="post" style="display: inline;">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <button type="submit" class="btn" style="background: var(--gray-400); color: var(--white);" 
                            onclick="return confirm('정말 삭제하시겠습니까?');">삭제</button>
                </form>
            </div>
        </sec:authorize>
    </div>
</div>

<%@ include file="/WEB-INF/views/components/footer.jsp" %>
</body>
</html>
