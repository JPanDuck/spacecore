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
                    <p>안녕하세요! Space Core 챗봇입니다. 무엇을 도와드릴까요? 😊</p>
                </div>
            </div>
            <div class="chatbot-quick-questions" id="quickQuestions">
                <!-- 빠른 질문 버튼들이 여기에 동적으로 추가됩니다 -->
            </div>
        </div>
        <div class="chatbot-input-area">
            <input type="text" id="chatbotInput" class="chatbot-input" placeholder="질문을 입력하세요..." maxlength="500">
            <button id="chatbotSend" class="chatbot-send-btn">
                <i class="ph ph-paper-plane-tilt"></i>
            </button>
        </div>
        <div class="chatbot-footer-link">
            <a href="${pageContext.request.contextPath}/chatbot/faq" target="_blank">전체 FAQ 보기</a>
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

    /* 빠른 질문 버튼 영역 */
    .chatbot-quick-questions {
        display: flex;
        flex-wrap: wrap;
        gap: 8px;
        padding: 12px 20px;
        margin-top: 8px;
    }

    /* 답변 아래에 표시되는 인라인 FAQ 목록 */
    .chatbot-quick-questions-inline {
        margin-top: 12px;
        margin-bottom: 8px;
        padding: 12px 0;
        border-top: 1px solid var(--gray-200);
    }

    .quick-question-btn {
        padding: 8px 16px;
        background: var(--white);
        border: 1px solid var(--gray-300);
        border-radius: 20px;
        font-size: 13px;
        color: var(--text-primary);
        cursor: pointer;
        transition: all 0.3s ease;
        white-space: nowrap;
    }

    .quick-question-btn:hover {
        background: var(--choco);
        color: var(--white);
        border-color: var(--choco);
        transform: translateY(-2px);
        box-shadow: 0 2px 8px rgba(91, 59, 49, 0.2);
    }

    /* 챗봇 입력 영역 */
    .chatbot-input-area {
        display: flex;
        gap: 8px;
        padding: 16px;
        background: var(--white);
        border-top: 1px solid var(--gray-200);
    }

    /* 챗봇 푸터 링크 */
    .chatbot-footer-link {
        padding: 12px 16px;
        text-align: center;
        background: var(--gray-50);
        border-top: 1px solid var(--gray-200);
    }

    .chatbot-footer-link a {
        font-size: 13px;
        color: var(--choco);
        text-decoration: underline;
        transition: color 0.3s ease;
    }

    .chatbot-footer-link a:hover {
        color: var(--amber);
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
        const quickQuestions = document.getElementById('quickQuestions');

        let faqData = []; // FAQ 데이터 캐시
        let categories = []; // 카테고리 목록

        // FAQ 데이터 로드 (개선된 버전)
        async function loadFAQData() {
            try {
                // 먼저 전역 변수에서 FAQ 데이터 확인 (FAQ 페이지에서 제공)
                if (window.faqDataForChatbot && window.faqDataForChatbot.length > 0) {
                    faqData = window.faqDataForChatbot.map(item => ({
                        id: item.id,
                        category: item.category,
                        question: item.question,
                        answer: item.answer,
                        priority: item.priority
                    }));
                    
                    // 카테고리 목록 추출
                    categories = [...new Set(faqData.map(faq => faq.category).filter(cat => cat))];
                    console.log('전역 변수에서 FAQ 데이터 로드:', faqData.length);
                    return;
                }

                // 전역 변수가 없으면 FAQ 페이지에서 카테고리 목록을 가져오기
                const response = await fetch('${pageContext.request.contextPath}/chatbot/faq');
                const html = await response.text();
                const parser = new DOMParser();
                const doc = parser.parseFromString(html, 'text/html');
                
                // JSON 데이터가 페이지에 포함되어 있는지 확인
                const faqJsonElement = doc.getElementById('faqJsonData');
                if (faqJsonElement) {
                    try {
                        const jsonData = JSON.parse(faqJsonElement.textContent);
                        faqData = jsonData.map(item => ({
                            id: item.id,
                            category: item.category,
                            question: item.question,
                            answer: item.answer,
                            priority: item.priority
                        }));
                        categories = [...new Set(faqData.map(faq => faq.category).filter(cat => cat))];
                        console.log('JSON에서 FAQ 데이터 로드:', faqData.length);
                        return;
                    } catch (e) {
                        console.error('JSON 파싱 오류:', e);
                    }
                }
                
                // JSON이 없으면 HTML 파싱 방식 사용
                const categoryLinks = doc.querySelectorAll('.category-tab');
                const categoryUrls = Array.from(categoryLinks).map(link => {
                    const href = link.getAttribute('href');
                    const categoryName = link.textContent.trim().replace(/[📁\s]/g, '').trim();
                    return { name: categoryName, url: href };
                });

                categories = categoryUrls.map(cat => cat.name).filter(name => name);

                // 각 카테고리별로 FAQ 데이터 가져오기
                for (const catInfo of categoryUrls) {
                    if (!catInfo.name) continue;
                    
                    try {
                        const catResponse = await fetch('${pageContext.request.contextPath}/chatbot/faq?category=' + encodeURIComponent(catInfo.name));
                        const catHtml = await catResponse.text();
                        const catDoc = parser.parseFromString(catHtml, 'text/html');
                        
                        // JSON 데이터 확인
                        const catJsonElement = catDoc.getElementById('faqJsonData');
                        if (catJsonElement) {
                            try {
                                const jsonData = JSON.parse(catJsonElement.textContent);
                                jsonData.forEach(item => {
                                    faqData.push({
                                        id: item.id,
                                        category: item.category,
                                        question: item.question,
                                        answer: item.answer,
                                        priority: item.priority
                                    });
                                });
                                continue;
                            } catch (e) {
                                console.error('카테고리 JSON 파싱 오류:', e);
                            }
                        }
                        
                        // HTML 파싱 방식
                        const faqItems = catDoc.querySelectorAll('.faq-item');
                        faqItems.forEach((item) => {
                            const question = item.getAttribute('data-question') || 
                                           item.querySelector('.faq-question span')?.textContent.trim() || '';
                            const answer = item.getAttribute('data-answer') || 
                                         item.querySelector('.faq-answer-content')?.textContent.trim() || '';
                            
                            if (question && answer) {
                                faqData.push({
                                    category: catInfo.name,
                                    question: question,
                                    answer: answer
                                });
                            }
                        });
                    } catch (err) {
                        console.error('카테고리 데이터 로드 실패:', catInfo.name, err);
                    }
                }

                console.log('로드된 FAQ 데이터 개수:', faqData.length);
            } catch (err) {
                console.error('FAQ 데이터 로드 실패:', err);
            }
        }

        // 빠른 질문 버튼 생성 (컨테이너 지정 가능)
        function createQuickQuestions(container) {
            const targetContainer = container || quickQuestions;
            targetContainer.innerHTML = '';
            
            // FAQ 데이터에서 실제 질문들을 추출하여 빠른 질문 버튼으로 사용
            let quickQList = [];
            
            if (faqData.length > 0) {
                // FAQ 데이터에서 우선순위가 높은 질문들 추출 (최대 5개)
                const sortedFaqs = [...faqData].slice(0, 5);
                quickQList = sortedFaqs.map(faq => faq.question);
            } else {
                // FAQ 데이터가 없으면 기본 질문들 사용
                quickQList = [
                    '예약 방법이 궁금해요',
                    '결제는 어떻게 하나요?',
                    '환불 정책은?',
                    '오피스 위치는 어디인가요?',
                    '이용 시간은 어떻게 되나요?'
                ];
            }

            quickQList.forEach(question => {
                if (!question) return;
                
                const btn = document.createElement('button');
                btn.className = 'quick-question-btn';
                btn.textContent = question.length > 20 ? question.substring(0, 20) + '...' : question;
                btn.title = question; // 전체 텍스트를 툴팁으로
                btn.addEventListener('click', () => {
                    chatbotInput.value = question;
                    sendMessage();
                });
                targetContainer.appendChild(btn);
            });
        }
        
        // 답변 메시지 아래에 FAQ 목록 추가
        function addQuickQuestionsAfterMessage(messageElement) {
            if (!messageElement || !messageElement.parentNode) return;
            
            // 이미 FAQ 목록이 있는지 확인
            let quickQContainer = messageElement.nextElementSibling;
            if (quickQContainer && quickQContainer.classList.contains('chatbot-quick-questions-inline')) {
                // 이미 있으면 업데이트만
                createQuickQuestions(quickQContainer);
                quickQContainer.style.display = 'flex';
                // 스크롤 업데이트
                setTimeout(() => {
                    chatbotMessages.scrollTop = chatbotMessages.scrollHeight;
                }, 100);
                return;
            }
            
            // 새로운 FAQ 목록 컨테이너 생성
            quickQContainer = document.createElement('div');
            quickQContainer.className = 'chatbot-quick-questions chatbot-quick-questions-inline';
            quickQContainer.style.display = 'flex';
            
            // 메시지 다음에 삽입
            messageElement.parentNode.insertBefore(quickQContainer, messageElement.nextSibling);
            
            // FAQ 목록 생성
            createQuickQuestions(quickQContainer);
            
            // 스크롤을 맨 아래로 이동
            setTimeout(() => {
                chatbotMessages.scrollTop = chatbotMessages.scrollHeight;
            }, 100);
        }

        // FAQ 검색 함수 (개선된 버전)
        function searchFAQ(query) {
            if (!query || faqData.length === 0) {
                return null;
            }

            const lowerQuery = query.toLowerCase().trim();
            const keywords = lowerQuery.split(/\s+/).filter(k => k.length > 0);

            // 점수 기반 매칭
            let bestMatch = null;
            let bestScore = 0;
            const matches = [];

            faqData.forEach(faq => {
                const questionLower = faq.question.toLowerCase();
                const answerLower = faq.answer.toLowerCase();
                let score = 0;

                // 완전 일치 (가장 높은 점수)
                if (questionLower === lowerQuery) {
                    score += 100;
                } else if (answerLower.includes(lowerQuery)) {
                    score += 50;
                }

                // 질문 시작 부분 일치
                if (questionLower.startsWith(lowerQuery)) {
                    score += 30;
                }

                // 정확한 일치
                if (questionLower.includes(lowerQuery)) {
                    score += 20;
                }
                
                if (answerLower.includes(lowerQuery)) {
                    score += 10;
                }

                // 키워드 매칭
                keywords.forEach(keyword => {
                    if (keyword.length < 2) return;
                    
                    if (questionLower.includes(keyword)) {
                        score += 5;
                    }
                    if (answerLower.includes(keyword)) {
                        score += 2;
                    }
                });

                // 질문과 답변 모두에서 키워드 발견
                const matchedKeywords = keywords.filter(k => 
                    questionLower.includes(k) || answerLower.includes(k)
                ).length;
                if (matchedKeywords === keywords.length && keywords.length > 0) {
                    score += 10;
                }

                if (score > 0) {
                    matches.push({ faq, score });
                    if (score > bestScore) {
                        bestScore = score;
                        bestMatch = faq;
                    }
                }
            });

            // 최소 점수 이상인 경우만 반환
            return bestScore >= 5 ? bestMatch : null;
        }

        // 팝업 열기
        async function openChatbot() {
            chatbotPopup.classList.add('active');
            chatbotOverlay.classList.add('active');
            document.body.style.overflow = 'hidden';
            chatbotInput.focus();

            // FAQ 데이터가 없으면 로드
            if (faqData.length === 0) {
                const loadingMsg = addMessage('FAQ 데이터를 불러오는 중입니다...', false);
                try {
                    await loadFAQData();
                    // 로딩 메시지 제거 (정상적으로 로드되었을 때는 조용히 제거)
                    if (loadingMsg && loadingMsg.parentNode) {
                        loadingMsg.remove();
                    }
                } catch (err) {
                    // 오류 발생 시에만 오류 메시지 표시
                    if (loadingMsg && loadingMsg.parentNode) {
                        loadingMsg.remove();
                    }
                    addMessage('FAQ 데이터를 불러오는 중 오류가 발생했습니다.', false);
                    console.error('FAQ 로드 오류:', err);
                }
            }
            
            createQuickQuestions();
        }

        // 팝업 닫기
        function closeChatbot() {
            chatbotPopup.classList.remove('active');
            chatbotOverlay.classList.remove('active');
            document.body.style.overflow = '';
        }

        // 메시지 추가 함수
        function addMessage(text, isUser, isTyping = false) {
            const messageDiv = document.createElement('div');
            messageDiv.className = 'chatbot-message ' + (isUser ? 'chatbot-message-user' : 'chatbot-message-bot');
            if (isTyping) {
                messageDiv.classList.add('typing-indicator');
            }
            
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
            return messageDiv;
        }

        // 타이핑 애니메이션
        function showTypingIndicator() {
            const typingDiv = addMessage('입력 중...', false, true);
            return typingDiv;
        }

        // 메시지 전송
        async function sendMessage() {
            const text = chatbotInput.value.trim();
            if (!text) return;

            // 사용자 메시지 추가
            addMessage(text, true);
            chatbotInput.value = '';
            chatbotSend.disabled = true;

            // 빠른 질문 버튼 숨기기
            quickQuestions.style.display = 'none';

            // 타이핑 인디케이터
            const typingDiv = showTypingIndicator();

            // 약간의 딜레이 (자연스러운 대화 느낌)
            await new Promise(resolve => setTimeout(resolve, 800));

            // 타이핑 인디케이터 제거
            typingDiv.remove();

            // FAQ 데이터가 없으면 먼저 로드 시도
            if (faqData.length === 0) {
                await loadFAQData();
            }

            // FAQ 검색
            const matchedFAQ = searchFAQ(text);

            if (matchedFAQ) {
                // 매칭된 FAQ 답변 표시
                const answerMessage = addMessage(matchedFAQ.answer, false);
                
                // 답변 메시지 바로 아래에 FAQ 목록 추가
                if (faqData.length > 0) {
                    addQuickQuestionsAfterMessage(answerMessage);
                }
                
                // 추가 도움이 필요하면 안내
                setTimeout(() => {
                    addMessage('더 궁금한 점이 있으시면 위의 질문 버튼을 클릭하거나 질문해 주세요. 전체 FAQ 페이지에서도 더 많은 정보를 확인하실 수 있습니다.', false);
                }, 500);
            } else {
                // 매칭되는 FAQ가 없을 때
                addMessage('죄송합니다. 관련된 답변을 찾지 못했습니다. 😔', false);
                setTimeout(() => {
                    addMessage('다른 방식으로 질문해 주시거나, 전체 FAQ 페이지를 확인해 보시기 바랍니다.', false);
                    setTimeout(() => {
                        if (faqData.length > 0) {
                            createQuickQuestions();
                            quickQuestions.style.display = 'flex';
                        }
                    }, 300);
                }, 500);
            }

            chatbotSend.disabled = false;
        }

        // 이벤트 리스너
        chatbotButton.addEventListener('click', openChatbot);
        chatbotClose.addEventListener('click', closeChatbot);
        chatbotOverlay.addEventListener('click', closeChatbot);
        chatbotSend.addEventListener('click', sendMessage);
        
        // Enter 키로 메시지 전송
        chatbotInput.addEventListener('keypress', function(e) {
            if (e.key === 'Enter' && !e.shiftKey) {
                e.preventDefault();
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