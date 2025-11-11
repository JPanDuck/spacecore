<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>사용자 상세정보 | Space Core</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/phosphor-icons@1.4.2/dist/phosphor.css">
    <style>
        .admin-container {
            max-width: 1000px;
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

        .detail-container {
            background: var(--white);
            border-radius: 12px;
            box-shadow: var(--shadow-sm);
            padding: 40px;
            margin-bottom: 24px;
        }

        .detail-section {
            margin-bottom: 30px;
        }

        .detail-section:last-child {
            margin-bottom: 0;
        }

        .detail-section-title {
            font-size: 20px;
            font-weight: 700;
            color: var(--choco);
            margin-bottom: 20px;
            padding-bottom: 12px;
            border-bottom: 2px solid var(--cream-tan);
        }

        .detail-grid {
            display: grid;
            grid-template-columns: 200px 1fr;
            gap: 20px;
            margin-bottom: 16px;
        }

        .detail-label {
            font-weight: 600;
            color: var(--text-primary);
            display: flex;
            align-items: center;
        }

        .detail-value {
            color: var(--text-primary);
            word-break: break-word;
        }

        .badge {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 12px;
            font-size: 13px;
            font-weight: 600;
        }

        .badge-role-ADMIN {
            background: var(--choco);
            color: var(--white);
        }

        .badge-role-USER {
            background: var(--cream-tan);
            color: var(--choco);
        }

        .badge-status-ACTIVE {
            background: #10b981;
            color: var(--white);
        }

        .badge-status-SUSPENDED {
            background: #ef4444;
            color: var(--white);
        }

        .badge-provider {
            background: var(--gray-200);
            color: var(--text-primary);
            font-size: 12px;
        }

        .badge-provider-google {
            background: #4285F4;
            color: var(--white);
        }

        .badge-provider-kakao {
            background: #FEE500;
            color: #000;
        }

        .badge-provider-naver {
            background: #03C75A;
            color: var(--white);
        }

        .badge-provider-general {
            background: var(--gray-200);
            color: var(--text-primary);
        }

        .action-buttons {
            display: flex;
            gap: 12px;
            margin-top: 30px;
            padding-top: 30px;
            border-top: 2px solid var(--cream-tan);
        }

        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-primary {
            background: var(--choco);
            color: var(--white);
        }

        .btn-primary:hover {
            background: var(--amber);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        }

        .btn-secondary {
            background: #3b82f6;
            color: var(--white);
        }

        .btn-secondary:hover {
            background: #2563eb;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(59, 130, 246, 0.3);
        }

        .btn-danger {
            background: #dc3545;
            color: var(--white);
        }

        .btn-danger:hover {
            background: #c82333;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(220, 53, 69, 0.3);
        }

        .btn-outline {
            background: var(--white);
            color: var(--text-primary);
            border: 2px solid var(--gray-300);
        }

        .btn-outline:hover {
            border-color: var(--amber);
            color: var(--amber);
        }

        .info-message {
            padding: 12px 20px;
            background: #d1fae5;
            color: #065f46;
            border-radius: 8px;
            margin-bottom: 20px;
            font-weight: 600;
        }

        .warning-message {
            padding: 12px 20px;
            background: #fef3c7;
            color: #92400e;
            border-radius: 8px;
            margin-bottom: 20px;
            font-weight: 600;
        }

        .password-reset-message {
            margin-top: 20px;
            padding: 12px 16px;
            border-radius: 8px;
            font-weight: 600;
        }

        .password-reset-message.success {
            background: #d1fae5;
            color: #065f46;
        }

        .password-reset-message.error {
            background: #fee2e2;
            color: #991b1b;
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

            .detail-container {
                padding: 20px;
            }

            .detail-grid {
                grid-template-columns: 1fr;
                gap: 12px;
            }

            .detail-label {
                margin-bottom: 4px;
            }

            .action-buttons {
                flex-direction: column;
            }

            .btn {
                width: 100%;
                justify-content: center;
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
            <i class="ph ph-user-circle"></i>
            사용자 상세정보
        </h1>
        <a href="${pageContext.request.contextPath}/admin/list" class="btn btn-outline" style="background: var(--white); color: var(--choco);">
            <i class="ph ph-arrow-left"></i>
            목록으로
        </a>
    </div>

<c:if test="${not empty message}">
        <div class="info-message">
            ${message}
        </div>
</c:if>

    <div class="detail-container">
        <!-- 기본 정보 -->
        <div class="detail-section">
            <h2 class="detail-section-title">기본 정보</h2>
            <div class="detail-grid">
                <div class="detail-label">사용자 ID</div>
                <div class="detail-value">${user.id}</div>

                <div class="detail-label">아이디</div>
                <div class="detail-value">${user.username}</div>

                <div class="detail-label">이름</div>
                <div class="detail-value">${user.name}</div>

                <div class="detail-label">이메일</div>
                <div class="detail-value">${user.email}</div>

                <div class="detail-label">전화번호</div>
                <div class="detail-value">${user.phone != null ? user.phone : '-'}</div>
            </div>
        </div>

        <!-- 계정 정보 -->
        <div class="detail-section">
            <h2 class="detail-section-title">계정 정보</h2>
            <div class="detail-grid">
                <div class="detail-label">역할</div>
                <div class="detail-value">
                    <span class="badge badge-role-${user.role}">${user.role}</span>
                </div>

                <div class="detail-label">상태</div>
                <div class="detail-value">
                    <span class="badge badge-status-${user.status}">${user.status == 'ACTIVE' ? '활성' : '정지'}</span>
                </div>

                <div class="detail-label">로그인 방식</div>
                <div class="detail-value">
                    <c:choose>
                        <c:when test="${not empty user.provider}">
                            <c:choose>
                                <c:when test="${user.provider eq 'google'}">
                                    <span class="badge badge-provider-google">Google 로그인</span>
                                </c:when>
                                <c:when test="${user.provider eq 'kakao'}">
                                    <span class="badge badge-provider-kakao">Kakao 로그인</span>
                                </c:when>
                                <c:when test="${user.provider eq 'naver'}">
                                    <span class="badge badge-provider-naver">Naver 로그인</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-provider-general">${user.provider} 로그인</span>
                                </c:otherwise>
                            </c:choose>
                        </c:when>
                        <c:otherwise>
                            <span class="badge badge-provider-general">일반 로그인</span>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="detail-label">임시 비밀번호</div>
                <div class="detail-value">
                    ${user.isTempPassword == 'Y' ? '<span class="badge badge-status-SUSPENDED">임시 비밀번호</span>' : '<span class="badge badge-status-ACTIVE">일반</span>'}
                </div>
            </div>
        </div>

        <!-- 날짜 정보 -->
        <div class="detail-section">
            <h2 class="detail-section-title">날짜 정보</h2>
            <div class="detail-grid">
                <div class="detail-label">가입일</div>
                <div class="detail-value">${user.createdAtStr}</div>

                <div class="detail-label">수정일</div>
                <div class="detail-value">${user.updatedAtStr}</div>
            </div>
        </div>

        <!-- 관리 기능 -->
        <div class="action-buttons">
            <a href="${pageContext.request.contextPath}/admin/${user.id}/edit" class="btn btn-primary">
                <i class="ph ph-pencil"></i>
                정보 수정
            </a>
            <!-- 일반 로그인 사용자만 비밀번호 초기화 버튼 표시 -->
            <c:if test="${empty user.provider}">
                <button type="button" class="btn btn-secondary" data-user-id="${user.id}" onclick="resetPassword(this.getAttribute('data-user-id'))">
                    <i class="ph ph-key"></i>
                    비밀번호 초기화
                </button>
            </c:if>
            <!-- 예약 차단/해제 버튼 (USER 역할만) -->
            <c:if test="${user.role == 'USER'}">
                <c:choose>
                    <c:when test="${user.status == 'ACTIVE'}">
                        <form method="post" action="${pageContext.request.contextPath}/admin/${user.id}/block-reservation" style="display: inline;">
                            <button type="submit" class="btn btn-danger" onclick="return confirm('이 사용자의 예약을 차단하시겠습니까?\n사용자 상태가 정지로 변경됩니다.');">
                                <i class="ph ph-lock"></i>
                                예약 차단
                            </button>
                        </form>
                    </c:when>
                    <c:when test="${user.status == 'SUSPENDED'}">
                        <form method="post" action="${pageContext.request.contextPath}/admin/${user.id}/unblock-reservation" style="display: inline;">
                            <button type="submit" class="btn btn-success" onclick="return confirm('이 사용자의 예약 차단을 해제하시겠습니까?\n사용자 상태가 활성으로 변경됩니다.');">
                                <i class="ph ph-unlock"></i>
                                예약 차단 해제
                            </button>
                        </form>
                    </c:when>
                </c:choose>
            </c:if>
            <form method="post" action="${pageContext.request.contextPath}/admin/${user.id}/delete" style="display: inline;">
                <button type="submit" class="btn btn-danger" data-username="${user.username}" data-user-id="${user.id}" onclick="return confirmDelete(this.getAttribute('data-username'), this.getAttribute('data-user-id'))">
                    <i class="ph ph-trash"></i>
                    사용자 삭제
                </button>
</form>
            <a href="${pageContext.request.contextPath}/admin/list" class="btn btn-outline">
                <i class="ph ph-list"></i>
                목록으로
            </a>
        </div>

        <!-- 비밀번호 초기화 결과 메시지 -->
        <c:if test="${empty user.provider}">
            <div id="passwordResetMsg" class="password-reset-message" style="display: none; margin-top: 20px;"></div>
        </c:if>
    </div>
</div>

<!-- ✅ 푸터 include -->
<%@ include file="../components/footer.jsp" %>

<script>
    function resetPassword(userId) {
        if (!confirm("정말로 비밀번호를 초기화하시겠습니까?\n임시 비밀번호가 발급됩니다.")) {
            return;
        }

        const msgDiv = document.getElementById("passwordResetMsg");
        if (!msgDiv) return;

        msgDiv.style.display = "none";
        msgDiv.className = "password-reset-message";

        fetch("${pageContext.request.contextPath}/api/admin/users/" + userId + "/reset-password", {
            method: "POST",
            credentials: "include"
        })
            .then(function(response) {
                if (!response.ok) {
                    throw new Error("서버 오류: " + response.status);
                }
                return response.json();
            })
            .then(function(data) {
                if (data.tempPassword) {
                    msgDiv.className = "password-reset-message success";
                    msgDiv.innerHTML = "✅ 비밀번호가 초기화되었습니다.<br><strong style='font-size: 16px; color: #065f46;'>임시 비밀번호: " + data.tempPassword + "</strong><br><small>이 비밀번호를 사용자에게 안전하게 전달하세요.</small>";
                    msgDiv.style.display = "block";
                } else {
                    msgDiv.className = "password-reset-message error";
                    msgDiv.innerHTML = "❌ " + (data.message || "비밀번호 초기화 실패");
                    msgDiv.style.display = "block";
                }
            })
            .catch(function(err) {
                msgDiv.className = "password-reset-message error";
                msgDiv.innerHTML = "❌ 서버 오류: " + err.message;
                msgDiv.style.display = "block";
            });
    }

    function confirmDelete(username, userId) {
        return confirm("정말로 사용자 \"" + username + "\" (ID: " + userId + ")를 삭제하시겠습니까?\n이 작업은 되돌릴 수 없습니다.");
    }
</script>
</body>
</html>
