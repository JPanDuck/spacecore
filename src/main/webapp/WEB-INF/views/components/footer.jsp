<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<footer class="app-footer">
    <div class="container-1980">
        <p>© 2025 <strong>Space Core</strong>. All Rights Reserved.</p>
        <p style="margin-top:8px; font-size:13px; opacity:0.8;">
            Designed & Built by Space Core Team
        </p>
    </div>
</footer>

<!-- ✅ 챗봇 버튼 및 팝업 -->
<button id="chatbotButton" class="chatbot-button" title="챗봇 상담">
    <img src="${pageContext.request.contextPath}/img/bot.png" alt="챗봇" class="chatbot-icon">
</button>

<!-- 챗봇 팝업 -->
<div id="chatbotPopup" class="chatbot-popup">
    <div class="chatbot-popup-header">
        <div class="chatbot-popup-title">
            <img src="${pageContext.request.contextPath}/img/bot.png" alt="챗봇" class="chatbot-popup-icon">
            <span>챗봇 상담</span>
        </div>
        <button id="chatbotClose" class="chatbot-close-btn">
            <i class="ph ph-x"></i>
        </button>
    </div>
    <div class="chatbot-popup-content">
        <div class="chatbot-messages" id="chatbotMessages">
            <div class="chatbot-message chatbot-message-bot">
                <div class="message-avatar">
                    <img src="${pageContext.request.contextPath}/img/bot.png" alt="봇">
                </div>
                <div class="message-content">
                    <p>안녕하세요! Space Core 챗봇입니다. 무엇을 도와드릴까요?</p>
                </div>
            </div>
        </div>
        <div class="chatbot-input-area">
            <input type="text" id="chatbotInput" class="chatbot-input" placeholder="메시지를 입력하세요..." maxlength="500">
            <button id="chatbotSend" class="chatbot-send-btn">
                <i class="ph ph-paper-plane-tilt"></i>
            </button>
        </div>
    </div>
</div>

<!-- 챗봇 팝업 오버레이 -->
<div id="chatbotOverlay" class="chatbot-overlay"></div>

<style>
    /* 챗봇 버튼 스타일 */
    .chatbot-button {
        position: fixed;
        bottom: 30px;
        right: 30px;
        width: 60px;
        height: 60px;
        border-radius: 50%;
        background: var(--choco);
        color: var(--white);
        border: none;
        cursor: pointer;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        transition: all 0.3s ease;
        z-index: 1000;
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 0;
        overflow: hidden;
    }

    .chatbot-icon {
        width: 40px;
        height: 40px;
        object-fit: contain;
    }

    .chatbot-button:hover {
        background: var(--amber);
        transform: scale(1.1);
        box-shadow: 0 6px 16px rgba(0, 0, 0, 0.2);
    }

    .chatbot-button:active {
        transform: scale(0.95);
    }

    /* 챗봇 팝업 오버레이 */
    .chatbot-overlay {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0, 0, 0, 0.3);
        opacity: 0;
        visibility: hidden;
        transition: opacity 0.3s ease, visibility 0.3s ease;
        z-index: 1001;
    }

    .chatbot-overlay.active {
        opacity: 1;
        visibility: visible;
    }

    /* 챗봇 팝업 */
    .chatbot-popup {
        position: fixed;
        bottom: 100px;
        right: 30px;
        width: 380px;
        height: 600px;
        background: var(--white);
        border-radius: 16px;
        box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
        display: flex;
        flex-direction: column;
        opacity: 0;
        visibility: hidden;
        transform: scale(0.8) translateY(20px);
        transition: all 0.3s ease;
        z-index: 1002;
        overflow: hidden;
    }

    .chatbot-popup.active {
        opacity: 1;
        visibility: visible;
        transform: scale(1) translateY(0);
    }

    /* 챗봇 팝업 헤더 */
    .chatbot-popup-header {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 20px;
        background: var(--choco);
        color: var(--white);
        border-bottom: 1px solid rgba(255, 255, 255, 0.1);
    }

    .chatbot-popup-title {
        display: flex;
        align-items: center;
        gap: 12px;
        font-size: 18px;
        font-weight: 600;
    }

    .chatbot-popup-icon {
        width: 32px;
        height: 32px;
        object-fit: contain;
    }

    .chatbot-close-btn {
        background: none;
        border: none;
        color: var(--white);
        font-size: 24px;
        cursor: pointer;
        padding: 4px;
        display: flex;
        align-items: center;
        justify-content: center;
        transition: transform 0.2s ease;
        border-radius: 4px;
    }

    .chatbot-close-btn:hover {
        background: rgba(255, 255, 255, 0.1);
        transform: rotate(90deg);
    }

    /* 챗봇 팝업 콘텐츠 */
    .chatbot-popup-content {
        display: flex;
        flex-direction: column;
        height: 100%;
        flex: 1;
        overflow: hidden;
    }

    /* 챗봇 메시지 영역 */
    .chatbot-messages {
        flex: 1;
        overflow-y: auto;
        padding: 20px;
        background: var(--gray-50);
        display: flex;
        flex-direction: column;
        gap: 16px;
    }

    .chatbot-messages::-webkit-scrollbar {
        width: 6px;
    }

    .chatbot-messages::-webkit-scrollbar-track {
        background: transparent;
    }

    .chatbot-messages::-webkit-scrollbar-thumb {
        background: var(--gray-300);
        border-radius: 3px;
    }

    .chatbot-messages::-webkit-scrollbar-thumb:hover {
        background: var(--gray-400);
    }

    /* 챗봇 메시지 */
    .chatbot-message {
        display: flex;
        gap: 12px;
        max-width: 80%;
        animation: fadeInUp 0.3s ease;
    }

    @keyframes fadeInUp {
        from {
            opacity: 0;
            transform: translateY(10px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    .chatbot-message-bot {
        align-self: flex-start;
    }

    .chatbot-message-user {
        align-self: flex-end;
        flex-direction: row-reverse;
    }

    .message-avatar {
        width: 36px;
        height: 36px;
        border-radius: 50%;
        background: var(--choco);
        display: flex;
        align-items: center;
        justify-content: center;
        flex-shrink: 0;
        overflow: hidden;
    }

    .chatbot-message-user .message-avatar {
        background: var(--amber);
    }

    .message-avatar img {
        width: 28px;
        height: 28px;
        object-fit: contain;
    }

    .message-content {
        background: var(--white);
        padding: 12px 16px;
        border-radius: 12px;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
    }

    .chatbot-message-user .message-content {
        background: var(--choco);
        color: var(--white);
    }

    .message-content p {
        margin: 0;
        font-size: 14px;
        line-height: 1.5;
        word-wrap: break-word;
    }

    /* 챗봇 입력 영역 */
    .chatbot-input-area {
        display: flex;
        gap: 8px;
        padding: 16px;
        background: var(--white);
        border-top: 1px solid var(--gray-200);
    }

    .chatbot-input {
        flex: 1;
        padding: 12px 16px;
        border: 1px solid var(--gray-300);
        border-radius: 24px;
        font-size: 14px;
        outline: none;
        transition: border-color 0.3s ease;
    }

    .chatbot-input:focus {
        border-color: var(--choco);
    }

    .chatbot-send-btn {
        width: 44px;
        height: 44px;
        border-radius: 50%;
        background: var(--choco);
        color: var(--white);
        border: none;
        cursor: pointer;
        display: flex;
        align-items: center;
        justify-content: center;
        transition: all 0.3s ease;
        font-size: 20px;
    }

    .chatbot-send-btn:hover {
        background: var(--amber);
        transform: scale(1.05);
    }

    .chatbot-send-btn:active {
        transform: scale(0.95);
    }

    .chatbot-send-btn:disabled {
        background: var(--gray-300);
        cursor: not-allowed;
        transform: none;
    }

    /* 모바일 반응형 */
    @media (max-width: 768px) {
        .chatbot-button {
            width: 50px;
            height: 50px;
            bottom: 20px;
            right: 20px;
        }

        .chatbot-icon {
            width: 32px;
            height: 32px;
        }

        .chatbot-popup {
            width: calc(100% - 40px);
            height: calc(100vh - 100px);
            bottom: 80px;
            right: 20px;
            left: 20px;
            max-width: 380px;
        }
    }

    @media (max-width: 480px) {
        .chatbot-popup {
            width: calc(100% - 20px);
            right: 10px;
            left: 10px;
        }
    }
</style>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const chatbotButton = document.getElementById('chatbotButton');
        const chatbotPopup = document.getElementById('chatbotPopup');
        const chatbotOverlay = document.getElementById('chatbotOverlay');
        const chatbotClose = document.getElementById('chatbotClose');
        const chatbotInput = document.getElementById('chatbotInput');
        const chatbotSend = document.getElementById('chatbotSend');
        const chatbotMessages = document.getElementById('chatbotMessages');

        // 팝업 열기
        function openChatbot() {
            chatbotPopup.classList.add('active');
            chatbotOverlay.classList.add('active');
            document.body.style.overflow = 'hidden';
            chatbotInput.focus();
        }

        // 팝업 닫기
        function closeChatbot() {
            chatbotPopup.classList.remove('active');
            chatbotOverlay.classList.remove('active');
            document.body.style.overflow = '';
        }

        // 메시지 추가 함수
        function addMessage(text, isUser) {
            const messageDiv = document.createElement('div');
            messageDiv.className = 'chatbot-message ' + (isUser ? 'chatbot-message-user' : 'chatbot-message-bot');
            
            const avatarDiv = document.createElement('div');
            avatarDiv.className = 'message-avatar';
            const avatarImg = document.createElement('img');
            avatarImg.src = '${pageContext.request.contextPath}/img/bot.png';
            avatarImg.alt = isUser ? '사용자' : '봇';
            avatarDiv.appendChild(avatarImg);
            
            const contentDiv = document.createElement('div');
            contentDiv.className = 'message-content';
            const p = document.createElement('p');
            p.textContent = text;
            contentDiv.appendChild(p);
            
            messageDiv.appendChild(avatarDiv);
            messageDiv.appendChild(contentDiv);
            
            chatbotMessages.appendChild(messageDiv);
            
            // 스크롤을 맨 아래로
            chatbotMessages.scrollTop = chatbotMessages.scrollHeight;
        }

        // 메시지 전송
        function sendMessage() {
            const text = chatbotInput.value.trim();
            if (!text) return;

            // 사용자 메시지 추가
            addMessage(text, true);
            chatbotInput.value = '';

            // 봇 응답 (예시)
            setTimeout(function() {
                addMessage('죄송합니다. 챗봇 기능은 현재 개발 중입니다. 곧 만나뵐게요! 😊', false);
            }, 500);
        }

        // 이벤트 리스너
        chatbotButton.addEventListener('click', openChatbot);
        chatbotClose.addEventListener('click', closeChatbot);
        chatbotOverlay.addEventListener('click', closeChatbot);
        chatbotSend.addEventListener('click', sendMessage);
        
        // Enter 키로 메시지 전송
        chatbotInput.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                sendMessage();
            }
        });

        // ESC 키로 팝업 닫기
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape' && chatbotPopup.classList.contains('active')) {
                closeChatbot();
            }
        });
    });
</script>