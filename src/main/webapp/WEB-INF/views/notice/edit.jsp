<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<% String context = request.getContextPath(); %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>공지 수정 | Space Core</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .notice-form-container {
            max-width: 900px;
            margin: 0 auto;
            padding: 40px 20px;
        }

        .form-header {
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid var(--cream-tan);
        }

        .form-title {
            font-size: 32px;
            font-weight: 700;
            color: var(--choco);
        }

        .notice-form {
            background: var(--white);
            padding: 40px;
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--gray-200);
        }

        .form-group {
            margin-bottom: 24px;
        }

        .form-label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: var(--choco);
            font-size: 15px;
        }

        .form-input {
            width: 100%;
            padding: 12px 16px;
            border: 1px solid var(--gray-300);
            border-radius: var(--radius-md);
            font-size: 15px;
            color: var(--text-primary);
            background: var(--white);
            transition: var(--transition);
        }

        .form-input:focus {
            outline: none;
            border-color: var(--amber);
            box-shadow: 0 0 0 3px rgba(141, 94, 76, 0.1);
        }

        .form-textarea {
            width: 100%;
            min-height: 400px;
            padding: 12px 16px;
            border: 1px solid var(--gray-300);
            border-radius: var(--radius-md);
            font-size: 15px;
            color: var(--text-primary);
            background: var(--white);
            resize: vertical;
            font-family: inherit;
            line-height: 1.6;
            transition: var(--transition);
        }

        .form-textarea:focus {
            outline: none;
            border-color: var(--amber);
            box-shadow: 0 0 0 3px rgba(141, 94, 76, 0.1);
        }

        .radio-group {
            display: flex;
            gap: 20px;
            margin-top: 8px;
        }

        .radio-item {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .radio-item input[type="radio"] {
            width: 18px;
            height: 18px;
            cursor: pointer;
            accent-color: var(--amber);
        }

        .radio-item label {
            cursor: pointer;
            color: var(--text-primary);
        }

        .form-actions {
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            margin-top: 30px;
            padding-top: 30px;
            border-top: 1px solid var(--gray-200);
        }
    </style>
</head>
<body>
<%@ include file="/WEB-INF/views/components/header.jsp" %>

<div class="notice-form-container">
    <div class="form-header">
        <h1 class="form-title">공지 수정</h1>
    </div>

    <form action="/notices/edit" method="post" class="notice-form">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
        <input type="hidden" name="id" value="${notice.id}"/>
        
        <div class="form-group">
            <label class="form-label" for="title">제목 *</label>
            <input type="text" id="title" name="title" class="form-input" required 
                   value="${notice.title}"/>
        </div>

        <div class="form-group">
            <label class="form-label">중요 공지</label>
            <div class="radio-group">
                <div class="radio-item">
                    <input type="radio" id="pinned-y" name="pinned" value="Y" 
                           ${notice.pinned == 'Y' ? 'checked' : ''}/>
                    <label for="pinned-y">예</label>
                </div>
                <div class="radio-item">
                    <input type="radio" id="pinned-n" name="pinned" value="N" 
                           ${notice.pinned != 'Y' ? 'checked' : ''}/>
                    <label for="pinned-n">아니오</label>
                </div>
            </div>
        </div>

        <div class="form-group">
            <label class="form-label" for="content">내용 *</label>
            <textarea id="content" name="content" class="form-textarea" required>${notice.content}</textarea>
        </div>

        <div class="form-actions">
            <a href="/notices/detail/${notice.id}" class="btn btn-outline">취소</a>
            <button type="submit" class="btn btn-brown">수정</button>
        </div>
    </form>
</div>

<%@ include file="/WEB-INF/views/components/footer.jsp" %>
</body>
</html>
