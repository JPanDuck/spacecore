<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FAQ 수정 | Space Core</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/phosphor-icons@1.4.2/dist/phosphor.css">
    <style>
        .admin-container {
            max-width: 900px;
            margin: 40px auto;
            padding: 20px;
        }

        .admin-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding: 30px;
            background: linear-gradient(135deg, var(--amber) 0%, var(--choco) 100%);
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
        }

        .form-group {
            margin-bottom: 28px;
        }

        .form-group label {
            display: block;
            font-weight: 700;
            font-size: 15px;
            color: var(--choco);
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .form-group label .required {
            color: #dc3545;
        }

        .form-group input[type="text"],
        .form-group input[type="number"],
        .form-group textarea {
            width: 100%;
            padding: 14px 18px;
            border: 2px solid var(--gray-300);
            border-radius: 8px;
            font-size: 15px;
            font-family: inherit;
            transition: all 0.3s ease;
            box-sizing: border-box;
        }

        .form-group input[type="text"]:focus,
        .form-group input[type="number"]:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: var(--choco);
            box-shadow: 0 0 0 3px rgba(91, 59, 49, 0.1);
        }

        .form-group textarea {
            min-height: 200px;
            resize: vertical;
            line-height: 1.6;
        }

        .form-group small {
            display: block;
            margin-top: 8px;
            font-size: 13px;
            color: var(--gray-600);
        }

        .button-group {
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            margin-top: 40px;
            padding-top: 30px;
            border-top: 2px solid var(--gray-200);
        }

        .btn {
            padding: 14px 28px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
        }

        .btn-cancel {
            background: var(--gray-300);
            color: var(--text-primary);
        }

        .btn-cancel:hover {
            background: var(--gray-400);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        .btn-submit {
            background: var(--amber);
            color: var(--white);
        }

        .btn-submit:hover {
            background: var(--choco);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(141, 94, 76, 0.3);
        }

        .btn:disabled {
            opacity: 0.6;
            cursor: not-allowed;
            transform: none;
        }

        .form-help {
            background: var(--gray-50);
            padding: 16px;
            border-radius: 8px;
            border-left: 4px solid var(--amber);
            margin-bottom: 28px;
            font-size: 14px;
            color: var(--text-primary);
            line-height: 1.6;
        }

        .form-help strong {
            color: var(--amber);
        }

        .faq-info {
            background: var(--cream-tan);
            padding: 16px;
            border-radius: 8px;
            margin-bottom: 28px;
            font-size: 14px;
            color: var(--text-primary);
        }

        .faq-info strong {
            color: var(--choco);
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

            .button-group {
                flex-direction: column-reverse;
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
            <i class="ph ph-pencil-circle"></i>
            FAQ 수정 (ID: ${faq.id})
        </h1>
    </div>

    <div class="form-container">
        <div class="faq-info">
            <strong><i class="ph ph-info"></i> FAQ 정보:</strong> 
            등록일: ${faq.createdAtStr} | 카테고리: ${faq.category} | 우선순위: ${faq.priority}
        </div>

        <div class="form-help">
            <strong><i class="ph ph-lightbulb"></i> 도움말:</strong> 
            수정된 내용은 즉시 적용되며, 사용자들이 챗봇을 통해 업데이트된 정보를 확인할 수 있습니다.
        </div>

        <input type="hidden" id="faqId" value="${faq.id}">

        <form id="faqForm">
            <div class="form-group">
                <label for="category">
                    <i class="ph ph-folder"></i>
                    카테고리 <span class="required">*</span>
                </label>
                <input type="text" id="category" name="category" 
                       value="${faq.category}" 
                       required>
                <small>FAQ를 분류할 카테고리를 입력하세요. 기존 카테고리를 사용하면 함께 표시됩니다.</small>
            </div>

            <div class="form-group">
                <label for="question">
                    <i class="ph ph-question"></i>
                    질문 <span class="required">*</span>
                </label>
                <input type="text" id="question" name="question" 
                       value="${faq.question}" 
                       required>
                <small>사용자가 자주 묻는 질문을 명확하고 간단하게 작성하세요.</small>
            </div>

            <div class="form-group">
                <label for="answer">
                    <i class="ph ph-chat-circle-text"></i>
                    답변 <span class="required">*</span>
                </label>
                <textarea id="answer" name="answer" 
                          required>${faq.answer}</textarea>
                <small>질문에 대한 명확하고 자세한 답변을 작성하세요. 줄바꿈을 사용하여 가독성을 높일 수 있습니다.</small>
            </div>

            <div class="form-group">
                <label for="priority">
                    <i class="ph ph-sort-ascending"></i>
                    우선순위 <span class="required">*</span>
                </label>
                <input type="number" id="priority" name="priority" 
                       value="${faq.priority}" 
                       min="1" max="999" 
                       required>
                <small>숫자가 낮을수록 해당 카테고리 내에서 목록의 위쪽에 표시됩니다. (1~999)</small>
            </div>

            <div class="button-group">
                <a href="${pageContext.request.contextPath}/chatbot/admin/list" class="btn btn-cancel">
                    <i class="ph ph-x"></i>
                    취소
                </a>
                <button type="button" class="btn btn-submit" onclick="modifyFaq()">
                    <i class="ph ph-check"></i>
                    수정 완료
                </button>
            </div>
        </form>
    </div>
</div>

<!-- ✅ 푸터 include -->
<%@ include file="../components/footer.jsp" %>

<script>
    function modifyFaq() {
        const id = document.getElementById('faqId').value;
        const category = document.getElementById('category').value.trim();
        const question = document.getElementById('question').value.trim();
        const answer = document.getElementById('answer').value.trim();
        const priority = document.getElementById('priority').value;

        // 유효성 검사
        if (!category || !question || !answer) {
            alert('카테고리, 질문, 답변은 필수 입력 사항입니다.');
            return;
        }

        if (priority < 1 || priority > 999) {
            alert('우선순위는 1부터 999까지의 숫자여야 합니다.');
            return;
        }

        const faqData = {
            id: parseInt(id),
            category: category,
            question: question,
            answer: answer,
            priority: parseInt(priority)
        };

        const submitBtn = document.querySelector('.btn-submit');
        submitBtn.disabled = true;
        submitBtn.innerHTML = '<i class="ph ph-spinner"></i> 수정 중...';

        // REST API 호출 (PUT 요청)
        fetch('${pageContext.request.contextPath}/api/admin/chatbot/' + id, {
            method: 'PUT',
            headers: {
                'Content-Type': 'application/json'
            },
            credentials: 'include',
            body: JSON.stringify(faqData)
        })
            .then(res => {
                if (res.ok) {
                    alert('FAQ 수정이 성공적으로 완료되었습니다.');
                    location.href = '${pageContext.request.contextPath}/chatbot/admin/list';
                } else if (res.status === 404) {
                    alert('수정할 FAQ를 찾을 수 없습니다.');
                    submitBtn.disabled = false;
                    submitBtn.innerHTML = '<i class="ph ph-check"></i> 수정 완료';
                } else {
                    return res.text().then(text => {
                        throw new Error(text);
                    });
                }
            })
            .catch(error => {
                console.error('FAQ 수정 실패:', error);
                alert('FAQ 수정에 실패했습니다. 서버 로그를 확인하세요.\n오류: ' + error.message);
                submitBtn.disabled = false;
                submitBtn.innerHTML = '<i class="ph ph-check"></i> 수정 완료';
            });
    }

    // Enter 키로 폼 제출 방지
    document.getElementById('faqForm').addEventListener('keypress', function(e) {
        if (e.key === 'Enter' && e.target.tagName !== 'TEXTAREA') {
            e.preventDefault();
        }
    });
</script>
</body>
</html>
