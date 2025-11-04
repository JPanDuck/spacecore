<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>룸 수정</title>
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
<h2>룸 수정</h2>

<form action="/offices/${room.officeId}/rooms/edit" method="post">
    <input type="hidden" name="id" value="${room.id}">
    <div class="field">
        <label>지점ID</label>
        <input type="number" name="officeId" value="${room.officeId}" required>
    </div>

    <div class="field">
        <label>룸명</label>
        <input type="text" name="name" value="${room.name}" required>
    </div>

    <div class="field">
        <label>정원</label>
        <input type="number" name="capacity" value="${room.capacity}" min="1" required>
    </div>

    <div class="field">
        <label>기본요금</label>
        <input type="number" name="priceBase" value="${room.priceBase}" min="0" step="100" required>
    </div>

    <div class="field">
        <label>최소 예약 시간</label>
        <input type="number" name="minReservationHours" value="${room.minReservationHours != null ? room.minReservationHours : 1}" min="1" required>
    </div>

    <div class="field">
        <label>상태</label>
        <select name="status" required>
            <option value="ACTIVE"   ${room.status == 'ACTIVE'   ? 'selected' : ''}>ACTIVE</option>
            <option value="INACTIVE" ${room.status == 'INACTIVE' ? 'selected' : ''}>INACTIVE</option>
        </select>
    </div>

    <!-- 이미지 업로드 자리(나중에) -->
    <div class="upload-slot">
        이미지 업로드 자리 (추후 업로더/콜백으로 fileIds hidden 삽입)
        <div id="fileIds-holder"></div>
    </div>

    <div class="field">
        <button type="submit">저장</button>
        <a href="/rooms/detail/${room.id}">취소</a>
    </div>
</form>

</body>
</html>
