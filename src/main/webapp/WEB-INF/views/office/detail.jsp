<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String context = request.getContextPath();
%>
<%@ include file="/WEB-INF/views/components/header.jsp" %>
<link rel="stylesheet" href="<%=context%>/css/style.css">

<style>
    .office-detail {
        max-width: 1400px;
        margin: 40px auto;
        padding: 20px;
    }

    /* 상단 헤더 섹션 */
    .office-header {
        background: white;
        padding: 30px;
        border-radius: 12px;
        margin-bottom: 30px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    }
    .office-header-top {
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
        margin-bottom: 20px;
    }
    .office-title-section {
        flex: 1;
    }
    .office-title-section h1 {
        color: var(--choco);
        margin: 0 0 10px 0;
        font-size: 28px;
        display: flex;
        align-items: center;
        gap: 12px;
    }
    .office-address {
        color: var(--gray-600);
        font-size: 16px;
        margin-bottom: 15px;
    }
    .office-price {
        font-size: 24px;
        font-weight: 600;
        color: var(--choco);
    }
    .office-favorite-btn {
        background: none;
        border: none;
        font-size: 32px;
        cursor: pointer;
        color: var(--gray-400);
        transition: all 0.2s;
        padding: 8px;
    }
    .office-favorite-btn:hover {
        transform: scale(1.1);
    }
    .office-favorite-btn.active {
        color: #e74c3c;
    }

    /* 객실 목록 섹션 */
    .room-list-section {
        background: white;
        padding: 30px;
        border-radius: 12px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        margin-bottom: 30px;
    }
    .room-list-section h2 {
        color: var(--choco);
        margin-bottom: 30px;
        font-size: 24px;
        border-bottom: 2px solid var(--choco);
        padding-bottom: 10px;
    }
    .room-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
        gap: 24px;
    }
    .room-card {
        border: 1px solid var(--gray-300);
        border-radius: 12px;
        overflow: hidden;
        background: white;
        transition: all 0.3s ease;
        position: relative;
    }
    .room-card:hover {
        border-color: var(--choco);
        box-shadow: 0 8px 24px rgba(0,0,0,0.15);
        transform: translateY(-4px);
    }
    .room-card-image {
        width: 100%;
        height: 200px;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-size: 18px;
        position: relative;
    }
    .room-card-image img {
        width: 100%;
        height: 100%;
        object-fit: cover;
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
        font-size: 20px;
        cursor: pointer;
        transition: all 0.2s;
        z-index: 10;
    }
    .room-card-favorite:hover {
        background: white;
        transform: scale(1.1);
    }
    .room-card-favorite.active {
        color: #e74c3c;
    }
    .room-card-content {
        padding: 20px;
    }
    .room-card-title {
        font-size: 20px;
        font-weight: 600;
        color: var(--choco);
        margin-bottom: 12px;
    }
    .room-card-info {
        font-size: 14px;
        color: var(--gray-600);
        margin-bottom: 8px;
        display: flex;
        align-items: center;
        gap: 8px;
    }
    .room-card-info strong {
        color: var(--gray-800);
        min-width: 80px;
    }
    .room-card-price {
        font-size: 22px;
        font-weight: 600;
        color: var(--choco);
        margin: 16px 0;
        padding-top: 16px;
        border-top: 1px solid var(--gray-200);
    }
    .room-card-price .price-label {
        font-size: 14px;
        color: var(--gray-600);
        font-weight: 400;
        margin-right: 8px;
    }
    .room-card-actions {
        margin-top: 16px;
        display: flex;
        gap: 8px;
    }
    .btn-reserve {
        flex: 1;
        padding: 12px 20px;
        background: var(--choco);
        color: white;
        border: none;
        border-radius: 8px;
        font-size: 16px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s;
    }
    .btn-reserve:hover {
        background: var(--amber);
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(0,0,0,0.2);
    }

    /* 지도 섹션 */
    .map-section {
        background: white;
        padding: 30px;
        border-radius: 12px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        margin-bottom: 30px;
    }
    .map-section h2 {
        color: var(--choco);
        margin-bottom: 20px;
        font-size: 24px;
        border-bottom: 2px solid var(--choco);
        padding-bottom: 10px;
    }
    .map-container {
        width: 100%;
        height: 400px;
        border-radius: 8px;
        overflow: hidden;
        background: var(--gray-100);
    }
    #officeMap {
        width: 100%;
        height: 100%;
    }

    @media (max-width: 768px) {
        .room-grid {
            grid-template-columns: 1fr;
        }
        .office-header-top {
            flex-direction: column;
        }
    }
</style>

<script src="https://maps.googleapis.com/maps/api/js?key=YOUR_GOOGLE_MAPS_API_KEY&callback=initMap" async defer></script>

<main class="office-detail">
    <!-- 상단 헤더 -->
    <div class="office-header">
        <div class="office-header-top">
            <div class="office-title-section">
                <h1>
                    ${office.name}
                    <button class="office-favorite-btn" id="officeFavoriteBtn" onclick="toggleOfficeFavorite(event)">
                        <i class="ph ph-heart"></i>
                    </button>
                </h1>
                <div class="office-address">${office.address}</div>
                <div class="office-price">예상 가격: <span id="officeMinPrice">-</span>원 ~ <span id="officeMaxPrice">-</span>원</div>
            </div>
        </div>
    </div>

    <!-- 객실 목록 -->
    <div class="room-list-section">
        <h2>객실 목록</h2>
        <c:choose>
            <c:when test="${empty roomList}">
                <p>등록된 객실이 없습니다.</p>
            </c:when>
            <c:otherwise>
                <div class="room-grid">
                    <c:forEach var="room" items="${roomList}">
                        <div class="room-card">
                            <div class="room-card-image">
                                <c:choose>
                                    <c:when test="${not empty room.thumbnail}">
                                        <img src="<%=context%>${room.thumbnail}" alt="${room.name}">
                                    </c:when>
                                    <c:otherwise>
                                        <span>${room.name}</span>
                                    </c:otherwise>
                                </c:choose>
                                <button class="room-card-favorite" onclick="toggleRoomFavorite(event, ${room.id})" data-room-id="${room.id}">
                                    <i class="ph ph-heart"></i>
                                </button>
                            </div>
                            <div class="room-card-content">
                                <div class="room-card-title">${room.name}</div>
                                <div class="room-card-info">
                                    <strong>정원:</strong>
                                    <span>기준 ${room.capacity}명 / 최대 ${room.capacity}명</span>
                                </div>
                                <div class="room-card-info">
                                    <strong>최소 예약:</strong>
                                    <span>${room.minReservationHours}시간</span>
                                </div>
                                <div class="room-card-price">
                                    <span class="price-label">예상 가격</span>
                                    <span>${room.priceBase}원</span>
                                </div>
                                <div class="room-card-actions">
                                    <button class="btn-reserve" onclick="goToReservation(event, ${room.id})">
                                        예약하기
                                    </button>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- 지도 섹션 -->
    <div class="map-section">
        <h2>위치 정보</h2>
        <div class="map-container">
            <div id="officeMap"></div>
        </div>
    </div>
</main>

<script>
    const officeId = ${office.id};
    const officeAddress = "${office.address}";
    let officeMap = null;
    let officeMarker = null;

    // 지도 초기화
    function initMap() {
        const geocoder = new google.maps.Geocoder();
        const mapOptions = {
            zoom: 15,
            center: { lat: 37.5665, lng: 126.9780 } // 기본: 서울시청
        };
        officeMap = new google.maps.Map(document.getElementById('officeMap'), mapOptions);

        // 주소로 지도 표시
        geocoder.geocode({ address: officeAddress }, function(results, status) {
            if (status === 'OK' && results[0]) {
                const location = results[0].geometry.location;
                officeMap.setCenter(location);
                officeMarker = new google.maps.Marker({
                    map: officeMap,
                    position: location,
                    title: "${office.name}"
                });

                // 정보창
                const infoWindow = new google.maps.InfoWindow({
                    content: `<div style="padding: 10px;">
                        <strong>${office.name}</strong><br>
                        ${officeAddress}
                    </div>`
                });
                officeMarker.addListener('click', function() {
                    infoWindow.open(officeMap, officeMarker);
                });
            } else {
                console.error('Geocoding failed:', status);
            }
        });
    }

    // 지도 API 로드 실패 시 대체
    window.initMap = initMap;
    if (typeof google === 'undefined' || typeof google.maps === 'undefined') {
        console.warn('Google Maps API not loaded');
    }

    // 예상 가격 계산 (최소/최대)
    function calculateOfficePrice() {
        const rooms = document.querySelectorAll('.room-card');
        let minPrice = Infinity;
        let maxPrice = 0;

        rooms.forEach(room => {
            const priceText = room.querySelector('.room-card-price span:last-child')?.textContent;
            if (priceText) {
                const price = parseInt(priceText.replace(/[^0-9]/g, ''));
                if (!isNaN(price)) {
                    minPrice = Math.min(minPrice, price);
                    maxPrice = Math.max(maxPrice, price);
                }
            }
        });

        if (minPrice !== Infinity && maxPrice > 0) {
            document.getElementById('officeMinPrice').textContent = minPrice.toLocaleString();
            document.getElementById('officeMaxPrice').textContent = maxPrice.toLocaleString();
        } else {
            document.getElementById('officeMinPrice').textContent = '-';
            document.getElementById('officeMaxPrice').textContent = '-';
        }
    }

    // 예약하기 버튼 클릭
    function goToReservation(event, roomId) {
        event.stopPropagation();
        
        // 서버에서 로그인 상태 확인 (쿠키 기반 인증)
        fetch('<%=context%>/api/auth/validate', {
            method: 'GET',
            credentials: 'include' // 쿠키 포함
        })
        .then(response => {
            if (!response.ok) {
                // 인증 실패
                throw new Error('Unauthorized');
            }
            return response.json();
        })
        .then(data => {
            if (data.valid === true) {
                // 로그인 되어 있으면 예약 페이지로 이동
                window.location.href = '<%=context%>/reservations/add/' + roomId;
            } else {
                // 유효하지 않은 토큰
                throw new Error('Invalid token');
            }
        })
        .catch(error => {
            // 로그인되지 않았거나 인증 실패
            alert('로그인이 필요합니다');
            window.location.href = '<%=context%>/auth/login?error=' + encodeURIComponent('로그인이 필요합니다');
        });
    }

    // 객실 즐겨찾기 토글
    function toggleRoomFavorite(event, roomId) {
        event.stopPropagation();
        const btn = event.currentTarget;
        const icon = btn.querySelector('i');
        const isActive = btn.classList.contains('active');

        // 로그인 체크
        const token = localStorage.getItem('token');
        if (!token) {
            alert('로그인이 필요합니다');
            window.location.href = '<%=context%>/auth/login?error=' + encodeURIComponent('로그인이 필요합니다');
            return;
        }

        // TODO: 즐겨찾기 API 호출
        // 임시로 UI만 토글
        if (isActive) {
            btn.classList.remove('active');
            icon.className = 'ph ph-heart';
        } else {
            btn.classList.add('active');
            icon.className = 'ph ph-heart-fill';
        }
    }

    // 지점 즐겨찾기 토글
    function toggleOfficeFavorite(event) {
        event.stopPropagation();
        const btn = event.currentTarget;
        const icon = btn.querySelector('i');
        const isActive = btn.classList.contains('active');

        // 로그인 체크
        const token = localStorage.getItem('token');
        if (!token) {
            alert('로그인이 필요합니다');
            window.location.href = '<%=context%>/auth/login?error=' + encodeURIComponent('로그인이 필요합니다');
            return;
        }

        // TODO: 즐겨찾기 API 호출
        // 임시로 UI만 토글
        if (isActive) {
            btn.classList.remove('active');
            icon.className = 'ph ph-heart';
        } else {
            btn.classList.add('active');
            icon.className = 'ph ph-heart-fill';
        }
    }

    // 페이지 로드 시 예상 가격 계산
    document.addEventListener('DOMContentLoaded', function() {
        calculateOfficePrice();
    });
</script>

<%@ include file="/WEB-INF/views/components/footer.jsp" %>
