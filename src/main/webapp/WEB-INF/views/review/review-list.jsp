<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Space Core® | 리뷰 리스트</title>

    <!-- CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <!-- 폰트 -->
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&family=Montserrat:wght@400;600&display=swap" rel="stylesheet">
</head>
<body>

<%@ include file="/WEB-INF/views/components/header.jsp" %>

<%
    String context = request.getContextPath();
    String roomId = request.getParameter("roomId");
    if (roomId == null || roomId.isEmpty()) roomId = "1";
%>

<main class="container-1980 mt-40 mb-40">
    <h2 class="section-title">이용자 리뷰 목록</h2>

    <div class="card-basic">
        <h3 class="card-title">등록된 리뷰</h3>

        <!-- ⭐ 리뷰 요약 -->
        <div id="reviewSummary" class="text-center" style="margin-bottom:25px; font-weight:600; color:var(--choco);">
            불러오는 중...
        </div>

        <!-- 🔍 검색 + 필터 -->
        <div class="flex-row" style="gap:10px; margin-bottom:25px; flex-wrap:wrap;">
            <input type="text" id="keyword" placeholder="리뷰 내용 검색"
                   class="input" style="flex:1; min-width:200px; height:40px; padding:0 12px; border:1px solid var(--gray-300); border-radius:var(--radius-md);">
            <input type="text" id="userName" placeholder="작성자 이름"
                   class="input" style="width:150px; height:40px; padding:0 12px; border:1px solid var(--gray-300); border-radius:var(--radius-md);">
            <select id="rating" class="input" style="width:130px; height:40px; border:1px solid var(--gray-300); border-radius:var(--radius-md);">
                <option value="">별점 선택</option>
                <option value="5">⭐ 5점</option>
                <option value="4">⭐ 4점</option>
                <option value="3">⭐ 3점</option>
                <option value="2">⭐ 2점</option>
                <option value="1">⭐ 1점</option>
            </select>
            <button class="btn btn-brown" onclick="searchReviews()">검색</button>
            <button class="btn btn-outline" onclick="resetFilters()">초기화</button>
        </div>

        <!-- 💬 리뷰 목록 -->
        <div id="reviewList" style="display:flex; flex-direction:column; gap:25px;">
            <p class="text-center" style="color:var(--gray-600);">리뷰를 불러오는 중...</p>
        </div>

        <!-- 📄 페이지네이션 -->
        <div id="pagination" class="pagination" style="margin-top:40px;"></div>

        <!-- ✍ 리뷰 작성 버튼 -->
        <div class="text-right mt-40">
            <a href="<%=context%>/reviews/create?roomId=<%=roomId%>" class="btn btn-brown">리뷰 작성하기</a>
        </div>
    </div>
</main>

<%@ include file="/WEB-INF/views/components/footer.jsp" %>
<%@ include file="/WEB-INF/views/components/pagination.jsp" %>
<script>
    var base = "<%=context%>";
    var roomId = "<%=roomId%>";
    var currentPage = 1;
    var size = 5;

    function loadReviewSummary() {
        fetch(base + "/api/reviews/rooms/" + roomId + "/summary")
            .then(function(res){ return res.json(); })
            .then(function(data){
                var el = document.getElementById("reviewSummary");
                if (!data || data.totalCount === 0) {
                    el.innerHTML = "아직 등록된 리뷰가 없습니다.";
                } else {
                    el.innerHTML = "⭐ 평균 <strong>" + data.avgRating.toFixed(1) + "</strong>점 (총 <strong>" + data.totalCount + "</strong>개의 리뷰)";
                }
            })
            .catch(function(err){
                console.error("요약 불러오기 실패:", err);
                document.getElementById("reviewSummary").innerText = "요약 정보를 불러오지 못했습니다.";
            });
    }

    function loadReviews(page) {
        if (!page) page = 1;
        currentPage = page;

        var keyword = document.getElementById("keyword").value.trim();
        var userName = document.getElementById("userName").value.trim();
        var rating = document.getElementById("rating").value;

        var url = base + "/api/reviews/rooms/" + roomId + "?page=" + page + "&size=" + size;
        if (keyword) url += "&keyword=" + encodeURIComponent(keyword);
        if (userName) url += "&userName=" + encodeURIComponent(userName);
        if (rating) url += "&rating=" + rating;

        fetch(url)
            .then(function(res){ return res.json(); })
            .then(function(result){
                var data = result.data || [];
                var pageInfo = result.pageInfo || {};
                var area = document.getElementById("reviewList");
                area.innerHTML = "";

                if (data.length === 0) {
                    area.innerHTML = '<p class="text-center" style="color:var(--gray-600);">등록된 리뷰가 없습니다.</p>';
                    document.getElementById("pagination").innerHTML = "";
                    return;
                }

                data.forEach(function(r){
                    var html = '';
                    html += '<div class="rounded shadow" style="padding:20px; border:1px solid var(--gray-300); background:var(--white);">';
                    html += '<div class="flex-row" style="justify-content:space-between;">';
                    html += '<strong style="color:var(--choco);">' + r.userName + '</strong>';
                    html += '<span style="color:var(--amber);">' + "⭐".repeat(r.rating) + '</span>';
                    html += '</div>';
                    html += '<p style="margin:10px 0; color:var(--text-primary); white-space:pre-line;">' + r.content + '</p>';
                    if (r.imgUrl) {
                        html += '<img src="' + r.imgUrl + '" alt="리뷰 이미지" class="rounded" style="width:140px; margin-top:10px;">';
                    }
                    html += '<p style="font-size:13px; color:var(--gray-600); margin-top:8px;">' + r.createdAt + '</p>';
                    html += '</div>';
                    area.innerHTML += html;
                });

                renderPagination(pageInfo.totalPages || 1);
            })
            .catch(function(err){
                console.error("리뷰 불러오기 실패:", err);
                document.getElementById("reviewList").innerHTML =
                    '<p class="text-center" style="color:red;">리뷰를 불러오는 중 오류가 발생했습니다.</p>';
            });
    }

    function searchReviews() {
        loadReviews(1);
    }

    function resetFilters() {
        document.getElementById("keyword").value = "";
        document.getElementById("userName").value = "";
        document.getElementById("rating").value = "";
        loadReviews(1);
    }

    function renderPagination(totalPages) {
        var el = document.getElementById("pagination");
        el.innerHTML = "";
        if (totalPages <= 1) return;

        var html = '<ul class="pagination-list">';
        if (currentPage > 1) {
            html += '<li><a href="javascript:void(0)" onclick="loadReviews(' + (currentPage - 1) + ')">이전</a></li>';
        }

        for (var i = 1; i <= totalPages; i++) {
            html += '<li class="' + (i === currentPage ? 'active' : '') + '">';
            html += '<a href="javascript:void(0)" onclick="loadReviews(' + i + ')">' + i + '</a>';
            html += '</li>';
        }

        if (currentPage < totalPages) {
            html += '<li><a href="javascript:void(0)" onclick="loadReviews(' + (currentPage + 1) + ')">다음</a></li>';
        }

        html += '</ul>';
        el.innerHTML = html;
    }

    window.onload = function() {
        loadReviewSummary();
        loadReviews();
    };
</script>

</body>
</html>
