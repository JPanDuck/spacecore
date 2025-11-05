<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>관리자 - FAQ 관리</title>
    <style>
        /* 관리자 화면용 기본 테이블 스타일 */
        table { width: 100%; border-collapse: collapse; margin-top: 15px; font-size: 0.9em; }
        th, td { border: 1px solid #ddd; padding: 10px; text-align: left; vertical-align: top; }
        th { background-color: #f2f2f2; font-weight: bold; }
        .action-cell button { margin-right: 5px; cursor: pointer; }
    </style>
</head>
<body>
<h2>[관리자] FAQ 목록 및 관리</h2>
<hr>

<%-- 새 등록 버튼 --%>
<p style="text-align: right;">
    <button onclick="location.href='/chatbot/admin/register'">새 FAQ 등록</button>
</p>

<table>
    <thead>
    <tr>
        <th style="width: 5%;">ID</th>
        <th style="width: 8%;">질문 우선순위</th>
        <th style="width: 10%;">카테고리</th>
        <th style="width: 20%;">질문</th>
        <th style="width: 35%;">답변 내용</th>
        <th style="width: 12%;">등록일</th>
        <th style="width: 10%;">관리</th>
    </tr>
    </thead>
    <tbody>
    <c:choose>
        <c:when test="${empty faqList}">
            <tr><td>등록된 FAQ가 없습니다.</td></tr>
        </c:when>
        <c:otherwise>
            <c:forEach var="faq" items="${faqList}">
                <tr id="faq-row-${faq.id}">
                    <td>${faq.id}</td>
                    <td>${faq.priority}</td>
                    <td>${faq.category}</td>
                    <td>${faq.question}</td>
                    <td>${faq.answer}</td>
                    <td>${faq.createdAtStr}</td>
                    <td class="action-cell">
                            <%-- 수정버튼 --%>
                        <button onclick="location.href='/chatbot/admin/modify?id=${faq.id}'">수정</button>
                            <%-- 삭제버튼 --%>
                        <button onclick="removeFaq(${faq.id})">삭제</button>
                    </td>
                </tr>
            </c:forEach>
        </c:otherwise>
    </c:choose>
    </tbody>
</table>

<script>
    //FAQ 데이터 삭제
    function removeFaq(id){
        if(!confirm('정말로 ID: ' + id + ' FAQ를 삭제하시겠습니까?')){
            return;
        }

        fetch('/api/admin/chatbot/' + id, {
            method: 'DELETE'
        })
            .then(res => {
                if(res.status === 204){
                    alert('FAQ가 삭제되었습니다.');
                    //삭제된 행을 화면에서 제거하거나 페이지 새로고침
                    const row = document.getElementById('faq-row-' + id);
                    if(row){
                        row.remove();
                    }
                }else if(res.status === 404){
                    alert('삭제할 FAQ 정보를 찾을 수 없습니다.');
                }else {
                    return res.text().then(text => {throw new Error(text);});
                }
            })
            .catch(err => {
                console.error('FAQ 삭제 실패: ', err)
                alert('FAQ 삭제에 실패했습니다. (오류: ' + err.message + ')');
            });
    }
</script>

</body>
</html>