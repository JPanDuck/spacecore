<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    String context = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>룸 수정 | Space Core</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .edit-container {
            max-width: 900px;
            margin: 0 auto;
            padding: 40px 20px;
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid var(--cream-tan);
        }

        .page-title {
            font-size: 28px;
            font-weight: 700;
            color: var(--choco);
        }

        .form-container {
            background: var(--white);
            border-radius: var(--radius-lg);
            padding: 40px;
            box-shadow: var(--shadow-sm);
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 24px;
        }

        .form-grid .field.full-width {
            grid-column: 1 / -1;
        }

        .field {
            margin-bottom: 24px;
        }

        .field label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: var(--choco);
            font-size: 15px;
        }

        .field input,
        .field select,
        .field textarea {
            width: 100%;
            padding: 12px 16px;
            border: 1px solid var(--gray-300);
            border-radius: var(--radius-md);
            background: var(--white);
            color: var(--text-primary);
            font-size: 14px;
            font-family: "Noto Sans KR", "Montserrat", sans-serif;
            transition: var(--transition);
        }

        .field input:focus,
        .field select:focus,
        .field textarea:focus {
            outline: none;
            border-color: var(--amber);
            box-shadow: 0 0 0 3px rgba(141, 94, 76, 0.1);
        }

        .field textarea {
            resize: vertical;
            min-height: 120px;
        }

        .thumbnail-upload {
            margin-top: 20px;
        }

        .thumbnail-preview {
            width: 200px;
            height: 200px;
            margin-top: 12px;
            border: 2px solid var(--gray-300);
            border-radius: var(--radius-md);
            overflow: hidden;
            background: var(--gray-200);
            display: flex;
            align-items: center;
            justify-content: center;
            transition: var(--transition);
        }

        .thumbnail-preview:hover {
            border-color: var(--amber);
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

        .upload-slot {
            padding: 20px;
            background: var(--gray-100);
            border-radius: var(--radius-md);
            color: var(--gray-600);
            font-size: 14px;
            margin-top: 20px;
        }

        .button-group {
            display: flex;
            gap: 12px;
            margin-top: 40px;
            padding-top: 30px;
            border-top: 1px solid var(--gray-200);
        }

        .btn-primary {
            padding: 12px 32px;
            background: var(--amber);
            color: var(--white);
            border: none;
            border-radius: var(--radius-md);
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: var(--transition);
            text-decoration: none;
            display: inline-block;
        }

        .btn-primary:hover {
            background: var(--mocha);
        }

        .btn-secondary {
            padding: 12px 32px;
            background: var(--gray-200);
            color: var(--text-primary);
            border: none;
            border-radius: var(--radius-md);
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: var(--transition);
            text-decoration: none;
            display: inline-block;
        }

        .btn-secondary:hover {
            background: var(--gray-300);
        }

        @media (max-width: 768px) {
            .form-grid {
                grid-template-columns: 1fr;
            }

            .edit-container {
                padding: 20px;
            }

            .form-container {
                padding: 24px;
            }
        }
    </style>
</head>
<body>
<%@ include file="/WEB-INF/views/components/header.jsp" %>

<div class="edit-container">
    <div class="page-header">
        <h1 class="page-title">룸 수정</h1>
        <a href="/offices/${room.officeId}/rooms" class="btn-secondary">← 목록으로</a>
    </div>

    <div class="form-container">
        <form action="/offices/${room.officeId}/rooms/edit" method="post" enctype="multipart/form-data">
            <input type="hidden" name="id" value="${room.id}">
            <input type="hidden" name="officeId" value="${room.officeId}">

            <div class="form-grid">
                <div class="field">
                    <label>지점ID</label>
                    <input type="number" name="officeId" value="${room.officeId}" required readonly style="background: var(--gray-100);">
                </div>

                <div class="field">
                    <label>상태</label>
                    <select name="status" required>
                        <option value="ACTIVE" ${room.status == 'ACTIVE' ? 'selected' : ''}>활성</option>
                        <option value="INACTIVE" ${room.status == 'INACTIVE' ? 'selected' : ''}>비활성</option>
                    </select>
                </div>

                <div class="field full-width">
                    <label>룸명</label>
                    <input type="text" name="name" value="${room.name}" required>
                </div>

                <div class="field">
                    <label>정원</label>
                    <input type="number" name="capacity" value="${room.capacity}" min="1" required>
                </div>

                <div class="field">
                    <label>기본요금 (원)</label>
                    <input type="number" name="priceBase" value="${room.priceBase}" min="0" step="100" required>
                </div>

                <div class="field">
                    <label>최소 예약 시간 (시간)</label>
                    <input type="number" name="minReservationHours" value="${room.minReservationHours != null ? room.minReservationHours : 1}" min="1" required>
                </div>

                <div class="field full-width">
                    <label>공간소개</label>
                    <textarea name="description" rows="5">${room.description != null ? room.description : ''}</textarea>
                </div>

                <div class="field full-width">
                    <label>시설안내</label>
                    <textarea name="facilityInfo" rows="5">${room.facilityInfo != null ? room.facilityInfo : ''}</textarea>
                </div>

                <div class="field full-width">
                    <label>유의사항</label>
                    <textarea name="precautions" rows="5">${room.precautions != null ? room.precautions : ''}</textarea>
                </div>

                <!-- 썸네일 업로드 -->
                <div class="field full-width thumbnail-upload">
                    <label>썸네일 이미지</label>
                    <input type="file" id="thumbnailFile" name="thumbnailFile" accept="image/*" onchange="previewThumbnail(this)">
                    <div class="thumbnail-preview ${empty room.thumbnail ? 'no-image' : ''}" id="thumbnailPreview">
                        <c:choose>
                            <c:when test="${not empty room.thumbnail}">
                                <img src="${room.thumbnail}" alt="현재 썸네일">
                            </c:when>
                            <c:otherwise>
                                No Image
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- 이미지 업로드 자리(나중에) -->
                <div class="field full-width">
                    <div class="upload-slot">
                        이미지 업로드 자리 (추후 업로더/콜백으로 fileIds hidden 삽입)
                        <div id="fileIds-holder"></div>
                    </div>
                </div>
            </div>

            <div class="button-group">
                <button type="submit" class="btn-primary">저장</button>
                <a href="/offices/${room.officeId}/rooms" class="btn-secondary">취소</a>
            </div>
        </form>
    </div>
</div>

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
            <c:choose>
                <c:when test="${not empty room.thumbnail}">
                    preview.innerHTML = '<img src="${room.thumbnail}" alt="현재 썸네일">';
                    preview.classList.remove('no-image');
                </c:when>
                <c:otherwise>
                    preview.innerHTML = 'No Image';
                    preview.classList.add('no-image');
                </c:otherwise>
            </c:choose>
        }
    }
</script>

<%@ include file="/WEB-INF/views/components/footer.jsp" %>
</body>
</html>
