<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    String context = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>지점 목록 | Space Core</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .office-list-container {
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

        /* 지점 카드 리스트 */
        .office-list {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 24px;
        }

        .office-card {
            background: var(--white);
            border-radius: var(--radius-lg);
            overflow: hidden;
            box-shadow: var(--shadow-sm);
            transition: var(--transition);
            cursor: pointer;
        }

        .office-card:hover {
            box-shadow: var(--shadow-md);
            transform: translateY(-4px);
        }

        .office-card-image {
            width: 100%;
            height: 200px;
            background: var(--gray-200);
            position: relative;
            overflow: hidden;
        }

        .office-card-image img {
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

        .office-card-content {
            padding: 20px;
        }

        .office-card-name {
            font-size: 20px;
            font-weight: 600;
            color: var(--choco);
            margin-bottom: 12px;
        }

        .office-card-info {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .office-card-address {
            font-size: 14px;
            color: var(--gray-600);
            margin-bottom: 8px;
        }

        .office-card-status {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 600;
        }

        .status-active {
            background: #e8f5e9;
            color: #2e7d32;
        }

        .status-inactive {
            background: #fff3e0;
            color: #e65100;
        }

        .office-card-actions {
            margin-top: 16px;
            padding-top: 16px;
            border-top: 1px solid var(--gray-200);
            display: flex;
            gap: 8px;
        }

        .office-card-actions a {
            flex: 1;
            padding: 8px 12px;
            text-align: center;
            border-radius: var(--radius-md);
            font-size: 14px;
            font-weight: 500;
            text-decoration: none;
            transition: var(--transition);
        }

        .btn-primary {
            background: var(--amber);
            color: var(--white);
        }

        .btn-primary:hover {
            background: var(--mocha);
        }

        .btn-secondary {
            background: var(--gray-200);
            color: var(--text-primary);
        }

        .btn-secondary:hover {
            background: var(--gray-300);
        }

        /* 관리자 버튼 */
        .admin-actions {
            margin-top: 30px;
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

            .office-list {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
<%@ include file="/WEB-INF/views/components/header.jsp" %>

<div class="office-list-container">
    <!-- 상단 헤더 -->
    <div class="list-header">
        <div>
            <h1 class="list-title">
                공유오피스 지점 목록
                <span class="list-count">(${not empty officeList ? officeList.size() : 0}개)</span>
            </h1>
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
                <!-- 지역 필터 -->
                <div class="filter-section">
                    <h3 class="filter-title">지역</h3>
                    <div class="filter-option">
                        <label>
                            <input type="radio" name="region" value="" ${empty param.region ? 'checked' : ''} onchange="applyFilters()">
                            전체
                        </label>
                    </div>
                    <c:forEach var="reg" items="${availableRegions}">
                        <div class="filter-option">
                            <label>
                                <input type="radio" name="region" value="${reg}" ${param.region == reg ? 'checked' : ''} onchange="applyFilters()">
                                ${reg}
                            </label>
                        </div>
                    </c:forEach>
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
                                <label style="display: block; margin-bottom: 5px; font-weight: 600; color: var(--choco);">지역</label>
                                <select id="mapRegionFilter" style="padding: 8px 12px; border: 1px solid var(--gray-300); border-radius: var(--radius-md);">
                                    <option value="">전체</option>
                                    <c:forEach var="reg" items="${availableRegions}">
                                        <option value="${reg}">${reg}</option>
                                    </c:forEach>
                                </select>
                            </div>
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

        <!-- 오른쪽: 지점 카드 리스트 -->
        <main>
            <div class="office-list">
                <c:forEach var="office" items="${officeList}">
                    <div class="office-card">
                        <!-- 지점 이미지 (추후 추가 가능) -->
                        <div class="office-card-image">
                            <div class="no-image-placeholder">No Image</div>
                        </div>

                        <!-- 지점 정보 -->
                        <div class="office-card-content">
                            <h3 class="office-card-name">${office.name}</h3>
                            <div class="office-card-info">
                                    <div class="office-card-address">
                                        ${office.address != null ? office.address : '주소 정보 없음'}
                                    </div>
                                    <div style="margin-top: 8px;">
                                        <c:set var="reviewSummary" value="${officeReviewMap[office.id]}"/>
                                        <c:choose>
                                            <c:when test="${not empty reviewSummary && reviewSummary.totalCount != null && reviewSummary.totalCount > 0}">
                                                <div style="display: flex; align-items: center; gap: 8px;">
                                                    <span class="star-rating" style="color: var(--amber); font-size: 14px;">
                                                        <c:forEach begin="1" end="5" var="i">
                                                            <c:choose>
                                                                <c:when test="${i <= reviewSummary.avgRating}">★</c:when>
                                                                <c:otherwise>☆</c:otherwise>
                                                            </c:choose>
                                                        </c:forEach>
                                                    </span>
                                                    <span style="font-size: 14px; color: var(--gray-600);">
                                                        <fmt:formatNumber value="${reviewSummary.avgRating}" pattern="#.#"/>점
                                                        (${reviewSummary.totalCount}개 리뷰)
                                                    </span>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div style="font-size: 14px; color: var(--gray-500);">
                                                    <span class="star-rating">☆☆☆☆☆</span>
                                                    <span style="margin-left: 8px;">리뷰 없음</span>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div style="margin-top: 8px;">
                                        <span class="office-card-status ${office.status == 'ACTIVE' ? 'status-active' : 'status-inactive'}">
                                            <c:choose>
                                                <c:when test="${office.status == 'ACTIVE'}">활성</c:when>
                                                <c:when test="${office.status == 'INACTIVE'}">비활성</c:when>
                                                <c:otherwise>${office.status}</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                </div>
                            <div class="office-card-actions">
                                <a href="/offices/${office.id}/rooms" class="btn-primary" onclick="event.stopPropagation();">룸 보기</a>
                                <sec:authorize access="hasRole('ADMIN')">
                                    <a href="/offices/edit/${office.id}" class="btn-secondary" onclick="event.stopPropagation();" style="font-size: 12px; padding: 6px 10px;">수정</a>
                                </sec:authorize>
                            </div>
                        </div>
                    </div>
                </c:forEach>

                <c:if test="${empty officeList}">
                    <div style="grid-column: 1 / -1; text-align: center; padding: 60px 20px; color: var(--gray-600);">
                        <p style="font-size: 18px; margin-bottom: 12px;">등록된 지점이 없습니다.</p>
                        <sec:authorize access="hasRole('ADMIN')">
                            <a href="/offices/add" style="color: var(--amber);">지점 등록하기</a>
                        </sec:authorize>
                    </div>
                </c:if>
            </div>

            <!-- Pagination -->
            <c:if test="${not empty pageInfo}">
                <c:set var="baseUrl" value="/offices"/>
                <c:set var="queryParams" value=""/>
                <c:if test="${not empty param.region}">
                    <c:set var="queryParams" value="${queryParams}${not empty queryParams ? '&' : ''}region=${param.region}"/>
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
                    <a href="/offices/add" style="display: inline-block; padding: 12px 24px; background: var(--amber); color: white; border-radius: var(--radius-md); text-decoration: none; font-weight: 600;">
                        지점 등록
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
        const currentUrl = new URL(window.location.href);
        const currentParams = new URLSearchParams(currentUrl.search);
        
        // 기존 page 파라미터 제거
        currentParams.delete('page');
        
        // 라디오 버튼 처리 (region)
        const selectedRegion = form.querySelector('input[name="region"]:checked');
        if (selectedRegion && selectedRegion.value) {
            currentParams.set('region', selectedRegion.value);
        } else {
            currentParams.delete('region');
        }
        
        // 폼 데이터 추가
        for (const [key, value] of formData.entries()) {
            if (value && key !== 'region') {
                currentParams.set(key, value);
            } else if (key !== 'region') {
                currentParams.delete(key);
            }
        }
        
        window.location.href = currentUrl.pathname + (currentParams.toString() ? '?' + currentParams.toString() : '');
    }

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

    // 지도 로드 (모든 지점 표시)
    function loadMap() {
        const mapContainer = document.getElementById('mapContainer');
        if (!mapContainer) return;

        const regionFilter = document.getElementById('mapRegionFilter')?.value || '';
        const minPrice = document.getElementById('mapMinPrice')?.value || '';
        const maxPrice = document.getElementById('mapMaxPrice')?.value || '';

        // 모든 지점의 위치 정보 (필터링 전 전체 목록)
        const allOffices = [
            <c:forEach var="office" items="${allOfficeList}" varStatus="status">
            {
                id: ${office.id},
                name: '${office.name}',
                address: '${office.address != null ? office.address : ""}',
                latitude: ${office.latitude != null ? office.latitude : 0},
                longitude: ${office.longitude != null ? office.longitude : 0}
            }<c:if test="${!status.last}">,</c:if>
            </c:forEach>
        ];

        // 필터링 적용
        let offices = allOffices.filter(o => {
            // 지역 필터
            if (regionFilter && !o.address.includes(regionFilter)) {
                return false;
            }
            return true;
        });

        // 유효한 위치 정보가 있는 지점만 필터링
        const validOffices = offices.filter(o => o.latitude !== 0 && o.longitude !== 0);

        if (validOffices.length === 0) {
            mapContainer.innerHTML = '<div style="display: flex; align-items: center; justify-content: center; height: 100%; color: var(--gray-600);">위치 정보가 있는 지점이 없습니다.</div>';
            return;
        }

        try {
            // 첫 번째 지점을 중심으로 지도 생성
            const firstOffice = validOffices[0];
            const map = new naver.maps.Map('mapContainer', {
                center: new naver.maps.LatLng(firstOffice.latitude, firstOffice.longitude),
                zoom: 10
            });

            // 모든 지점에 마커 추가
            validOffices.forEach(function(office) {
                const marker = new naver.maps.Marker({
                    position: new naver.maps.LatLng(office.latitude, office.longitude),
                    map: map,
                    title: office.name
                });

                const infoWindow = new naver.maps.InfoWindow({
                    content: '<div style="padding: 15px; min-width: 200px;">' +
                             '<div style="margin-bottom: 10px;">' +
                             '<strong style="font-size: 16px; color: var(--choco);">' + office.name + '</strong><br>' +
                             '<span style="font-size: 13px; color: var(--gray-700);">' + office.address + '</span>' +
                             '</div>' +
                             '<a href="/offices/' + office.id + '/rooms" ' +
                             'style="display: inline-block; padding: 8px 16px; background: var(--amber); color: white; ' +
                             'text-decoration: none; border-radius: var(--radius-md); font-size: 13px; font-weight: 600; ' +
                             'text-align: center; transition: var(--transition);">상세보기</a>' +
                             '</div>'
                });

                naver.maps.Event.addListener(marker, 'click', function() {
                    if (infoWindow.getMap()) {
                        infoWindow.close();
                    } else {
                        // 다른 정보창 닫기
                        if (map.infoWindows) {
                            map.infoWindows.forEach(function(iw) {
                                iw.close();
                            });
                        }
                        infoWindow.open(map, marker);
                    }
                });
            });

            // 모든 마커가 보이도록 지도 범위 조정
            if (validOffices.length > 1) {
                const bounds = new naver.maps.LatLngBounds();
                validOffices.forEach(function(office) {
                    bounds.extend(new naver.maps.LatLng(office.latitude, office.longitude));
                });
                map.fitBounds(bounds);
            }
        } catch (e) {
            console.error('지도 로드 실패:', e);
            mapContainer.innerHTML = '<div style="display: flex; align-items: center; justify-content: center; height: 100%; color: var(--gray-600);">지도를 불러올 수 없습니다.</div>';
        }
    }
</script>

<%@ include file="/WEB-INF/views/components/footer.jsp" %>
</body>
</html>
