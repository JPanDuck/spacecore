<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FAQ | Space Core</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/phosphor-icons@1.4.2/dist/phosphor.css">
    <style>
        .faq-container {
            max-width: 1200px;
            margin: 40px auto;
            padding: 20px;
        }

        .faq-header {
            text-align: center;
            margin-bottom: 40px;
            padding: 40px 20px;
            background: linear-gradient(135deg, var(--choco) 0%, var(--amber) 100%);
            border-radius: 16px;
            color: var(--white);
        }

        .faq-header h1 {
            font-size: 36px;
            font-weight: 700;
            margin-bottom: 12px;
        }

        .faq-header p {
            font-size: 16px;
            opacity: 0.95;
        }

        .faq-categories {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
            margin-bottom: 40px;
            padding: 20px;
            background: var(--white);
            border-radius: 12px;
            box-shadow: var(--shadow-sm);
        }

        .category-tab {
            padding: 12px 24px;
            background: var(--gray-100);
            color: var(--text-primary);
            border: 2px solid var(--gray-300);
            border-radius: 24px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .category-tab:hover {
            background: var(--choco);
            color: var(--white);
            border-color: var(--choco);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(91, 59, 49, 0.2);
        }

        .category-tab.active {
            background: var(--choco);
            color: var(--white);
            border-color: var(--choco);
            box-shadow: 0 4px 12px rgba(91, 59, 49, 0.3);
        }

        .faq-content {
            background: var(--white);
            border-radius: 12px;
            box-shadow: var(--shadow-sm);
            overflow: hidden;
        }

        .faq-category-title {
            padding: 24px 30px;
            background: var(--cream-tan);
            border-bottom: 2px solid var(--gray-200);
            font-size: 20px;
            font-weight: 700;
            color: var(--choco);
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .faq-list {
            padding: 0;
        }

        .faq-item {
            border-bottom: 1px solid var(--gray-200);
            transition: all 0.3s ease;
        }

        .faq-item:last-child {
            border-bottom: none;
        }

        .faq-item:hover {
            background: var(--gray-50);
        }

        .faq-question {
            padding: 24px 30px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            font-size: 16px;
            font-weight: 600;
            color: var(--text-primary);
            transition: all 0.3s ease;
            user-select: none;
        }

        .faq-question:hover {
            color: var(--choco);
        }

        .faq-question.active {
            color: var(--choco);
        }

        .faq-question-icon {
            font-size: 20px;
            color: var(--amber);
            transition: transform 0.3s ease;
            flex-shrink: 0;
        }

        .faq-question.active .faq-question-icon {
            transform: rotate(180deg);
        }

        .faq-answer {
            max-height: 0;
            overflow: hidden;
            transition: max-height 0.4s ease, padding 0.4s ease;
            background: var(--gray-50);
        }

        .faq-answer.active {
            max-height: 1000px;
            padding: 24px 30px;
        }

        .faq-answer-content {
            color: var(--text-primary);
            font-size: 15px;
            line-height: 1.8;
            white-space: pre-line;
        }

        .faq-empty {
            text-align: center;
            padding: 80px 20px;
            color: var(--gray-600);
        }

        .faq-empty-icon {
            font-size: 64px;
            color: var(--gray-400);
            margin-bottom: 20px;
        }

        .faq-empty h3 {
            font-size: 24px;
            margin-bottom: 12px;
            color: var(--text-primary);
        }

        .faq-empty p {
            font-size: 16px;
            color: var(--gray-600);
        }

        .initial-state {
            text-align: center;
            padding: 80px 20px;
            color: var(--gray-600);
        }

        .initial-state-icon {
            font-size: 80px;
            color: var(--gray-300);
            margin-bottom: 24px;
        }

        .initial-state h3 {
            font-size: 28px;
            margin-bottom: 12px;
            color: var(--text-primary);
        }

        .initial-state p {
            font-size: 16px;
            color: var(--gray-600);
            margin-bottom: 30px;
        }

        @media (max-width: 768px) {
            .faq-container {
                padding: 10px;
            }

            .faq-header h1 {
                font-size: 28px;
            }

            .faq-categories {
                padding: 15px;
            }

            .category-tab {
                padding: 10px 18px;
                font-size: 14px;
            }

            .faq-question {
                padding: 20px;
                font-size: 15px;
            }

            .faq-answer.active {
                padding: 20px;
            }
        }

        .search-box {
            margin-bottom: 30px;
            position: relative;
        }

        .search-input {
            width: 100%;
            padding: 16px 20px 16px 50px;
            border: 2px solid var(--gray-300);
            border-radius: 12px;
            font-size: 16px;
            transition: all 0.3s ease;
            background: var(--white);
        }

        .search-input:focus {
            outline: none;
            border-color: var(--choco);
            box-shadow: 0 0 0 3px rgba(91, 59, 49, 0.1);
        }

        .search-icon {
            position: absolute;
            left: 18px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 20px;
            color: var(--gray-500);
        }
    </style>
</head>
<body>
<!-- ✅ 헤더 include -->
<%@ include file="../components/header.jsp" %>

<div class="faq-container">
    <div class="faq-header">
        <h1><i class="ph ph-question"></i> 자주 묻는 질문</h1>
        <p>궁금한 점을 빠르게 찾아보세요</p>
    </div>

    <%-- 검색 박스 --%>
    <div class="search-box">
        <i class="ph ph-magnifying-glass search-icon"></i>
        <input type="text" id="faqSearch" class="search-input" placeholder="질문을 검색해보세요...">
    </div>

    <%-- 카테고리 탭 메뉴 --%>
    <c:if test="${not empty categories}">
        <div class="faq-categories">
            <c:forEach var="categoryName" items="${categories}">
                <a href="${pageContext.request.contextPath}/chatbot/faq?category=${categoryName}"
                   class="category-tab <c:if test="${currentCategory eq categoryName}">active</c:if>">
                    <i class="ph ph-folder"></i>
                    ${categoryName}
                </a>
            </c:forEach>
        </div>
    </c:if>

    <%-- FAQ 목록 --%>
    <div class="faq-content">
        <c:choose>
            <c:when test="${empty faqList}">
                <c:choose>
                    <c:when test="${currentCategory eq '선택 필요'}">
                        <div class="initial-state">
                            <div class="initial-state-icon">
                                <i class="ph ph-magnifying-glass"></i>
                            </div>
                            <h3>카테고리를 선택해주세요</h3>
                            <p>위의 카테고리 탭을 클릭하여 원하는 주제의 FAQ를 확인하세요.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="faq-empty">
                            <div class="faq-empty-icon">
                                <i class="ph ph-file-x"></i>
                            </div>
                            <h3>등록된 질문이 없습니다</h3>
                            <p>현재 [${currentCategory}] 카테고리에 등록된 FAQ가 없습니다.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </c:when>
            <c:otherwise>
                <div class="faq-category-title">
                    <i class="ph ph-folder-open"></i>
                    ${currentCategory}
                    <span style="margin-left: auto; font-size: 14px; font-weight: 500; opacity: 0.7;">
                        총 ${fn:length(faqList)}개의 FAQ
                    </span>
                </div>
                <div class="faq-list" id="faqList">
                    <c:forEach var="faq" items="${faqList}">
                        <div class="faq-item" data-question="${faq.question}" data-answer="${faq.answer}">
                            <div class="faq-question" onclick="toggleAnswer(this)">
                                <span>${faq.question}</span>
                                <i class="ph ph-caret-down faq-question-icon"></i>
                            </div>
                            <div class="faq-answer">
                                <div class="faq-answer-content">${faq.answer}</div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<!-- ✅ 푸터 include -->
<%@ include file="../components/footer.jsp" %>

<!-- 챗봇용 FAQ 데이터 로드 스크립트 -->
<script>
    // 챗봇이 FAQ 데이터를 쉽게 가져올 수 있도록 전역 변수로 제공
    (function() {
        window.faqDataForChatbot = window.faqDataForChatbot || [];
        
        // FAQ 데이터를 안전하게 추가하는 함수
        function addFaqToChatbot(id, category, question, answer, priority) {
            // JSON 문자열로 변환하여 안전하게 처리
            const faqItem = {
                id: id || 0,
                category: (category || '').replace(/"/g, '\\"').replace(/\n/g, '\\n').replace(/\r/g, '\\r'),
                question: (question || '').replace(/"/g, '\\"').replace(/\n/g, '\\n').replace(/\r/g, '\\r'),
                answer: (answer || '').replace(/"/g, '\\"').replace(/\n/g, '\\n').replace(/\r/g, '\\r'),
                priority: priority || 100
            };
            
            // 중복 체크 (id 기준)
            const exists = window.faqDataForChatbot.some(item => item.id === faqItem.id);
            if (!exists) {
                window.faqDataForChatbot.push(faqItem);
            }
        }
        
        // 현재 페이지의 FAQ 데이터를 전역 변수에 추가
        <c:if test="${not empty faqList}">
        <c:forEach var="faq" items="${faqList}">
        addFaqToChatbot(
            ${faq.id},
            '<c:out value="${faq.category}" escapeXml="true"/>',
            '<c:out value="${faq.question}" escapeXml="true"/>',
            '<c:out value="${faq.answer}" escapeXml="true"/>',
            ${faq.priority}
        );
        </c:forEach>
        </c:if>
    })();
</script>

<script>
    function toggleAnswer(questionEl) {
        const faqItem = questionEl.closest('.faq-item');
        const answerEl = faqItem.querySelector('.faq-answer');
        const isActive = questionEl.classList.contains('active');

        // 모든 FAQ 아이템 닫기 (선택사항 - 원하면 주석 처리)
        // document.querySelectorAll('.faq-question').forEach(q => {
        //     q.classList.remove('active');
        //     q.nextElementSibling.classList.remove('active');
        // });

        // 현재 아이템 토글
        if (isActive) {
            questionEl.classList.remove('active');
            answerEl.classList.remove('active');
        } else {
            questionEl.classList.add('active');
            answerEl.classList.add('active');
        }
    }

    // 검색 기능
    document.addEventListener('DOMContentLoaded', function() {
        const searchInput = document.getElementById('faqSearch');
        const faqItems = document.querySelectorAll('.faq-item');

        if (searchInput && faqItems.length > 0) {
            searchInput.addEventListener('input', function(e) {
                const searchTerm = e.target.value.toLowerCase().trim();
                
                faqItems.forEach(item => {
                    const question = item.dataset.question.toLowerCase();
                    const answer = item.dataset.answer.toLowerCase();
                    const matches = searchTerm === '' || 
                                  question.includes(searchTerm) || 
                                  answer.includes(searchTerm);
                    
                    item.style.display = matches ? 'block' : 'none';
                });

                // 검색 결과가 없을 때 메시지 표시
                const visibleItems = Array.from(faqItems).filter(item => 
                    item.style.display !== 'none'
                );

                if (searchTerm !== '' && visibleItems.length === 0) {
                    const faqList = document.getElementById('faqList');
                    if (faqList && !faqList.querySelector('.faq-empty-search')) {
                        const emptyMsg = document.createElement('div');
                        emptyMsg.className = 'faq-empty faq-empty-search';
                        emptyMsg.innerHTML = `
                            <div class="faq-empty-icon">
                                <i class="ph ph-magnifying-glass"></i>
                            </div>
                            <h3>검색 결과가 없습니다</h3>
                            <p>"${searchTerm}"에 대한 검색 결과를 찾을 수 없습니다.</p>
                        `;
                        faqList.appendChild(emptyMsg);
                    }
                } else {
                    const emptyMsg = faqList?.querySelector('.faq-empty-search');
                    if (emptyMsg) {
                        emptyMsg.remove();
                    }
                }
            });
        }
    });
</script>
</body>
</html>
