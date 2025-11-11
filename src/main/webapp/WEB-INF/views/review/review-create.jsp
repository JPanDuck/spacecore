<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<% String context = request.getContextPath(); %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>리뷰 작성 | Space Core</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .review-create-container {
            max-width: 800px;
            margin: 0 auto;
            padding: 40px 20px;
        }

        .page-header {
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid var(--cream-tan);
        }

        .page-title {
            font-size: 32px;
            font-weight: 700;
            color: var(--choco);
            margin-bottom: 12px;
        }

        .review-form-card {
            background: var(--white);
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--gray-200);
            padding: 40px;
        }

        .form-group {
            margin-bottom: 30px;
        }

        .form-label {
            display: block;
            font-weight: 600;
            color: var(--choco);
            margin-bottom: 12px;
            font-size: 16px;
        }

        .form-label.required::after {
            content: ' *';
            color: var(--amber);
        }

        .form-input,
        .form-select,
        .form-textarea {
            width: 100%;
            padding: 12px 16px;
            border: 1px solid var(--gray-300);
            border-radius: var(--radius-md);
            background: var(--white);
            color: var(--text-primary);
            font-size: 15px;
            font-family: "Noto Sans KR", "Montserrat", sans-serif;
            transition: var(--transition);
        }

        .form-input:focus,
        .form-select:focus,
        .form-textarea:focus {
            outline: none;
            border-color: var(--amber);
            box-shadow: 0 0 0 3px rgba(141, 94, 76, 0.1);
        }

        .form-textarea {
            resize: vertical;
            min-height: 150px;
            line-height: 1.6;
        }

        .star-rating-select {
            font-size: 20px;
        }

        .file-upload-area {
            border: 2px dashed var(--gray-300);
            border-radius: var(--radius-md);
            padding: 30px;
            text-align: center;
            background: var(--cream-base);
            transition: var(--transition);
            cursor: pointer;
        }

        .file-upload-area:hover {
            border-color: var(--amber);
            background: var(--cream-tan);
        }

        .file-upload-area.dragover {
            border-color: var(--amber);
            background: var(--cream-tan);
        }

        .file-input-label {
            display: block;
            cursor: pointer;
            color: var(--mocha);
            font-weight: 500;
            margin-bottom: 8px;
        }

        .file-input-hint {
            font-size: 13px;
            color: var(--gray-600);
            margin-top: 8px;
        }

        .file-input {
            display: none;
        }

        .preview-area {
            margin-top: 20px;
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
        }

        .preview-item {
            position: relative;
            width: 120px;
            height: 120px;
            border-radius: var(--radius-md);
            overflow: hidden;
            border: 2px solid var(--gray-200);
            box-shadow: var(--shadow-sm);
        }

        .preview-item img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .preview-remove {
            position: absolute;
            top: 4px;
            right: 4px;
            width: 24px;
            height: 24px;
            background: rgba(0, 0, 0, 0.6);
            color: var(--white);
            border: none;
            border-radius: 50%;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 14px;
            transition: var(--transition);
        }

        .preview-remove:hover {
            background: rgba(232, 53, 70, 0.9);
        }

        .form-actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 40px;
            padding-top: 30px;
            border-top: 1px solid var(--gray-200);
        }

        .error-message {
            color: #e63946;
            font-size: 14px;
            margin-top: 8px;
        }

        .selected-files-count {
            color: var(--mocha);
            font-size: 14px;
            margin-top: 8px;
            font-weight: 500;
        }
    </style>
</head>
<body>
<%@ include file="/WEB-INF/views/components/header.jsp" %>

<div class="review-create-container">
    <div class="page-header">
        <h1 class="page-title">리뷰 작성</h1>
    </div>

    <div class="review-form-card">
        <form id="reviewForm" action="${pageContext.request.contextPath}/reviews/create" 
              method="post" enctype="multipart/form-data">
            
            <input type="hidden" name="roomId" value="${param.roomId}">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

            <!-- 별점 -->
            <div class="form-group">
                <label for="rating" class="form-label required">별점</label>
                <select id="rating" name="rating" class="form-select star-rating-select" required>
                    <option value="">선택해주세요</option>
                    <option value="5">⭐⭐⭐⭐⭐ (5점)</option>
                    <option value="4">⭐⭐⭐⭐ (4점)</option>
                    <option value="3">⭐⭐⭐ (3점)</option>
                    <option value="2">⭐⭐ (2점)</option>
                    <option value="1">⭐ (1점)</option>
                </select>
            </div>

            <!-- 내용 -->
            <div class="form-group">
                <label for="content" class="form-label required">리뷰 내용</label>
                <textarea id="content" name="content" class="form-textarea" 
                          placeholder="리뷰 내용을 작성해주세요.&#10;이용하신 공간에 대한 솔직한 후기를 남겨주시면 다른 이용자들에게 도움이 됩니다." 
                          required></textarea>
            </div>

            <!-- 이미지 업로드 -->
            <div class="form-group">
                <label class="form-label">사진 첨부 (선택)</label>
                <div class="file-upload-area" id="fileUploadArea">
                    <label for="imgFiles" class="file-input-label">
                        📷 클릭하거나 파일을 드래그하여 이미지를 선택하세요
                    </label>
                    <input type="file" id="imgFiles" name="imgFiles" 
                           class="file-input" multiple accept="image/*">
                    <div class="file-input-hint">
                        최대 5장까지 첨부 가능합니다. (JPG, PNG, GIF)
                    </div>
                    <div id="selectedFilesCount" class="selected-files-count" style="display: none;"></div>
                </div>
                <div id="previewArea" class="preview-area"></div>
            </div>

            <!-- 버튼 영역 -->
            <div class="form-actions">
                <a href="/reservations" class="btn btn-outline">취소</a>
                <button type="submit" class="btn btn-brown">리뷰 등록</button>
            </div>
        </form>
    </div>
</div>

<%@ include file="/WEB-INF/views/components/footer.jsp" %>

<script>
    (function() {
        const fileInput = document.getElementById('imgFiles');
        const fileUploadArea = document.getElementById('fileUploadArea');
        const previewArea = document.getElementById('previewArea');
        const selectedFilesCount = document.getElementById('selectedFilesCount');
        const maxFiles = 5;
        let selectedFiles = [];

        // 파일 선택 핸들러
        fileInput.addEventListener('change', function(e) {
            handleFiles(e.target.files);
        });

        // 드래그 앤 드롭
        fileUploadArea.addEventListener('dragover', function(e) {
            e.preventDefault();
            fileUploadArea.classList.add('dragover');
        });

        fileUploadArea.addEventListener('dragleave', function(e) {
            e.preventDefault();
            fileUploadArea.classList.remove('dragover');
        });

        fileUploadArea.addEventListener('drop', function(e) {
            e.preventDefault();
            fileUploadArea.classList.remove('dragover');
            handleFiles(e.dataTransfer.files);
        });

        function handleFiles(files) {
            const newFiles = Array.from(files).filter(file => {
                if (!file.type.startsWith('image/')) {
                    alert('이미지 파일만 업로드 가능합니다.');
                    return false;
                }
                return true;
            });

            // 최대 개수 체크
            if (selectedFiles.length + newFiles.length > maxFiles) {
                alert(`최대 ${maxFiles}장까지 첨부 가능합니다.`);
                newFiles.splice(maxFiles - selectedFiles.length);
            }

            // 기존 파일에 추가
            newFiles.forEach(file => {
                selectedFiles.push(file);
                addPreview(file);
            });

            updateFileInput();
            updateFilesCount();
        }

        function addPreview(file) {
            const reader = new FileReader();
            reader.onload = function(e) {
                const previewItem = document.createElement('div');
                previewItem.className = 'preview-item';
                previewItem.dataset.fileName = file.name;

                const img = document.createElement('img');
                img.src = e.target.result;
                img.alt = file.name;

                const removeBtn = document.createElement('button');
                removeBtn.type = 'button';
                removeBtn.className = 'preview-remove';
                removeBtn.innerHTML = '×';
                removeBtn.onclick = function() {
                    removeFile(file.name);
                };

                previewItem.appendChild(img);
                previewItem.appendChild(removeBtn);
                previewArea.appendChild(previewItem);
            };
            reader.readAsDataURL(file);
        }

        function removeFile(fileName) {
            selectedFiles = selectedFiles.filter(file => file.name !== fileName);
            const previewItem = previewArea.querySelector(`[data-file-name="${fileName}"]`);
            if (previewItem) {
                previewItem.remove();
            }
            updateFileInput();
            updateFilesCount();
        }

        function updateFileInput() {
            // DataTransfer를 사용하여 새로운 FileList 생성
            const dataTransfer = new DataTransfer();
            selectedFiles.forEach(file => {
                dataTransfer.items.add(file);
            });
            fileInput.files = dataTransfer.files;
        }

        function updateFilesCount() {
            if (selectedFiles.length > 0) {
                selectedFilesCount.style.display = 'block';
                selectedFilesCount.textContent = `선택된 파일: ${selectedFiles.length}장 / 최대 ${maxFiles}장`;
            } else {
                selectedFilesCount.style.display = 'none';
            }
        }

        // 폼 제출 전 검증
        document.getElementById('reviewForm').addEventListener('submit', function(e) {
            const rating = document.getElementById('rating').value;
            const content = document.getElementById('content').value.trim();

            if (!rating) {
                e.preventDefault();
                alert('별점을 선택해주세요.');
                return false;
            }

            if (!content) {
                e.preventDefault();
                alert('리뷰 내용을 입력해주세요.');
                return false;
            }

            if (selectedFiles.length > maxFiles) {
                e.preventDefault();
                alert(`최대 ${maxFiles}장까지 첨부 가능합니다.`);
                return false;
            }
        });
    })();
</script>
</body>
</html>
