<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

 <!-- CSS -->
 <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
<%
    String context = request.getContextPath();
    String roomIdParam = request.getParameter("roomId");
    Long roomId = 1L;
    if (roomIdParam != null && roomIdParam.trim().length() > 0) {
        roomId = Long.parseLong(roomIdParam);
    }
    
    // 세션에서 사용자 정보 가져오기
    Object userObj = session.getAttribute("user");
    String role = (String) session.getAttribute("role");
    Long loginUserId = null;
    
    if (userObj != null) {
        // User 객체에서 ID 추출 (도메인 객체에 따라 달라질 수 있음)
        try {
            java.lang.reflect.Method getIdMethod = userObj.getClass().getMethod("getId");
            loginUserId = (Long) getIdMethod.invoke(userObj);
        } catch (Exception e) {
            // 리플렉션 실패 시 기본값 사용
            loginUserId = 1L;
        }
    }
    
    // JSP에서도 권한 체크 (이중 보안)
    if (userObj == null || role == null) {
        // 비회원 → 로그인 페이지로 리다이렉트 (URL 인코딩)
        String errorMsg = java.net.URLEncoder.encode("로그인 후 가능합니다", "UTF-8");
        response.sendRedirect(context + "/auth/login?error=" + errorMsg);
        return;
    }
    
    if ("ADMIN".equals(role)) {
        // 관리자 → 리뷰 목록으로 리다이렉트 (URL 인코딩)
        String message = java.net.URLEncoder.encode("리뷰 작성 권한이 없습니다", "UTF-8");
        response.sendRedirect(context + "/reviews?roomId=" + roomId + "&message=" + message);
        return;
    }
    
    if (!"USER".equals(role)) {
        // USER가 아닌 경우 → 로그인 페이지로 리다이렉트 (URL 인코딩)
        String errorMsg = java.net.URLEncoder.encode("로그인 후 가능합니다", "UTF-8");
        response.sendRedirect(context + "/auth/login?error=" + errorMsg);
        return;
    }
%>

<!-- HEADER -->
<%@ include file="/WEB-INF/views/components/header.jsp" %>

<main class="container-1980 mt-40 mb-40">
    <!-- 페이지 헤더 -->
    <div class="flex-row" style="justify-content:space-between; align-items:center; margin-bottom:30px;">
        <h2 class="section-title" style="margin:0;">리뷰 작성하기</h2>
        <a href="<%= context %>/reviews<%= roomId != null ? "?roomId=" + roomId : "" %>" class="btn btn-outline">← 목록으로</a>
    </div>

    <!-- 본문 카드 -->
    <div class="card-basic" style="padding:30px;">
        <form id="reviewForm" action="${pageContext.request.contextPath}/reviews/create"
              method="post" enctype="multipart/form-data"
              style="display:flex; flex-direction:column; gap:20px;">

            <input type="hidden" name="roomId" value="<%= roomId %>">
            <% if (loginUserId != null) { %>
                <input type="hidden" name="userId" value="<%= loginUserId %>">
            <% } %>

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

<!-- FOOTER -->
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
