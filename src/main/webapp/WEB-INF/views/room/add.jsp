<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>룸 등록</title>
    <style>
        body {
            font-family: "Pretendard", sans-serif;
            background-color: #fafafa;
            margin: 50px;
        }
        h2 { color: #333; }
        label {
            display: block;
            margin-top: 10px;
            font-weight: bold;
        }
        input {
            width: 250px;
            padding: 8px;
            margin-top: 5px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        button {
            margin-top: 20px;
            padding: 10px 20px;
            background-color: #7b6cf6;
            color: #fff;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: bold;
        }
        button:hover {
            background-color: #6957f2;
        }
        a {
            display: inline-block;
            margin-top: 20px;
            text-decoration: none;
            color: #7b6cf6;
        }
    </style>
</head>
<body>
<h2>룸 등록</h2>

<form action="/offices/${officeId}/rooms/add" method="post">
    <div class="field">
        <label>지점 선택</label>
        <select name="officeId" required>
            <c:forEach var="o" items="${offices}">
                <option value="${o.id}">${o.id} - ${o.name}</option>
            </c:forEach>
        </select>
    </div>

    <div class="field">
        <label>룸명</label>
        <input type="text" name="name" required>
    </div>

    <div class="field">
        <label>정원</label>
        <input type="number" name="capacity" min="1" required>
    </div>

    <div class="field">
        <label>기본요금</label>
        <input type="number" name="priceBase" min="0" step="100" required>
    </div>

    <div class="field">
        <label>상태</label>
        <select name="status" required>
            <option value="ACTIVE">ACTIVE</option>
            <option value="INACTIVE">INACTIVE</option>
        </select>
    </div>

    <!-- 이미지 업로드 자리(나중에 업로더 붙임) -->
    <div class="upload-slot">
        이미지 업로드 자리 (추후 업로더/콜백으로 fileIds hidden 삽입)
        <div id="fileIds-holder"></div>
    </div>

    <div class="field">
        <button type="submit">등록</button>
        <a href="/offices/${officeId}/rooms">취소</a>
    </div>
</form>

</body>
</html>
