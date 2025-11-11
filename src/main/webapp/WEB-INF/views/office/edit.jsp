<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>지점 수정 | Space Core</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .container {
            max-width: 800px;
            margin: 40px auto;
            padding: 30px;
            background: var(--white);
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-md);
        }

        h2 {
            color: var(--choco);
            margin-bottom: 30px;
            text-align: center;
            font-size: 28px;
            font-weight: 700;
        }

        .form-group {
            margin-bottom: 24px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: var(--text-primary);
            font-size: 15px;
        }

        input[type="text"],
        select {
            width: 100%;
            padding: 12px;
            border: 1px solid var(--gray-300);
            border-radius: var(--radius-md);
            background: var(--white);
            color: var(--text-primary);
            font-size: 14px;
            box-sizing: border-box;
        }

        input:focus, select:focus {
            outline: none;
            border-color: var(--amber);
            box-shadow: 0 0 0 2px rgba(141, 94, 76, 0.2);
        }

        .button-group {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin-top: 30px;
        }

        .button-group button,
        .button-group a {
            padding: 12px 28px;
            border: none;
            border-radius: var(--radius-md);
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: var(--transition);
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }

        .button-group button[type="submit"] {
            background: var(--amber);
            color: var(--white);
        }

        .button-group button[type="submit"]:hover {
            background: var(--mocha);
        }

        .button-group a.cancel-button {
            background: var(--gray-300);
            color: var(--text-primary);
        }

        .button-group a.cancel-button:hover {
            background: var(--gray-400);
        }

        .back-to-list {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            margin-bottom: 20px;
            color: var(--gray-600);
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            transition: color 0.2s ease;
        }

        .back-to-list:hover {
            color: var(--choco);
        }

        @media (max-width: 768px) {
            .container {
                margin: 20px;
                padding: 20px;
            }

            .button-group {
                flex-direction: column;
                gap: 10px;
            }

            .button-group button,
            .button-group a {
                width: 100%;
            }
        }
    </style>
</head>
<body>
<%@ include file="../components/header.jsp" %>

<div class="container">
    <a href="/offices" class="back-to-list">
        ← 목록으로
    </a>
    <h2>지점 수정</h2>

    <form action="/offices/edit" method="post">
        <input type="hidden" name="id" value="${office.id}"/>
        
        <div class="form-group">
            <label for="name">지점명</label>
            <input type="text" id="name" name="name" value="${office.name}" required/>
        </div>

        <div class="form-group">
            <label for="address">주소</label>
            <input type="text" id="address" name="address" value="${office.address != null ? office.address : ''}"/>
        </div>

        <div class="form-group">
            <label for="status">상태</label>
            <select id="status" name="status" required>
                <option value="ACTIVE" ${office.status == 'ACTIVE' ? 'selected' : ''}>활성</option>
                <option value="INACTIVE" ${office.status == 'INACTIVE' ? 'selected' : ''}>비활성</option>
            </select>
        </div>

        <div class="button-group">
            <button type="submit">저장</button>
            <a href="/offices" class="cancel-button">취소</a>
        </div>
    </form>
</div>

<%@ include file="../components/footer.jsp" %>
</body>
</html>
