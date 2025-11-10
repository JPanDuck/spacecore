<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FAQ 관리 | Space Core</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/phosphor-icons@1.4.2/dist/phosphor.css">
    <style>
        .admin-container {
            max-width: 1400px;
            margin: 40px auto;
            padding: 20px;
        }

        .admin-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding: 30px;
            background: linear-gradient(135deg, var(--choco) 0%, var(--amber) 100%);
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

        .btn-register {
            padding: 14px 28px;
            background: var(--white);
            color: var(--choco);
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }

        .btn-register:hover {
            background: var(--cream-base);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        }

        .faq-table-container {
            background: var(--white);
            border-radius: 12px;
            box-shadow: var(--shadow-sm);
            overflow: hidden;
        }

        .faq-table {
            width: 100%;
            border-collapse: collapse;
        }

        .faq-table thead {
            background: var(--cream-tan);
        }

        .faq-table th {
            padding: 18px 20px;
            text-align: left;
            font-weight: 700;
            font-size: 15px;
            color: var(--choco);
            border-bottom: 2px solid var(--gray-300);
        }

        .faq-table td {
            padding: 20px;
            border-bottom: 1px solid var(--gray-200);
            vertical-align: top;
            font-size: 14px;
            color: var(--text-primary);
        }

        .faq-table tbody tr {
            transition: background 0.2s ease;
        }

        .faq-table tbody tr:hover {
            background: var(--gray-50);
        }

        .faq-table tbody tr:last-child td {
            border-bottom: none;
        }

        .faq-id {
            font-weight: 600;
            color: var(--amber);
            width: 60px;
        }

        .faq-priority {
            font-weight: 600;
            color: var(--choco);
            width: 80px;
        }

        .faq-category {
            width: 120px;
        }

        .faq-category-badge {
            display: inline-block;
            padding: 6px 12px;
            background: var(--cream-tan);
            color: var(--choco);
            border-radius: 12px;
            font-size: 13px;
            font-weight: 600;
        }

        .faq-question {
            max-width: 300px;
            font-weight: 600;
            color: var(--text-primary);
            line-height: 1.5;
        }

        .faq-answer {
            max-width: 400px;
            color: var(--gray-600);
            line-height: 1.6;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .faq-date {
            width: 160px;
            color: var(--gray-600);
            font-size: 13px;
        }

        .faq-actions {
            width: 150px;
        }

        .action-btn {
            padding: 8px 16px;
            border: none;
            border-radius: 6px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-right: 8px;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .btn-edit {
            background: var(--choco);
            color: var(--white);
        }

        .btn-edit:hover {
            background: var(--amber);
            transform: translateY(-2px);
            box-shadow: 0 2px 8px rgba(91, 59, 49, 0.3);
        }

        .btn-delete {
            background: #dc3545;
            color: var(--white);
        }

        .btn-delete:hover {
            background: #c82333;
            transform: translateY(-2px);
            box-shadow: 0 2px 8px rgba(220, 53, 69, 0.3);
        }

        .empty-state {
            text-align: center;
            padding: 80px 20px;
            color: var(--gray-600);
        }

        .empty-state-icon {
            font-size: 64px;
            color: var(--gray-400);
            margin-bottom: 20px;
        }

        .empty-state h3 {
            font-size: 24px;
            margin-bottom: 12px;
            color: var(--text-primary);
        }

        .empty-state p {
            font-size: 16px;
            color: var(--gray-600);
            margin-bottom: 30px;
        }

        @media (max-width: 1200px) {
            .faq-question, .faq-answer {
                max-width: 200px;
            }
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

            .faq-table {
                font-size: 12px;
            }

            .faq-table th,
            .faq-table td {
                padding: 12px 8px;
            }

            .faq-question,
            .faq-answer {
                max-width: 150px;
            }

            .action-btn {
                padding: 6px 12px;
                font-size: 12px;
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
            <i class="ph ph-list-dashes"></i>
            FAQ 관리
        </h1>
        <a href="${pageContext.request.contextPath}/chatbot/admin/register" class="btn-register">
            <i class="ph ph-plus"></i>
            새 FAQ 등록
        </a>
    </div>

    <div class="faq-table-container">
        <c:choose>
            <c:when test="${empty faqList}">
                <div class="empty-state">
                    <div class="empty-state-icon">
                        <i class="ph ph-file-x"></i>
                    </div>
                    <h3>등록된 FAQ가 없습니다</h3>
                    <p>새로운 FAQ를 등록하여 고객들에게 도움을 제공하세요.</p>
                    <a href="${pageContext.request.contextPath}/chatbot/admin/register" class="btn-register">
                        <i class="ph ph-plus"></i>
                        첫 FAQ 등록하기
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <table class="faq-table">
                    <thead>
                    <tr>
                        <th class="faq-id">ID</th>
                        <th class="faq-priority">우선순위</th>
                        <th class="faq-category">카테고리</th>
                        <th class="faq-question">질문</th>
                        <th class="faq-answer">답변</th>
                        <th class="faq-date">등록일</th>
                        <th class="faq-actions">관리</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="faq" items="${faqList}">
                        <tr id="faq-row-${faq.id}">
                            <td class="faq-id">${faq.id}</td>
                            <td class="faq-priority">${faq.priority}</td>
                            <td class="faq-category">
                                <span class="faq-category-badge">${faq.category}</span>
                            </td>
                            <td class="faq-question" title="${faq.question}">${faq.question}</td>
                            <td class="faq-answer" title="${faq.answer}">${faq.answer}</td>
                            <td class="faq-date">${faq.createdAtStr}</td>
                            <td class="faq-actions">
                                <button class="action-btn btn-edit" onclick="location.href='${pageContext.request.contextPath}/chatbot/admin/modify?id=${faq.id}'">
                                    <i class="ph ph-pencil"></i>
                                    수정
                                </button>
                                <button class="action-btn btn-delete" onclick="removeFaq(${faq.id})">
                                    <i class="ph ph-trash"></i>
                                    삭제
                                </button>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<!-- ✅ 푸터 include -->
<%@ include file="../components/footer.jsp" %>

<script>
    // FAQ 삭제 함수
    function removeFaq(id) {
        if (!confirm('정말로 ID: ' + id + ' FAQ를 삭제하시겠습니까?\n이 작업은 되돌릴 수 없습니다.')) {
            return;
        }

        fetch('${pageContext.request.contextPath}/api/admin/chatbot/' + id, {
            method: 'DELETE',
            credentials: 'include'
        })
            .then(res => {
                if (res.status === 204) {
                    alert('FAQ가 성공적으로 삭제되었습니다.');
                    // 삭제된 행을 화면에서 제거
                    const row = document.getElementById('faq-row-' + id);
                    if (row) {
                        row.style.transition = 'opacity 0.3s ease';
                        row.style.opacity = '0';
                        setTimeout(() => {
                            row.remove();
                            // 테이블이 비어있으면 empty state 표시
                            const tbody = document.querySelector('.faq-table tbody');
                            if (tbody && tbody.children.length === 0) {
                                location.reload();
                            }
                        }, 300);
                    } else {
                        location.reload();
                    }
                } else if (res.status === 404) {
                    alert('삭제할 FAQ 정보를 찾을 수 없습니다.');
                } else {
                    return res.text().then(text => {
                        throw new Error(text);
                    });
                }
            })
            .catch(err => {
                console.error('FAQ 삭제 실패: ', err);
                alert('FAQ 삭제에 실패했습니다. 오류: ' + err.message);
            });
    }
</script>
</body>
</html>
