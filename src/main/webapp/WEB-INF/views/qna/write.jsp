<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String context = request.getContextPath();
%>

<!-- ✅ 공통 헤더 -->
<%@ include file="/WEB-INF/views/components/header.jsp" %>
<link rel="stylesheet" href="<%=context%>/css/style.css">

<style>
    .qna-write-container {
        max-width: 900px;
        margin: 40px auto;
        padding: 20px;
    }

    .qna-write-header {
        margin-bottom: 30px;
        padding: 30px;
        background: white;
        border-radius: 12px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    }

    .qna-write-header h1 {
        color: var(--choco);
        font-size: 28px;
        margin: 0;
        display: flex;
        align-items: center;
        gap: 12px;
    }

    .qna-write-form {
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

<main class="qna-write-container">
    <div class="qna-write-header">
        <h1><i class="ph ph-pencil-simple"></i> 새 문의글 작성</h1>
    </div>

    <form id="qnaWriteForm" class="qna-write-form">
        <div class="form-group">
            <label for="title">제목</label>
            <input type="text" id="title" name="title" required placeholder="문의 제목을 입력하세요">
        </div>

        <div class="form-group">
            <label for="content">내용</label>
            <textarea id="content" name="content" required placeholder="문의 내용을 입력하세요"></textarea>
        </div>

        <div class="form-group">
            <div class="checkbox-group">
                <input type="checkbox" id="isPrivate" name="isPrivate" value="Y">
                <label for="isPrivate">비공개 설정</label>
            </div>
        </div>

        <div class="form-actions">
            <button type="button" class="btn btn-secondary" onclick="location.href='<%=context%>/qna/list'">
                <i class="ph ph-x"></i> 취소
            </button>
            <button type="button" class="btn btn-primary" onclick="submitQna()">
                <i class="ph ph-check"></i> 등록
            </button>
        </div>
    </form>
</main>

<script>
    function submitQna(){
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
            title: title,
            content: content,
            isPrivate: isPrivate
        };

        fetch('<%=context%>/api/qna', {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify(qnaData)
        })
            .then(async res => {
                const data = await res.json();
                if(res.ok){
                    alert(data.message || '문의글이 등록되었습니다.');
                    location.href = '<%=context%>/qna/list';
                }else {
                    alert('문의글 등록 실패: ' + (data.message || '서버 오류가 발생했습니다.'));
                }
            })
            .catch(err => {
                console.error('통신 오류: ', err);
                alert('통신 오류로 등록에 실패했습니다.');
            });
    }
</script>

<%@ include file="/WEB-INF/views/components/footer.jsp" %>
