<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>관리자 - FAQ 수정</title>
    <style>
        body { font-family: Arial, sans-serif; padding: 20px; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; font-weight: bold; margin-bottom: 5px; }
        .form-group input[type="text"], .form-group textarea, .form-group input[type="number"] {
            width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box;
        }
        .form-group textarea { height: 150px; resize: vertical; }
        .button-group { margin-top: 20px; text-align: right; }
        .button-group button { padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer; margin-left: 10px; }
        .btn-submit { background-color: #28a745; color: white; } /* 수정은 보통 초록색 계열 사용 */
        .btn-cancel { background-color: #6c757d; color: white; }
    </style>
</head>
<body>
<h2>[관리자] FAQ 수정 (ID: ${faq.id})</h2>
<hr>

<%-- FAQ ID를 JavaScript에서 쉽게 접근하도록 숨겨진 필드에 저장 --%>
<input type="hidden" id="faqId" value="${faq.id}">

<div class="form-container">
    <div class="form-group">
        <label for="category">카테고리</label>
        <input type="text" id="category" value="${faq.category}" required>
    </div>
    <div class="form-group">
        <label for="question">질문</label>
        <input type="text" id="question" value="${faq.question}" required>
    </div>
    <div class="form-group">
        <label for="answer">답변</label>
        <textarea id="answer" required>${faq.answer}</textarea>
    </div>
    <div class="form-group">
        <label for="priority">카테고리별 질문 우선순위</label>
        <input type="number" id="priority" value="${faq.priority}" min="1" max="999" required>
        <small>숫자가 낮을수록 목록에서 위에 표시됩니다.</small>
    </div>

    <div class="button-group">
        <button type="button" class="btn-cancel" onclick="location.href='/chatbot/admin/list'">목록으로</button>
        <button type="button" class="btn-submit" onclick="modifyFaq()">수정 완료</button>
    </div>
</div>

<script>
    function modifyFaq() {
        const id = document.getElementById('faqId').value;
        const category = document.getElementById('category').value.trim();
        const question = document.getElementById('question').value.trim();
        const answer = document.getElementById('answer').value.trim();
        const priority = document.getElementById('priority').value;

        if (!category || !question || !answer) {
            alert('카테고리, 질문, 답변은 필수 입력 사항입니다.');
            return;
        }

        const faqData = {
            id: parseInt(id), // ID도 데이터에 포함 (RestController에서 사용)
            category: category,
            question: question,
            answer: answer,
            priority: parseInt(priority)
        };

        // REST API 호출 (PUT 요청)
        fetch('/api/admin/chatbot/' + id, {
            method: 'PUT',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(faqData)
        })
            .then(res => {
                if (res.ok) { // 200 OK
                    alert('FAQ 수정이 성공적으로 완료되었습니다.');
                    location.href = '/chatbot/admin/list'; // 수정 후 목록 페이지로 이동
                } else if (res.status === 404) {
                    alert('수정할 FAQ를 찾을 수 없습니다.');
                } else {
                    return res.text().then(text => { throw new Error(text); });
                }
            })
            .catch(error => {
                console.error('FAQ 수정 실패:', error);
                alert('FAQ 수정에 실패했습니다. 서버 로그를 확인하세요. 오류: ' + error.message);
            });
    }
</script>
</body>
</html>