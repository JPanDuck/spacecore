<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String context = request.getContextPath();
%>

<!-- ✅ 공통 헤더 -->
<%@ include file="/WEB-INF/views/components/header.jsp" %>
<link rel="stylesheet" href="<%=context%>/css/style.css">

<style>
    .qna-modify-container {
        max-width: 900px;
        margin: 40px auto;
        padding: 20px;
    }

    .qna-modify-header {
        margin-bottom: 30px;
        padding: 30px;
        background: white;
        border-radius: 12px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    }

    .qna-modify-header h1 {
        color: var(--choco);
        font-size: 28px;
        margin: 0 0 16px 0;
        display: flex;
        align-items: center;
        gap: 12px;
    }

    .qna-info {
        display: flex;
        gap: 20px;
        font-size: 14px;
        color: var(--gray-600);
    }

    .qna-info span {
        display: flex;
        align-items: center;
        gap: 6px;
    }

    .qna-modify-form {
        background: white;
        padding: 40px;
        border-radius: 12px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    }

    .form-group {
        margin-bottom: 24px;
    }

    .form-group label {
        display: block;
        margin-bottom: 8px;
        font-weight: 600;
        color: var(--gray-800);
        font-size: 14px;
    }

    .form-group input[type="text"],
    .form-group textarea {
        width: 100%;
        padding: 12px 16px;
        border: 1px solid var(--gray-300);
        border-radius: 8px;
        font-size: 14px;
        font-family: inherit;
        transition: all 0.2s;
        box-sizing: border-box;
    }

    .form-group input[type="text"]:focus,
    .form-group textarea:focus {
        outline: none;
        border-color: var(--choco);
        box-shadow: 0 0 0 3px rgba(139, 90, 58, 0.1);
    }

    .form-group textarea {
        min-height: 300px;
        resize: vertical;
    }

    .checkbox-group {
        display: flex;
        align-items: center;
        gap: 8px;
        padding: 12px;
        background: var(--gray-50);
        border-radius: 8px;
    }

    .checkbox-group input[type="checkbox"] {
        width: 18px;
        height: 18px;
        cursor: pointer;
    }

    .checkbox-group label {
        margin: 0;
        cursor: pointer;
        color: var(--gray-700);
    }

    .form-actions {
        display: flex;
        gap: 12px;
        justify-content: flex-end;
        margin-top: 30px;
        padding-top: 30px;
        border-top: 1px solid var(--gray-200);
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
</style>

<main class="qna-modify-container">
    <c:if test="${not empty qna}">
        <div class="qna-modify-header">
            <h1><i class="ph ph-pencil-simple"></i> 문의글 수정</h1>
            <div class="qna-info">
                <span><i class="ph ph-user"></i> 작성자: ${qna.name}</span>
                <span>
                    <i class="ph ph-info"></i> 상태:
                    <c:choose>
                        <c:when test="${qna.status eq 'ANSWERED'}">답변완료</c:when>
                        <c:otherwise>대기중</c:otherwise>
                    </c:choose>
                </span>
            </div>
        </div>

        <form id="qnaModifyForm" class="qna-modify-form">
            <input type="hidden" id="qnaId" value="${qna.id}">

            <div class="form-group">
                <label for="title">제목</label>
                <input type="text" id="title" name="title" value="${qna.title}" required>
            </div>

            <div class="form-group">
                <label for="content">내용</label>
                <textarea id="content" name="content" required><c:out value="${qna.content}" /></textarea>
            </div>

            <div class="form-group">
                <div class="checkbox-group">
                    <input type="checkbox" id="isPrivate" name="isPrivate" value="Y"
                           <c:if test="${qna.isPrivate eq 'Y'}">checked</c:if>>
                    <label for="isPrivate">비공개 설정</label>
                </div>
            </div>

            <div class="form-actions">
                <button type="button" class="btn btn-secondary" onclick="location.href='<%=context%>/qna/detail/${qna.id}'">
                    <i class="ph ph-x"></i> 취소
                </button>
                <button type="button" class="btn btn-primary" onclick="submitModification()">
                    <i class="ph ph-check"></i> 저장
                </button>
            </div>
        </form>
    </c:if>
</main>

<script>
    function submitModification(){
        const qnaId = document.getElementById('qnaId').value;
        const title = document.getElementById('title').value.trim();
        const content = document.getElementById('content').value.trim();
        const isPrivate = document.getElementById('isPrivate').checked ? 'Y' : 'N';

        if(!title){
            alert('제목을 입력해주세요');
            return;
        }
        if(!content){
            alert('내용을 입력해주세요');
            return;
        }

        const qnaData = {
            id: qnaId,
            title: title,
            content: content,
            isPrivate: isPrivate
        };

        fetch('<%=context%>/api/qna/' + qnaId, {
            method: 'PUT',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify(qnaData)
        })
            .then(async res => {
                const data = await res.json();
                if(res.ok){
                    alert(data.message || '문의글이 수정되었습니다.');
                    location.href = '<%=context%>/qna/detail/' + qnaId;
                } else {
                    alert('문의글 수정 실패: ' + (data.message || '권한이 없거나 서버 오류가 발생했습니다.'));
                }
            })
            .catch(err => {
                console.error('통신 오류: ', err);
                alert('통신 오류로 수정에 실패했습니다.');
            });
    }
</script>

<%@ include file="/WEB-INF/views/components/footer.jsp" %>
