<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%
    String context = request.getContextPath();
%>

<%@ include file="/WEB-INF/views/components/header.jsp" %>
<link rel="stylesheet" href="<%=context%>/css/style.css">

<style>
    /* 필터와 카드 섹션 카드 */
    .filter-card-section {
        background: white;
        border: 1px solid var(--gray-300);
        border-radius: 12px;
        padding: 30px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    }
    
    .filter-section {
        margin-bottom: 30px;
        padding-bottom: 30px;
        border-bottom: 1px solid var(--gray-100);
    }
    
    .search-filter-row {
        display: flex;
        gap: 12px;
        align-items: center;
        justify-content: center;
        margin-bottom: 20px;
        flex-wrap: wrap;
    }
    
    .search-filter-row .search-input {
        width: 300px;
        max-width: 100%;
        padding: 10px 16px;
        border: 1px solid var(--gray-300);
        border-radius: 8px;
        font-size: 14px;
    }
    
    .price-filter-section {
        margin-top: 20px;
    }
    
    .filter-label {
        font-weight: 600;
        color: var(--choco);
        margin-bottom: 12px;
        font-size: 14px;
    }
    
    .result-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-top: 20px;
    }
    
    .result-summary {
        font-size: 14px;
        color: var(--gray-600);
    }
    
    .card-section {
        margin-top: 30px;
    }
    
    /* 중앙 팝업 스타일 */
    .map-popup {
        position: fixed;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        width: 90%;
        max-width: 1400px;
        height: 85vh;
        background: white;
        border-radius: 12px;
        box-shadow: 0 8px 32px rgba(0,0,0,0.2);
        z-index: 10000;
        display: none;
        overflow: hidden;
    }
    
    .map-popup.active {
        display: flex;
        flex-direction: column;
    }
    
    .map-popup-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 20px 30px;
        border-bottom: 1px solid var(--gray-200);
        background: var(--cream-base);
    }
    
    .map-popup-header h2 {
        margin: 0;
        color: var(--choco);
        font-size: 20px;
    }
    
    .map-popup-close {
        background: none;
        border: none;
        font-size: 32px;
        cursor: pointer;
        color: var(--text-primary);
        padding: 0;
        width: 40px;
        height: 40px;
        display: flex;
        align-items: center;
        justify-content: center;
        transition: color 0.2s;
    }
    
    .map-popup-close:hover {
        color: var(--choco);
    }
    
    .map-popup-content {
        display: flex;
        flex: 1;
        overflow: hidden;
    }
    
    .map-popup-filters {
        width: 320px;
        padding: 30px;
        border-right: 1px solid var(--gray-200);
        overflow-y: auto;
        background: var(--cream-base);
    }
    
    .map-popup-map {
        flex: 1;
        position: relative;
        background: var(--gray-200);
    }
    
    .map-popup-map #mapContainer {
        width: 100%;
        height: 100%;
    }
    
    .map-popup-filters .filter-group {
        margin-bottom: 24px;
    }
    
    .map-popup-filters .filter-group:last-child {
        margin-bottom: 0;
    }
    
    .map-popup-filters .search-input {
        width: 100%;
        padding: 10px 16px;
        border: 1px solid var(--gray-300);
        border-radius: 8px;
        font-size: 14px;
    }
    
    .map-popup-filters .price-filter-group {
        display: flex;
        flex-direction: column;
        gap: 8px;
    }
    
    .map-popup-filters .price-filter-btn {
        width: 100%;
        text-align: left;
    }
    
    .map-popup-overlay {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0,0,0,0.5);
        z-index: 9999;
        display: none;
    }
    
    .map-popup-overlay.active {
        display: block;
    }
    
    /* 객실 카드 스타일 */
    .room-card {
        background: white;
        border: 1px solid var(--gray-300);
        border-radius: 12px;
        overflow: hidden;
        transition: all 0.3s ease;
        cursor: pointer;
        position: relative;
    }
    .room-card:hover {
        border-color: var(--choco);
        box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        transform: translateY(-2px);
    }
    .room-card-image {
        width: 100%;
        height: 240px;
        object-fit: cover;
        background: var(--gray-200);
    }
    .room-card-content {
        padding: 20px;
    }
    .room-card-title {
        font-size: 18px;
        font-weight: 600;
        color: var(--choco);
        margin-bottom: 8px;
    }
    .room-card-info {
        font-size: 14px;
        color: var(--gray-600);
        margin-bottom: 8px;
    }
    .room-card-rating {
        display: flex;
        align-items: center;
        gap: 8px;
        margin-bottom: 8px;
        font-size: 14px;
        color: var(--amber);
    }
    .room-card-price {
        font-size: 18px;
        font-weight: 700;
        color: var(--choco);
        margin-top: 12px;
    }
    .room-card-favorite {
        position: absolute;
        top: 12px;
        right: 12px;
        background: rgba(255,255,255,0.9);
        border: none;
        border-radius: 50%;
        width: 40px;
        height: 40px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 24px;
        cursor: pointer;
        transition: all 0.2s;
        z-index: 10;
    }
    .room-card-favorite:hover {
        background: white;
        transform: scale(1.1);
    }
    .room-card-favorite.active {
        color: #e74c3c !important;
    }
    .room-card-favorite.active:hover {
        color: #c0392b !important;
        transform: scale(1.15);
    }
    .room-card-favorite.active i {
        color: #e74c3c !important;
    }
    
    /* 그리드 레이아웃 */
    .room-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
        gap: 24px;
        margin-top: 30px;
    }
    
    /* 가격 필터 버튼 */
    .price-filter-group {
        display: flex;
        gap: 12px;
        flex-wrap: wrap;
        margin-bottom: 20px;
    }
    .price-filter-btn {
        padding: 10px 20px;
        border: 1px solid var(--gray-300);
        background: white;
        border-radius: 8px;
        cursor: pointer;
        transition: all 0.2s;
        font-size: 14px;
    }
    .price-filter-btn:hover {
        border-color: var(--choco);
        color: var(--choco);
    }
    .price-filter-btn.active {
        background: var(--choco);
        color: white;
        border-color: var(--choco);
    }
</style>

<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>

<main class="container-1980 mt-40 mb-40">
    <!-- 필터와 카드 섹션을 하나의 카드로 묶기 -->
    <div class="filter-card-section">
        <!-- 필터 영역 -->
        <div class="filter-section">
            <!-- 검색/필터 -->
            <div class="search-filter-row">
                <input type="text" id="keyword" class="search-input" placeholder="지점명 검색" />
                <button class="btn btn-brown" id="searchBtn">검색</button>
                <button class="btn btn-outline" id="resetBtn">초기화</button>
                <button class="btn btn-outline" id="mapToggleBtn">지도보기</button>
                <span id="pricePreview" style="margin-left:8px;color:var(--amber);font-weight:600;"></span>
            </div>
            
            <!-- 가격대 필터 -->
            <div class="price-filter-section">
                <p class="filter-label">가격대 선택</p>
                <div class="price-filter-group">
                    <button class="price-filter-btn" data-min="10000" data-max="30000">1만 ~ 3만</button>
                    <button class="price-filter-btn" data-min="30000" data-max="60000">3만 ~ 6만</button>
                    <button class="price-filter-btn" data-min="60000" data-max="100000">6만 ~ 10만</button>
                    <button class="price-filter-btn" data-min="100000" data-max="200000">10만 ~ 20만</button>
                    <button class="price-filter-btn" data-min="" data-max="">전체</button>
                </div>
            </div>

            <!-- 결과 헤더 -->
            <div class="result-header">
                <h2 class="section-title">검색 결과</h2>
                <div style="display: flex; align-items: center; gap: 16px;">
                    <p class="result-summary">
                        총 <span id="totalOffices">0</span>개 지점
                    </p>
                    <sec:authorize access="hasRole('ADMIN')">
                        <a href="<%=context%>/offices/add" class="btn-admin" style="padding: 10px 20px; background: var(--mocha); color: white; border-radius: 8px; text-decoration: none; font-weight: 600; font-size: 14px; transition: all 0.3s ease; display: inline-flex; align-items: center; gap: 6px;">
                            <i class="ph ph-plus"></i> 지점 추가
                        </a>
                    </sec:authorize>
                </div>
            </div>
        </div>

        <!-- 리스트 영역 -->
        <div class="card-section">
            <section id="officeList" class="room-grid"></section>

            <!-- 페이지네이션 -->
            <div class="pagination mt-40">
                <ul class="pagination-list" id="paginationArea"></ul>
            </div>
        </div>
    </div>
</main>

<!-- 중앙 팝업 지도 -->
<div class="map-popup-overlay" id="mapOverlay"></div>
<div class="map-popup" id="mapPopup">
    <div class="map-popup-header">
        <h2>지도 보기</h2>
        <button class="map-popup-close" id="mapCloseBtn">&times;</button>
    </div>
    
    <div class="map-popup-content">
        <!-- 좌측 필터 영역 -->
        <div class="map-popup-filters">
            <div class="filter-group">
                <p class="filter-label">지점명 검색</p>
                <input type="text" id="mapKeyword" class="search-input" placeholder="지점명 검색" style="width:100%; margin-bottom:16px;" />
                <button class="btn btn-brown" id="mapSearchBtn" style="width:100%; margin-bottom:16px;">검색</button>
                <button class="btn btn-outline" id="mapResetBtn" style="width:100%; margin-bottom:24px;">초기화</button>
            </div>
            
            <div class="filter-group">
                <p class="filter-label">가격대 선택</p>
                <div class="price-filter-group">
                    <button class="price-filter-btn" data-min="10000" data-max="30000">1만 ~ 3만</button>
                    <button class="price-filter-btn" data-min="30000" data-max="60000">3만 ~ 6만</button>
                    <button class="price-filter-btn" data-min="60000" data-max="100000">6만 ~ 10만</button>
                    <button class="price-filter-btn" data-min="100000" data-max="200000">10만 ~ 20만</button>
                    <button class="price-filter-btn" data-min="" data-max="">전체</button>
                </div>
            </div>
            
            <div class="filter-group" style="margin-top:24px;">
                <p class="result-summary" style="font-size:13px;">
                    총 <span id="mapTotalOffices">0</span>개 지점
                </p>
            </div>
        </div>
        
        <!-- 우측 지도 영역 -->
        <div class="map-popup-map">
            <div id="mapContainer" style="width:100%; height:100%;"></div>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/views/components/footer.jsp" %>

<!-- 네이버 지도 API 로드 (지오코딩 포함) -->
<script type="text/javascript"
        src="https://oapi.map.naver.com/openapi/v3/maps.js?ncpKeyId=${clientId}"
        onload="console.log('네이버 지도 API 로드 완료');"
        onerror="console.error('네이버 지도 API 로드 실패');">
</script>
<script>
    (function() {
        var ctx = "<%=context%>";
        var qs = new URLSearchParams(location.search);
        var $ = function(sel){ return document.querySelector(sel); };
        var $all = function(sel){ return Array.prototype.slice.call(document.querySelectorAll(sel)); };

        var CSRF_TOKEN = document.querySelector('meta[name="_csrf"]').getAttribute('content');
        var CSRF_HEADER = document.querySelector('meta[name="_csrf_header"]').getAttribute('content');

        var state = {
            page: parseInt(qs.get("page") || 1),
            limit: parseInt(qs.get("limit") || 10),
            keyword: qs.get("keyword") || "",
            minPrice: qs.get("minPrice") || "",
            maxPrice: qs.get("maxPrice") || ""
        };

        var allOffices = []; // 전체 지점 데이터 저장
        var filteredOffices = []; // 필터링된 지점 데이터

        $("#keyword").value = state.keyword;

        function setPricePreview() {
            var pv = $("#pricePreview");
            if (state.minPrice && state.maxPrice) {
                pv.textContent = Number(state.minPrice).toLocaleString() + " ~ " +
                    Number(state.maxPrice).toLocaleString() + "원";
            } else {
                pv.textContent = "";
            }
        }
        setPricePreview();
        
        // URL 파라미터에서 가격대 필터 초기화 (메인 페이지 + 지도 팝업 모두)
        if (state.minPrice || state.maxPrice) {
            $all(".price-filter-btn").forEach(function(btn){
                var btnMin = btn.getAttribute("data-min") || "";
                var btnMax = btn.getAttribute("data-max") || "";
                if (btnMin === state.minPrice && btnMax === state.maxPrice) {
                    btn.classList.add("active");
                }
            });
        }
        
        // 지도 팝업 내 검색창 동기화 (요소가 존재하는 경우에만)
        var mapKeywordEl = document.getElementById("mapKeyword");
        if (mapKeywordEl) {
            mapKeywordEl.value = state.keyword || "";
        }

        function pushUrl() {
            var params = new URLSearchParams({
                page: state.page,
                limit: state.limit,
                keyword: state.keyword || "",
                minPrice: state.minPrice || "",
                maxPrice: state.maxPrice || ""
            });
            var url = location.pathname + "?" + params.toString();
            history.pushState(state, "", url);
        }

        // 클라이언트 사이드 필터링
        function filterOffices(offices) {
            var filtered = offices;
            
            // 키워드 검색 (지점명)
            if (state.keyword && state.keyword.trim()) {
                var keyword = state.keyword.trim().toLowerCase();
                filtered = filtered.filter(function(o) {
                    return (o.name && o.name.toLowerCase().indexOf(keyword) !== -1) ||
                           (o.address && o.address.toLowerCase().indexOf(keyword) !== -1);
                });
            }
            
            // 가격대 필터 (office의 room 가격 범위 기준)
            if (state.minPrice || state.maxPrice) {
                filtered = filtered.filter(function(o) {
                    var officeMinPrice = o.minPrice || 0;
                    var officeMaxPrice = o.maxPrice || 0;
                    
                    // office에 객실이 없으면 제외
                    if (officeMinPrice === 0 && officeMaxPrice === 0) return false;
                    
                    // 가격 범위가 겹치면 포함
                    if (state.minPrice && officeMaxPrice < Number(state.minPrice)) return false;
                    if (state.maxPrice && officeMinPrice > Number(state.maxPrice)) return false;
                    
                    return true;
                });
            }
            
            return filtered;
        }

        // 지점의 모든 객실 리뷰 통계 및 가격 정보 가져오기
        async function getOfficeReviewSummary(officeId) {
            try {
                // 해당 지점의 모든 객실 가져오기
                var roomsRes = await fetch(ctx + "/api/rooms", { credentials: "same-origin" });
                if (!roomsRes.ok) return { avgRating: 0, totalCount: 0, minPrice: 0, maxPrice: 0 };
                var allRooms = await roomsRes.json();
                
                // 해당 지점의 객실만 필터링
                var officeRooms = allRooms.filter(function(r) { return r.officeId === officeId; });
                if (officeRooms.length === 0) return { avgRating: 0, totalCount: 0, minPrice: 0, maxPrice: 0 };
                
                // 객실 가격 범위 계산
                var prices = officeRooms.map(function(r) { return r.priceBase || 0; }).filter(function(p) { return p > 0; });
                var minPrice = prices.length > 0 ? Math.min.apply(Math, prices) : 0;
                var maxPrice = prices.length > 0 ? Math.max.apply(Math, prices) : 0;
                
                // 각 객실의 리뷰 통계 가져오기
                var totalRating = 0;
                var totalCount = 0;
                var roomCount = 0;
                
                for (var i=0; i<officeRooms.length; i++) {
                    var roomId = officeRooms[i].id;
                    var reviewRes = await fetch(ctx + "/api/reviews/rooms/" + roomId + "/summary", { credentials: "same-origin" });
                    if (reviewRes.ok) {
                        var reviewData = await reviewRes.json();
                        if (reviewData.totalCount > 0) {
                            totalRating += (reviewData.avgRating || 0) * reviewData.totalCount;
                            totalCount += reviewData.totalCount || 0;
                            roomCount++;
                        }
                    }
                }
                
                var avgRating = totalCount > 0 ? (totalRating / totalCount) : 0;
                return {
                    avgRating: avgRating.toFixed(1),
                    totalCount: totalCount,
                    minPrice: minPrice,
                    maxPrice: maxPrice
                };
            } catch(e) {
                console.error("지점 리뷰 통계 조회 실패:", e);
                return { avgRating: 0, totalCount: 0, minPrice: 0, maxPrice: 0 };
            }
        }

        async function fetchOffices(page) {
            if (!page) page = 1;
            state.page = page;

            // 전체 지점 데이터가 없으면 한번에 가져오기
            if (allOffices.length === 0) {
                var res = await fetch(ctx + "/api/offices", { credentials: "same-origin" });
                if (!res.ok) {
                    console.error("지점 목록 로드 실패", res.status);
                    return;
                }
                var offices = await res.json();
                
                // 각 지점의 리뷰 통계 및 가격 정보 가져오기
                allOffices = await Promise.all(offices.map(async function(office) {
                    var reviewInfo = await getOfficeReviewSummary(office.id);
                    return {
                        ...office,
                        avgRating: reviewInfo.avgRating,
                        reviewCount: reviewInfo.totalCount,
                        minPrice: reviewInfo.minPrice,
                        maxPrice: reviewInfo.maxPrice
                    };
                }));
            }

            // 필터링 적용
            filteredOffices = filterOffices(allOffices);
            
            // 페이지네이션 적용
            var start = (state.page - 1) * state.limit;
            var end = start + state.limit;
            var paginatedOffices = filteredOffices.slice(start, end);

            renderOfficeCards(paginatedOffices);
            renderPagination({
                currentPage: state.page,
                totalPages: Math.ceil(filteredOffices.length / state.limit),
                totalCount: filteredOffices.length
            });
            $("#totalOffices").innerText = filteredOffices.length;
            pushUrl();
        }

        function escapeHtml(str) {
            if (!str) return "";
            return String(str).replace(/&/g,"&amp;")
                .replace(/</g,"&lt;")
                .replace(/>/g,"&gt;")
                .replace(/"/g,"&quot;")
                .replace(/'/g,"&#039;");
        }

        function renderOfficeCards(offices) {
            var list = $("#officeList");
            if (!offices || offices.length === 0) {
                list.innerHTML = '<div class="card-basic" style="grid-column:1/-1;text-align:center;">검색 결과가 없습니다.</div>';
                return;
            }

            var html = "";
            for (var i=0; i<offices.length; i++) {
                var o = offices[i];
                var id = o.id;
                var name = escapeHtml(o.name || "이름 없음");
                var address = escapeHtml(o.address || "");
                var img = ctx + "/img/no_image.jpg"; // Office는 thumbnail이 없으므로 기본 이미지 사용
                var rating = o.avgRating ? Number(o.avgRating).toFixed(1) : "0.0";
                var rcnt = o.reviewCount || 0;
                var minPrice = o.minPrice || 0;
                var maxPrice = o.maxPrice || 0;
                var priceText = "";
                if (minPrice > 0 && maxPrice > 0) {
                    if (minPrice === maxPrice) {
                        priceText = Number(minPrice).toLocaleString() + "원 ~";
                    } else {
                        priceText = Number(minPrice).toLocaleString() + " ~ " + Number(maxPrice).toLocaleString() + "원";
                    }
                } else if (minPrice > 0) {
                    priceText = Number(minPrice).toLocaleString() + "원 ~";
                } else {
                    priceText = "문의";
                }

                html += '<div class="room-card" onclick="SC.goDetail(' + id + ')">' +
                    '<img src="' + img + '" alt="' + name + '" class="room-card-image">' +
                    '<div class="room-card-content">' +
                    '<div class="room-card-title">' + name + '</div>' +
                    '<div class="room-card-info">' + address + '</div>' +
                    '<div class="room-card-rating">' +
                    '⭐ ' + rating + ' (' + rcnt + '개 리뷰)' +
                    '</div>' +
                    '<div class="room-card-price">' + priceText + '</div>' +
                    '</div></div>';
            }
            list.innerHTML = html;
        }

        function renderPagination(info) {
            var area = $("#paginationArea");
            if (!info || !info.totalPages || info.totalPages <= 1) {
                area.innerHTML = "";
                return;
            }
            var cur = parseInt(info.currentPage || state.page || 1);
            var total = parseInt(info.totalPages);
            var prev = (cur > 1) ? (cur - 1) : 1;
            var next = (cur < total) ? (cur + 1) : total;

            var pages = "";
            var start = info.startPage || 1;
            var end = info.endPage || total;
            for (var i=start; i<=end; i++) {
                pages += '<li><a href="#" class="' + (i == cur ? 'btn-brown' : '') +
                    '" onclick="SC.fetch(' + i + ');return false;">' + i + '</a></li>';
            }

            area.innerHTML =
                '<li><a href="#" onclick="SC.fetch(1);return false;">«</a></li>' +
                '<li><a href="#" onclick="SC.fetch(' + prev + ');return false;">‹</a></li>' +
                pages +
                '<li><a href="#" onclick="SC.fetch(' + next + ');return false;">›</a></li>' +
                '<li><a href="#" onclick="SC.fetch(' + total + ');return false;">»</a></li>';
        }

        var map = null;
        var markers = [];
        var labels = [];
        var mapBounds = null;
        var mapResizeTimer = null;
        var mapEventListenersAttached = false;
        var boundsAdjustTimer = null;
        
        function ensureMap() {
            var container = document.getElementById('mapContainer');
            if (!container) return null;
            
            // 모달이 열려있는지 확인
            var mapPopup = document.getElementById('mapPopup');
            var isModalOpen = mapPopup && mapPopup.classList.contains('active');
            
            // 지도가 이미 초기화되어 있으면 리사이즈만 트리거
            if (map && typeof naver !== 'undefined' && typeof naver.maps !== 'undefined') {
                if (isModalOpen) {
                    // 모달이 열려있으면 리사이즈 트리거
                    if (mapResizeTimer) clearTimeout(mapResizeTimer);
                    mapResizeTimer = setTimeout(function() {
                        if (map) {
                            try {
                                naver.maps.Event.trigger(map, 'resize');
                            } catch (e) {
                                console.warn('지도 리사이즈 트리거 실패:', e);
                            }
                        }
                    }, 300);
                }
                return map;
            }
            
            // 모달이 열려있지 않으면 지도 초기화하지 않음
            if (!isModalOpen) {
                return null;
            }
            
            // 지도 초기화
            if (typeof naver !== 'undefined' && typeof naver.maps !== 'undefined') {
                try {
                    map = new naver.maps.Map(container, {
                        center: new naver.maps.LatLng(37.5665, 126.9780),
                        zoom: 12
                    });
                    
                    // 지도 이벤트 리스너는 한 번만 등록
                    if (!mapEventListenersAttached) {
                        attachMapEventListeners();
                        mapEventListenersAttached = true;
                    }
                    
                    // 지도가 완전히 로드된 후 리사이즈 트리거
                    naver.maps.Event.addListenerOnce(map, 'init', function() {
                        setTimeout(function() {
                            if (map) {
                                try {
                                    naver.maps.Event.trigger(map, 'resize');
                                } catch (e) {
                                    console.warn('지도 리사이즈 트리거 실패:', e);
                                }
                            }
                        }, 200);
                    });
                    
                    // init 이벤트가 발생하지 않을 경우를 대비한 fallback
                    setTimeout(function() {
                        if (map && isModalOpen) {
                            try {
                                naver.maps.Event.trigger(map, 'resize');
                            } catch (e) {
                                console.warn('지도 리사이즈 트리거 실패:', e);
                            }
                        }
                    }, 500);
                } catch (e) {
                    console.error('지도 초기화 실패:', e);
                    return null;
                }
            }
            return map;
        }

        async function drawMarkers() {
            // 네이버 지도 API가 로드되지 않았으면 대기
            if (typeof naver === 'undefined' || typeof naver.maps === 'undefined') {
                console.warn('네이버 지도 API가 로드되지 않았습니다.');
                return;
            }
            
            // 전체 지점 데이터가 없으면 가져오기
            if (allOffices.length === 0) {
                var res = await fetch(ctx + "/api/offices", { credentials: "same-origin" });
                if (!res.ok) return;
                var offices = await res.json();
                
                // 각 지점의 리뷰 통계 및 가격 정보 가져오기
                allOffices = await Promise.all(offices.map(async function(office) {
                    var reviewInfo = await getOfficeReviewSummary(office.id);
                    return {
                        ...office,
                        avgRating: reviewInfo.avgRating,
                        reviewCount: reviewInfo.totalCount,
                        minPrice: reviewInfo.minPrice,
                        maxPrice: reviewInfo.maxPrice
                    };
                }));
            }
            
            // 필터링 적용
            var offices = filterOffices(allOffices);
            
            // 지도 팝업 내 총 개수 업데이트
            var mapTotalEl = document.getElementById("mapTotalOffices");
            if (mapTotalEl) {
                mapTotalEl.innerText = offices.length;
            }
            
            // 지도 초기화
            var currentMap = ensureMap();
            if (!currentMap) {
                console.warn('지도 초기화 실패');
                return;
            }

            // 기존 마커 및 라벨 제거
            if (markers.length > 0) {
                markers.forEach(function(item) {
                    if (item.marker) {
                        item.marker.setMap(null);
                    }
                });
            }
            if (labels.length > 0) {
                labels.forEach(function(item) {
                    if (item.el && item.el.parentNode) {
                        item.el.parentNode.removeChild(item.el);
                    }
                });
            }
            markers = [];
            labels = [];
            mapBounds = new naver.maps.LatLngBounds();

            // 각 지점에 대해 마커 생성
            var geocodeCount = 0;
            var completedCount = 0;
            
            for (var i=0; i<offices.length; i++) {
                var o = offices[i];
                var address = o.address || '';
                
                if (!address) continue;
                
                geocodeCount++;
                
                (function(office, addr) {
                    // 위도/경도가 있으면 직접 사용
                    if (office.latitude != null && office.longitude != null && 
                        !isNaN(parseFloat(office.latitude)) && !isNaN(parseFloat(office.longitude))) {
                        completedCount++;
                        var lat = parseFloat(office.latitude);
                        var lng = parseFloat(office.longitude);
                        var position = new naver.maps.LatLng(lat, lng);
                        createMarker(office, addr, position);
                        checkAllGeocodeComplete();
                        return;
                    }
                    
                    // 위도/경도가 없으면 지오코딩 수행
                    // OpenStreetMap Nominatim을 사용하여 지오코딩 (무료, API 키 불필요)
                    var geocoderUrl = 'https://nominatim.openstreetmap.org/search?format=json&q=' + encodeURIComponent(addr) + '&limit=1&countrycodes=kr';
                    
                    fetch(geocoderUrl, {
                        method: 'GET',
                        headers: {
                            'User-Agent': 'SpaceCore/1.0' // Nominatim은 User-Agent 필수
                        }
                    })
                    .then(function(res) {
                        if (!res.ok) {
                            throw new Error('HTTP ' + res.status);
                        }
                        return res.json();
                    })
                    .then(function(data) {
                        completedCount++;
                        
                        if (data && data.length > 0) {
                            var result = data[0];
                            var lat = parseFloat(result.lat);
                            var lng = parseFloat(result.lon);
                            
                            if (!isNaN(lat) && !isNaN(lng)) {
                                var position = new naver.maps.LatLng(lat, lng);
                                createMarker(office, addr, position);
                            } else {
                                // 좌표 파싱 실패
                                console.warn('좌표 파싱 실패:', office.name, addr);
                            }
                        } else {
                            // 결과 없음
                            console.warn('지오코딩 결과 없음:', office.name, addr);
                        }
                        
                        checkAllGeocodeComplete();
                    })
                    .catch(function(err) {
                        completedCount++;
                        console.warn('OpenStreetMap 지오코딩 실패:', office.name, addr, err);
                        checkAllGeocodeComplete();
                    });
                })(o, address);
            }
            
            // 네이버 지도 API 지오코딩 시도 (fallback) - 제거됨 (OpenStreetMap Nominatim만 사용)
            function tryNaverGeocode(office, addr) {
                // 네이버 지도 API 지오코더는 사용하지 않음 (OpenStreetMap Nominatim만 사용)
                completedCount++;
                checkAllGeocodeComplete();
                console.warn('지오코딩 실패:', office.name, addr, '(OpenStreetMap Nominatim 실패)');
                return Promise.reject('지오코딩 실패');
            }
            
            // 마커 생성 함수
            function createMarker(office, addr, position) {
                if (!currentMap || !position) return;
                
                // 마커 생성
                var marker = new naver.maps.Marker({
                    position: position,
                    map: currentMap,
                    title: office.name
                });
                
                // 이름 라벨
                var labelEl = document.createElement('div');
                labelEl.className = 'map-label';
                labelEl.textContent = office.name;
                labelEl.style.cssText = 'background: white; border: 1px solid #ccc; border-radius: 4px; padding: 2px 6px; font-size: 12px; font-weight: bold; white-space: nowrap; box-shadow: 0 1px 3px rgba(0, 0, 0, 0.2); position: absolute; cursor: pointer; transform: translate(-50%, -54px);';
                labelEl.onclick = function() {
                    window.location.href = ctx + '/offices/detail/' + office.id;
                };
                currentMap.getPanes().floatPane.appendChild(labelEl);
                
                // 정보창 생성
                var infoWindow = new naver.maps.InfoWindow({
                    content: '<div style="padding:8px 12px;font-size:14px;min-width:150px;">' +
                        '<strong style="color:#5B3B31;font-size:14px;">' + escapeHtml(office.name) + '</strong><br>' +
                        '<span style="color:#666;font-size:12px;">' + escapeHtml(addr) + '</span><br>' +
                        '<a href="' + ctx + '/offices/detail/' + office.id + '" style="color:#5B3B31;font-weight:700;text-decoration:none;">상세보기</a></div>'
                });
                
                // 마커 클릭 시 상세 페이지 이동
                naver.maps.Event.addListener(marker, 'click', function() {
                    if (infoWindow.getMap()) {
                        infoWindow.close();
                    } else {
                        infoWindow.open(currentMap, marker);
                    }
                });
                
                markers.push({ marker: marker, position: position });
                labels.push({ el: labelEl, position: position });
                
                // bounds 확장
                if (mapBounds) {
                    mapBounds.extend(position);
                }
            }
            
            // 모든 지오코딩 완료 확인
            function checkAllGeocodeComplete() {
                if (completedCount === geocodeCount && geocodeCount > 0) {
                    // 중복 호출 방지를 위해 타이머 정리
                    if (boundsAdjustTimer) clearTimeout(boundsAdjustTimer);
                    
                    // 약간의 지연을 두어 모든 마커가 생성된 후 지도 조정
                    boundsAdjustTimer = setTimeout(function() {
                        if (!currentMap || markers.length === 0 || !mapBounds) return;
                        
                        try {
                            // bounds가 유효한지 확인
                            var sw = mapBounds.getSW();
                            var ne = mapBounds.getNE();
                            
                            if (!sw || !ne) return;
                            
                            // 지도 리사이즈 트리거 (컨테이너 크기 재확인)
                            try {
                                naver.maps.Event.trigger(currentMap, 'resize');
                            } catch (e) {
                                console.warn('지도 리사이즈 트리거 실패:', e);
                            }
                            
                            // 지도 조정 (간단하게)
                            setTimeout(function() {
                                if (!currentMap || markers.length === 0) return;
                                
                                try {
                                    if (markers.length > 1) {
                                        // 여러 마커가 있으면 모든 마커가 보이도록 조정
                                        currentMap.fitBounds(mapBounds);
                                        // fitBounds 후 약간의 여백 추가
                                        setTimeout(function() {
                                            if (currentMap) {
                                                var currentZoom = currentMap.getZoom();
                                                if (currentZoom > 0) {
                                                    currentMap.setZoom(currentZoom - 1);
                                                }
                                                updateLabelPositions();
                                            }
                                        }, 300);
                                    } else if (markers.length === 1) {
                                        // 마커가 하나면 해당 위치로 이동
                                        var center = mapBounds.getCenter();
                                        if (center && currentMap) {
                                            currentMap.setCenter(center);
                                            currentMap.setZoom(15);
                                            updateLabelPositions();
                                        }
                                    }
                                } catch (err) {
                                    console.error('지도 조정 실패:', err);
                                }
                            }, 400);
                        } catch (err) {
                            console.error('지도 조정 실패:', err);
                        }
                    }, 600);
                }
            }
            
            // 지오코딩할 주소가 없으면 즉시 완료 처리
            if (geocodeCount === 0) {
                console.warn('지오코딩할 주소가 없습니다.');
            }
        }
        
        // 라벨 위치 업데이트 함수
        function updateLabelPositions() {
            if (!map) return;
            labels.forEach(function(item) {
                try {
                    var projection = map.getProjection();
                    if (!projection || !item.position) return;
                    var pixel = projection.fromCoordToOffset(item.position);
                    if (item.el && pixel) {
                        item.el.style.left = pixel.x + 'px';
                        item.el.style.top = pixel.y + 'px';
                    }
                } catch (e) {
                    console.warn('라벨 위치 업데이트 실패:', e);
                }
            });
        }
        
        // 지도 이벤트마다 라벨 위치 갱신 (지도가 생성된 후에만, 한 번만 등록)
        function attachMapEventListeners() {
            if (!map || mapEventListenersAttached) return;
            if (typeof naver === 'undefined' || typeof naver.maps === 'undefined') return;
            
            try {
                naver.maps.Event.addListener(map, 'idle', updateLabelPositions);
                naver.maps.Event.addListener(map, 'zoom_changed', updateLabelPositions);
                naver.maps.Event.addListener(map, 'dragend', updateLabelPositions);
            } catch (e) {
                console.error('지도 이벤트 리스너 등록 실패:', e);
            }
        }

        // 이벤트
        function closeMapPopup() {
            document.getElementById("mapPopup").classList.remove("active");
            document.getElementById("mapOverlay").classList.remove("active");
            document.body.style.overflow = "";
        }
        
        $("#mapToggleBtn").addEventListener("click", function(){
            document.getElementById("mapPopup").classList.add("active");
            document.getElementById("mapOverlay").classList.add("active");
            document.body.style.overflow = "hidden";
            
            // 지도 팝업 내 검색창 동기화 (요소가 존재하는지 확인)
            var mapKeywordEl = document.getElementById("mapKeyword");
            if (mapKeywordEl) {
                mapKeywordEl.value = state.keyword || "";
            }
            
            // 가격대 필터 동기화
            if (state.minPrice || state.maxPrice) {
                var priceRange = state.minPrice + "~" + state.maxPrice;
                var priceBtn = document.querySelector('[data-price="' + priceRange + '"]');
                if (priceBtn) {
                    document.querySelectorAll('.price-filter-btn').forEach(function(btn) {
                        btn.classList.remove('active');
                    });
                    priceBtn.classList.add('active');
                }
            } else {
                var allBtn = document.querySelector('[data-price="전체"]');
                if (allBtn) {
                    document.querySelectorAll('.price-filter-btn').forEach(function(btn) {
                        btn.classList.remove('active');
                    });
                    allBtn.classList.add('active');
                }
            }
            
            // 모달이 열린 후 지도 초기화 및 마커 그리기
            // 모달 애니메이션 완료를 위해 약간의 지연
            setTimeout(function() {
                var currentMap = ensureMap();
                if (currentMap) {
                    // 지도 리사이즈를 먼저 트리거하여 컨테이너 크기 인식
                    setTimeout(function() {
                        if (currentMap) {
                            try {
                                naver.maps.Event.trigger(currentMap, 'resize');
                            } catch (e) {
                                console.warn('지도 리사이즈 트리거 실패:', e);
                            }
                        }
                        // 지도가 준비된 후 마커 그리기
                        drawMarkers();
                    }, 400);
                } else {
                    // 지도 초기화 실패 시 재시도
                    setTimeout(function() {
                        var retryMap = ensureMap();
                        if (retryMap) {
                            setTimeout(function() {
                                if (retryMap) {
                                    try {
                                        naver.maps.Event.trigger(retryMap, 'resize');
                                    } catch (e) {
                                        console.warn('지도 리사이즈 트리거 실패:', e);
                                    }
                                }
                                drawMarkers();
                            }, 300);
                        }
                    }, 200);
                }
            }, 200);
        });
        
        $("#mapCloseBtn").addEventListener("click", function(){
            closeMapPopup();
        });
        
        $("#mapOverlay").addEventListener("click", function(){
            closeMapPopup();
        });

        // 가격대 필터 버튼 이벤트 (메인 페이지)
        $all(".filter-card-section .price-filter-btn").forEach(function(btn){
            btn.addEventListener("click", function(){
                $all(".price-filter-btn").forEach(function(b){ b.classList.remove("active"); });
                btn.classList.add("active");
                // 지도 팝업 내 동일한 버튼도 활성화
                var btnMin = btn.getAttribute("data-min") || "";
                var btnMax = btn.getAttribute("data-max") || "";
                $all(".map-popup-filters .price-filter-btn").forEach(function(b){
                    if (b.getAttribute("data-min") === btnMin && b.getAttribute("data-max") === btnMax) {
                        b.classList.add("active");
                    }
                });
                state.minPrice = btnMin;
                state.maxPrice = btnMax;
                state.page = 1;
                setPricePreview();
                fetchOffices(1);
                setTimeout(function(){ drawMarkers(); }, 100);
            });
        });
        
        // 지도 팝업 내 가격 필터 버튼 이벤트
        $all(".map-popup-filters .price-filter-btn").forEach(function(btn){
            btn.addEventListener("click", function(){
                $all(".price-filter-btn").forEach(function(b){ b.classList.remove("active"); });
                btn.classList.add("active");
                // 메인 페이지의 동일한 버튼도 활성화
                var btnMin = btn.getAttribute("data-min") || "";
                var btnMax = btn.getAttribute("data-max") || "";
                $all(".filter-card-section .price-filter-btn").forEach(function(b){
                    if (b.getAttribute("data-min") === btnMin && b.getAttribute("data-max") === btnMax) {
                        b.classList.add("active");
                    }
                });
                state.minPrice = btnMin;
                state.maxPrice = btnMax;
                state.page = 1;
                setPricePreview();
                fetchOffices(1);
                setTimeout(function(){ drawMarkers(); }, 100);
            });
        });
        
        // 지도 팝업 내 검색/초기화 이벤트 (요소가 존재하는 경우에만)
        var mapKeywordEl = document.getElementById("mapKeyword");
        var mapSearchBtn = document.getElementById("mapSearchBtn");
        var mapResetBtn = document.getElementById("mapResetBtn");
        
        if (mapKeywordEl) {
            mapKeywordEl.addEventListener("keydown", function(e){
                if (e.key == "Enter" && mapSearchBtn) {
                    mapSearchBtn.click();
                }
            });
        }
        
        if (mapSearchBtn) {
            mapSearchBtn.addEventListener("click", function(){
                var keywordValue = mapKeywordEl ? mapKeywordEl.value.trim() : "";
                state.keyword = keywordValue;
                state.page = 1;
                var keywordEl = document.getElementById("keyword");
                if (keywordEl) {
                    keywordEl.value = state.keyword; // 메인 검색창도 동기화
                }
                setPricePreview();
                fetchOffices(1);
                setTimeout(function(){ drawMarkers(); }, 100);
            });
        }
        
        if (mapResetBtn) {
            mapResetBtn.addEventListener("click", function(){
                state.keyword = "";
                state.minPrice = "";
                state.maxPrice = "";
                state.page = 1;
                var keywordEl = document.getElementById("keyword");
                if (keywordEl) {
                    keywordEl.value = "";
                }
                if (mapKeywordEl) {
                    mapKeywordEl.value = "";
                }
                $all(".price-filter-btn").forEach(function(b){ b.classList.remove("active"); });
                setPricePreview();
                fetchOffices(1);
                setTimeout(function(){ drawMarkers(); }, 100);
            });
        }

        var searchBtn = document.getElementById("searchBtn");
        if (searchBtn) {
            searchBtn.addEventListener("click", function(){
                var keywordEl = document.getElementById("keyword");
                var keywordValue = keywordEl ? keywordEl.value.trim() : "";
                state.keyword = keywordValue;
                state.page = 1;
                if (mapKeywordEl) {
                    mapKeywordEl.value = state.keyword; // 지도 팝업 검색창도 동기화
                }
                setPricePreview();
                fetchOffices(1);
                setTimeout(function(){ drawMarkers(); }, 100);
            });
        }
        
        var keywordEl = document.getElementById("keyword");
        if (keywordEl) {
            keywordEl.addEventListener("keydown", function(e){
                if (e.key == "Enter" && searchBtn) {
                    searchBtn.click();
                }
            });
        }
        
        var resetBtn = document.getElementById("resetBtn");
        if (resetBtn) {
            resetBtn.addEventListener("click", function(){
                state.keyword = "";
                state.minPrice = "";
                state.maxPrice = "";
                state.page = 1;
                if (keywordEl) {
                    keywordEl.value = "";
                }
                if (mapKeywordEl) {
                    mapKeywordEl.value = ""; // 지도 팝업 검색창도 초기화
                }
                $all(".price-filter-btn").forEach(function(b){ b.classList.remove("active"); });
                setPricePreview();
                fetchOffices(1);
                setTimeout(function(){ drawMarkers(); }, 100);
            });
        }

        window.SC = {
            fetch: function(p){ fetchOffices(p); },
            goDetail: function(id){ 
                location.href = ctx + "/offices/detail/" + id;
            }
        };

            // 네이버 지도 API 로드 완료 대기 함수
            function waitForNaverMaps(callback, maxAttempts) {
                maxAttempts = maxAttempts || 50; // 최대 5초 대기
                var attempts = 0;
                
                var checkInterval = setInterval(function() {
                    attempts++;
                    
                    if (typeof naver !== 'undefined' && 
                        typeof naver.maps !== 'undefined' && 
                        typeof naver.maps.Map !== 'undefined') {
                        clearInterval(checkInterval);
                        console.log('네이버 지도 API 로드 확인 완료');
                        if (callback) callback();
                    } else if (attempts >= maxAttempts) {
                        clearInterval(checkInterval);
                        console.warn('네이버 지도 API 로드 타임아웃');
                    }
                }, 100);
            }
        
        // 네이버 지도 API가 로드되면 초기화
        waitForNaverMaps(function() {
            ensureMap();
        });

        fetchOffices(state.page);
    })();
</script>
