<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    String context = request.getContextPath();
%>

<!-- ✅ 공통 헤더 -->
<%@ include file="/WEB-INF/views/components/header.jsp" %>
<link rel="stylesheet" href="<%=context%>/css/style.css">

<style>
    .qna-container {
        max-width: 1200px;
        margin: 40px auto;
        padding: 20px;
    }

    .qna-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 30px;
        padding: 30px;
        background: white;
        border-radius: 12px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    }

    .qna-header h1 {
        color: var(--choco);
        font-size: 28px;
        margin: 0;
    }

    .btn-write {
        padding: 12px 24px;
        background: var(--choco);
        color: white;
        border: none;
        border-radius: 8px;
        font-size: 14px;
        font-weight: 600;
        cursor: pointer;
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        gap: 8px;
        transition: all 0.3s;
    }

    .btn-write:hover {
        background: var(--amber);
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(0,0,0,0.15);
    }

    .qna-table-wrapper {
        background: white;
        border-radius: 12px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        overflow: hidden;
    }

    .qna-table {
        width: 100%;
        border-collapse: collapse;
    }

    .qna-table thead {
        background: var(--choco);
        color: white;
    }

    .qna-table thead th {
        padding: 16px;
        text-align: left;
        font-weight: 600;
        font-size: 14px;
    }

    .qna-table tbody tr {
        border-bottom: 1px solid var(--gray-200);
        transition: background 0.2s;
    }

    .qna-table tbody tr:hover {
        background: var(--gray-50);
    }

    .qna-table tbody td {
        padding: 16px;
        font-size: 14px;
        color: var(--gray-800);
    }

    .qna-table tbody td:first-child {
        width: 80px;
        text-align: center;
        color: var(--gray-600);
    }

    .qna-table tbody td:nth-child(2) {
        width: auto;
    }

    .qna-table tbody td:nth-child(3) {
        width: 120px;
        text-align: center;
    }

    .qna-table tbody td:nth-child(4) {
        width: 100px;
        text-align: center;
    }

    .qna-table tbody td:nth-child(5) {
        width: 150px;
        text-align: center;
        color: var(--gray-600);
    }

    .qna-title-link {
        color: var(--gray-800);
        text-decoration: none;
        display: flex;
        align-items: center;
        gap: 8px;
        transition: color 0.2s;
    }

    .qna-title-link:hover {
        color: var(--choco);
    }

    .qna-title-link .lock-icon {
        font-size: 16px;
        color: var(--amber);
    }

    .qna-private-text {
        color: var(--gray-500);
        font-style: italic;
    }

    .status-badge {
        display: inline-block;
        padding: 4px 12px;
        border-radius: 12px;
        font-size: 12px;
        font-weight: 600;
    }

    .status-answered {
        background: #e8f5e9;
        color: #2e7d32;
    }

    .status-pending {
        background: #fff3e0;
        color: #e65100;
    }

    .empty-state {
        text-align: center;
        padding: 60px 20px;
        color: var(--gray-500);
    }

    .empty-state i {
        font-size: 48px;
        margin-bottom: 16px;
        opacity: 0.5;
    }

    .empty-state p {
        font-size: 16px;
        margin: 0;
    }
</style>

<main class="qna-container">
    <div class="qna-header">
        <h1><i class="ph ph-chat-circle-dots"></i> 문의게시판</h1>
        <a href="<%=context%>/qna/write" class="btn-write">
            <i class="ph ph-plus"></i> 문의글 등록
        </a>
    </div>

    <div class="qna-table-wrapper">
        <table class="qna-table">
            <thead>
                <tr>
                    <th>번호</th>
                    <th>제목</th>
                    <th>작성자</th>
                    <th>상태</th>
                    <th>작성일</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty qnaList}">
                        <tr>
                            <td colspan="5">
                                <div class="empty-state">
                                    <i class="ph ph-file-x"></i>
                                    <p>등록된 문의글이 없습니다.</p>
                                </div>
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="item" items="${qnaList}">
                            <c:set var="isPrivate" value="${item.isPrivate eq 'Y'}" />
                            <c:set var="isAuthor" value="${currentUserId != null and currentUserId == item.userId}" />
                            <c:set var="isAdmin" value="${currentUserRole eq 'ADMIN'}" />
                            <c:set var="canAccess" value="${not isPrivate or isAuthor or isAdmin}" />

                            <tr>
                                <td>${item.id}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${canAccess}">
                                            <a href="<%=context%>/qna/detail/${item.id}" class="qna-title-link">
                                                <c:if test="${isPrivate}">
                                                    <i class="ph ph-lock lock-icon"></i>
                                                </c:if>
                                                ${item.title}
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="qna-private-text">
                                                <i class="ph ph-lock"></i> 비공개 글입니다.
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${item.name}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${item.status eq 'ANSWERED'}">
                                            <span class="status-badge status-answered">답변완료</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge status-pending">대기중</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${item.createdAtStr}</td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</main>

<%@ include file="/WEB-INF/views/components/footer.jsp" %>
