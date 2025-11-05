<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String context = request.getContextPath();
%>

<!-- ✅ 공통 헤더 -->
<%@ include file="/WEB-INF/views/components/header.jsp" %>
<link rel="stylesheet" href="<%=context%>/css/style.css">

<style>
    .notification-container {
        max-width: 1000px;
        margin: 40px auto;
        padding: 20px;
    }

    .notification-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 30px;
        padding: 30px;
        background: white;
        border-radius: 12px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    }

    .notification-header h1 {
        color: var(--choco);
        font-size: 28px;
        margin: 0;
        display: flex;
        align-items: center;
        gap: 12px;
    }

    .notification-count {
        color: var(--amber);
        font-weight: 600;
    }

    .btn-mark-all {
        padding: 10px 20px;
        background: var(--choco);
        color: white;
        border: none;
        border-radius: 8px;
        font-size: 14px;
        font-weight: 600;
        cursor: pointer;
        display: inline-flex;
        align-items: center;
        gap: 8px;
        transition: all 0.3s;
    }

    .btn-mark-all:hover {
        background: var(--amber);
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(0,0,0,0.15);
    }

    .notification-list {
        background: white;
        border-radius: 12px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        overflow: hidden;
    }

    .notification-item {
        padding: 20px 24px;
        border-bottom: 1px solid var(--gray-200);
        cursor: pointer;
        transition: background 0.2s;
    }

    .notification-item:last-child {
        border-bottom: none;
    }

    .notification-item:hover {
        background: var(--gray-50);
    }

    .notification-item.unread {
        background: rgba(139, 90, 58, 0.05);
        border-left: 4px solid var(--choco);
    }

    .notification-message {
        font-size: 16px;
        color: var(--gray-800);
        margin-bottom: 8px;
        font-weight: 500;
    }

    .notification-meta {
        display: flex;
        justify-content: space-between;
        align-items: center;
        font-size: 14px;
        color: var(--gray-600);
    }

    .notification-badge-new {
        display: inline-block;
        padding: 2px 8px;
        background: var(--amber);
        color: white;
        border-radius: 12px;
        font-size: 11px;
        font-weight: 700;
        margin-left: 8px;
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

<main class="notification-container">
    <div class="notification-header">
        <h1>
            <i class="ph ph-bell"></i> 알림 
            <span class="notification-count">(<span id="unreadCountDisplay">${unreadCount}</span>건)</span>
        </h1>
        <button class="btn-mark-all" onclick="markAllAsRead()">
            <i class="ph ph-check-circle"></i> 전체 읽음 처리
        </button>
    </div>

    <div class="notification-list">
        <c:choose>
            <c:when test="${empty notifications}">
                <div class="empty-state">
                    <i class="ph ph-bell-slash"></i>
                    <p>새로운 알림이 없습니다.</p>
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach var="noti" items="${notifications}">
                    <div class="notification-item ${noti.readYn eq 'N' ? 'unread' : ''}"
                         data-noti-id="${noti.notiId}"
                         data-target-url="${noti.targetUrl}"
                         onclick="markAsReadAndRedirect(${noti.notiId}, '${noti.targetUrl}')">
                        <div class="notification-message">
                            ${noti.message}
                        </div>
                        <div class="notification-meta">
                            <span>${noti.createdAtStr}</span>
                            <c:if test="${noti.readYn eq 'N'}">
                                <span class="notification-badge-new">NEW</span>
                            </c:if>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
</main>

<script>
    // 알림 클릭 시 읽음 처리 후 페이지 이동
    function markAsReadAndRedirect(notiId, targetUrl){
        fetch('<%=context%>/api/notifications/' + notiId + '/read', {
            method: 'PUT',
            headers: {'Content-Type': 'application/json'}
        })
            .then(res => {
                if(res.ok){
                    console.log(`[알림 ${notiId}]: 읽음처리 성공. ${targetUrl}로 이동`);
                    location.href = targetUrl;
                }else {
                    res.json().then(data => console.error("읽음 처리 실패: ", data.message));
                    alert("알림 처리 중 오류가 발생했습니다. 해당 페이지로 이동합니다.");
                    location.href = targetUrl;
                }
            })
            .catch(error => {
                console.error("Fetch 오류: ", error);
                alert("네트워크 오류가 발생했습니다. 해당 페이지로 이동합니다.");
                location.href = targetUrl;
            });
    }

    // 전체 읽음 처리
    function markAllAsRead(){
        fetch('<%=context%>/api/notifications/read-all', {
            method: 'PUT',
            headers: {'Content-Type': 'application/json'}
        })
            .then(res => {
                if(res.ok){
                    alert("모든 알림이 읽음 처리되었습니다.");
                    location.reload();
                }else {
                    res.json().then(data => alert("전체 읽음 처리 실패: " + (data.message || '서버오류')));
                }
            })
            .catch(error => {
                console.error("Fetch 오류: ", error);
                alert("네트워크 오류로 전체 읽음 처리에 실패했습니다.");
            });
    }
</script>

<%@ include file="/WEB-INF/views/components/footer.jsp" %>
