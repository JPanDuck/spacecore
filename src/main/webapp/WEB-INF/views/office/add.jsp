<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String context = request.getContextPath();
%>
<%@ include file="/WEB-INF/views/components/header.jsp" %>
<link rel="stylesheet" href="<%=context%>/css/style.css">

<style>
    body {
        background: var(--cream-base);
    }

    .form-container {
        max-width: 700px;
        margin: 0 auto;
        padding: 60px 20px;
    }

    .form-header {
        text-align: center;
        margin-bottom: 50px;
    }

    .form-header h1 {
        color: var(--choco);
        font-size: 36px;
        font-weight: 700;
        margin-bottom: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 12px;
    }

    .form-header p {
        color: var(--gray-600);
        font-size: 16px;
        line-height: 1.6;
    }

    .form-card {
        background: white;
        padding: 40px;
        border-radius: 12px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    }

    .form-section {
        margin-bottom: 32px;
    }

    .form-label {
        display: block;
        font-weight: 600;
        color: var(--choco);
        margin-bottom: 10px;
        font-size: 16px;
    }

    .form-label .required {
        color: #e74c3c;
        margin-left: 4px;
    }

    .form-input,
    .form-select {
        width: 100%;
        padding: 14px 16px;
        border: 1px solid var(--sirocco);
        border-radius: var(--radius-md);
        font-size: 16px;
        background: var(--cream-base);
        color: var(--text-primary);
        transition: border-color 0.2s ease, background 0.2s ease;
        box-sizing: border-box;
    }

    .form-input:focus,
    .form-select:focus {
        outline: none;
        border-color: var(--mocha);
        background: var(--white);
    }

    .form-select {
        cursor: pointer;
    }

    .form-message {
        font-size: 13px;
        margin-top: 8px;
        min-height: 18px;
    }

    .form-message.error {
        color: #e74c3c;
    }

    .form-message.success {
        color: #27ae60;
    }

    .btn-group {
        display: flex;
        gap: 12px;
        margin-top: 30px;
    }

    .btn-submit {
        flex: 1;
        background: var(--mocha);
        color: var(--white);
        border: none;
        border-radius: 9999px;
        padding: 16px;
        font-size: 18px;
        font-weight: 600;
        cursor: pointer;
        transition: 0.3s ease;
    }

    .btn-submit:hover {
        background: var(--amber);
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(0,0,0,0.15);
    }

    .btn-cancel {
        padding: 16px 24px;
        background: var(--gray-200);
        color: var(--gray-700);
        border: none;
        border-radius: 9999px;
        font-size: 16px;
        font-weight: 600;
        cursor: pointer;
        text-decoration: none;
        transition: 0.3s ease;
        display: inline-flex;
        align-items: center;
        gap: 6px;
    }

    .btn-cancel:hover {
        background: var(--gray-300);
    }

    @media (max-width: 768px) {
        .form-container {
            padding: 40px 16px;
        }

        .form-card {
            padding: 30px 20px;
        }

        .form-header h1 {
            font-size: 28px;
        }
    }
</style>

<main>
    <div class="form-container">
        <div class="form-header">
            <h1>
                <i class="ph ph-buildings"></i>
                지점 추가
            </h1>
            <p>새로운 공유오피스 지점을 등록하세요</p>
        </div>

        <div class="form-card">
            <form action="<%=context%>/offices/add" method="post">
                <div class="form-section">
                    <label for="name" class="form-label">
                        지점명
                        <span class="required">*</span>
                    </label>
                    <input type="text" id="name" name="name" class="form-input" required placeholder="지점명을 입력하세요">
                    <p id="nameMessage" class="form-message"></p>
                </div>

                <div class="form-section">
                    <label for="address" class="form-label">주소</label>
                    <input type="text" id="address" name="address" class="form-input" placeholder="주소를 입력하세요">
                    <p id="addressMessage" class="form-message"></p>
                </div>

                <div class="form-section">
                    <label for="status" class="form-label">상태</label>
                    <select id="status" name="status" class="form-select">
                        <option value="ACTIVE" selected>활성</option>
                        <option value="INACTIVE">비활성</option>
                    </select>
                </div>

                <div class="btn-group">
                    <button type="submit" class="btn-submit">
                        <i class="ph ph-check"></i>
                        등록하기
                    </button>
                    <a href="<%=context%>/offices" class="btn-cancel">
                        <i class="ph ph-x"></i>
                        취소
                    </a>
                </div>
            </form>
        </div>
    </div>
</main>

<%@ include file="/WEB-INF/views/components/footer.jsp" %>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const nameInput = document.getElementById('name');
        const nameMessage = document.getElementById('nameMessage');

        nameInput.addEventListener('input', function() {
            if (this.value.length < 1) {
                nameMessage.textContent = '지점명을 입력해주세요.';
                nameMessage.className = 'form-message error';
            } else {
                nameMessage.textContent = '';
                nameMessage.className = 'form-message';
            }
        });
    });
</script>
