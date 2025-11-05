<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>관리자 - FAQ 추가</title>
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
        .btn-submit { background-color: #007bff; color: white; }
        .btn-cancel { background-color: #6c757d; color: white; }
    </style>
</head>
<body>
<h2>[관리자] 새 FAQ 등록</h2>
<hr>

<div class="form-container">
    <div class="form-group">
        <label for="category">카테고리</label>
        <input type="text" id="category" placeholder="예: 서비스 안내, 계정/로그인" required>
    </div>
    <div class="form-group">
        <label for="question">질문</label>
        <input type="text" id="question" placeholder="질문을 입력하세요." required>
    </div>
    <div class="form-group">
        <label for="answer">답변</label>
        <textarea id="answer" placeholder="답변 내용을 입력하세요." required></textarea>
    </div>
    <div class="form-group">
        <label for="priority">카테고리별 질문 우선순위</label>
        <input type="number" id="priority" value="100" min="1" max="999" required>
        <small>숫자가 낮을수록 목록에서 위에 표시됩니다.</small>
    </div>

    <div class="button-group">
        <button type="button" class="btn-cancel" onclick="location.href='/chatbot/admin/list'">목록으로</button>
        <button type="button" class="btn-submit" onclick="registerFaq()">등록</button>
    </div>
</div>

<script>
    function registerFaq() {
        const category = document.getElementById('category').value.trim();
        const question = document.getElementById('question').value.trim();
        const answer = document.getElementById('answer').value.trim();
        const priority = document.getElementById('priority').value;

        if (!category || !question || !answer) {
            alert('카테고리, 질문, 답변은 필수 입력 사항입니다.');
            return;
        }

        const faqData = {
            category: category,
            question: question,
            answer: answer,
            priority: parseInt(priority)
        };

        // REST API 호출 (POST 요청)
        fetch('/api/admin/chatbot', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(faqData)
        })
            .then(res => {
                if (res.status === 201) { // 201 Created
                    alert('FAQ 등록이 성공적으로 완료되었습니다.');
                    location.href = '/chatbot/admin/list'; // 등록 후 목록 페이지로 이동
                } else {
                    return res.text().then(text => { throw new Error(text); });
                }
            })
            .catch(error => {
                console.error('FAQ 등록 실패:', error);
                alert('FAQ 등록에 실패했습니다. 서버 로그를 확인하세요. 오류: ' + error.message);
            });
    }
</script>
</body>
</html>