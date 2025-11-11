<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>룸 등록</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        body {
            font-family: "Noto Sans KR", "Montserrat", sans-serif;
            background: var(--cream-base);
            color: var(--text-primary);
            margin: 50px;
        }
        h2 { 
            color: var(--choco);
            margin-bottom: 30px;
        }
        label {
            display: block;
            margin-top: 10px;
            font-weight: 600;
            color: var(--text-primary);
        }
        input, select, textarea {
            width: 100%;
            max-width: 500px;
            padding: 10px;
            margin-top: 5px;
            border: 1px solid var(--gray-300);
            border-radius: var(--radius-md);
            background: var(--white);
            color: var(--text-primary);
            font-size: 14px;
        }
        input:focus, select:focus, textarea:focus {
            outline: none;
            border-color: var(--amber);
        }
        button {
            margin-top: 20px;
            padding: 12px 24px;
            background: var(--amber);
            color: var(--white);
            border: none;
            border-radius: var(--radius-md);
            cursor: pointer;
            font-weight: 600;
            font-size: 15px;
            transition: var(--transition);
        }
        button:hover {
            background: var(--mocha);
        }
        a {
            display: inline-block;
            margin-top: 20px;
            margin-left: 10px;
            text-decoration: none;
            color: var(--amber);
            font-weight: 500;
        }
        a:hover {
            color: var(--mocha);
        }
        .field {
            margin-bottom: 20px;
        }
        .thumbnail-upload {
            margin-top: 20px;
        }
        .thumbnail-preview {
            width: 200px;
            height: 200px;
            margin-top: 10px;
            border: 2px solid var(--gray-300);
            border-radius: var(--radius-md);
            overflow: hidden;
            background: var(--gray-200);
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .thumbnail-preview img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .thumbnail-preview.no-image {
            color: var(--gray-500);
            font-size: 14px;
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
    <div class="field">
        <label>공간소개</label>
        <textarea name="description" rows="5"></textarea>
    </div>

    <div class="field">
        <label>시설안내</label>
        <textarea name="facilityInfo" rows="5"></textarea>
    </div>

    <div class="field">
        <label>유의사항</label>
        <textarea name="precautions" rows="5"></textarea>
    </div>

    <!-- 썸네일 업로드 -->
    <div class="field thumbnail-upload">
        <label>썸네일 이미지</label>
        <input type="file" id="thumbnailFile" name="thumbnailFile" accept="image/*" onchange="previewThumbnail(this)">
        <div class="thumbnail-preview no-image" id="thumbnailPreview">
            No Image
        </div>
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

<script>
    function previewThumbnail(input) {
        const preview = document.getElementById('thumbnailPreview');
        if (input.files && input.files[0]) {
            const reader = new FileReader();
            reader.onload = function(e) {
                preview.innerHTML = '<img src="' + e.target.result + '" alt="썸네일 미리보기">';
                preview.classList.remove('no-image');
            };
            reader.readAsDataURL(input.files[0]);
        } else {
            preview.innerHTML = 'No Image';
            preview.classList.add('no-image');
        }
    }
</script>

</body>
</html>
