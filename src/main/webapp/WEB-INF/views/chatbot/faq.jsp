<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>FAQ 챗봇</title>

    <style>
        /* 아코디언 구현을 위한 최소 스타일 */
        .faq-question { cursor: pointer; padding: 10px; border: 1px solid #ccc; margin-top: -1px; background-color: #f9f9f9; font-weight: bold; }
        .faq-answer { padding: 15px; border: 1px solid #eee; background-color: #fff; display: none; } /* 초기에는 답변 숨김 */
        .active-tab { background-color: #007bff; color: white; }
        .tab-btn { padding: 10px 15px; margin-right: 5px; cursor: pointer; border: 1px solid #ccc; display: inline-block; }
        .initial-message { text-align: center; padding: 50px; border: 1px dashed #ddd; margin-top: 20px; color: #555; }
    </style>
</head>
<body>
<div>
    <h2>궁금한 점을 해결하세요!</h2>
    <hr>

    <%-- 카테고리 탭 메뉴 --%>
    <div>
        <c:forEach var="categoryName" items="${categories}">
            <a href="/chatbot/faq?category=${categoryName}"
               class="tab-btn <c:if test="${currentCategory eq categoryName}">active-tab</c:if>">${categoryName}</a>
        </c:forEach>
    </div>
    <br>

    <%-- FAQ 목록 (질문-답변 아코디언) --%>
    <div id="faq-list-container">
        <c:choose>
            <c:when test="${empty faqList}">
                <%-- 초기화면 및 질문 없는 카테고리 선택 시 표시 --%>
                <c:choose>
                    <c:when test="${currentCategory eq '선택 필요'}">
                        <div class="initial-message">
                            <p>궁금한 점에 대해 카테고리를 선택해주세요.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <p>현재 [${currentCategory}] 카테고리에 등록된 질문이 없습니다.</p>
                    </c:otherwise>
                </c:choose>
            </c:when>
            <c:otherwise>
                <%-- 카테고리 선택 후 질문 목록이 있을 때 표시 --%>
                <h4>${currentCategory}</h4>
                <c:forEach var="faq" items="${faqList}">
                    <div class="faq-question" onclick="toggleAnswer(this)">
                            ${faq.question}
                    </div>
                    <div class="faq-answer">
                            ${faq.answer}
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script>
    function toggleAnswer(questionEl){
        const answerEl = questionEl.nextElementSibling;

        if(answerEl && answerEl.classList.contains('faq-answer')){
            if(answerEl.style.display === 'block'){
                answerEl.style.display = 'none';
            }else {
                answerEl.style.display = 'block';
            }
        }
    }
</script>

</body>
</html>