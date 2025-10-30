<%@ page contentType="text/html; charset=UTF-8" language="java" isELIgnored="true" %>
<%@ include file="/WEB-INF/views/components/header.jsp" %>

<%
    String context = request.getContextPath();
    String roomId = request.getParameter("roomId");
    if (roomId == null) roomId = "1";
    Long loginUserId = 1L;
%>

<div class="container-1980 mt-40 mb-40">
    <h2 class="section-title">리뷰 작성하기</h2>

    <div class="card soft">
        <form id="reviewForm" enctype="multipart/form-data" style="display:flex; flex-direction:column; gap:20px;">
            <input type="hidden" name="userId" value="<%=loginUserId%>">

            <div>
                <label>별점</label>
                <select name="rating" required style="padding:6px; border:1px solid var(--gray-300); border-radius:var(--radius-md);">
                    <option value="">선택</option>
                    <option value="5">⭐⭐⭐⭐⭐ (5)</option>
                    <option value="4">⭐⭐⭐⭐ (4)</option>
                    <option value="3">⭐⭐⭐ (3)</option>
                    <option value="2">⭐⭐ (2)</option>
                    <option value="1">⭐ (1)</option>
                </select>
            </div>

            <div>
                <label>내용</label>
                <textarea name="content" rows="4" required
                          style="width:100%; padding:10px; border:1px solid var(--gray-300); border-radius:var(--radius-md); resize:none;"
                          placeholder="리뷰 내용을 작성하세요."></textarea>
            </div>

            <div>
                <label>이미지 첨부 (선택)</label>
                <input type="file" name="img" accept="image/*"
                       style="padding:6px; border:1px solid var(--gray-300); border-radius:var(--radius-md);" />
            </div>

            <div class="flex-row" style="justify-content:space-between;">
                <a href="<%=context%>/reviews?roomId=<%=roomId%>" class="btn btn-outline">← 목록으로</a>
                <button type="submit" class="btn btn-brown">리뷰 등록</button>
            </div>
        </form>
    </div>
</div>

<script>
    const base = "<%=context%>";
    const roomId = "<%=roomId%>";

    document.getElementById("reviewForm").addEventListener("submit", function(e) {
        e.preventDefault();
        const formData = new FormData(this);

        fetch(`${base}/api/reviews/rooms/${roomId}`, {
            method: "POST",
            body: formData
        })
            .then(res => res.text())
            .then(msg => {
                alert(msg);
                window.location.href = `${base}/reviews?roomId=${roomId}`;
            })
            .catch(err => alert("리뷰 등록 실패: " + err));
    });
</script>

<%@ include file="/WEB-INF/views/components/footer.jsp" %>
