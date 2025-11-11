<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%
    String context = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>룸 목록 | Space Core</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .room-list-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 40px 20px;
        }

        /* 상단 헤더 */
        .list-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid var(--cream-tan);
        }

        .list-title {
            font-size: 28px;
            font-weight: 700;
            color: var(--choco);
        }

        .list-count {
            font-size: 16px;
            color: var(--gray-600);
            margin-left: 12px;
        }

        .sort-section {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .sort-select {
            padding: 8px 12px;
            border: 1px solid var(--gray-300);
            border-radius: var(--radius-md);
            font-size: 14px;
            background: var(--white);
            color: var(--text-primary);
            cursor: pointer;
        }

        /* 2컬럼 레이아웃 */
        .list-layout {
            display: grid;
            grid-template-columns: 280px 1fr;
            gap: 30px;
        }

        /* 필터 사이드바 */
        .filter-sidebar {
            background: var(--white);
            border-radius: var(--radius-lg);
            padding: 24px;
            box-shadow: var(--shadow-sm);
            height: fit-content;
            position: sticky;
            top: 100px;
        }

        .filter-section {
            margin-bottom: 30px;
            padding-bottom: 24px;
            border-bottom: 1px solid var(--gray-200);
        }

        .filter-section:last-child {
            border-bottom: none;
            margin-bottom: 0;
        }

        .filter-title {
            font-size: 16px;
            font-weight: 600;
            color: var(--choco);
            margin-bottom: 16px;
        }

        .filter-option {
            margin-bottom: 12px;
        }

        .filter-option label {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
            color: var(--text-primary);
            cursor: pointer;
        }

        .filter-option input[type="checkbox"],
        .filter-option input[type="radio"] {
            width: 18px;
            height: 18px;
            cursor: pointer;
        }

        .price-range {
            display: flex;
            flex-direction: column;
            gap: 0;
        }

        .map-view-button:hover {
            background: var(--mocha) !important;
        }

        /* 지도 모달 */
        .map-modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.6);
            align-items: center;
            justify-content: center;
            padding: 20px;
            box-sizing: border-box;
        }

        .map-modal-content {
            background: var(--white);
            border-radius: var(--radius-lg);
            max-width: 1000px;
            width: 100%;
            max-height: 90vh;
            display: flex;
            flex-direction: column;
            box-shadow: var(--shadow-lg);
        }

        .map-modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px 24px;
            border-bottom: 1px solid var(--gray-200);
        }

        .map-modal-header h2 {
            margin: 0;
            color: var(--choco);
            font-size: 24px;
            font-weight: 700;
        }

        .map-modal-close {
            background: none;
            border: none;
            font-size: 32px;
            color: var(--gray-600);
            cursor: pointer;
            line-height: 1;
            padding: 0;
            width: 32px;
            height: 32px;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: color 0.2s;
        }

        .map-modal-close:hover {
            color: var(--choco);
        }

        .map-modal-body {
            padding: 24px;
            flex: 1;
            overflow: hidden;
        }

        .map-container-modal {
            width: 100%;
            height: 600px;
            border-radius: var(--radius-md);
            overflow: hidden;
            background: var(--gray-200);
        }

        .price-input {
            width: 100%;
            padding: 8px 12px;
            border: 1px solid var(--gray-300);
            border-radius: var(--radius-md);
            font-size: 14px;
        }

        /* 룸 카드 리스트 */
        .room-list {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .room-card {
            display: flex;
            gap: 0;
            background: var(--white);
            border-radius: var(--radius-lg);
            overflow: hidden;
            box-shadow: var(--shadow-sm);
            transition: var(--transition);
            border: 1px solid var(--gray-200);
        }

        .room-card:hover {
            box-shadow: var(--shadow-md);
            border-color: var(--amber);
        }

        .room-image-wrapper {
            width: 280px;
            min-width: 280px;
            height: 200px;
            flex-shrink: 0;
            overflow: hidden;
            background: var(--gray-200);
            position: relative;
        }

        .room-image {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .no-image-placeholder {
            width: 100%;
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--gray-500);
            font-size: 14px;
            background: var(--gray-200);
        }

        .favorite-icon {
            position: absolute;
            top: 12px;
            right: 12px;
            width: 32px;
            height: 32px;
            background: rgba(255, 255, 255, 0.9);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            cursor: pointer;
            transition: var(--transition);
            border: none;
            color: var(--gray-400);
        }

        .favorite-icon.active {
            color: #e63946;
        }

        .favorite-icon:hover {
            background: var(--white);
            transform: scale(1.1);
        }

        .room-info {
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            padding: 24px;
        }

        .room-header-info {
            margin-bottom: 16px;
        }

        .room-name {
            font-size: 22px;
            font-weight: 700;
            color: var(--choco);
            margin-bottom: 12px;
        }

        .room-location {
            font-size: 14px;
            color: var(--gray-600);
            margin-bottom: 12px;
        }

        .room-rating {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
            margin-bottom: 16px;
        }

        .star-rating {
            color: var(--amber);
            font-size: 16px;
        }

        .review-count {
            color: var(--gray-600);
        }

        .room-footer-info {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: auto;
        }

        .room-capacity {
            font-size: 15px;
            color: var(--gray-700);
            font-weight: 500;
        }

        .room-price-section {
            display: flex;
            flex-direction: column;
            align-items: flex-end;
            gap: 12px;
        }

        .room-price {
            text-align: right;
        }

        .price-value {
            font-size: 24px;
            font-weight: 700;
            color: var(--choco);
        }

        .reserve-button {
            padding: 10px 24px;
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

        .reserve-button:hover {
            background: var(--mocha);
        }

        .edit-button {
            padding: 10px 20px;
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

        .edit-button:hover {
            background: var(--gray-300);
        }

        .delete-button {
            padding: 10px 20px;
            background: #dc3545;
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

        .delete-button:hover {
            background: #c82333;
        }

        /* 관리자 버튼 */
        .admin-actions {
            margin-top: 20px;
            padding: 20px;
            background: var(--gray-100);
            border-radius: var(--radius-lg);
        }

        /* 반응형 */
        @media (max-width: 1024px) {
            .list-layout {
                grid-template-columns: 1fr;
            }

            .filter-sidebar {
                position: static;
            }
        }
    </style>
</head>
<body>
<%@ include file="/WEB-INF/views/components/header.jsp" %>

<div class="room-list-container">
    <!-- 상단 헤더 -->
    <div class="list-header">
        <div>
            <h1 class="list-title">
                룸 목록
                <span class="list-count">(${not empty roomList ? roomList.size() : 0}개)</span>
            </h1>
        </div>
        <div class="sort-section">
            <select class="sort-select" id="sortSelect" onchange="applySort()">
                <option value="recommended">추천순</option>
                <option value="price_asc">가격 낮은순</option>
                <option value="price_desc">가격 높은순</option>
                <option value="name_asc">이름순</option>
            </select>
        </div>
    </div>

    <!-- 2컬럼 레이아웃 -->
    <div class="list-layout">
        <!-- 왼쪽: 필터 사이드바 -->
        <aside class="filter-sidebar">
            <!-- 지도 보기 버튼 -->
            <button type="button" onclick="openMapModal()" class="map-view-button" style="width: 100%; padding: 12px; background: var(--amber); color: var(--white); border: none; border-radius: var(--radius-md); font-size: 15px; font-weight: 600; cursor: pointer; margin-bottom: 20px; transition: var(--transition);">
                🗺️ 지도 보기
            </button>
            
            <form id="filterForm" method="get">
                <!-- 지점 필터 -->
                <div class="filter-section">
                    <h3 class="filter-title">지점</h3>
                    <div class="filter-option">
                        <label>
                            <input type="radio" name="officeId" value="${selectedOfficeId}" checked disabled>
                            <c:forEach var="office" items="${officeList}">
                                <c:if test="${office.id == selectedOfficeId}">
                                    ${office.name}
                                </c:if>
                            </c:forEach>
                        </label>
                    </div>
                    <a href="/offices" style="margin-top: 12px; display: block; text-align: center; padding: 8px; background: var(--cream-tan); color: var(--choco); border-radius: var(--radius-md); text-decoration: none; font-size: 14px;">
                        다른 지점 보기
                    </a>
                </div>

                <!-- 가격 필터 -->
                <div class="filter-section">
                    <h3 class="filter-title">가격</h3>
                    <div class="price-range">
                        <input type="number" class="price-input" name="minPrice" placeholder="최소 가격" min="0" id="minPrice" value="${param.minPrice != null ? param.minPrice : ''}">
                        <input type="number" class="price-input" name="maxPrice" placeholder="최대 가격" min="0" id="maxPrice" value="${param.maxPrice != null ? param.maxPrice : ''}" style="margin-top: 8px;">
                    </div>
                    <button type="button" onclick="applyFilters()" style="margin-top: 12px; width: 100%; padding: 8px; background: var(--amber); color: white; border: none; border-radius: var(--radius-md); cursor: pointer;">
                        적용
                    </button>
                </div>

                <!-- 정원 필터 -->
                <div class="filter-section">
                    <h3 class="filter-title">정원</h3>
                    <div class="filter-option">
                        <label>
                            <input type="radio" name="capacity" value="" ${empty param.capacity ? 'checked' : ''} onchange="applyFilters()">
                            전체
                        </label>
                    </div>
                    <div class="filter-option">
                        <label>
                            <input type="radio" name="capacity" value="1-5" ${param.capacity == '1-5' ? 'checked' : ''} onchange="applyFilters()">
                            1-5명
                        </label>
                    </div>
                    <div class="filter-option">
                        <label>
                            <input type="radio" name="capacity" value="6-10" ${param.capacity == '6-10' ? 'checked' : ''} onchange="applyFilters()">
                            6-10명
                        </label>
                    </div>
                    <div class="filter-option">
                        <label>
                            <input type="radio" name="capacity" value="11+" ${param.capacity == '11+' ? 'checked' : ''} onchange="applyFilters()">
                            11명 이상
                        </label>
                    </div>
                </div>
            </form>
        </aside>

        <!-- 지도 모달 -->
        <div id="mapModal" class="map-modal" style="display: none;">
            <div class="map-modal-content">
                <div class="map-modal-header">
                    <h2>지도 보기</h2>
                    <button class="map-modal-close" onclick="closeMapModal()">&times;</button>
                </div>
                <div class="map-modal-body">
                    <!-- 지도 필터 -->
                    <div style="margin-bottom: 20px; padding: 15px; background: var(--gray-100); border-radius: var(--radius-md);">
                        <div style="display: flex; gap: 20px; flex-wrap: wrap;">
                            <div>
                                <label style="display: block; margin-bottom: 5px; font-weight: 600; color: var(--choco);">최소 가격</label>
                                <input type="number" id="mapMinPrice" placeholder="최소 가격" min="0" style="padding: 8px 12px; border: 1px solid var(--gray-300); border-radius: var(--radius-md); width: 150px;">
                            </div>
                            <div>
                                <label style="display: block; margin-bottom: 5px; font-weight: 600; color: var(--choco);">최대 가격</label>
                                <input type="number" id="mapMaxPrice" placeholder="최대 가격" min="0" style="padding: 8px 12px; border: 1px solid var(--gray-300); border-radius: var(--radius-md); width: 150px;">
                            </div>
                            <div style="display: flex; align-items: flex-end;">
                                <button onclick="applyMapFilters()" style="padding: 8px 20px; background: var(--amber); color: white; border: none; border-radius: var(--radius-md); cursor: pointer; font-weight: 600;">적용</button>
                            </div>
                        </div>
                    </div>
                    <div id="mapContainer" class="map-container-modal"></div>
                </div>
            </div>
        </div>

        <!-- 오른쪽: 룸 카드 리스트 -->
        <main>
            <div class="room-list">
                <c:forEach var="room" items="${roomList}">
                        <div class="room-card">
                            <!-- 룸 이미지 -->
                            <div class="room-image-wrapper">
                                <c:choose>
                                    <c:when test="${not empty room.thumbnail}">
                                        <img src="${room.thumbnail}" alt="${room.name}" class="room-image">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="no-image-placeholder">No Image</div>
                                    </c:otherwise>
                                </c:choose>
                                <button class="favorite-icon" data-room-id="${room.id}" data-office-id="${room.officeId}" onclick="event.preventDefault(); toggleFavorite(${room.id}, ${room.officeId}, this);">
                                    ♡
                                </button>
                            </div>

                            <!-- 룸 정보 -->
                            <div class="room-info">
                                <div class="room-header-info">
                                    <h3 class="room-name">${room.name}</h3>
                                    <div class="room-location">
                                        <c:forEach var="office" items="${officeList}">
                                            <c:if test="${office.id == room.officeId}">
                                                ${office.name}
                                            </c:if>
                                        </c:forEach>
                                    </div>
                                    <div class="room-rating">
                                        <c:set var="reviewSummary" value="${reviewMap[room.id]}"/>
                                        <c:choose>
                                            <c:when test="${not empty reviewSummary && reviewSummary.avgRating != null && reviewSummary.avgRating > 0}">
                                                <span class="star-rating">
                                                    <c:forEach begin="1" end="5" var="i">
                                                        <c:choose>
                                                            <c:when test="${i <= reviewSummary.avgRating}">★</c:when>
                                                            <c:otherwise>☆</c:otherwise>
                                                        </c:choose>
                                                    </c:forEach>
                                                </span>
                                                <span class="review-count">
                                                    <fmt:formatNumber value="${reviewSummary.avgRating}" pattern="#.#"/>점 (${reviewSummary.totalCount != null ? reviewSummary.totalCount : 0}개 리뷰)
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="star-rating">☆☆☆☆☆</span>
                                                <span class="review-count">리뷰 없음</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                <div class="room-footer-info">
                                    <div class="room-capacity">기준 ${room.capacity}명 / 최대 ${room.capacity}명</div>
                                    <div class="room-price-section">
                                        <div class="room-price">
                                            <div class="price-value"><fmt:formatNumber value="${room.priceBase}" type="number"/>원</div>
                                        </div>
                                        <div style="display: flex; gap: 8px; align-items: center;">
                                            <a href="/offices/${room.officeId}/rooms/detail/${room.id}" class="reserve-button">상세보기</a>
                                            <sec:authorize access="hasRole('ADMIN')">
                                                <a href="/offices/${room.officeId}/rooms/edit/${room.id}" class="edit-button">수정</a>
                                                <form action="/offices/${room.officeId}/rooms/delete/${room.id}" method="post" style="display: inline;" onsubmit="return confirm('정말 이 룸을 삭제하시겠습니까?');">
                                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                                    <button type="submit" class="delete-button">삭제</button>
                                                </form>
                                            </sec:authorize>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                </c:forEach>

                <c:if test="${empty roomList}">
                    <div style="text-align: center; padding: 60px 20px; color: var(--gray-600);">
                        <p style="font-size: 18px; margin-bottom: 12px;">등록된 룸이 없습니다.</p>
                        <sec:authorize access="hasRole('ADMIN')">
                            <a href="/offices/${selectedOfficeId}/rooms/add" style="color: var(--amber);">룸 등록하기</a>
                        </sec:authorize>
                    </div>
                </c:if>
            </div>

            <!-- Pagination -->
            <c:if test="${not empty pageInfo}">
                <c:set var="baseUrl" value="/offices/${selectedOfficeId}/rooms"/>
                <c:set var="queryParams" value=""/>
                <c:if test="${not empty param.sort}">
                    <c:set var="queryParams" value="${queryParams}sort=${param.sort}"/>
                </c:if>
                <c:if test="${not empty param.minPrice}">
                    <c:set var="queryParams" value="${queryParams}${not empty queryParams ? '&' : ''}minPrice=${param.minPrice}"/>
                </c:if>
                <c:if test="${not empty param.maxPrice}">
                    <c:set var="queryParams" value="${queryParams}${not empty queryParams ? '&' : ''}maxPrice=${param.maxPrice}"/>
                </c:if>
                <c:if test="${not empty param.capacity}">
                    <c:set var="queryParams" value="${queryParams}${not empty queryParams ? '&' : ''}capacity=${param.capacity}"/>
                </c:if>
                <c:if test="${not empty queryParams}">
                    <c:set var="baseUrl" value="${baseUrl}?${queryParams}"/>
                </c:if>
                <div style="margin-top: 40px; display: flex; justify-content: center;">
                    <%@ include file="../components/pagination.jsp" %>
                </div>
            </c:if>

            <!-- 관리자 액션 -->
            <sec:authorize access="hasRole('ADMIN')">
                <div class="admin-actions">
                    <a href="/offices/${selectedOfficeId}/rooms/add" style="display: inline-block; padding: 12px 24px; background: var(--amber); color: white; border-radius: var(--radius-md); text-decoration: none; font-weight: 600;">
                        룸 등록
                    </a>
                </div>
            </sec:authorize>
        </main>
    </div>
</div>

<script>
    // 필터 적용
    function applyFilters() {
        const form = document.getElementById('filterForm');
        const formData = new FormData(form);
        const params = new URLSearchParams();
        
        // 현재 URL의 쿼리 파라미터 유지
        const currentUrl = new URL(window.location.href);
        const currentParams = new URLSearchParams(currentUrl.search);
        
        // 기존 page 파라미터 제거 (필터 적용 시 첫 페이지로)
        currentParams.delete('page');
        
        // 폼 데이터 추가
        for (const [key, value] of formData.entries()) {
            if (value) {
                currentParams.set(key, value);
            } else {
                currentParams.delete(key);
            }
        }
        
        window.location.href = currentUrl.pathname + (currentParams.toString() ? '?' + currentParams.toString() : '');
    }

    // 정렬 적용
    function applySort() {
        const sortValue = document.getElementById('sortSelect').value;
        const currentUrl = new URL(window.location.href);
        currentUrl.searchParams.set('sort', sortValue);
        currentUrl.searchParams.delete('page'); // 정렬 변경 시 첫 페이지로
        window.location.href = currentUrl.toString();
    }
    
    // 페이지 로드 시 정렬 옵션 설정
    document.addEventListener('DOMContentLoaded', () => {
        const urlParams = new URLSearchParams(window.location.search);
        const sortValue = urlParams.get('sort') || 'recommended';
        document.getElementById('sortSelect').value = sortValue;
    });

    // 즐겨찾기 토글
    async function toggleFavorite(roomId, officeId, button) {
        event.stopPropagation();
        
        try {
            const params = new URLSearchParams({ roomId, officeId });
            const res = await fetch('/api/favorites/toggle', {
                method: 'POST',
                headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                body: params
            });

            if (res.ok) {
                const data = await res.json();
                if (data.favorite) {
                    button.textContent = '♥';
                    button.classList.add('active');
                } else {
                    button.textContent = '♡';
                    button.classList.remove('active');
                }
            }
        } catch (error) {
            console.error('즐겨찾기 토글 실패:', error);
        }
    }

    // 페이지 로드 시 즐겨찾기 상태 확인
    document.addEventListener('DOMContentLoaded', async () => {
        const favoriteButtons = document.querySelectorAll('.favorite-icon');
        
        for (const button of favoriteButtons) {
            const roomId = button.dataset.roomId;
            try {
                const res = await fetch('/api/favorites/check?roomId=' + roomId);
                const data = await res.json();
                if (data.favorite) {
                    button.textContent = '♥';
                    button.classList.add('active');
                }
            } catch (e) {
                console.warn('즐겨찾기 상태 확인 실패', e);
            }
        }
    });

    // 지도 모달 열기
    function openMapModal() {
        const modal = document.getElementById('mapModal');
        modal.style.display = 'flex';
        document.body.style.overflow = 'hidden';
        
        // 지도 초기화 (한 번만)
        if (!window.mapInitialized) {
            initMap();
            window.mapInitialized = true;
        }
    }

    // 지도 모달 닫기
    function closeMapModal() {
        const modal = document.getElementById('mapModal');
        modal.style.display = 'none';
        document.body.style.overflow = 'auto';
    }

    // 모달 외부 클릭 시 닫기
    window.addEventListener('click', function(event) {
        const modal = document.getElementById('mapModal');
        if (event.target === modal) {
            closeMapModal();
        }
    });

    // 지도 초기화
    function initMap() {
        // 네이버 지도 API 스크립트 로드
        if (typeof naver === 'undefined') {
            const script = document.createElement('script');
            script.src = 'https://oapi.map.naver.com/openapi/v3/maps.js?ncpKeyId=${clientId}';
            script.onload = function() {
                loadMap();
            };
            document.head.appendChild(script);
        } else {
            loadMap();
        }
    }

    // 지도 필터 적용
    function applyMapFilters() {
        loadMap();
    }

    // 지도 로드
    function loadMap() {
        const mapContainer = document.getElementById('mapContainer');
        if (!mapContainer) return;

        <c:if test="${not empty currentOffice}">
            <c:choose>
                <c:when test="${not empty currentOffice.latitude && not empty currentOffice.longitude}">
                    try {
                        const map = new naver.maps.Map('mapContainer', {
                            center: new naver.maps.LatLng(${currentOffice.latitude}, ${currentOffice.longitude}),
                            zoom: 15
                        });
                        
                        const marker = new naver.maps.Marker({
                            position: new naver.maps.LatLng(${currentOffice.latitude}, ${currentOffice.longitude}),
                            map: map,
                            title: '${currentOffice.name}'
                        });
                        
                        const infoWindow = new naver.maps.InfoWindow({
                            content: '<div style="padding: 10px;"><strong>${currentOffice.name}</strong><br>${currentOffice.address != null ? currentOffice.address : ""}</div>'
                        });
                        
                        naver.maps.Event.addListener(marker, 'click', function() {
                            if (infoWindow.getMap()) {
                                infoWindow.close();
                            } else {
                                infoWindow.open(map, marker);
                            }
                        });
                    } catch (e) {
                        console.error('지도 로드 실패:', e);
                        mapContainer.innerHTML = '<div style="display: flex; align-items: center; justify-content: center; height: 100%; color: var(--gray-600);">지도를 불러올 수 없습니다.</div>';
                    }
                </c:when>
                <c:otherwise>
                    mapContainer.innerHTML = '<div style="display: flex; align-items: center; justify-content: center; height: 100%; color: var(--gray-600);">위치 정보가 없습니다.</div>';
                </c:otherwise>
            </c:choose>
        </c:if>
    }
</script>

<%@ include file="/WEB-INF/views/components/footer.jsp" %>
</body>
</html>
