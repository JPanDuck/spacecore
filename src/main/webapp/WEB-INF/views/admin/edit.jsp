<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>사용자 정보 수정 | Space Core</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/phosphor-icons@1.4.2/dist/phosphor.css">
    <style>
        .admin-container {
            max-width: 800px;
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

        .form-container {
            background: var(--white);
            border-radius: 12px;
            box-shadow: var(--shadow-sm);
            padding: 40px;
            margin-bottom: 24px;
        }

        .form-section {
            margin-bottom: 30px;
        }

        .form-section:last-child {
            margin-bottom: 0;
        }

        .form-section-title {
            font-size: 20px;
            font-weight: 700;
            color: var(--choco);
            margin-bottom: 20px;
            padding-bottom: 12px;
            border-bottom: 2px solid var(--cream-tan);
        }

        .form-group {
            margin-bottom: 24px;
        }

        .form-label {
            display: block;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 8px;
            font-size: 15px;
        }

        .form-label.required::after {
            content: ' *';
            color: #ef4444;
        }

        .form-input {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid var(--gray-300);
            border-radius: 8px;
            font-size: 15px;
            transition: border-color 0.3s ease;
            box-sizing: border-box;
        }

        .form-input:focus {
            outline: none;
            border-color: var(--amber);
        }

        .form-input:disabled {
            background: var(--gray-100);
            cursor: not-allowed;
        }

        .form-select {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid var(--gray-300);
            border-radius: 8px;
            font-size: 15px;
            background: var(--white);
            cursor: pointer;
            transition: border-color 0.3s ease;
            box-sizing: border-box;
        }

        .form-select:focus {
            outline: none;
            border-color: var(--amber);
        }

        .form-help {
            font-size: 13px;
            color: var(--gray-600);
            margin-top: 6px;
        }

        .readonly-info {
            padding: 12px 16px;
            background: var(--gray-50);
            border: 2px solid var(--gray-200);
            border-radius: 8px;
            color: var(--gray-600);
            font-size: 15px;
        }

        .badge {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 12px;
            font-size: 13px;
            font-weight: 600;
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

        .password-reset-section {
            margin-top: 30px;
            padding-top: 30px;
            border-top: 2px solid var(--cream-tan);
        }

        .password-reset-section h3 {
            font-size: 18px;
            font-weight: 600;
            color: var(--choco);
            margin-bottom: 16px;
        }

        #tempMsg {
            margin-top: 12px;
            padding: 12px 16px;
            border-radius: 8px;
            font-weight: 600;
        }

        #tempMsg.success {
            background: #d1fae5;
            color: #065f46;
        }

        #tempMsg.error {
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

            .form-container {
                padding: 20px;
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
            <i class="ph ph-pencil"></i>
            사용자 정보 수정
        </h1>
        <a href="${pageContext.request.contextPath}/admin/${user.id}" class="btn btn-outline" style="background: var(--white); color: var(--choco);">
            <i class="ph ph-arrow-left"></i>
            돌아가기
        </a>
    </div>

    <c:if test="${not empty message}">
        <div class="info-message">
            ${message}
        </div>
    </c:if>

    <div class="form-container">
        <form method="post" action="${pageContext.request.contextPath}/admin/${user.id}/edit">
            <!-- 기본 정보 -->
            <div class="form-section">
                <h2 class="form-section-title">기본 정보</h2>

                <div class="form-group">
                    <label class="form-label">사용자 ID</label>
                    <div class="readonly-info">${user.id}</div>
                </div>

                <div class="form-group">
                    <label class="form-label">로그인 유형</label>
                    <div class="readonly-info">
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
                </div>

                <div class="form-group">
                    <label class="form-label">아이디</label>
                    <div class="readonly-info">${user.username}</div>
                    <div class="form-help">아이디는 수정할 수 없습니다.</div>
                </div>

                <div class="form-group">
                    <label class="form-label">이름</label>
                    <div class="readonly-info">${user.name}</div>
                    <div class="form-help">이름은 수정할 수 없습니다.</div>
                </div>

                <div class="form-group">
                    <label class="form-label">이메일</label>
                    <div class="readonly-info">${user.email}</div>
                    <div class="form-help">이메일은 수정할 수 없습니다.</div>
                </div>

                <div class="form-group">
                    <label class="form-label">전화번호</label>
                    <div class="readonly-info">${user.phone != null && !empty user.phone ? user.phone : '-'}</div>
                    <div class="form-help">전화번호는 수정할 수 없습니다.</div>
                </div>
            </div>

            <!-- 계정 정보 -->
            <div class="form-section">
                <h2 class="form-section-title">계정 정보</h2>

                <div class="form-group">
                    <label for="status" class="form-label required">상태</label>
                    <select id="status" name="status" class="form-select" required>
                        <option value="ACTIVE" ${user.status == 'ACTIVE' ? 'selected' : ''}>활성 (ACTIVE)</option>
                        <option value="SUSPENDED" ${user.status == 'SUSPENDED' ? 'selected' : ''}>정지 (SUSPENDED)</option>
                    </select>
                    <div class="form-help">활성: 정상 사용 가능, 정지: 계정 사용 불가</div>
                </div>
            </div>

            <!-- 제출 버튼 -->
            <div class="action-buttons">
                <button type="submit" class="btn btn-primary">
                    <i class="ph ph-check"></i>
                    수정 완료
                </button>
                <a href="${pageContext.request.contextPath}/admin/${user.id}" class="btn btn-outline">
                    <i class="ph ph-x"></i>
                    취소
                </a>
                <a href="${pageContext.request.contextPath}/admin/list" class="btn btn-outline">
                    <i class="ph ph-list"></i>
                    목록으로
                </a>
            </div>
        </form>

        <!-- 일반 계정만 비밀번호 초기화 -->
        <c:if test="${empty user.provider}">
            <div class="password-reset-section">
                <h3>
                    <i class="ph ph-key"></i>
                    비밀번호 관리
                </h3>
                <button type="button" class="btn btn-danger" onclick="resetPassword(${user.id})">
                    <i class="ph ph-key"></i>
                    비밀번호 초기화
                </button>
                <div id="tempMsg"></div>
            </div>
        </c:if>
    </div>
</div>

<!-- ✅ 푸터 include -->
<%@ include file="../components/footer.jsp" %>

<script>
    function resetPassword(userId) {
        if (!confirm("정말 이 사용자의 비밀번호를 초기화하시겠습니까?\n임시 비밀번호가 발급됩니다.")) {
            return;
        }

        const tempMsgDiv = document.getElementById("tempMsg");
        tempMsgDiv.innerHTML = "";
        tempMsgDiv.className = "";

        fetch("${pageContext.request.contextPath}/api/admin/users/" + userId + "/reset-password", {
            method: "POST",
            credentials: "include"
        })
            .then(response => {
                if (!response.ok) {
                    throw new Error("서버 오류: " + response.status);
                }
                return response.json();
            })
            .then(data => {
                if (data.tempPassword) {
                    tempMsgDiv.className = "success";
                    tempMsgDiv.innerHTML = "✅ 임시 비밀번호: <b style='font-size: 16px; color: #065f46;'>" + data.tempPassword + "</b><br><small>이 비밀번호를 사용자에게 안전하게 전달하세요.</small>";
                } else {
                    tempMsgDiv.className = "error";
                    tempMsgDiv.innerHTML = "❌ " + (data.message || "초기화 실패");
                }
            })
            .catch(err => {
                tempMsgDiv.className = "error";
                tempMsgDiv.innerHTML = "❌ 서버 오류: " + err.message;
            });
    }
</script>
</body>
</html>
