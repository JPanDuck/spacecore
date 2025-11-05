<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String context = request.getContextPath();
%>

<!-- ✅ 공통 헤더 -->
<%@ include file="/WEB-INF/views/components/header.jsp" %>
<link rel="stylesheet" href="<%=context%>/css/style.css">

<style>
    .qna-detail-container {
        max-width: 1000px;
        margin: 40px auto;
        padding: 20px;
    }

    .qna-detail-header {
        margin-bottom: 30px;
        padding: 30px;
        background: white;
        border-radius: 12px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    }

    .qna-detail-header h1 {
        color: var(--choco);
        font-size: 28px;
        margin: 0 0 16px 0;
        display: flex;
        align-items: center;
        gap: 12px;
    }

    .qna-meta {
        display: flex;
        gap: 20px;
        font-size: 14px;
        color: var(--gray-600);
        padding: 16px;
        background: var(--gray-50);
        border-radius: 8px;
    }

    .qna-meta span {
        display: flex;
        align-items: center;
        gap: 6px;
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

    .qna-content-section {
        background: white;
        padding: 40px;
        border-radius: 12px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        margin-bottom: 30px;
    }

    .qna-title {
        font-size: 24px;
        font-weight: 600;
        color: var(--gray-800);
        margin-bottom: 24px;
        padding-bottom: 16px;
        border-bottom: 2px solid var(--gray-200);
        display: flex;
        align-items: center;
        gap: 12px;
    }

    .qna-title .lock-icon {
        color: var(--amber);
        font-size: 20px;
    }

    .qna-content {
        font-size: 16px;
        line-height: 1.8;
        color: var(--gray-800);
        white-space: pre-wrap;
        min-height: 200px;
        padding: 20px;
        background: var(--gray-50);
        border-radius: 8px;
        border: 1px solid var(--gray-200);
    }

    .qna-actions {
        display: flex;
        gap: 12px;
        margin-top: 24px;
        padding-top: 24px;
        border-top: 1px solid var(--gray-200);
    }

    .btn {
        padding: 10px 20px;
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

    .btn-mocha {
        background: #8B6F47;
        color: white;
    }

    .btn-mocha:hover {
        background: #A0825D;
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(139, 111, 71, 0.3);
    }

    .btn-danger {
        background: #e74c3c;
        color: white;
    }

    .btn-danger:hover {
        background: #c0392b;
    }

    .reply-section {
        background: white;
        padding: 40px;
        border-radius: 12px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        margin-bottom: 30px;
    }

    .reply-section h2 {
        color: var(--choco);
        font-size: 24px;
        margin-bottom: 24px;
        display: flex;
        align-items: center;
        gap: 12px;
    }

    .reply-item {
        padding: 20px;
        margin-bottom: 20px;
        background: var(--gray-50);
        border-radius: 8px;
        border-left: 4px solid var(--choco);
    }

    .reply-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 12px;
    }

    .reply-author {
        font-weight: 600;
        color: var(--gray-800);
        display: flex;
        align-items: center;
        gap: 8px;
    }

    .reply-author .admin-badge {
        padding: 2px 8px;
        background: var(--choco);
        color: white;
        border-radius: 12px;
        font-size: 11px;
        font-weight: 700;
    }

    .reply-date {
        font-size: 12px;
        color: var(--gray-600);
    }

    .reply-content {
        font-size: 14px;
        line-height: 1.6;
        color: var(--gray-800);
        white-space: pre-wrap;
        margin-bottom: 12px;
        padding: 12px;
        background: white;
        border-radius: 6px;
    }

    .reply-actions {
        display: flex;
        gap: 8px;
        margin-top: 12px;
    }

    .btn-small {
        padding: 6px 12px;
        font-size: 12px;
    }

    .reply-form {
        margin-top: 24px;
        padding: 20px;
        background: var(--gray-50);
        border-radius: 8px;
    }

    .reply-form h3 {
        color: var(--choco);
        font-size: 18px;
        margin-bottom: 16px;
    }

    .reply-form textarea {
        width: 100%;
        min-height: 120px;
        padding: 12px;
        border: 1px solid var(--gray-300);
        border-radius: 8px;
        font-size: 14px;
        font-family: inherit;
        resize: vertical;
        box-sizing: border-box;
    }

    .reply-form textarea:focus {
        outline: none;
        border-color: var(--choco);
        box-shadow: 0 0 0 3px rgba(139, 90, 58, 0.1);
    }

    .edit-form {
        margin-top: 12px;
        padding: 16px;
        background: white;
        border-radius: 8px;
        border: 1px solid var(--gray-300);
    }

    .edit-form textarea {
        width: 100%;
        min-height: 80px;
        padding: 12px;
        border: 1px solid var(--gray-300);
        border-radius: 8px;
        font-size: 14px;
        font-family: inherit;
        resize: vertical;
        box-sizing: border-box;
    }

    .edit-form-actions {
        display: flex;
        gap: 8px;
        margin-top: 12px;
    }

    .empty-replies {
        text-align: center;
        padding: 40px;
        color: var(--gray-500);
    }

    .empty-replies i {
        font-size: 48px;
        margin-bottom: 16px;
        opacity: 0.5;
    }
</style>

<main class="qna-detail-container">
    <div class="qna-detail-header">
        <h1><i class="ph ph-chat-circle-dots"></i> 문의 상세보기</h1>
        <div class="qna-meta">
            <span><i class="ph ph-user"></i> 작성자: ${qna.name}</span>
            <span><i class="ph ph-calendar"></i> 작성일: ${qna.createdAtStr}</span>
            <span>
                <i class="ph ph-info"></i> 상태:
                <c:choose>
                    <c:when test="${qna.status eq 'ANSWERED'}">
                        <span class="status-badge status-answered">답변완료</span>
                    </c:when>
                    <c:otherwise>
                        <span class="status-badge status-pending">대기중</span>
                    </c:otherwise>
                </c:choose>
            </span>
        </div>
    </div>

    <div class="qna-content-section">
        <div class="qna-title">
            <c:if test="${qna.isPrivate eq 'Y'}">
                <i class="ph ph-lock lock-icon"></i>
            </c:if>
            ${qna.title}
        </div>
        <div class="qna-content">${qna.content}</div>
        <div class="qna-actions">
            <a href="<%=context%>/qna/list" class="btn btn-secondary">
                <i class="ph ph-list"></i> 목록
            </a>
            <c:if test="${currentUserId eq qna.userId and qna.status eq 'PENDING'}">
                <a href="<%=context%>/qna/modify/${qna.id}" class="btn btn-primary">
                    <i class="ph ph-pencil"></i> 수정
                </a>
            </c:if>
            <c:if test="${not empty currentUserId and currentUserId eq qna.userId}">
                <button type="button" class="btn btn-danger" onclick="deleteQna(${qna.id})">
                    <i class="ph ph-trash"></i> 삭제
                </button>
            </c:if>
        </div>
    </div>

    <div class="reply-section">
        <h2><i class="ph ph-chat-text"></i> 답변/댓글</h2>

        <div id="reply-list">
            <c:choose>
                <c:when test="${empty qna.replies}">
                    <div class="empty-replies">
                        <i class="ph ph-chat-circle"></i>
                        <p>등록된 댓글이 없습니다.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="reply" items="${qna.replies}" varStatus="status">
                        <div class="reply-item" id="reply-item-${reply.id}">
                            <div class="reply-header">
                                <div class="reply-author">
                                    <strong>${reply.name}</strong>
                                    <c:if test="${reply.isAdmin eq 'Y'}">
                                        <span class="admin-badge">관리자</span>
                                    </c:if>
                                </div>
                                <div class="reply-date">${reply.createdAtStr}</div>
                            </div>

                            <div class="reply-content" id="reply-content-text-${reply.id}">
                                ${reply.content}
                            </div>

                            <div id="reply-edit-form-${reply.id}"></div>

                            <div class="reply-actions" id="reply-actions-${reply.id}">
                                <c:if test="${status.last}">
                                    <button type="button" class="btn btn-mocha btn-small" onclick="showReplyForm(${reply.id}, '${reply.name}')">
                                        <i class="ph ph-arrow-bend-up-right"></i> 답글
                                    </button>
                                </c:if>
                                <c:if test="${auth.id eq reply.userId}">
                                    <button type="button" class="btn btn-primary btn-small" onclick="showEditForm(${reply.id}, '${reply.content}')">
                                        <i class="ph ph-pencil"></i> 수정
                                    </button>
                                    <button type="button" class="btn btn-danger btn-small" onclick="deleteReply(${reply.id})">
                                        <i class="ph ph-trash"></i> 삭제
                                    </button>
                                </c:if>
                                <c:if test="${currentUserRole eq 'ADMIN' and currentUserId != reply.userId}">
                                    <button type="button" class="btn btn-danger btn-small" onclick="deleteReply(${reply.id})">
                                        <i class="ph ph-trash"></i> 삭제
                                    </button>
                                </c:if>
                            </div>
                        </div>
                        <div id="reply-form-target-${reply.id}"></div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>

        <c:if test="${empty qna.replies}">
            <div class="reply-form">
                <h3><i class="ph ph-plus-circle"></i> 새 댓글 작성</h3>
                <textarea id="mainReplyContent" placeholder="댓글을 입력하세요."></textarea>
                <div class="reply-actions" style="margin-top: 12px;">
                    <button type="button" class="btn btn-primary" onclick="registerReply(${qna.id})">
                        <i class="ph ph-check"></i> 등록
                    </button>
                </div>
            </div>
        </c:if>
    </div>
</main>

<script>
    function deleteQna(id){
        if(!confirm("정말 삭제하시겠습니까?")) return;

        fetch('<%=context%>/api/qna/' + id, {
            method: 'DELETE'
        })
            .then(async res => {
                const data = await res.json();
                if(res.ok){
                    alert(data.message || "문의글이 삭제되었습니다.");
                    location.href = "<%=context%>/qna/list";
                }else {
                    alert("삭제 실패: " + (data.message || "권한이 없거나 서버 오류가 발생했습니다."));
                }
            })
            .catch(err => {
                console.error(err);
                alert("통신 오류로 삭제에 실패했습니다.");
            });
    }

    function registerReply(qnaId){
        const content = document.getElementById("mainReplyContent").value.trim();
        if(!content){
            alert("내용을 입력하세요.");
            return;
        }

        fetch('<%=context%>/api/qna/'+ qnaId + '/reply', {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify({
                content: content,
                parentReplyId: null
            })
        })
            .then(async res => {
                const data = await res.json();
                if(res.ok){
                    location.reload();
                }else {
                    alert("댓글 등록 실패: " + (data.message || "서버오류"));
                }
            })
            .catch(err => {
                console.error(err);
                alert("통신 오류로 댓글 등록에 실패했습니다.");
            });
    }

    function showEditForm(replyId, currentContent){
        const contentTextDiv = document.getElementById('reply-content-text-' + replyId);
        const editFormDiv = document.getElementById('reply-edit-form-' + replyId);
        const actionDiv = document.getElementById('reply-actions-' + replyId);

        contentTextDiv.style.display = 'none';
        actionDiv.style.display = 'none';

        editFormDiv.innerHTML =
            '<div class="edit-form">' +
                '<textarea id="edit-reply-content-' + replyId + '">' + currentContent.trim() + '</textarea>' +
                '<div class="edit-form-actions">' +
                    '<button type="button" class="btn btn-primary btn-small" onclick="updateReply(' + replyId + ')">저장</button>' +
                    '<button type="button" class="btn btn-secondary btn-small" onclick="cancelEdit(' + replyId + ')">취소</button>' +
                '</div>' +
            '</div>';
    }

    function cancelEdit(replyId){
        const contentTextDiv = document.getElementById('reply-content-text-' + replyId);
        const editFormDiv = document.getElementById('reply-edit-form-' + replyId);
        const actionsDiv = document.getElementById('reply-actions-' + replyId);

        contentTextDiv.style.display = 'block';
        editFormDiv.innerHTML = '';
        actionsDiv.style.display = 'flex';
    }

    function updateReply(replyId){
        const newContent = document.getElementById('edit-reply-content-' +replyId).value.trim();

        if(!newContent){
            alert("내용을 입력해주세요.");
            return;
        }

        fetch('<%=context%>/api/qna/reply/' + replyId, {
            method: 'PUT',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify({
                content: newContent
            })
        })
            .then(async res => {
                const data = await res.json();
                if(res.ok){
                    alert(data.message || "댓글이 수정되었습니다.");
                    location.reload();
                }else {
                    alert("수정 실패: " + (data.message || "권한이 없거나 서버 오류가 발생했습니다."));
                }
            })
            .catch(err => {
                console.error(err);
                alert("통신 오류로 댓글 수정에 실패했습니다.");
            })
    }

    function deleteReply(replyId){
        if(!confirm("댓글을 삭제하시겠습니까?")) return;

        fetch('<%=context%>/api/qna/reply/' + replyId, {
            method: 'DELETE'
        })
            .then(async res => {
                const data = await res.json();
                if(res.ok){
                    alert(data.message || "댓글이 삭제되었습니다.");
                    location.reload();
                }else {
                    alert("댓글 삭제 실패: " + (data.message || "권한이 없거나 서버 오류가 발생했습니다."));
                }
            })
            .catch(err => {
                console.error(err);
                alert("통신 오류로 삭제에 실패했습니다.");
            });
    }

    let currentParentReplyId = null;

    function showReplyForm(parentReplyId, parentAuthorName){
        const targetDiv = document.getElementById('reply-form-target-' + parentReplyId);

        if(currentParentReplyId === parentReplyId){
            targetDiv.innerHTML = '';
            currentParentReplyId = null;
            return;
        }

        if(currentParentReplyId !== null){
            document.getElementById('reply-form-target-' + currentParentReplyId).innerHTML = '';
        }

        const qnaId = '${qna.id}';

        targetDiv.innerHTML =
            '<div class="reply-form" id="child-reply-form-' + parentReplyId + '">' +
                '<h3><i class="ph ph-arrow-bend-up-right"></i> ' + parentAuthorName + '님에게 답글 작성 중</h3>' +
                '<textarea id="replyContent-' + parentReplyId + '" placeholder="답글을 입력하세요."></textarea>' +
                '<div class="reply-actions" style="margin-top: 12px;">' +
                    '<button type="button" class="btn btn-primary btn-small" onclick="registerChildReply(' + parentReplyId + ', ' + qnaId + ')">등록</button>' +
                    '<button type="button" class="btn btn-secondary btn-small" onclick="hideReplyForm(' + parentReplyId + ')">취소</button>' +
                '</div>' +
            '</div>';

        currentParentReplyId = parentReplyId;
    }

    function hideReplyForm(parentReplyId){
        document.getElementById('reply-form-target-' + parentReplyId).innerHTML = '';
        currentParentReplyId = null;
    }

    function registerChildReply(parentReplyId, qnaId){
        const content = document.getElementById('replyContent-' + parentReplyId).value.trim();
        if(!content){
            alert("내용을 입력하세요.");
            return;
        }

        fetch('<%=context%>/api/qna/' + qnaId + '/reply', {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify({
                content: content,
                parentReplyId: parentReplyId
            })
        })
            .then(async res => {
                const data = await res.json();
                if(res.ok){
                    location.reload();
                }else {
                    alert("댓글 등록 실패: " + (data.message || "서버오류"));
                }
            })
            .catch(err => {
                console.error(err);
                alert("통신 오류로 댓글 등록에 실패했습니다.");
            });
    }
</script>

<%@ include file="/WEB-INF/views/components/footer.jsp" %>
