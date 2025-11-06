<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%
    String context = request.getContextPath();
%>
<%@ include file="/WEB-INF/views/components/header.jsp" %>
<link rel="stylesheet" href="<%=context%>/css/style.css">

<style>
    body {
        background: var(--cream-base);
    }

    .office-detail {
        max-width: 1400px;
        margin: 40px auto;
        padding: 20px;
    }

    /* 메인 이미지 갤러리 */
    .image-gallery {
        background: white;
        padding: 30px;
        border-radius: 12px;
        margin-bottom: 30px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    }
    .image-gallery-container {
        display: grid;
        grid-template-columns: 2fr 1fr;
        gap: 12px;
        height: 500px;
    }
    .main-image {
        width: 100%;
        height: 100%;
        object-fit: cover;
        border-radius: 8px;
        background: var(--gray-200);
    }
    .sub-images {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 12px;
    }
    .sub-image {
        width: 100%;
        height: 100%;
        object-fit: cover;
        border-radius: 8px;
        background: var(--gray-200);
        cursor: pointer;
        transition: opacity 0.3s ease;
    }
    .sub-image:hover {
        opacity: 0.8;
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
        font-size: 32px;
        font-weight: 700;
        display: flex;
        align-items: center;
        gap: 12px;
    }
    .office-rating {
        display: flex;
        align-items: center;
        gap: 8px;
        margin-bottom: 10px;
        font-size: 16px;
        color: var(--gray-700);
    }
    .office-rating .rating-score {
        color: var(--amber);
        font-weight: 600;
    }
    .office-rating .review-count {
        color: var(--gray-600);
    }
    .office-address {
        color: var(--gray-600);
        font-size: 16px;
        margin-bottom: 15px;
    }
    .office-price {
        font-size: 28px;
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

    /* 객실 선택 섹션 */
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
        font-weight: 700;
        border-bottom: 2px solid var(--choco);
        padding-bottom: 10px;
    }
    .room-list {
        display: flex;
        flex-direction: column;
        gap: 24px;
    }
    .room-card {
        display: flex;
        border: 1px solid var(--gray-300);
        border-radius: 12px;
        overflow: hidden;
        background: white;
        transition: all 0.3s ease;
        position: relative;
        cursor: pointer;
    }
    .room-card:hover {
        border-color: var(--choco);
        box-shadow: 0 8px 24px rgba(0,0,0,0.15);
        transform: translateY(-2px);
    }
    .room-card-image {
        width: 300px;
        min-width: 300px;
        height: 200px;
        background: var(--gray-200);
        display: flex;
        align-items: center;
        justify-content: center;
        color: var(--gray-600);
        font-size: 18px;
        position: relative;
        overflow: hidden;
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
        transition: all 0.3s ease;
        z-index: 10;
        color: var(--gray-600);
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }
    .room-card-favorite i {
        display: block;
        font-size: 20px;
    }
    .room-card-favorite:hover {
        background: white;
        transform: scale(1.1);
        box-shadow: 0 4px 8px rgba(0,0,0,0.15);
        color: var(--mocha);
    }
    .room-card-favorite.active {
        color: #c33;
    }
    .room-card-favorite.active:hover {
        color: #a00;
    }
    .room-card-content {
        flex: 1;
        padding: 20px;
        display: flex;
        flex-direction: column;
        justify-content: space-between;
    }
    .room-card-title {
        font-size: 22px;
        font-weight: 600;
        color: var(--choco);
        margin-bottom: 12px;
    }
    .room-card-info {
        font-size: 15px;
        color: var(--gray-600);
        margin-bottom: 8px;
        display: flex;
        align-items: center;
        gap: 8px;
    }
    .room-card-info strong {
        color: var(--gray-800);
        min-width: 100px;
    }
    .room-card-features {
        margin: 12px 0;
        font-size: 14px;
        color: var(--gray-600);
    }
    .room-card-bottom {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-top: auto;
        padding-top: 16px;
        border-top: 1px solid var(--gray-200);
    }
    .room-card-price {
        font-size: 24px;
        font-weight: 600;
        color: var(--choco);
    }
    .btn-select {
        padding: 12px 24px;
        background: var(--choco);
        color: white;
        border: none;
        border-radius: 8px;
        font-size: 16px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s;
    }
    .btn-select:hover {
        background: var(--amber);
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(0,0,0,0.2);
    }

    /* 정보 섹션 공통 스타일 */
    .info-section {
        background: white;
        padding: 30px;
        border-radius: 12px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        margin-bottom: 30px;
    }
    .info-section h2 {
        color: var(--choco);
        margin-bottom: 24px;
        font-size: 24px;
        font-weight: 700;
        border-bottom: 2px solid var(--choco);
        padding-bottom: 10px;
    }
    .info-section-content {
        color: var(--gray-700);
        font-size: 15px;
        line-height: 1.8;
    }
    .info-section-content p {
        margin-bottom: 16px;
    }

    /* 서비스 및 부대시설 */
    .facilities-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
        gap: 16px;
        margin-top: 20px;
    }
    .facility-item {
        display: flex;
        align-items: center;
        gap: 12px;
        padding: 12px;
        background: var(--gray-50);
        border-radius: 8px;
        font-size: 15px;
        color: var(--gray-700);
    }
    .facility-item i {
        font-size: 20px;
        color: var(--mocha);
    }

    /* 숙소 이용정보 */
    .usage-info-list {
        list-style: none;
        padding: 0;
        margin: 0;
    }
    .usage-info-list li {
        padding: 12px 0;
        border-bottom: 1px solid var(--gray-200);
        display: flex;
        justify-content: space-between;
    }
    .usage-info-list li:last-child {
        border-bottom: none;
    }
    .usage-info-label {
        font-weight: 600;
        color: var(--gray-800);
        min-width: 150px;
    }
    .usage-info-value {
        color: var(--gray-700);
        flex: 1;
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
        font-weight: 700;
        border-bottom: 2px solid var(--choco);
        padding-bottom: 10px;
    }
    .map-container {
        width: 100%;
        height: 400px;
        border-radius: 8px;
        overflow: hidden;
        background: var(--gray-100);
        margin-bottom: 20px;
    }
    #officeMap {
        width: 100%;
        height: 100%;
    }
    .map-address {
        padding: 16px;
        background: var(--gray-50);
        border-radius: 8px;
        font-size: 15px;
        color: var(--gray-700);
    }
    .map-address strong {
        color: var(--choco);
        margin-right: 8px;
    }

    /* 리뷰 섹션 */
    .reviews-section {
        background: white;
        padding: 30px;
        border-radius: 12px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        margin-bottom: 30px;
    }
    .reviews-section h2 {
        color: var(--choco);
        margin-bottom: 20px;
        font-size: 24px;
        font-weight: 700;
        border-bottom: 2px solid var(--choco);
        padding-bottom: 10px;
    }
    .reviews-summary {
        display: flex;
        align-items: center;
        gap: 16px;
        margin-bottom: 24px;
        padding: 20px;
        background: var(--gray-50);
        border-radius: 8px;
    }
    .reviews-summary .rating-score {
        font-size: 32px;
        font-weight: 700;
        color: var(--amber);
    }
    .reviews-summary .review-count {
        font-size: 16px;
        color: var(--gray-600);
    }
    .reviews-list {
        display: flex;
        flex-direction: column;
        gap: 16px;
    }
    .review-card {
        padding: 20px;
        border: 1px solid var(--gray-200);
        border-radius: 8px;
        background: var(--gray-50);
    }
    .review-card-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 12px;
    }
    .review-card-room {
        font-weight: 600;
        color: var(--choco);
        font-size: 16px;
    }
    .review-card-rating {
        color: var(--amber);
        font-size: 14px;
    }
    .review-card-content {
        color: var(--gray-700);
        font-size: 15px;
        line-height: 1.6;
        margin-bottom: 8px;
    }
    .review-card-image {
        margin: 12px 0;
    }
    .review-card-image img {
        max-width: 100%;
        max-height: 300px;
        border-radius: 8px;
        object-fit: cover;
    }
    .review-card-footer {
        display: flex;
        justify-content: space-between;
        align-items: center;
        font-size: 13px;
        color: var(--gray-500);
    }

    /* 모달 스타일 */
    .room-modal-overlay {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0, 0, 0, 0.5);
        z-index: 9999;
        display: none;
        align-items: center;
        justify-content: center;
    }
    .room-modal-overlay.active {
        display: flex;
    }
    .room-modal {
        background: white;
        border-radius: 12px;
        max-width: 900px;
        width: 90%;
        max-height: 90vh;
        overflow-y: auto;
        position: relative;
        box-shadow: 0 8px 32px rgba(0,0,0,0.2);
    }
    .room-modal-header {
        padding: 24px;
        border-bottom: 1px solid var(--gray-200);
        display: flex;
        justify-content: space-between;
        align-items: center;
        position: sticky;
        top: 0;
        background: white;
        z-index: 10;
    }
    .room-modal-header h2 {
        color: var(--choco);
        font-size: 24px;
        margin: 0;
    }
    .room-modal-close {
        background: none;
        border: none;
        font-size: 24px;
        cursor: pointer;
        color: var(--gray-600);
        padding: 8px;
    }
    .room-modal-close:hover {
        color: var(--choco);
    }
    .room-modal-content {
        padding: 24px;
    }
    .room-modal-images {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
        gap: 12px;
        margin-bottom: 24px;
    }
    .room-modal-image {
        width: 100%;
        height: 150px;
        object-fit: cover;
        border-radius: 8px;
        background: var(--gray-200);
    }
    .room-modal-info {
        margin-bottom: 24px;
    }
    .room-modal-info-item {
        display: flex;
        margin-bottom: 12px;
        font-size: 16px;
    }
    .room-modal-info-item strong {
        min-width: 120px;
        color: var(--gray-800);
    }
    .room-modal-reviews {
        margin-top: 24px;
        padding-top: 24px;
        border-top: 1px solid var(--gray-200);
    }
    .room-modal-reviews h3 {
        color: var(--choco);
        font-size: 20px;
        margin-bottom: 16px;
    }
    .review-item {
        padding: 16px;
        border-bottom: 1px solid var(--gray-200);
    }
    .review-item:last-child {
        border-bottom: none;
    }
    .review-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 8px;
    }
    .review-user {
        font-weight: 600;
        color: var(--gray-800);
    }
    .review-rating {
        color: var(--amber);
    }
    .review-content {
        color: var(--gray-700);
        font-size: 14px;
        line-height: 1.6;
    }
    .review-date {
        color: var(--gray-500);
        font-size: 12px;
        margin-top: 8px;
    }

    @media (max-width: 768px) {
        .image-gallery-container {
            grid-template-columns: 1fr;
            height: auto;
        }
        .sub-images {
            grid-template-columns: 1fr 1fr;
        }
        .room-card {
            flex-direction: column;
        }
        .room-card-image {
            width: 100%;
            min-width: 100%;
        }
        .office-header-top {
            flex-direction: column;
        }
        .room-modal {
            width: 95%;
            max-height: 90vh;
        }
    }
</style>

<!-- Google Maps API는 나중에 추가 예정 -->
<!-- <script src="https://maps.googleapis.com/maps/api/js?key=YOUR_GOOGLE_MAPS_API_KEY&callback=initMap" async defer></script> -->

<main class="office-detail">
    <!-- 메인 이미지 갤러리 -->
    <div class="image-gallery">
        <div class="image-gallery-container">
            <img src="<%=context%>/img/no_image.jpg" alt="${office.name}" class="main-image" id="mainImage" onerror="this.onerror=null; this.src='<%=context%>/img/no_image.jpg';">
            <div class="sub-images">
                <img src="<%=context%>/img/no_image.jpg" alt="이미지 1" class="sub-image" onclick="changeMainImage(this.src)" onerror="this.onerror=null; this.src='<%=context%>/img/no_image.jpg';">
                <img src="<%=context%>/img/no_image.jpg" alt="이미지 2" class="sub-image" onclick="changeMainImage(this.src)" onerror="this.onerror=null; this.src='<%=context%>/img/no_image.jpg';">
                <img src="<%=context%>/img/no_image.jpg" alt="이미지 3" class="sub-image" onclick="changeMainImage(this.src)" onerror="this.onerror=null; this.src='<%=context%>/img/no_image.jpg';">
                <img src="<%=context%>/img/no_image.jpg" alt="이미지 4" class="sub-image" onclick="changeMainImage(this.src)" onerror="this.onerror=null; this.src='<%=context%>/img/no_image.jpg';">
            </div>
        </div>
    </div>

    <!-- 상단 헤더 -->
    <div class="office-header">
        <div class="office-header-top">
            <div class="office-title-section">
                <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 16px;">
                    <div style="flex: 1;">
                        <h1>
                            ${office.name}
                            <button class="office-favorite-btn" id="officeFavoriteBtn" onclick="toggleOfficeFavorite(event)">
                                <i class="ph ph-heart"></i>
                            </button>
                        </h1>
                        <div class="office-rating">
                            <span class="rating-score" id="officeRating">4.5점</span>
                            <span class="review-count" id="officeReviewCount">리뷰 0개</span>
                        </div>
                        <div class="office-address">${office.address}</div>
                        <div class="office-price">예상 가격: <span id="officeMinPrice">-</span>원 ~ <span id="officeMaxPrice">-</span>원</div>
                    </div>
                    <sec:authorize access="hasRole('ADMIN')">
                        <div style="display: flex; gap: 8px; margin-left: 20px;">
                            <a href="<%=context%>/offices/edit/${office.id}" class="btn-admin" style="padding: 10px 20px; background: var(--mocha); color: white; border-radius: 8px; text-decoration: none; font-weight: 600; font-size: 14px; transition: all 0.3s ease;">
                                <i class="ph ph-pencil"></i> 지점 수정
                            </a>
                        </div>
                    </sec:authorize>
                </div>
            </div>
        </div>
    </div>

    <!-- 객실 선택 섹션 -->
    <div class="room-list-section">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
            <h2>객실 선택</h2>
            <sec:authorize access="hasRole('ADMIN')">
                <a href="<%=context%>/offices/${office.id}/rooms/add" class="btn-admin" style="padding: 10px 20px; background: var(--mocha); color: white; border-radius: 8px; text-decoration: none; font-weight: 600; font-size: 14px; transition: all 0.3s ease; display: inline-flex; align-items: center; gap: 6px;">
                    <i class="ph ph-plus"></i> 룸 추가
                </a>
            </sec:authorize>
        </div>
        <c:choose>
            <c:when test="${empty roomList}">
                <p style="text-align: center; padding: 40px; color: var(--gray-500);">등록된 객실이 없습니다.</p>
            </c:when>
            <c:otherwise>
                <div class="room-list">
                    <c:forEach var="room" items="${roomList}">
                        <div class="room-card" onclick="showRoomModal(${room.id})" data-room-id="${room.id}">
                            <div class="room-card-image">
                                <c:choose>
                                    <c:when test="${not empty room.thumbnail}">
                                        <img src="<%=context%>${room.thumbnail != null && room.thumbnail != '' ? room.thumbnail : '/img/no_image.jpg'}" alt="${room.name}" onerror="this.onerror=null; this.src='<%=context%>/img/no_image.jpg';">
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
                                <div>
                                    <div class="room-card-title">${room.name}</div>
                                    <div class="room-card-info">
                                        <strong>정원:</strong>
                                        <span>기준 ${room.capacity}명 / 최대 ${room.capacity}명</span>
                                    </div>
                                    <div class="room-card-info">
                                        <strong>최소 예약:</strong>
                                        <span>${room.minReservationHours}시간</span>
                                    </div>
                                    <div class="room-card-features">
                                        <span>프로젝터, 화이트보드, 무선 인터넷</span>
                                    </div>
                                </div>
                                <div class="room-card-bottom">
                                    <div class="room-card-price">
                                        <fmt:formatNumber value="${room.priceBase}" type="number"/>원
                                    </div>
                                    <div style="display: flex; gap: 8px;">
                                        <button class="btn-select" onclick="goToReservation(event, ${room.id})">
                                            선택
                                        </button>
                                        <sec:authorize access="hasRole('ADMIN')">
                                            <a href="<%=context%>/offices/${office.id}/rooms/edit/${room.id}" class="btn-admin" style="padding: 8px 16px; background: var(--mocha); color: white; border-radius: 8px; text-decoration: none; font-weight: 600; font-size: 13px; transition: all 0.3s ease; display: inline-flex; align-items: center; gap: 4px; white-space: nowrap;" onclick="event.stopPropagation();">
                                                <i class="ph ph-pencil"></i> 수정
                                            </a>
                                        </sec:authorize>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- 숙소 소개 -->
    <div class="info-section">
        <h2>숙소 소개</h2>
        <div class="info-section-content">
            <p>
                ${office.name}은 프리미엄 오피스 공간을 제공하는 현대적인 비즈니스 센터입니다. 
                업무와 협업에 최적화된 환경을 조성하여 고객의 비즈니스 성공을 지원합니다.
            </p>
            <p>
                각 룸은 최신 시설과 편의 기능을 갖추고 있어, 회의, 프레젠테이션, 워크샵 등 다양한 용도로 활용하실 수 있습니다. 
                조용하고 쾌적한 환경에서 집중력 있는 업무를 경험하실 수 있습니다.
            </p>
            <p>
                접근성이 뛰어난 위치에 자리하고 있어, 교통 편의를 제공하며, 
                주변 편의시설과의 연계도 용이합니다.
            </p>
        </div>
    </div>

    <!-- 서비스 및 부대시설 -->
    <div class="info-section">
        <h2>서비스 및 부대시설</h2>
        <div class="facilities-grid">
            <div class="facility-item">
                <i class="ph ph-car"></i>
                <span>주차 가능</span>
            </div>
            <div class="facility-item">
                <i class="ph ph-wifi-high"></i>
                <span>와이파이</span>
            </div>
            <div class="facility-item">
                <i class="ph ph-coffee"></i>
                <span>조식 가능</span>
            </div>
            <div class="facility-item">
                <i class="ph ph-barbell"></i>
                <span>피트니스</span>
            </div>
            <div class="facility-item">
                <i class="ph ph-swimming-pool"></i>
                <span>수영장</span>
            </div>
            <div class="facility-item">
                <i class="ph ph-fork-knife"></i>
                <span>레스토랑</span>
            </div>
            <div class="facility-item">
                <i class="ph ph-printer"></i>
                <span>프린터</span>
            </div>
            <div class="facility-item">
                <i class="ph ph-projector-screen"></i>
                <span>프로젝터</span>
            </div>
        </div>
    </div>

    <!-- 숙소 이용정보 -->
    <div class="info-section">
        <h2>숙소 이용정보</h2>
        <ul class="usage-info-list">
            <li>
                <span class="usage-info-label">체크인 시간</span>
                <span class="usage-info-value">예약 시작 시간부터</span>
            </li>
            <li>
                <span class="usage-info-label">체크아웃 시간</span>
                <span class="usage-info-value">예약 종료 시간까지</span>
            </li>
            <li>
                <span class="usage-info-label">연령 제한</span>
                <span class="usage-info-value">만 18세 이상</span>
            </li>
            <li>
                <span class="usage-info-label">반려동물</span>
                <span class="usage-info-value">불가</span>
            </li>
            <li>
                <span class="usage-info-label">흡연</span>
                <span class="usage-info-value">금지</span>
            </li>
            <li>
                <span class="usage-info-label">취소 규정</span>
                <span class="usage-info-value">예약일 기준 24시간 전까지 취소 가능</span>
            </li>
        </ul>
    </div>

    <!-- 위치 정보 -->
    <div class="map-section">
        <h2>위치 정보</h2>
        <div class="map-container">
            <div id="officeMap"></div>
        </div>
        <div class="map-address">
            <strong>주소:</strong> ${office.address}
        </div>
    </div>

    <!-- 리뷰 섹션 -->
    <div class="reviews-section">
        <h2>리뷰</h2>
        <div class="reviews-summary">
            <span class="rating-score" id="reviewsSummaryRating">4.5</span>
            <span class="review-count" id="reviewsSummaryCount">리뷰 0개</span>
        </div>
        <div id="officeReviewsList" class="reviews-list">
            <div style="text-align: center; padding: 40px; color: var(--gray-500);">리뷰를 불러오는 중...</div>
        </div>
    </div>
</main>

<!-- 룸 상세 모달 -->
<div id="roomModal" class="room-modal-overlay" onclick="closeRoomModal(event)">
    <div class="room-modal" onclick="event.stopPropagation()">
        <div class="room-modal-header">
            <h2 id="roomModalTitle">룸 상세 정보</h2>
            <button class="room-modal-close" onclick="closeRoomModal()">
                <i class="ph ph-x"></i>
            </button>
        </div>
        <div class="room-modal-content">
            <div id="roomModalImages" class="room-modal-images"></div>
            <div id="roomModalInfo" class="room-modal-info"></div>
            <div id="roomModalReviews" class="room-modal-reviews">
                <h3>리뷰</h3>
                <div id="roomModalReviewsList"></div>
            </div>
        </div>
    </div>
</div>

<script>
    const officeId = ${office != null ? office.id : 0};
    const officeAddress = "${office != null ? office.address : ''}";
    let officeMap = null;
    let officeMarker = null;

    // 메인 이미지 변경
    function changeMainImage(src) {
        document.getElementById('mainImage').src = src;
    }

    // 지도 초기화 (나중에 Google Maps API 추가 시 사용)
    function initMap() {
        try {
            if (typeof google === 'undefined' || typeof google.maps === 'undefined') {
                console.warn('Google Maps API가 로드되지 않았습니다. 나중에 추가 예정입니다.');
                // 지도 컨테이너에 주소 표시
                const mapContainer = document.getElementById('officeMap');
                if (mapContainer) {
                    mapContainer.innerHTML = '<div style="display: flex; align-items: center; justify-content: center; height: 100%; color: var(--gray-600); font-size: 16px;">' + officeAddress + '</div>';
                }
                return;
            }
            
            const geocoder = new google.maps.Geocoder();
            const mapOptions = {
                zoom: 15,
                center: { lat: 37.5665, lng: 126.9780 }
            };
            officeMap = new google.maps.Map(document.getElementById('officeMap'), mapOptions);

            geocoder.geocode({ address: officeAddress }, function(results, status) {
                if (status === 'OK' && results[0]) {
                    const location = results[0].geometry.location;
                    officeMap.setCenter(location);
                    officeMarker = new google.maps.Marker({
                        map: officeMap,
                        position: location,
                        title: "${office.name}"
                    });

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
                    // 지도 컨테이너에 주소 표시
                    const mapContainer = document.getElementById('officeMap');
                    if (mapContainer) {
                        mapContainer.innerHTML = '<div style="display: flex; align-items: center; justify-content: center; height: 100%; color: var(--gray-600); font-size: 16px;">' + officeAddress + '</div>';
                    }
                }
            });
        } catch (error) {
            console.error('지도 초기화 실패:', error);
            // 지도 컨테이너에 주소 표시
            const mapContainer = document.getElementById('officeMap');
            if (mapContainer) {
                mapContainer.innerHTML = '<div style="display: flex; align-items: center; justify-content: center; height: 100%; color: var(--gray-600); font-size: 16px;">' + officeAddress + '</div>';
            }
        }
    }

    // 페이지 로드 시 지도 초기화 시도 (Google Maps API가 로드된 경우에만)
    if (typeof google !== 'undefined' && typeof google.maps !== 'undefined') {
        window.initMap = initMap;
    } else {
        // Google Maps API가 없으면 직접 호출 (지도 컨테이너에 주소만 표시)
        document.addEventListener('DOMContentLoaded', function() {
            setTimeout(function() {
                initMap();
            }, 100);
        });
    }

    // 예상 가격 계산
    function calculateOfficePrice() {
        const rooms = document.querySelectorAll('.room-card');
        let minPrice = Infinity;
        let maxPrice = 0;

        rooms.forEach(room => {
            const priceText = room.querySelector('.room-card-price')?.textContent;
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

    // 예약하기 버튼
    function goToReservation(event, roomId) {
        event.stopPropagation();
        
        fetch('<%=context%>/api/auth/validate', {
            method: 'GET',
            credentials: 'include'
        })
        .then(response => {
            if (!response.ok) throw new Error('Unauthorized');
            return response.json();
        })
        .then(data => {
            if (data.valid === true) {
                window.location.href = '<%=context%>/reservations/add/' + roomId;
            } else {
                throw new Error('Invalid token');
            }
        })
        .catch(error => {
            alert('로그인이 필요합니다');
            window.location.href = '<%=context%>/auth/login?error=' + encodeURIComponent('로그인이 필요합니다');
        });
    }

    // 객실 즐겨찾기 토글
    function toggleRoomFavorite(event, roomId) {
        event.stopPropagation();
        const btn = event.currentTarget;
        const icon = btn.querySelector('i');

        fetch('<%=context%>/api/auth/validate', {
            method: 'GET',
            credentials: 'include'
        })
        .then(response => {
            if (!response.ok) throw new Error('Unauthorized');
            return response.json();
        })
        .then(data => {
            if (data.valid !== true) throw new Error('Invalid token');
            return fetch('<%=context%>/api/favorites/rooms/' + roomId, {
                method: 'POST',
                credentials: 'include',
                headers: { 'Content-Type': 'application/json' }
            });
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                if (data.isFavorite) {
                    btn.classList.add('active');
                    if (icon) icon.className = 'ph ph-heart-fill';
                } else {
                    btn.classList.remove('active');
                    if (icon) icon.className = 'ph ph-heart';
                }
            }
        })
        .catch(error => {
            alert('로그인이 필요합니다');
            window.location.href = '<%=context%>/auth/login?error=' + encodeURIComponent('로그인이 필요합니다');
        });
    }

    // 지점 즐겨찾기 토글
    function toggleOfficeFavorite(event) {
        event.stopPropagation();
        const btn = event.currentTarget;
        const icon = btn.querySelector('i');
        const isActive = btn.classList.contains('active');

        const token = localStorage.getItem('token');
        if (!token) {
            alert('로그인이 필요합니다');
            window.location.href = '<%=context%>/auth/login?error=' + encodeURIComponent('로그인이 필요합니다');
            return;
        }

        if (isActive) {
            btn.classList.remove('active');
            icon.className = 'ph ph-heart';
        } else {
            btn.classList.add('active');
            icon.className = 'ph ph-heart-fill';
        }
    }

    // 룸 모달 표시
    async function showRoomModal(roomId) {
        const modal = document.getElementById('roomModal');
        const modalTitle = document.getElementById('roomModalTitle');
        const modalImages = document.getElementById('roomModalImages');
        const modalInfo = document.getElementById('roomModalInfo');
        const modalReviews = document.getElementById('roomModalReviewsList');

        modal.classList.add('active');

        try {
            const roomRes = await fetch('<%=context%>/api/rooms/' + roomId, {
                credentials: 'include'
            });
            if (!roomRes.ok) throw new Error('룸 정보를 불러올 수 없습니다.');
            const room = await roomRes.json();

            const imagesRes = await fetch('<%=context%>/api/rooms/' + roomId + '/images', {
                credentials: 'include'
            });
            let images = [];
            if (imagesRes.ok) {
                images = await imagesRes.json();
            }

            modalTitle.textContent = room.name || '룸 상세 정보';

            if (images.length > 0) {
                modalImages.innerHTML = images.map(img => 
                    `<img src="<%=context%>${img.filePath != null && img.filePath != '' ? img.filePath : '/img/no_image.jpg'}" alt="${room.name}" class="room-modal-image" onerror="this.onerror=null; this.src='<%=context%>/img/no_image.jpg';">`
                ).join('');
            } else {
                modalImages.innerHTML = `<img src="<%=context%>/img/no_image.jpg" alt="이미지 없음" class="room-modal-image" onerror="this.onerror=null; this.src='<%=context%>/img/no_image.jpg';">`;
            }

            modalInfo.innerHTML = `
                <div class="room-modal-info-item">
                    <strong>정원:</strong>
                    <span>기준 ${room.capacity}명 / 최대 ${room.capacity}명</span>
                </div>
                <div class="room-modal-info-item">
                    <strong>최소 예약:</strong>
                    <span>${room.minReservationHours}시간</span>
                </div>
                <div class="room-modal-info-item">
                    <strong>가격:</strong>
                    <span>${room.priceBase ? room.priceBase.toLocaleString() + '원' : '문의'}</span>
                </div>
            `;

            try {
                const reviewsUrl = '<%=context%>/api/reviews/rooms/' + roomId + '?page=1&limit=10';
                console.log('모달 리뷰 API 호출 URL:', reviewsUrl);
                
                const reviewsRes = await fetch(reviewsUrl, {
                    credentials: 'include'
                });
                
                console.log('모달 리뷰 API 응답 상태:', reviewsRes.status, reviewsRes.statusText);
                
                if (reviewsRes.ok) {
                    const reviewsData = await reviewsRes.json();
                    const reviews = reviewsData.data || [];
                    
                    // 디버깅: 모달 리뷰 데이터 확인
                    console.log('=== 모달 리뷰 데이터 디버깅 (roomId: ' + roomId + ') ===');
                    console.log('응답 데이터:', reviewsData);
                    console.log('리뷰 개수:', reviews.length);
                    if (reviews.length > 0) {
                        console.log('첫 번째 리뷰 원본:', JSON.stringify(reviews[0], null, 2));
                        console.log('첫 번째 리뷰 content:', reviews[0].content, 'type:', typeof reviews[0].content, 'isFalse?', reviews[0].content === false, 'isFalseString?', reviews[0].content === 'false');
                        console.log('첫 번째 리뷰 userName:', reviews[0].userName, 'type:', typeof reviews[0].userName, 'isFalse?', reviews[0].userName === false, 'isFalseString?', reviews[0].userName === 'false');
                    }
                    console.log('==========================================');
                    
                    if (reviews.length > 0) {
                        modalReviews.innerHTML = reviews.map(review => {
                            // content 처리: false, null, undefined, 빈 문자열, 'false' 문자열 모두 처리
                            let content = '내용이 없습니다.';
                            if (review.content !== null && review.content !== undefined && review.content !== false && review.content !== 'false') {
                                const contentStr = String(review.content).trim();
                                if (contentStr !== '' && contentStr !== 'false') {
                                    content = contentStr;
                                }
                            }
                            
                            // userName 처리: false, null, undefined, 빈 문자열, 'false' 문자열 모두 처리
                            let userName = '익명';
                            if (review.userName !== null && review.userName !== undefined && review.userName !== false && review.userName !== 'false') {
                                const userNameStr = String(review.userName).trim();
                                if (userNameStr !== '' && userNameStr !== 'false') {
                                    userName = userNameStr;
                                }
                            }
                            
                            const rating = review.rating || 0;
                            const createdAt = review.createdAt || '';
                            
                            return `
                                <div class="review-item">
                                    <div class="review-header">
                                        <span class="review-user">${userName}</span>
                                        <span class="review-rating">⭐ ${rating}</span>
                                    </div>
                                    <div class="review-content">${content}</div>
                                    <div class="review-date">${createdAt}</div>
                                </div>
                            `;
                        }).join('');
                    } else {
                        modalReviews.innerHTML = '<div style="text-align: center; padding: 20px; color: var(--gray-500);">등록된 리뷰가 없습니다.</div>';
                    }
                } else {
                    const errorText = await reviewsRes.text();
                    console.error('모달 리뷰 API 에러 응답:', reviewsRes.status, errorText);
                    modalReviews.innerHTML = '<div style="text-align: center; padding: 20px; color: var(--gray-500);">리뷰를 불러올 수 없습니다. (상태: ' + reviewsRes.status + ')</div>';
                }
            } catch (error) {
                console.error('리뷰 로드 실패:', error);
                modalReviews.innerHTML = '<div style="text-align: center; padding: 20px; color: var(--gray-500);">리뷰를 불러올 수 없습니다.</div>';
            }
        } catch (error) {
            console.error('룸 정보 로드 실패:', error);
            alert('룸 정보를 불러올 수 없습니다.');
        }
    }

    // 룸 모달 닫기
    function closeRoomModal(event) {
        if (event && event.target.classList.contains('room-modal-overlay')) {
            document.getElementById('roomModal').classList.remove('active');
        } else if (!event) {
            document.getElementById('roomModal').classList.remove('active');
        }
    }

    // 지점의 모든 룸 리뷰 로드
    async function loadOfficeReviews() {
        const reviewsList = document.getElementById('officeReviewsList');
        if (!reviewsList) {
            console.error('officeReviewsList 요소를 찾을 수 없습니다.');
            return;
        }

        // room-card에서 data-room-id 추출
        const roomCards = document.querySelectorAll('.room-card');
        console.log('=== 리뷰 로드 시작 ===');
        console.log('찾은 room-card 개수:', roomCards.length);
        
        const roomIds = [];
        roomCards.forEach((card, index) => {
            const roomId = card.getAttribute('data-room-id');
            console.log('room-card[' + index + '] data-room-id:', roomId);
            if (roomId) {
                roomIds.push(roomId);
            }
        });

        console.log('추출된 roomIds:', roomIds);

        if (roomIds.length === 0) {
            console.warn('roomId가 없습니다. room-card 요소를 확인하세요.');
            reviewsList.innerHTML = '<div style="text-align: center; padding: 40px; color: var(--gray-500);">등록된 룸이 없습니다.</div>';
            return;
        }

        try {
            const allReviews = [];
            console.log('=== 리뷰 수집 시작 ===');
            console.log('처리할 roomIds:', roomIds);
            
            for (const roomId of roomIds) {
                try {
                    const url = '<%=context%>/api/reviews/rooms/' + roomId + '?page=1&limit=100';
                    console.log('리뷰 API 호출 URL:', url);
                    
                    const res = await fetch(url, {
                        credentials: 'include'
                    });
                    
                    console.log('리뷰 API 응답 상태 (roomId: ' + roomId + '):', res.status, res.statusText);
                    
                    if (res.ok) {
                        const data = await res.json();
                        const reviews = data.data || [];
                        
                        // 디버깅: 리뷰 데이터 확인
                        console.log('=== 리뷰 데이터 디버깅 (roomId: ' + roomId + ') ===');
                        console.log('응답 데이터:', data);
                        console.log('리뷰 개수:', reviews.length);
                        if (reviews.length > 0) {
                            console.log('첫 번째 리뷰:', reviews[0]);
                            console.log('첫 번째 리뷰 content:', reviews[0].content, 'type:', typeof reviews[0].content);
                            console.log('첫 번째 리뷰 userName:', reviews[0].userName, 'type:', typeof reviews[0].userName);
                        }
                        console.log('==========================================');
                        
                        // 각 리뷰에 roomId 추가 (roomId를 문자열에서 숫자로 변환)
                        const roomIdNum = parseInt(roomId);
                        reviews.forEach(review => {
                            // review 객체가 유효한지 확인
                            if (review && typeof review === 'object') {
                                // roomId가 없으면 추가
                                if (!review.roomId) {
                                    review.roomId = roomIdNum;
                                }
                                // 새 객체로 복사하여 추가 (원본 변조 방지)
                                allReviews.push({
                                    id: review.id,
                                    userId: review.userId,
                                    roomId: review.roomId || roomIdNum,
                                    rating: review.rating,
                                    content: review.content,
                                    userName: review.userName,
                                    imgUrl: review.imgUrl,
                                    createdAt: review.createdAt
                                });
                            }
                        });
                        
                        console.log('현재까지 수집된 리뷰 개수:', allReviews.length);
                    } else {
                        // 응답이 ok가 아닌 경우
                        const errorText = await res.text();
                        console.error('리뷰 API 에러 응답 (roomId: ' + roomId + '):', res.status, errorText);
                    }
                } catch (error) {
                    console.error('룸 리뷰 로드 실패 (roomId: ' + roomId + '):', error);
                    console.error('에러 스택:', error.stack);
                }
            }
            
            console.log('=== 리뷰 수집 완료 ===');
            console.log('최종 수집된 리뷰 개수:', allReviews.length);

            const roomMap = new Map();
            for (const roomId of roomIds) {
                try {
                    const res = await fetch('<%=context%>/api/rooms/' + roomId, {
                        credentials: 'include'
                    });
                    if (res.ok) {
                        const room = await res.json();
                        // roomId를 숫자로 변환하여 키로 사용 (일관성 유지)
                        const roomIdNum = parseInt(roomId, 10);
                        if (!isNaN(roomIdNum)) {
                            // 숫자 키로 저장
                            roomMap.set(roomIdNum, room);
                            // 문자열 키로도 저장 (혹시 모를 경우를 대비)
                            roomMap.set(String(roomIdNum), room);
                            console.log('룸 정보 로드 성공:', roomIdNum, room.name, 'room.id:', room.id);
                        }
                    }
                } catch (error) {
                    console.error('룸 정보 로드 실패:', roomId, error);
                }
            }
            
            console.log('roomMap 크기:', roomMap.size);
            console.log('roomMap 키:', Array.from(roomMap.keys()));

            if (allReviews.length > 0) {
                allReviews.sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt));
                
                // 평점 계산
                const avgRating = (allReviews.reduce((sum, r) => sum + r.rating, 0) / allReviews.length).toFixed(1);
                document.getElementById('officeRating').textContent = avgRating + '점';
                document.getElementById('officeReviewCount').textContent = '리뷰 ' + allReviews.length + '개';
                document.getElementById('reviewsSummaryRating').textContent = avgRating;
                document.getElementById('reviewsSummaryCount').textContent = '리뷰 ' + allReviews.length + '개';
                
                // 디버깅: 최종 리뷰 데이터 확인
                console.log('=== 최종 리뷰 데이터 (allReviews) ===');
                console.log('전체 리뷰 개수:', allReviews.length);
                if (allReviews.length > 0) {
                    console.log('첫 번째 리뷰 원본:', JSON.stringify(allReviews[0], null, 2));
                    console.log('첫 번째 리뷰 content:', allReviews[0].content, 'type:', typeof allReviews[0].content, 'isFalse?', allReviews[0].content === false);
                    console.log('첫 번째 리뷰 userName:', allReviews[0].userName, 'type:', typeof allReviews[0].userName, 'isFalse?', allReviews[0].userName === false);
                }
                console.log('====================================');
                
                // 리뷰 렌더링
                console.log('리뷰 렌더링 시작, allReviews.length:', allReviews.length);
                
                // 디버깅: roomMap 확인
                console.log('=== roomMap 디버깅 ===');
                console.log('roomMap 크기:', roomMap.size);
                console.log('roomMap 키:', Array.from(roomMap.keys()));
                console.log('roomMap 값:', Array.from(roomMap.values()).map(r => ({ id: r.id, name: r.name })));
                console.log('====================');
                
                reviewsList.innerHTML = allReviews.slice(0, 20).map((review, index) => {
                    // 디버깅: review 객체 확인 (템플릿 리터럴 대신 문자열 연결 사용 - JSP EL 충돌 방지)
                    console.log('리뷰[' + index + '] 원본 객체:', review);
                    const reviewRoomIdType = typeof review.roomId;
                    console.log('리뷰[' + index + '] review.roomId:', review.roomId, 'type:', reviewRoomIdType);
                    const reviewContentType = typeof review.content;
                    console.log('리뷰[' + index + '] review.content:', review.content, 'type:', reviewContentType);
                    const reviewUserNameType = typeof review.userName;
                    console.log('리뷰[' + index + '] review.userName:', review.userName, 'type:', reviewUserNameType);
                    
                    // roomId를 숫자로 변환하여 일관성 유지
                    let roomIdNum = null;
                    if (review.roomId !== null && review.roomId !== undefined) {
                        roomIdNum = typeof review.roomId === 'string' ? parseInt(review.roomId, 10) : Number(review.roomId);
                        if (isNaN(roomIdNum)) {
                            roomIdNum = null;
                        }
                    }
                    
                    // roomMap에서 조회 (여러 타입으로 시도)
                    let room = null;
                    if (roomIdNum !== null) {
                        room = roomMap.get(roomIdNum) || roomMap.get(String(roomIdNum)) || roomMap.get(Number(roomIdNum));
                    }
                    
                    const roomName = room ? room.name : '알 수 없음';
                    
                    // typeof를 변수로 저장 (JSP EL 표현식 충돌 방지)
                    const roomIdNumType = typeof roomIdNum;
                    console.log('리뷰[' + index + '] - roomIdNum: ' + roomIdNum + ' (type: ' + roomIdNumType + '), room:', room, 'roomName:', roomName);
                    
                    // content 처리: false, null, undefined, 빈 문자열, 'false' 문자열 모두 처리
                    let content = '내용이 없습니다.';
                    if (review.content !== null && review.content !== undefined && review.content !== false && review.content !== 'false') {
                        const contentStr = String(review.content).trim();
                        if (contentStr !== '' && contentStr !== 'false') {
                            content = contentStr;
                        }
                    }
                    
                    // userName 처리: false, null, undefined, 빈 문자열, 'false' 문자열 모두 처리
                    let userName = '익명';
                    if (review.userName !== null && review.userName !== undefined && review.userName !== false && review.userName !== 'false') {
                        const userNameStr = String(review.userName).trim();
                        if (userNameStr !== '' && userNameStr !== 'false') {
                            userName = userNameStr;
                        }
                    }
                    
                    const rating = review.rating || 0;
                    const createdAt = review.createdAt || '';
                    
                    console.log('리뷰[' + index + '] - content: "' + content + '", userName: "' + userName + '", rating: ' + rating);
                    
                    // 이미지 처리 (여러 이미지 지원)
                    let imgHtml = '';
                    if (review.imgUrl && review.imgUrl.trim() !== '' && review.imgUrl !== 'false') {
                        // 콤마로 구분된 이미지 경로들을 분리
                        const imgPaths = review.imgUrl.split(',').map(function(path) {
                            return path.trim();
                        }).filter(function(path) {
                            return path !== '' && path !== 'false';
                        });
                        
                        if (imgPaths.length > 0) {
                            imgHtml = '<div class="review-card-images" style="display:flex; flex-wrap:wrap; gap:8px; margin:12px 0;">';
                            for (var i = 0; i < imgPaths.length; i++) {
                                var imgPath = imgPaths[i];
                                // 경로가 /로 시작하면 context 추가, 아니면 그대로 사용
                                if (imgPath.startsWith('/')) {
                                    imgPath = '<%=context%>' + imgPath;
                                }
                                imgHtml += '<img src="' + imgPath + '" alt="리뷰 이미지 ' + (i + 1) + '" style="max-width:150px; max-height:150px; border-radius:8px; object-fit:cover; cursor:pointer; border:1px solid var(--gray-300);" onerror="this.style.display=\'none\';" onclick="window.open(this.src, \'_blank\');">';
                            }
                            imgHtml += '</div>';
                        }
                    }
                    
                    // HTML 생성 (템플릿 리터럴 대신 문자열 연결 사용 - JSP EL 충돌 방지)
                    return '<div class="review-card">' +
                        '<div class="review-card-header">' +
                        '<span class="review-card-room">' + roomName + '</span>' +
                        '<span class="review-card-rating">⭐ ' + rating + '</span>' +
                        '</div>' +
                        '<div class="review-card-content">' + content + '</div>' +
                        imgHtml +
                        '<div class="review-card-footer">' +
                        '<span>' + userName + '</span>' +
                        '<span>' + createdAt + '</span>' +
                        '</div>' +
                        '</div>';
                }).join('');
                
                console.log('리뷰 HTML 생성 완료, 길이:', reviewsList.innerHTML.length);
            } else {
                document.getElementById('officeRating').textContent = '0.0점';
                document.getElementById('officeReviewCount').textContent = '리뷰 0개';
                document.getElementById('reviewsSummaryRating').textContent = '0.0';
                document.getElementById('reviewsSummaryCount').textContent = '리뷰 0개';
                reviewsList.innerHTML = '<div style="text-align: center; padding: 40px; color: var(--gray-500);">등록된 리뷰가 없습니다.</div>';
            }
        } catch (error) {
            console.error('리뷰 로드 실패:', error);
            reviewsList.innerHTML = '<div style="text-align: center; padding: 40px; color: var(--gray-500);">리뷰를 불러올 수 없습니다.</div>';
        }
    }

    // 페이지 로드 시
    document.addEventListener('DOMContentLoaded', function() {
        console.log('=== 페이지 로드 시작 ===');
        
        try {
            calculateOfficePrice();
            console.log('가격 계산 완료');
        } catch (error) {
            console.error('가격 계산 실패:', error);
        }
        
        try {
            loadOfficeReviews();
            console.log('리뷰 로드 시작');
        } catch (error) {
            console.error('리뷰 로드 실패:', error);
        }
        
        try {
            fetch('<%=context%>/api/auth/validate', {
                method: 'GET',
                credentials: 'include'
            })
            .then(response => {
                console.log('인증 확인 응답:', response.status, response.statusText);
                return response.json();
            })
            .then(data => {
                console.log('인증 확인 데이터:', data);
                if (data.valid === true) {
                    const favoriteButtons = document.querySelectorAll('.room-card-favorite');
                    console.log('즐겨찾기 버튼 개수:', favoriteButtons.length);
                    favoriteButtons.forEach(btn => {
                        const roomId = btn.getAttribute('data-room-id');
                        if (roomId) {
                            fetch('<%=context%>/api/favorites/rooms/' + roomId, {
                                method: 'GET',
                                credentials: 'include'
                            })
                            .then(res => {
                                if (res.ok) return res.json();
                                throw new Error('Failed to check favorite');
                            })
                            .then(favData => {
                                if (favData.isFavorite) {
                                    btn.classList.add('active');
                                    const icon = btn.querySelector('i');
                                    if (icon) icon.className = 'ph ph-heart-fill';
                                } else {
                                    btn.classList.remove('active');
                                    const icon = btn.querySelector('i');
                                    if (icon) icon.className = 'ph ph-heart';
                                }
                            })
                            .catch((err) => {
                                console.error('즐겨찾기 확인 실패 (roomId: ' + roomId + '):', err);
                            });
                        }
                    });
                }
            })
            .catch((error) => {
                console.error('인증 확인 실패:', error);
            });
        } catch (error) {
            console.error('인증 확인 초기화 실패:', error);
        }
        
        console.log('=== 페이지 로드 완료 ===');
    });
    
    // 전역 에러 핸들러
    window.addEventListener('error', function(event) {
        console.error('전역 에러 발생:', event.error);
        console.error('에러 메시지:', event.message);
        console.error('에러 파일:', event.filename);
        console.error('에러 라인:', event.lineno);
    });
    
    // Promise rejection 핸들러
    window.addEventListener('unhandledrejection', function(event) {
        console.error('처리되지 않은 Promise rejection:', event.reason);
    });
</script>

<%@ include file="/WEB-INF/views/components/footer.jsp" %>
