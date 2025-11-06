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

    .password-change-container {
        max-width: 600px;
        margin: 0 auto;
        padding: 60px 20px;
    }

    .password-change-header {
        text-align: center;
        margin-bottom: 50px;
    }

    .password-change-header h1 {
        color: var(--choco);
        font-size: 36px;
        font-weight: 700;
        margin-bottom: 12px;
    }

    .password-change-header p {
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

    .input-wrapper input::placeholder {
        color: var(--gray-400);
    }

    .password-strength-indicator {
        display: flex;
        gap: 4px;
        margin-top: 12px;
    }

    .strength-bar {
        flex: 1;
        height: 4px;
        border-radius: 2px;
        background: var(--gray-200);
        transition: all 0.3s ease;
    }

    .strength-bar.active {
        background: var(--mocha);
    }

    .strength-bar.active.weak {
        background: #e74c3c;
    }

    .strength-bar.active.medium {
        background: #f39c12;
    }

    .strength-bar.active.strong {
        background: #27ae60;
    }

    .password-feedback {
        margin-top: 10px;
        font-size: 14px;
        font-weight: 500;
        min-height: 20px;
    }

    .password-feedback.weak {
        color: #e74c3c;
    }

    .password-feedback.medium {
        color: #f39c12;
    }

    .password-feedback.strong {
        color: #27ae60;
    }

    .match-indicator {
        margin-top: 10px;
        font-size: 14px;
        font-weight: 500;
        min-height: 20px;
    }

    .match-indicator.match {
        color: #27ae60;
    }

    .match-indicator.no-match {
        color: #e74c3c;
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
        .password-change-container {
            padding: 30px 0;
        }

        .password-change-header h1 {
            font-size: 28px;
        }

        .input-wrapper input {
            padding: 14px 16px;
            font-size: 15px;
        }
    }
</style>

<main class="password-change-container">
    <div class="password-change-header">
        <h1>비밀번호 변경</h1>
        <p>보안을 위해 정기적으로 비밀번호를 변경해주세요</p>
    </div>

    <div class="info-text">
        <strong>비밀번호 안내</strong><br>
        • 비밀번호는 8자 이상이어야 합니다<br>
        • 기존 비밀번호와 동일한 비밀번호로 변경할 수 없습니다<br>
        • 비밀번호 변경 후 자동으로 로그아웃됩니다
    </div>

    <form id="changePasswordForm" onsubmit="changePassword(event)">
        <div class="form-section">
            <label for="currentPassword" class="form-label">현재 비밀번호</label>
            <div class="input-wrapper">
                <input type="password" id="currentPassword" name="currentPassword" 
                       placeholder="현재 비밀번호를 입력하세요" required>
            </div>
        </div>

        <div class="form-section">
            <label for="newPassword" class="form-label">새 비밀번호</label>
            <div class="input-wrapper">
                <input type="password" id="newPassword" name="newPassword" 
                       placeholder="새 비밀번호를 입력하세요 (8자 이상)" required
                       minlength="8" oninput="checkPasswordStrength()">
            </div>
            <div class="password-strength-indicator" id="strengthIndicator">
                <div class="strength-bar"></div>
                <div class="strength-bar"></div>
                <div class="strength-bar"></div>
                <div class="strength-bar"></div>
            </div>
            <div class="password-feedback" id="strengthFeedback"></div>
        </div>

        <div class="form-section">
            <label for="confirmPassword" class="form-label">새 비밀번호 확인</label>
            <div class="input-wrapper">
                <input type="password" id="confirmPassword" name="confirmPassword" 
                       placeholder="새 비밀번호를 다시 입력하세요" required
                       oninput="checkPasswordMatch()">
            </div>
            <div class="match-indicator" id="matchFeedback"></div>
        </div>

        <div id="message" class="message-box"></div>

        <button type="submit" class="btn-submit" id="submitBtn">
            <span id="submitText">비밀번호 변경하기</span>
        </button>
    </form>

    <a href="<%=context%>/user/mypage" class="back-link">
        ← 마이페이지로 돌아가기
    </a>
</main>

<script>
    function checkPasswordStrength() {
        const password = document.getElementById('newPassword').value;
        const strengthBars = document.querySelectorAll('.strength-bar');
        const feedback = document.getElementById('strengthFeedback');
        
        // 모든 바 초기화
        strengthBars.forEach(bar => {
            bar.classList.remove('active', 'weak', 'medium', 'strong');
        });

        if (password.length === 0) {
            feedback.textContent = '';
            feedback.className = 'password-feedback';
            return;
        }

        let strength = 0;
        let feedbackText = '';
        let strengthClass = '';

        // 길이 체크
        if (password.length >= 8) strength++;
        if (password.length >= 12) strength++;

        // 복잡도 체크
        if (/[a-z]/.test(password) && /[A-Z]/.test(password)) strength++;
        if (/[0-9]/.test(password)) strength++;
        if (/[^a-zA-Z0-9]/.test(password)) strength++;

        // 강도 표시
        if (strength <= 2) {
            strengthClass = 'weak';
            feedbackText = '⚠️ 약한 비밀번호입니다';
        } else if (strength <= 3) {
            strengthClass = 'medium';
            feedbackText = '⚡ 보통 비밀번호입니다';
        } else {
            strengthClass = 'strong';
            feedbackText = '✓ 강한 비밀번호입니다';
        }

        // 바 활성화
        for (let i = 0; i < strength && i < strengthBars.length; i++) {
            strengthBars[i].classList.add('active', strengthClass);
        }

        feedback.textContent = feedbackText;
        feedback.className = 'password-feedback ' + strengthClass;
    }

    function checkPasswordMatch() {
        const newPassword = document.getElementById('newPassword').value;
        const confirmPassword = document.getElementById('confirmPassword').value;
        const feedback = document.getElementById('matchFeedback');

        if (confirmPassword.length === 0) {
            feedback.textContent = '';
            feedback.className = 'match-indicator';
            return;
        }

        if (newPassword === confirmPassword) {
            feedback.textContent = '✓ 비밀번호가 일치합니다';
            feedback.className = 'match-indicator match';
        } else {
            feedback.textContent = '✗ 비밀번호가 일치하지 않습니다';
            feedback.className = 'match-indicator no-match';
        }
    }

    async function changePassword(event) {
        event.preventDefault();

        const currentPassword = document.getElementById('currentPassword').value.trim();
        const newPassword = document.getElementById('newPassword').value.trim();
        const confirmPassword = document.getElementById('confirmPassword').value.trim();
        const messageDiv = document.getElementById('message');
        const submitBtn = document.getElementById('submitBtn');
        const submitText = document.getElementById('submitText');

        // 초기화
        messageDiv.className = 'message-box';
        messageDiv.style.display = 'none';
        messageDiv.textContent = '';

        // 유효성 검사
        if (!currentPassword || !newPassword || !confirmPassword) {
            showMessage('모든 필드를 입력해주세요.', 'error');
            return;
        }

        if (newPassword.length < 8) {
            showMessage('새 비밀번호는 8자 이상이어야 합니다.', 'error');
            return;
        }

        if (newPassword !== confirmPassword) {
            showMessage('새 비밀번호가 일치하지 않습니다.', 'error');
            return;
        }

        // 버튼 비활성화
        submitBtn.disabled = true;
        submitText.textContent = '처리 중...';

        try {
            const response = await fetch('<%=context%>/api/user/change-password', {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json'
                },
                credentials: 'include',
                body: JSON.stringify({
                    currentPassword: currentPassword,
                    newPassword: newPassword
                })
            });

            const data = await response.json();
            const message = data.message || (typeof data === 'string' ? data : '비밀번호 변경 중 오류가 발생했습니다.');

            if (response.ok) {
                showMessage(message, 'success');
                
                // localStorage 정리
                localStorage.clear();

                // 2초 후 로그인 페이지로 이동
                setTimeout(() => {
                    alert('비밀번호가 변경되었습니다. 다시 로그인해주세요.');
                    window.location.href = '<%=context%>/auth/login';
                }, 2000);
            } else {
                showMessage(message, 'error');
                submitBtn.disabled = false;
                submitText.textContent = '비밀번호 변경하기';
            }
        } catch (error) {
            console.error('비밀번호 변경 오류:', error);
            showMessage('비밀번호 변경 중 오류가 발생했습니다.', 'error');
            submitBtn.disabled = false;
            submitText.textContent = '비밀번호 변경하기';
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
