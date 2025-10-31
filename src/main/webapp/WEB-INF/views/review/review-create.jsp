<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String context = request.getContextPath();
    String roomIdParam = request.getParameter("roomId");
    Long roomId = 1L;
    if (roomIdParam != null && roomIdParam.trim().length() > 0) {
        roomId = Long.parseLong(roomIdParam);
    }
    Long loginUserId = 1L; // 임시 사용자 ID
%>

<!-- ✅ HEADER -->
<%@ include file="/WEB-INF/views/components/header.jsp" %>

<main class="container-1980 mt-40 mb-40">
    <!-- 페이지 헤더 -->
    <div class="flex-row" style="justify-content:space-between; align-items:center; margin-bottom:30px;">
        <h2 class="section-title" style="margin:0;">리뷰 작성하기</h2>
        <a href="<%= context %>/reviews?roomId=<%= roomId %>" class="btn btn-outline">← 목록으로</a>
    </div>

    <!-- 본문 카드 -->
    <div class="card-basic" style="padding:30px;">
        <form id="reviewForm" action="${pageContext.request.contextPath}/reviews/create"
              method="post" enctype="multipart/form-data"
              style="display:flex; flex-direction:column; gap:20px;">

            <input type="hidden" name="roomId" value="<%= roomId %>">
            <input type="hidden" name="userId" value="<%= loginUserId %>">

            <!-- 별점 -->
            <div>
                <label for="rating" style="font-weight:600; color:var(--choco);">별점</label>
                <select id="rating" name="rating" required
                        style="padding:8px; border:1px solid var(--gray-300);
                               border-radius:var(--radius-md); width:100%; font-size:15px;">
                    <option value="">선택</option>
                    <option value="5">⭐⭐⭐⭐⭐ (5)</option>
                    <option value="4">⭐⭐⭐⭐ (4)</option>
                    <option value="3">⭐⭐⭐ (3)</option>
                    <option value="2">⭐⭐ (2)</option>
                    <option value="1">⭐ (1)</option>
                </select>
            </div>

            <!-- 내용 -->
            <div>
                <label for="content" style="font-weight:600; color:var(--choco);">내용</label>
                <textarea id="content" name="content" rows="5" required
                          style="width:100%; padding:10px; border:1px solid var(--gray-300);
                                 border-radius:var(--radius-md); resize:none; font-size:15px;"
                          placeholder="리뷰 내용을 작성하세요."></textarea>
            </div>

            <!-- 이미지 업로드 -->
            <div>
                <label for="imgFiles" style="display:block; font-weight:600; color:var(--choco); margin-bottom:8px;">
                    이미지 첨부 (선택)
                </label>
                <input id="imgFiles" type="file" name="imgFiles" multiple accept="image/*"
                       style="display:block; width:100%; padding:10px; border:1px solid var(--gray-300);
                              border-radius:var(--radius-md); background-color:#fff;
                              font-family:'Noto Sans KR', sans-serif; font-size:15px; cursor:pointer;">
                <div id="previewArea"
                     style="margin-top:15px; display:flex; flex-wrap:wrap; gap:10px;
                            background:#fafafa; border:1px dashed var(--gray-300);
                            border-radius:var(--radius-md); padding:10px; min-height:80px;">
                    <p style="color:var(--gray-500); font-size:14px; margin:0;">선택한 이미지 미리보기</p>
                </div>
            </div>

            <!-- 버튼 영역 -->
            <div class="flex-row" style="justify-content:space-between; margin-top:10px;">
                <a href="<%= context %>/reviews?roomId=<%= roomId %>" class="btn btn-outline">← 목록으로</a>
                <button type="submit" class="btn btn-brown">리뷰 등록</button>
            </div>
        </form>
    </div>
</main>

<!-- ✅ FOOTER -->
<%@ include file="/WEB-INF/views/components/footer.jsp" %>

<!-- 이미지 미리보기 -->
<script>
    const fileInput = document.getElementById("imgFiles");
    const previewArea = document.getElementById("previewArea");

    fileInput.addEventListener("change", (e) => {
        previewArea.innerHTML = "";
        const files = e.target.files;
        if (!files.length) return;

        Array.from(files).forEach(file => {
            if (!file.type.startsWith("image/")) return;
            const reader = new FileReader();
            reader.onload = (evt) => {
                const img = document.createElement("img");
                img.src = evt.target.result;
                img.style.width = "120px";
                img.style.height = "120px";
                img.style.objectFit = "cover";
                img.style.borderRadius = "10px";
                img.style.border = "1px solid var(--gray-300)";
                img.style.boxShadow = "0 2px 5px rgba(0,0,0,0.1)";
                previewArea.appendChild(img);
            };
            reader.readAsDataURL(file);
        });
    });
</script>
