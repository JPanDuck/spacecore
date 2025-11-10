<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>사용자 관리 | Space Core</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/phosphor-icons@1.4.2/dist/phosphor.css">
    <style>
        .admin-container {
            max-width: 1400px;
            margin: 40px auto;
            padding: 20px;
        }

        .admin-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding: 30px;
            background: linear-gradient(135deg, var(--choco) 0%, var(--amber) 100%);
            border-radius: 12px;
            color: var(--white);
        }

        .admin-header h1 {
            font-size: 32px;
            font-weight: 700;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .user-table-container {
            background: var(--white);
            border-radius: 12px;
            box-shadow: var(--shadow-sm);
            overflow: hidden;
        }

        .user-table {
            width: 100%;
            border-collapse: collapse;
        }

        .user-table thead {
            background: var(--cream-tan);
        }

        .user-table th {
            padding: 18px 20px;
            text-align: left;
            font-weight: 700;
            font-size: 15px;
            color: var(--choco);
            border-bottom: 2px solid var(--gray-300);
        }

        .user-table td {
            padding: 20px;
            border-bottom: 1px solid var(--gray-200);
            vertical-align: middle;
            font-size: 14px;
            color: var(--text-primary);
        }

        .user-table tbody tr {
            transition: background 0.2s ease;
        }

        .user-table tbody tr:hover {
            background: var(--gray-50);
        }

        .user-table tbody tr:last-child td {
            border-bottom: none;
        }

        .user-id {
            font-weight: 600;
            color: var(--amber);
            width: 80px;
        }

        .user-username {
            font-weight: 600;
            color: var(--text-primary);
            width: 150px;
        }

        .user-name {
            width: 120px;
        }

        .user-email {
            width: 200px;
            color: var(--gray-600);
        }

        .user-phone {
            width: 130px;
            color: var(--gray-600);
        }

        .user-role {
            width: 100px;
        }

        .role-badge {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 600;
        }

        .role-badge.ADMIN {
            background: var(--choco);
            color: var(--white);
        }

        .role-badge.USER {
            background: var(--cream-tan);
            color: var(--choco);
        }

        .user-status {
            width: 100px;
        }

        .status-badge {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 600;
        }

        .status-badge.ACTIVE {
            background: #10b981;
            color: var(--white);
        }

        .status-badge.SUSPENDED {
            background: #ef4444;
            color: var(--white);
        }

        .user-provider {
            width: 100px;
            font-size: 12px;
            color: var(--gray-600);
        }

        .user-date {
            width: 160px;
            color: var(--gray-600);
            font-size: 13px;
        }

        .user-actions {
            width: 180px;
        }

        .action-btn {
            padding: 8px 16px;
            border: none;
            border-radius: 6px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-right: 8px;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            text-decoration: none;
        }

        .btn-detail {
            background: var(--choco);
            color: var(--white);
        }

        .btn-detail:hover {
            background: var(--amber);
            transform: translateY(-2px);
            box-shadow: 0 2px 8px rgba(91, 59, 49, 0.3);
        }

        .btn-edit {
            background: #3b82f6;
            color: var(--white);
        }

        .btn-edit:hover {
            background: #2563eb;
            transform: translateY(-2px);
            box-shadow: 0 2px 8px rgba(59, 130, 246, 0.3);
        }

        .btn-delete {
            background: #dc3545;
            color: var(--white);
        }

        .btn-delete:hover {
            background: #c82333;
            transform: translateY(-2px);
            box-shadow: 0 2px 8px rgba(220, 53, 69, 0.3);
        }

        .empty-state {
            text-align: center;
            padding: 80px 20px;
            color: var(--gray-600);
        }

        .empty-state-icon {
            font-size: 64px;
            color: var(--gray-400);
            margin-bottom: 20px;
        }

        .empty-state h3 {
            font-size: 24px;
            margin-bottom: 12px;
            color: var(--text-primary);
        }

        .empty-state p {
            font-size: 16px;
            color: var(--gray-600);
            margin-bottom: 30px;
        }

        .info-message {
            padding: 12px 20px;
            background: #d1fae5;
            color: #065f46;
            border-radius: 8px;
            margin-bottom: 20px;
            font-weight: 600;
        }

        @media (max-width: 1200px) {
            .user-email, .user-phone {
                max-width: 150px;
            }
        }

        @media (max-width: 768px) {
            .admin-container {
                padding: 10px;
            }

            .admin-header {
                flex-direction: column;
                gap: 20px;
                padding: 20px;
            }

            .admin-header h1 {
                font-size: 24px;
            }

            .user-table {
                font-size: 12px;
            }

            .user-table th,
            .user-table td {
                padding: 12px 8px;
            }

            .user-actions {
                width: auto;
            }

            .action-btn {
                padding: 6px 12px;
                font-size: 12px;
                margin-bottom: 4px;
            }
        }
    </style>
</head>
<body>
<!-- ✅ 헤더 include -->
<%@ include file="../components/header.jsp" %>

<div class="admin-container">
    <div class="admin-header">
        <h1>
            <i class="ph ph-users"></i>
            사용자 관리
        </h1>
    </div>

    <c:if test="${not empty message}">
        <div class="info-message">
            ${message}
        </div>
    </c:if>


    <!-- 사용자 목록 테이블 -->
    <div class="user-table-container">
        <c:choose>
            <c:when test="${empty users}">
                <div class="empty-state">
                    <div class="empty-state-icon">
                        <i class="ph ph-users"></i>
                    </div>
                    <h3>등록된 사용자가 없습니다</h3>
                    <p>아직 등록된 사용자가 없습니다.</p>
                </div>
            </c:when>
            <c:otherwise>
                <table class="user-table">
                    <thead>
                    <tr>
                        <th class="user-id">ID</th>
                        <th class="user-username">아이디</th>
                        <th class="user-name">이름</th>
                        <th class="user-email">이메일</th>
                        <th class="user-phone">전화번호</th>
                        <th class="user-role">역할</th>
                        <th class="user-status">상태</th>
                        <th class="user-provider">로그인 방식</th>
                        <th class="user-date">가입일</th>
                        <th class="user-actions">관리</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="user" items="${users}">
                        <tr id="user-row-${user.id}">
                            <td class="user-id">${user.id}</td>
                            <td class="user-username">${user.username}</td>
                            <td class="user-name">${user.name}</td>
                            <td class="user-email">${user.email}</td>
                            <td class="user-phone">${user.phone != null ? user.phone : '-'}</td>
                            <td class="user-role">
                                <span class="role-badge ${user.role}">${user.role}</span>
                            </td>
                            <td class="user-status">
                                <span class="status-badge ${user.status}">${user.status == 'ACTIVE' ? '활성' : '정지'}</span>
                            </td>
                            <td class="user-provider">${user.provider != null ? user.provider : '일반'}</td>
                            <td class="user-date">${user.createdAtStr}</td>
                            <td class="user-actions">
                                <a href="${pageContext.request.contextPath}/admin/${user.id}" class="action-btn btn-detail">
                                    <i class="ph ph-eye"></i>
                                    상세
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/${user.id}/edit" class="action-btn btn-edit">
                                    <i class="ph ph-pencil"></i>
                                    수정
                                </a>
                                <button class="action-btn btn-delete" onclick="deleteUser(${user.id}, '${user.username}')">
                                    <i class="ph ph-trash"></i>
                                    삭제
                                </button>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
    </div>

</div>

<!-- ✅ 푸터 include -->
<%@ include file="../components/footer.jsp" %>

<script>
    // 사용자 삭제 함수
    function deleteUser(id, username) {
        if (!confirm('정말로 사용자 "' + username + '" (ID: ' + id + ')를 삭제하시겠습니까?\n이 작업은 되돌릴 수 없습니다.')) {
            return;
        }

        // CSRF 토큰이 필요한 경우 여기에 추가
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = '${pageContext.request.contextPath}/admin/' + id + '/delete';
        
        // CSRF 토큰 추가 (Spring Security 사용 시)
        const csrfToken = document.querySelector('meta[name="_csrf"]');
        if (csrfToken) {
            const csrfInput = document.createElement('input');
            csrfInput.type = 'hidden';
            csrfInput.name = '_csrf';
            csrfInput.value = csrfToken.getAttribute('content');
            form.appendChild(csrfInput);
        }

        document.body.appendChild(form);
        form.submit();
    }
</script>
</body>
</html>
