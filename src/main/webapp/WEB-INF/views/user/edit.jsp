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

    .edit-container {
        max-width: 600px;
        margin: 0 auto;
        padding: 60px 20px;
    }

    .edit-header {
        text-align: center;
        margin-bottom: 50px;
    }

    .edit-header h1 {
        color: var(--choco);
        font-size: 36px;
        font-weight: 700;
        margin-bottom: 12px;
    }

    .edit-header p {
        color: var(--gray-600);
        font-size: 16px;
        line-height: 1.6;
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

    .input-wrapper {
        position: relative;
    }

    .input-wrapper input {
        width: 100%;
        padding: 16px 20px;
        border: 2px solid var(--gray-300);
        border-radius: var(--radius-md);
        font-size: 16px;
        transition: all 0.3s ease;
        background: var(--white);
        color: var(--text-primary);
        box-sizing: border-box;
    }

    .input-wrapper input:focus {
        outline: none;
        border-color: var(--mocha);
        box-shadow: 0 0 0 3px rgba(139, 108, 77, 0.1);
    }

    .input-wrapper input:disabled {
        background: var(--gray-100);
        color: var(--gray-600);
        cursor: not-allowed;
    }

    .input-wrapper input::placeholder {
        color: var(--gray-400);
    }

    .input-feedback {
        margin-top: 8px;
        font-size: 13px;
        font-weight: 500;
        min-height: 20px;
    }

    .input-feedback.error {
        color: #e74c3c;
    }

    .input-feedback.success {
        color: #27ae60;
    }

    .input-feedback.info {
        color: var(--gray-600);
    }

    .btn-submit {
        width: 100%;
        padding: 18px;
        background: var(--mocha);
        color: var(--white);
        border: none;
        border-radius: var(--radius-md);
        font-size: 18px;
        font-weight: 700;
        cursor: pointer;
        transition: all 0.3s ease;
        margin-top: 20px;
    }

    .btn-submit:hover {
        background: var(--amber);
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
    }

    .btn-submit:active {
        transform: translateY(0);
    }

    .btn-submit:disabled {
        background: var(--gray-400);
        cursor: not-allowed;
        transform: none;
        box-shadow: none;
    }

    .message-box {
        margin-top: 24px;
        padding: 16px;
        border-radius: var(--radius-md);
        font-size: 15px;
        font-weight: 500;
        text-align: center;
        display: none;
    }

    .message-box.error {
        background: #fee;
        border: 2px solid #fcc;
        color: #c33;
        display: block;
    }

    .message-box.success {
        background: #efe;
        border: 2px solid #cfc;
        color: #3c3;
        display: block;
    }

    .back-link {
        display: block;
        text-align: center;
        margin-top: 32px;
        color: var(--mocha);
        text-decoration: none;
        font-size: 15px;
        font-weight: 600;
        transition: color 0.3s ease;
    }

    .back-link:hover {
        color: var(--amber);
        text-decoration: underline;
    }

    .info-text {
        background: var(--cream-tan);
        border: 1px solid var(--gray-200);
        border-radius: var(--radius-md);
        padding: 16px 20px;
        margin-bottom: 32px;
        font-size: 14px;
        color: var(--gray-700);
        line-height: 1.6;
    }

    .info-text strong {
        color: var(--choco);
        font-weight: 600;
    }

    @media (max-width: 640px) {
        .edit-container {
            padding: 40px 16px;
        }

        .edit-header h1 {
            font-size: 28px;
        }

        .input-wrapper input {
            padding: 14px 16px;
            font-size: 15px;
        }
    }
</style>

<main class="edit-container">
    <div class="edit-header">
        <h1>내 정보 수정</h1>
        <p>회원 정보를 수정할 수 있습니다</p>
    </div>

    <div class="info-text">
        <strong>수정 안내</strong><br>
        • 이메일과 전화번호는 중복 확인이 필요합니다<br>
        • 전화번호는 010-xxxx-xxxx 형식으로 입력해주세요<br>
        • 아이디는 변경할 수 없습니다
    </div>

    <form id="editForm" onsubmit="updateUserInfo(event)">
        <div class="form-section">
            <label for="username" class="form-label">아이디</label>
            <div class="input-wrapper">
                <input type="text" id="username" name="username" 
                       value="${user.username}" disabled>
            </div>
            <div class="input-feedback info">아이디는 변경할 수 없습니다</div>
        </div>

        <div class="form-section">
            <label for="name" class="form-label">
                이름
                <span class="required">*</span>
            </label>
            <div class="input-wrapper">
                <input type="text" id="name" name="name" 
                       value="${user.name}" 
                       placeholder="이름을 입력하세요" required>
            </div>
            <div class="input-feedback" id="nameFeedback"></div>
        </div>

        <div class="form-section">
            <label for="email" class="form-label">
                이메일
                <span class="required">*</span>
            </label>
            <div class="input-wrapper">
                <input type="email" id="email" name="email" 
                       value="${user.email}" 
                       placeholder="이메일을 입력하세요" required
                       onblur="checkEmail()">
            </div>
            <div class="input-feedback" id="emailFeedback"></div>
        </div>

        <div class="form-section">
            <label for="phone" class="form-label">전화번호</label>
            <div class="input-wrapper">
                <input type="text" id="phone" name="phone" 
                       value="${user.phone}" 
                       placeholder="010-0000-0000"
                       maxlength="13"
                       oninput="formatPhoneNumber()"
                       onblur="checkPhone()">
            </div>
            <div class="input-feedback" id="phoneFeedback"></div>
        </div>

        <div id="message" class="message-box"></div>

        <button type="submit" class="btn-submit" id="submitBtn">
            <span id="submitText">정보 수정하기</span>
        </button>
    </form>

    <a href="<%=context%>/user/mypage" class="back-link">
        ← 마이페이지로 돌아가기
    </a>
</main>

<script>
    // 전화번호 자동 포맷팅
    function formatPhoneNumber() {
        const phoneInput = document.getElementById('phone');
        let value = phoneInput.value.replace(/[^0-9]/g, '');
        
        if (value.length > 3 && value.length <= 7) {
            value = value.substring(0, 3) + '-' + value.substring(3);
        } else if (value.length > 7) {
            value = value.substring(0, 3) + '-' + value.substring(3, 7) + '-' + value.substring(7, 11);
        }
        
        phoneInput.value = value;
    }

    // 이메일 유효성 검사
    function checkEmail() {
        const emailInput = document.getElementById('email');
        const email = emailInput.value.trim();
        const feedback = document.getElementById('emailFeedback');
        const originalEmail = '${user.email}';

        if (email.length === 0) {
            feedback.textContent = '';
            feedback.className = 'input-feedback';
            return;
        }

        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(email)) {
            feedback.textContent = '✗ 올바른 이메일 형식이 아닙니다';
            feedback.className = 'input-feedback error';
            return;
        }

        if (email === originalEmail) {
            feedback.textContent = '';
            feedback.className = 'input-feedback';
            return;
        }

        // 중복 확인은 서버에서 처리
        feedback.textContent = '';
        feedback.className = 'input-feedback';
    }

    // 전화번호 유효성 검사
    function checkPhone() {
        const phoneInput = document.getElementById('phone');
        const phone = phoneInput.value.trim();
        const feedback = document.getElementById('phoneFeedback');
        const originalPhone = '${user.phone}';

        if (phone.length === 0) {
            feedback.textContent = '';
            feedback.className = 'input-feedback';
            return;
        }

        const phoneRegex = /^010-\d{4}-\d{4}$/;
        if (!phoneRegex.test(phone)) {
            feedback.textContent = '✗ 전화번호는 010-xxxx-xxxx 형식이어야 합니다';
            feedback.className = 'input-feedback error';
            return;
        }

        if (phone === originalPhone) {
            feedback.textContent = '';
            feedback.className = 'input-feedback';
            return;
        }

        feedback.textContent = '';
        feedback.className = 'input-feedback';
    }

    // 이름 유효성 검사
    document.getElementById('name').addEventListener('blur', function() {
        const nameInput = this;
        const name = nameInput.value.trim();
        const feedback = document.getElementById('nameFeedback');

        if (name.length === 0) {
            feedback.textContent = '';
            feedback.className = 'input-feedback';
            return;
        }

        if (name.length < 2) {
            feedback.textContent = '✗ 이름은 2자 이상이어야 합니다';
            feedback.className = 'input-feedback error';
            return;
        }

        feedback.textContent = '';
        feedback.className = 'input-feedback';
    });

    async function updateUserInfo(event) {
        event.preventDefault();

        const name = document.getElementById('name').value.trim();
        const email = document.getElementById('email').value.trim();
        const phone = document.getElementById('phone').value.trim();
        const messageDiv = document.getElementById('message');
        const submitBtn = document.getElementById('submitBtn');
        const submitText = document.getElementById('submitText');

        // 초기화
        messageDiv.className = 'message-box';
        messageDiv.style.display = 'none';
        messageDiv.textContent = '';

        // 유효성 검사
        if (!name || !email) {
            showMessage('이름과 이메일은 필수 입력 항목입니다.', 'error');
            return;
        }

        if (name.length < 2) {
            showMessage('이름은 2자 이상이어야 합니다.', 'error');
            return;
        }

        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(email)) {
            showMessage('올바른 이메일 형식이 아닙니다.', 'error');
            return;
        }

        if (phone && !/^010-\d{4}-\d{4}$/.test(phone)) {
            showMessage('전화번호는 010-xxxx-xxxx 형식이어야 합니다.', 'error');
            return;
        }

        // 버튼 비활성화
        submitBtn.disabled = true;
        submitText.textContent = '처리 중...';

        try {
            const response = await fetch('<%=context%>/api/user/me', {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json'
                },
                credentials: 'include',
                body: JSON.stringify({
                    name: name,
                    email: email,
                    phone: phone || null
                })
            });

            const data = await response.json();
            const message = data.message || (typeof data === 'string' ? data : '정보 수정 중 오류가 발생했습니다.');

            if (response.ok) {
                showMessage(message, 'success');
                
                // 1.5초 후 마이페이지로 이동
                setTimeout(() => {
                    window.location.href = '<%=context%>/user/mypage';
                }, 1500);
            } else {
                showMessage(message, 'error');
                submitBtn.disabled = false;
                submitText.textContent = '정보 수정하기';
            }
        } catch (error) {
            console.error('정보 수정 오류:', error);
            showMessage('정보 수정 중 오류가 발생했습니다.', 'error');
            submitBtn.disabled = false;
            submitText.textContent = '정보 수정하기';
        }
    }

    function showMessage(text, type) {
        const messageDiv = document.getElementById('message');
        messageDiv.textContent = text;
        messageDiv.className = 'message-box ' + type;
        messageDiv.style.display = 'block';
    }
</script>

<%@ include file="/WEB-INF/views/components/footer.jsp" %>
