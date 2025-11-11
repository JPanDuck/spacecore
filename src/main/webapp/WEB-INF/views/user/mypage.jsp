<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String context = request.getContextPath();
%>

<!-- ✅ 공통 헤더 -->
<%@ include file="/WEB-INF/views/components/header.jsp" %>
<link rel="stylesheet" href="<%=context%>/css/style.css">

<style>
    .mypage-container {
        max-width: 1000px;
        margin: 40px auto;
        padding: 20px;
    }

    .mypage-header {
        margin-bottom: 30px;
        padding: 30px;
        background: white;
        border-radius: 12px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    }

    .mypage-header h1 {
        color: var(--choco);
        font-size: 28px;
        margin: 0 0 16px 0;
        display: flex;
        align-items: center;
        gap: 12px;
    }

    .mypage-header .subtitle {
        color: var(--gray-600);
        font-size: 14px;
    }

    .info-section {
        background: white;
        padding: 40px;
        border-radius: 12px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        margin-bottom: 30px;
    }

    .info-section h2 {
        color: var(--choco);
        font-size: 20px;
        margin-bottom: 24px;
        padding-bottom: 12px;
        border-bottom: 2px solid var(--choco);
        display: flex;
        align-items: center;
        gap: 8px;
    }

    .info-table {
        width: 100%;
        border-collapse: collapse;
    }

    .info-table tr {
        border-bottom: 1px solid var(--gray-200);
    }

    .info-table tr:last-child {
        border-bottom: none;
    }

    .info-table th {
        width: 180px;
        padding: 16px 20px;
        text-align: left;
        font-weight: 600;
        color: var(--gray-800);
        background: var(--gray-50);
        font-size: 14px;
    }

    .info-table td {
        padding: 16px 20px;
        color: var(--gray-700);
        font-size: 14px;
    }

    .role-badge {
        display: inline-block;
        padding: 4px 12px;
        border-radius: 12px;
        font-size: 12px;
        font-weight: 600;
    }

    .role-USER {
        background: #e3f2fd;
        color: #1976d2;
    }

    .role-ADMIN {
        background: #fff3e0;
        color: #e65100;
    }

    .provider-badge {
        display: inline-block;
        padding: 6px 12px;
        border-radius: 12px;
        font-size: 13px;
        font-weight: 600;
    }

    .provider-badge-google {
        background: #4285F4;
        color: var(--white);
    }

    .provider-badge-kakao {
        background: #FEE500;
        color: #000;
    }

    .provider-badge-naver {
        background: #03C75A;
        color: var(--white);
    }

    .provider-badge-general {
        background: var(--gray-200);
        color: var(--text-primary);
    }

    .actions-section {
        background: white;
        padding: 30px;
        border-radius: 12px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    }

    .actions-section h2 {
        color: var(--choco);
        font-size: 20px;
        margin-bottom: 20px;
        padding-bottom: 12px;
        border-bottom: 2px solid var(--choco);
        display: flex;
        align-items: center;
        gap: 8px;
    }

    .action-buttons {
        display: flex;
        gap: 12px;
        flex-wrap: wrap;
    }

    .btn {
        padding: 12px 24px;
        border: none;
        border-radius: 8px;
        font-size: 14px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s;
        display: inline-flex;
        align-items: center;
        gap: 8px;
        text-decoration: none;
    }

    .btn-primary {
        background: var(--choco);
        color: white;
    }

    .btn-primary:hover {
        background: var(--amber);
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(0,0,0,0.15);
    }

    .btn-secondary {
        background: var(--gray-200);
        color: var(--gray-700);
    }

    .btn-secondary:hover {
        background: var(--gray-300);
    }

    .btn-danger {
        background: #e74c3c;
        color: white;
    }

    .btn-danger:hover {
        background: #c0392b;
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(0,0,0,0.15);
    }
</style>

<main class="mypage-container">
    <div class="mypage-header">
        <h1><i class="ph ph-user-circle"></i> 마이페이지</h1>
        <p class="subtitle">내 정보를 확인하고 관리할 수 있습니다.</p>
    </div>

    <div class="info-section">
        <h2><i class="ph ph-identification-card"></i> 내 정보</h2>
        <table class="info-table">
            <tr>
                <th>아이디</th>
                <td><c:out value="${user.username}" default="정보 없음"/></td>
            </tr>
            <tr>
                <th>이름</th>
                <td><c:out value="${user.name}" default="정보 없음"/></td>
            </tr>
            <tr>
                <th>이메일</th>
                <td><c:out value="${user.email}" default="정보 없음"/></td>
            </tr>
            <tr>
                <th>전화번호</th>
                <td><c:out value="${user.phone != null && !user.phone.isEmpty() ? user.phone : '정보 없음'}" default="정보 없음"/></td>
            </tr>
            <tr>
                <th>역할</th>
                <td>
                    <c:choose>
                        <c:when test="${user.role == 'USER'}">
                            <span class="role-badge role-USER">일반 사용자</span>
                        </c:when>
                        <c:when test="${user.role == 'ADMIN'}">
                            <span class="role-badge role-ADMIN">관리자</span>
                        </c:when>
                        <c:otherwise>
                            <span class="role-badge"><c:out value="${user.role}" default="정보 없음"/></span>
                        </c:otherwise>
                    </c:choose>
                </td>
            </tr>
            <tr>
                <th>로그인 방식</th>
                <td>
                    <c:choose>
                        <c:when test="${not empty user.provider}">
                            <c:choose>
                                <c:when test="${user.provider eq 'google'}">
                                    <span class="provider-badge provider-badge-google">Google 로그인</span>
                                </c:when>
                                <c:when test="${user.provider eq 'kakao'}">
                                    <span class="provider-badge provider-badge-kakao">Kakao 로그인</span>
                                </c:when>
                                <c:when test="${user.provider eq 'naver'}">
                                    <span class="provider-badge provider-badge-naver">Naver 로그인</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="provider-badge provider-badge-general">${user.provider} 로그인</span>
                                </c:otherwise>
                            </c:choose>
                        </c:when>
                        <c:otherwise>
                            <span class="provider-badge provider-badge-general">일반 로그인</span>
                        </c:otherwise>
                    </c:choose>
                </td>
            </tr>
        </table>
    </div>

    <div class="actions-section">
        <h2><i class="ph ph-gear"></i> 계정 관리</h2>
        <div class="action-buttons">
            <a href="<%=context%>/user/edit" class="btn btn-primary">
                <i class="ph ph-pencil"></i> 정보 수정
            </a>
            <!-- 일반 로그인 사용자만 비밀번호 변경 버튼 표시 -->
            <c:if test="${empty user.provider}">
            <a href="<%=context%>/user/change-password" class="btn btn-secondary">
                <i class="ph ph-key"></i> 비밀번호 변경
            </a>
            </c:if>
            <button type="button" class="btn btn-danger" onclick="deleteAccount()">
                <i class="ph ph-trash"></i> 회원 탈퇴
            </button>
        </div>
    </div>
</main>

<script>
    async function deleteAccount() {
        if (!confirm("⚠ 정말 탈퇴하시겠습니까?\n이 작업은 되돌릴 수 없습니다.")) return;

        try {
            const res = await fetch("<%=context%>/api/user/me", {
                method: "DELETE",
                credentials: "include",
                headers: { "Content-Type": "application/json" }
            });

            const msg = await res.text();
            alert(msg);

            if (res.ok) {
                clearCookie("access_token");
                clearCookie("refresh_token");
                clearCookie("JSESSIONID");

                localStorage.clear();
                sessionStorage.clear();

                setTimeout(() => {
                    window.location.replace("<%=context%>/auth/login");
                }, 150);
            }
        } catch (err) {
            console.error("회원 탈퇴 요청 실패:", err);
            alert("회원 탈퇴 중 오류가 발생했습니다.");
        }
    }

    function clearCookie(name) {
        document.cookie = name + "=; Max-Age=0; path=/; SameSite=Lax;";
    }
</script>

<%@ include file="/WEB-INF/views/components/footer.jsp" %>
