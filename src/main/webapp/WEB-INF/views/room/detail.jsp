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
    <title>${room.name} | Space Core</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link href='https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.css' rel='stylesheet'/>
    <style>
        .room-detail-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 40px 20px;
        }

        /* 상단 헤더 */
        .room-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid var(--cream-tan);
        }

        .room-title-section {
            flex: 1;
        }

        .room-title {
            font-size: 32px;
            font-weight: 700;
            color: var(--choco);
            margin-bottom: 8px;
        }

        .room-subtitle {
            font-size: 18px;
            color: var(--gray-600);
            margin-bottom: 12px;
        }

        .room-rating {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 8px;
        }

        .star-rating {
            color: #FFB800;
            font-size: 20px;
        }

        .rating-text {
            font-size: 16px;
            font-weight: 600;
            color: var(--text-primary);
        }

        .review-count {
            font-size: 14px;
            color: var(--gray-600);
        }

        .room-price-section {
            text-align: right;
        }

        .price-label {
            font-size: 14px;
            color: var(--gray-600);
            margin-bottom: 4px;
        }

        .price-value {
            font-size: 28px;
            font-weight: 700;
            color: var(--amber);
        }

        /* 이미지 슬라이더 */
        .image-slider-container {
            margin-bottom: 40px;
        }

        .main-image-wrapper {
            position: relative;
            width: 100%;
            height: 500px;
            background: var(--gray-200);
            border-radius: var(--radius-lg);
            overflow: hidden;
            margin-bottom: 12px;
        }

        .main-image {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .no-image {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 100%;
            height: 100%;
            background: var(--gray-200);
            color: var(--gray-500);
            font-size: 18px;
        }

        .slider-controls {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            background: rgba(255, 255, 255, 0.9);
            border: none;
            width: 48px;
            height: 48px;
            border-radius: 50%;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            color: var(--choco);
            transition: var(--transition);
            z-index: 10;
        }

        .slider-controls:hover {
            background: var(--white);
            box-shadow: var(--shadow-md);
        }

        .slider-prev {
            left: 16px;
        }

        .slider-next {
            right: 16px;
        }

        .thumbnail-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 8px;
        }

        .thumbnail-item {
            position: relative;
            width: 100%;
            aspect-ratio: 1;
            background: var(--gray-200);
            border-radius: var(--radius-md);
            overflow: hidden;
            cursor: pointer;
            border: 2px solid transparent;
            transition: var(--transition);
        }

        .thumbnail-item.active {
            border-color: var(--amber);
        }

        .thumbnail-item img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .thumbnail-no-image {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 100%;
            height: 100%;
            background: var(--gray-200);
            color: var(--gray-400);
            font-size: 12px;
        }

        /* 2컬럼 레이아웃 */
        .room-content-grid {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 40px;
            margin-bottom: 60px;
        }

        /* 지도 섹션 */
        .map-section {
            margin: 60px 0;
            background: var(--white);
            border-radius: var(--radius-lg);
            padding: 30px;
            box-shadow: var(--shadow-sm);
        }

        .map-title {
            font-size: 24px;
            font-weight: 700;
            color: var(--choco);
            margin-bottom: 20px;
        }

        .map-container {
            width: 100%;
            height: 400px;
            border-radius: var(--radius-md);
            overflow: hidden;
            background: var(--gray-200);
            margin-bottom: 20px;
        }

        .map-info {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 16px;
            background: var(--gray-100);
            border-radius: var(--radius-md);
        }

        .map-address {
            font-size: 16px;
            color: var(--text-primary);
        }

        .map-phone {
            font-size: 14px;
            color: var(--gray-600);
        }

        /* 리뷰 섹션 */
        .review-section {
            margin: 60px 0;
            background: var(--white);
            border-radius: var(--radius-lg);
            padding: 30px;
            box-shadow: var(--shadow-sm);
        }

        .review-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid var(--cream-tan);
        }

        .review-title {
            font-size: 24px;
            font-weight: 700;
            color: var(--choco);
        }

        .review-list {
            display: flex;
            flex-direction: column;
            gap: 24px;
        }

        .review-item {
            padding: 20px;
            background: var(--gray-100);
            border-radius: var(--radius-md);
        }

        .review-user-info {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 12px;
        }

        .review-user-name {
            font-weight: 600;
            color: var(--text-primary);
        }

        .review-date {
            font-size: 14px;
            color: var(--gray-600);
        }

        .review-rating {
            color: #FFB800;
            font-size: 16px;
        }

        .review-content {
            color: var(--text-primary);
            line-height: 1.6;
            margin-top: 12px;
        }

        .review-images {
            display: flex;
            gap: 8px;
            margin-top: 12px;
        }

        .review-image {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: var(--radius-md);
            cursor: pointer;
        }

        /* 즐겨찾기 버튼 */
        .favorite-btn {
            font-size: 24px;
            border: none;
            background: none;
            cursor: pointer;
            transition: var(--transition);
            color: var(--gray-400);
            padding: 4px;
        }

        .favorite-btn.active {
            color: #e63946;
        }

        .favorite-btn:hover {
            transform: scale(1.1);
        }

        /* 관리자 섹션 */
        .admin-section {
            margin-top: 40px;
            padding: 30px;
            background: var(--gray-100);
            border-radius: var(--radius-lg);
        }

        /* 반응형 */
        @media (max-width: 1024px) {
            .room-content-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
<%@ include file="/WEB-INF/views/components/header.jsp" %>

<div class="room-detail-container">
    <!-- 상단 헤더 -->
    <div class="room-header">
        <div class="room-title-section">
            <h1 class="room-title">${room.name}</h1>
            <div class="room-subtitle">
                <c:forEach var="office" items="${officeList}">
                    <c:if test="${office.id == room.officeId}">
                        ${office.name}
                    </c:if>
                </c:forEach>
            </div>
            <div class="room-rating">
                <c:if test="${not empty reviewSummary && reviewSummary.avgRating != null}">
                    <span class="star-rating">
                        <c:forEach begin="1" end="5" var="i">
                            <c:choose>
                                <c:when test="${i <= reviewSummary.avgRating}">★</c:when>
                                <c:otherwise>☆</c:otherwise>
                            </c:choose>
                        </c:forEach>
                    </span>
                    <span class="rating-text"><fmt:formatNumber value="${reviewSummary.avgRating}" pattern="#.#"/>점</span>
                    <span class="review-count">(${reviewSummary.totalCount != null ? reviewSummary.totalCount : 0}개 리뷰)</span>
                </c:if>
                <c:if test="${empty reviewSummary || reviewSummary.avgRating == null}">
                    <span class="star-rating">☆☆☆☆☆</span>
                    <span class="rating-text">-</span>
                    <span class="review-count">(0개 리뷰)</span>
                </c:if>
                <button class="favorite-btn" data-room-id="${room.id}" data-office-id="${room.officeId}">♡</button>
            </div>
        </div>
        <div class="room-price-section">
            <div class="price-label">기본 요금</div>
            <div class="price-value"><fmt:formatNumber value="${room.priceBase}" type="number"/>원</div>
        </div>
    </div>

    <!-- 2컬럼 레이아웃 -->
    <div class="room-content-grid">
        <!-- 왼쪽: 이미지 슬라이더 + 상세 정보 -->
        <div>
            <!-- 이미지 슬라이더 -->
            <div class="image-slider-container">
                <div class="main-image-wrapper">
                    <c:choose>
                        <c:when test="${not empty roomImages && roomImages.size() > 0}">
                            <img id="mainImage" class="main-image" src="${roomImages[0].filePath != null ? roomImages[0].filePath : '/img/no-image.png'}" alt="룸 이미지">
                            <c:if test="${roomImages.size() > 1}">
                                <button class="slider-controls slider-prev" onclick="changeImage(-1)">‹</button>
                                <button class="slider-controls slider-next" onclick="changeImage(1)">›</button>
                            </c:if>
                        </c:when>
                        <c:otherwise>
                            <div class="no-image">No Image</div>
                        </c:otherwise>
                    </c:choose>
                </div>
                <c:if test="${not empty roomImages && roomImages.size() > 1}">
                    <div class="thumbnail-grid">
                        <c:forEach var="image" items="${roomImages}" varStatus="status">
                            <div class="thumbnail-item ${status.index == 0 ? 'active' : ''}" onclick="showImage(${status.index})">
                                <c:choose>
                                    <c:when test="${not empty image.filePath}">
                                        <img src="${image.filePath}" alt="썸네일 ${status.index + 1}">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="thumbnail-no-image">No Image</div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </c:forEach>
                    </div>
                </c:if>
            </div>

            <!-- 객실 정보 섹션 -->
            <div class="room-info-section" style="margin-top: 30px; background: var(--white); padding: 30px; border-radius: var(--radius-lg); box-shadow: var(--shadow-sm);">
                <h3 style="color: var(--choco); font-size: 20px; font-weight: 700; margin-bottom: 20px; padding-bottom: 12px; border-bottom: 2px solid var(--cream-tan);">객실 정보</h3>
                <div class="room-basic-info" style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 16px;">
                    <div class="info-item">
                        <span style="font-weight: 600; color: var(--gray-700);">룸명</span>
                        <span style="margin-left: 12px; color: var(--text-primary);">${room.name}</span>
                    </div>
                    <div class="info-item">
                        <span style="font-weight: 600; color: var(--gray-700);">정원</span>
                        <span style="margin-left: 12px; color: var(--text-primary);">기준 ${room.capacity}명 / 최대 ${room.capacity}명</span>
                    </div>
                    <div class="info-item">
                        <span style="font-weight: 600; color: var(--gray-700);">기본 요금</span>
                        <span style="margin-left: 12px; color: var(--text-primary);"><fmt:formatNumber value="${room.priceBase}" type="number"/>원/시간</span>
                    </div>
                    <div class="info-item">
                        <span style="font-weight: 600; color: var(--gray-700);">최소 예약 시간</span>
                        <span style="margin-left: 12px; color: var(--text-primary);">${room.minReservationHours != null ? room.minReservationHours : 1}시간</span>
                    </div>
                </div>
            </div>

            <!-- 추가정보 섹션 -->
            <div class="room-additional-info" style="margin-top: 30px; background: var(--white); padding: 30px; border-radius: var(--radius-lg); box-shadow: var(--shadow-sm);">
                <h3 style="color: var(--choco); font-size: 20px; font-weight: 700; margin-bottom: 20px; padding-bottom: 12px; border-bottom: 2px solid var(--cream-tan);">추가정보</h3>
                <c:if test="${not empty room.description}">
                    <div style="margin-bottom: 20px;">
                        <h4 style="color: var(--choco); font-size: 16px; font-weight: 600; margin-bottom: 10px;">공간소개</h4>
                        <p style="color: var(--text-primary); line-height: 1.8; white-space: pre-wrap;">${room.description}</p>
                    </div>
                </c:if>
                <c:if test="${not empty room.facilityInfo}">
                    <div style="margin-bottom: 20px;">
                        <h4 style="color: var(--choco); font-size: 16px; font-weight: 600; margin-bottom: 10px;">시설안내</h4>
                        <p style="color: var(--text-primary); line-height: 1.8; white-space: pre-wrap;">${room.facilityInfo}</p>
                    </div>
                </c:if>
                <c:if test="${not empty room.precautions}">
                    <div style="margin-bottom: 20px;">
                        <h4 style="color: var(--choco); font-size: 16px; font-weight: 600; margin-bottom: 10px;">유의사항</h4>
                        <p style="color: var(--text-primary); line-height: 1.8; white-space: pre-wrap;">${room.precautions}</p>
                    </div>
                </c:if>
                <c:if test="${empty room.description && empty room.facilityInfo && empty room.precautions}">
                    <p style="color: var(--gray-600);">등록된 추가정보가 없습니다.</p>
                </c:if>
            </div>

            <!-- 취소 및 환불 규정 섹션 -->
            <div class="room-cancellation-policy" style="margin-top: 30px; background: var(--white); padding: 30px; border-radius: var(--radius-lg); box-shadow: var(--shadow-sm);">
                <h3 style="color: var(--choco); font-size: 20px; font-weight: 700; margin-bottom: 20px; padding-bottom: 12px; border-bottom: 2px solid var(--cream-tan);">취소 및 환불 규정</h3>
                <div style="color: var(--text-primary); line-height: 1.8;">
                    <div style="margin-bottom: 16px;">
                        <h4 style="color: var(--choco); font-size: 16px; font-weight: 600; margin-bottom: 8px;">취소 규정</h4>
                        <ul style="margin-left: 20px; padding-left: 0;">
                            <li style="margin-bottom: 8px;">예약일 기준 7일 전 취소: 전액 환불</li>
                            <li style="margin-bottom: 8px;">예약일 기준 3일 전 취소: 50% 환불</li>
                            <li style="margin-bottom: 8px;">예약일 기준 1일 전 취소: 30% 환불</li>
                            <li style="margin-bottom: 8px;">예약일 당일 취소: 환불 불가</li>
                        </ul>
                    </div>
                    <div style="margin-bottom: 16px;">
                        <h4 style="color: var(--choco); font-size: 16px; font-weight: 600; margin-bottom: 8px;">환불 규정</h4>
                        <ul style="margin-left: 20px; padding-left: 0;">
                            <li style="margin-bottom: 8px;">환불은 취소 신청 후 영업일 기준 3~5일 내 처리됩니다.</li>
                            <li style="margin-bottom: 8px;">결제 수단에 따라 환불 소요 기간이 다를 수 있습니다.</li>
                            <li style="margin-bottom: 8px;">부분 환불의 경우, 이용한 시간에 대한 요금이 차감됩니다.</li>
                        </ul>
                    </div>
                    <div style="margin-top: 20px; padding: 16px; background: var(--gray-100); border-radius: var(--radius-md);">
                        <p style="color: var(--gray-700); font-size: 14px; margin: 0;">
                            <strong>문의사항:</strong> 취소 및 환불 관련 문의는 고객센터로 연락주시기 바랍니다.
                        </p>
                    </div>
                </div>
            </div>

            <!-- 관리자 전용: 시간대 차단 -->
            <sec:authorize access="hasRole('ADMIN')">
                <div class="admin-section">
                    <h3 style="color: var(--choco); margin-bottom: 20px;">시간대 차단 관리</h3>
                    <div id="calendar"></div>
                    <div id="adminSelectedTimeInfo" style="margin: 10px 0; color: var(--gray-600);"></div>
                    <div class="time-slots" style="display: flex; flex-wrap: wrap; gap: 5px; margin: 10px 0;">
                        <c:forEach var="hour" begin="9" end="21">
                            <div class="admin-time-slot" data-hour="${hour}"
                                 style="padding: 8px 15px; border: 1px solid var(--gray-300); border-radius: 4px; cursor: pointer; background: var(--white);">
                                ${hour}:00
                            </div>
                        </c:forEach>
                    </div>
                    <div id="blockedSlotsContainer" style="margin-top:8px;">
                        <c:if test="${not empty blockedSlots}">
                            <table style="width: 100%; border-collapse: collapse; margin-top:8px;">
                                <tr style="background: var(--cream-tan);">
                                    <th style="padding: 8px; text-align: left;">시작</th>
                                    <th style="padding: 8px; text-align: left;">종료</th>
                                    <th style="padding: 8px; text-align: left;">해제</th>
                                </tr>
                                <c:forEach var="s" items="${blockedSlots}">
                                    <tr style="border-bottom: 1px solid var(--gray-300);">
                                        <td style="padding: 8px;"><c:out value="${s.slotStart}"/></td>
                                        <td style="padding: 8px;"><c:out value="${s.slotEnd}"/></td>
                                        <td style="padding: 8px;">
                                            <form action="/offices/${room.officeId}/rooms/unblock-all/${room.id}" method="post" style="display:inline;">
                                                <input type="hidden" name="startAt" value="<c:out value='${s.slotStart}'/>">
                                                <input type="hidden" name="endAt" value="<c:out value='${s.slotEnd}'/>">
                                                <input type="hidden" name="date" value="${targetDateStr}">
                                                <button type="submit" style="background: var(--amber); color: white; border: none; padding: 5px 10px; border-radius: 4px; cursor: pointer;">
                                                    해제
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </table>
                        </c:if>
                        <c:if test="${empty blockedSlots}">
                            <div style="margin-top:8px; color: var(--gray-600);">선택일에 차단된 시간이 없습니다.</div>
                        </c:if>
                    </div>
                    <form id="blockForm" action="/offices/${room.officeId}/rooms/block/${room.id}" method="post" style="margin-top: 10px;">
                        <input type="hidden" name="date" value="${targetDateStr}">
                        <input type="hidden" name="startHour" id="adminStartHour">
                        <input type="hidden" name="endHour" id="adminEndHour">
                        <button type="submit" style="background: var(--amber); color: white; margin-right: 10px; padding: 8px 15px; border: none; border-radius: 4px; cursor: pointer;">
                            차단
                        </button>
                        <button type="submit" formaction="/offices/${room.officeId}/rooms/unblock-all/${room.id}"
                                style="background: var(--mocha); color: white; padding: 8px 15px; border: none; border-radius: 4px; cursor: pointer;">
                            당일 전체 차단 해제
                        </button>
                    </form>
                </div>
            </sec:authorize>

            <!-- 수정/목록 링크 -->
            <p style="margin-top: 20px;">
                <sec:authorize access="hasRole('ADMIN')">
                    <a href="/offices/${room.officeId}/rooms/edit/${room.id}" style="color: var(--amber);">[수정]</a> |
                </sec:authorize>
                <a href="/offices/${room.officeId}/rooms" style="color: var(--amber);">[목록]</a>
            </p>
        </div>

        <!-- 오른쪽: 예약 폼 -->
        <div>
            <%@ include file="../components/reservation-form.jsp" %>
        </div>
    </div>

    <!-- 지도 섹션 -->
    <c:if test="${not empty office}">
        <div class="map-section">
            <h2 class="map-title">위치</h2>
            <div class="map-container" id="map" style="width:100%;height:400px;"></div>
            <div class="map-info">
                <div>
                    <div class="map-address">${office.address != null ? office.address : '주소 정보 없음'}</div>
                </div>
            </div>
        </div>
    </c:if>

    <!-- 리뷰 섹션 -->
    <div class="review-section">
        <div class="review-header">
            <h2 class="review-title">리뷰</h2>
            <c:if test="${not empty reviewSummary && reviewSummary.totalCount != null && reviewSummary.totalCount > 0}">
                <div class="room-rating">
                    <span class="star-rating">
                        <c:forEach begin="1" end="5" var="i">
                            <c:choose>
                                <c:when test="${i <= reviewSummary.avgRating}">★</c:when>
                                <c:otherwise>☆</c:otherwise>
                            </c:choose>
                        </c:forEach>
                    </span>
                    <span class="rating-text"><fmt:formatNumber value="${reviewSummary.avgRating}" pattern="#.#"/>점</span>
                    <span class="review-count">(${reviewSummary.totalCount}개)</span>
                </div>
            </c:if>
        </div>
        <div id="reviewList" class="review-list">
            <!-- 리뷰는 JavaScript로 비동기 로드 -->
            <div style="text-align: center; padding: 40px; color: var(--gray-600);">리뷰를 불러오는 중...</div>
        </div>
    </div>
</div>

<!-- 전역변수 설정 -->
<script>
    window.ROOM_ID = ${room.id};
    window.MIN_HOURS = ${room.minReservationHours != null ? room.minReservationHours : 1};
    window.BASE_PRICE = ${room.priceBase != null ? room.priceBase : 0};
    window.BOOKED_SLOTS = [];
    
    // 이미지 슬라이더 변수
    <c:if test="${not empty roomImages}">
    window.ROOM_IMAGES = [
        <c:forEach var="image" items="${roomImages}" varStatus="status">
        {
            path: '${image.filePath != null ? image.filePath : "/img/no-image.png"}',
            id: ${image.id}
        }<c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ];
    </c:if>
    <c:if test="${empty roomImages}">
    window.ROOM_IMAGES = [];
    </c:if>
    
    let currentImageIndex = 0;
</script>

<!-- FullCalendar JS -->
<script src='https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.js'></script>
<script src='https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/locales/ko.js'></script>
<script src="/js/calendar.js"></script>
<script src="/js/time-selection.js"></script>

<!-- 이미지 슬라이더 스크립트 -->
<script>
    function showImage(index) {
        if (!window.ROOM_IMAGES || window.ROOM_IMAGES.length === 0) return;
        
        currentImageIndex = index;
        const mainImage = document.getElementById('mainImage');
        if (mainImage) {
            mainImage.src = window.ROOM_IMAGES[index].path;
        }
        
        // 썸네일 활성화 업데이트
        document.querySelectorAll('.thumbnail-item').forEach((item, i) => {
            if (i === index) {
                item.classList.add('active');
            } else {
                item.classList.remove('active');
            }
        });
    }
    
    function changeImage(direction) {
        if (!window.ROOM_IMAGES || window.ROOM_IMAGES.length === 0) return;
        
        currentImageIndex += direction;
        if (currentImageIndex < 0) {
            currentImageIndex = window.ROOM_IMAGES.length - 1;
        } else if (currentImageIndex >= window.ROOM_IMAGES.length) {
            currentImageIndex = 0;
        }
        showImage(currentImageIndex);
    }
</script>

<!-- 리뷰 비동기 로드 -->
<script>
    (function() {
        // contextPath를 JavaScript 변수로 설정
        const CONTEXT_PATH = '<%= context %>';
        
        async function loadReviews() {
            try {
                const response = await fetch('/api/reviews/rooms/' + window.ROOM_ID + '?page=1&limit=5');
                const data = await response.json();
                
                console.log('리뷰 API 응답:', data);
                console.log('응답 타입:', typeof data);
                console.log('data.data:', data.data);
                console.log('data.content:', data.content);
                console.log('data.pageInfo:', data.pageInfo);
                
                const reviewList = document.getElementById('reviewList');
                if (!reviewList) {
                    console.error('reviewList 요소를 찾을 수 없습니다');
                    return;
                }
                
                // PaginationDTO 구조: data.data에 실제 리뷰 배열이 있음
                // 하지만 혹시 다른 구조일 수도 있으므로 여러 경우를 확인
                let reviews = null;
                if (Array.isArray(data)) {
                    // 응답 자체가 배열인 경우
                    reviews = data;
                } else if (data && Array.isArray(data.data)) {
                    // PaginationDTO 구조
                    reviews = data.data;
                } else if (data && Array.isArray(data.content)) {
                    // Page 구조
                    reviews = data.content;
                } else if (data && data.reviews && Array.isArray(data.reviews)) {
                    // reviews 필드가 있는 경우
                    reviews = data.reviews;
                } else {
                    reviews = [];
                }
                
                console.log('파싱된 리뷰 배열:', reviews);
                console.log('리뷰 개수:', reviews ? reviews.length : 0);
                console.log('리뷰 배열 타입:', Array.isArray(reviews));
                
                if (!reviews || reviews.length === 0) {
                    console.log('리뷰가 없습니다. 빈 메시지 표시');
                    reviewList.innerHTML = '<div style="text-align: center; padding: 40px; color: var(--gray-600);">아직 리뷰가 없습니다.</div>';
                    return;
                }
                
                let html = '';
                reviews.forEach((review, index) => {
                    console.log(`리뷰 ${index} 전체 객체:`, review);
                    console.log(`리뷰 ${index} 키 목록:`, Object.keys(review));
                    console.log(`리뷰 ${index} userName:`, review.userName, typeof review.userName);
                    console.log(`리뷰 ${index} content:`, review.content, typeof review.content);
                    console.log(`리뷰 ${index} rating:`, review.rating, typeof review.rating);
                    console.log(`리뷰 ${index} createdAt:`, review.createdAt, typeof review.createdAt);
                    console.log(`리뷰 ${index} imgUrl:`, review.imgUrl, typeof review.imgUrl);
                    
                    // 필드명 확인 - 직접 review 객체에서 값을 가져오기
                    // || 연산자 대신 명시적으로 확인
                    let userName = '익명';
                    if (review.userName) {
                        userName = String(review.userName);
                    } else if (review.user_name) {
                        userName = String(review.user_name);
                    }
                    
                    let content = '';
                    if (review.content) {
                        content = String(review.content);
                    }
                    
                    let rating = 0;
                    if (review.rating !== undefined && review.rating !== null) {
                        rating = Number(review.rating);
                    }
                    
                    let createdAt = '';
                    if (review.createdAt) {
                        createdAt = String(review.createdAt);
                    } else if (review.created_at) {
                        createdAt = String(review.created_at);
                    }
                    
                    // 이미지 URL 처리 (콤마로 구분된 여러 이미지 지원)
                    let imgUrls = [];
                    if (review.imgUrl) {
                        const imgUrlStr = String(review.imgUrl).trim();
                        if (imgUrlStr && imgUrlStr !== 'null' && imgUrlStr !== 'undefined') {
                            // 콤마로 구분된 이미지들을 배열로 분리
                            imgUrls = imgUrlStr.split(',').map(url => url.trim()).filter(url => url && url.length > 0);
                        }
                    } else if (review.img_url) {
                        const imgUrlStr = String(review.img_url).trim();
                        if (imgUrlStr && imgUrlStr !== 'null' && imgUrlStr !== 'undefined') {
                            imgUrls = imgUrlStr.split(',').map(url => url.trim()).filter(url => url && url.length > 0);
                        }
                    }
                    
                    // createdAt이 문자열인 경우 처리
                    let dateStr = '';
                    if (createdAt) {
                        try {
                            // "2025-11-10 12:16:56" 형식의 문자열인 경우
                            if (typeof createdAt === 'string') {
                                const dateParts = createdAt.split(' ')[0].split('-');
                                if (dateParts.length === 3) {
                                    dateStr = dateParts[0] + '.' + 
                                             String(parseInt(dateParts[1])).padStart(2, '0') + '.' + 
                                             String(parseInt(dateParts[2])).padStart(2, '0');
                                } else {
                                    dateStr = createdAt;
                                }
                            } else {
                                const date = new Date(createdAt);
                                if (!isNaN(date.getTime())) {
                                    dateStr = date.getFullYear() + '.' + 
                                             String(date.getMonth() + 1).padStart(2, '0') + '.' + 
                                             String(date.getDate()).padStart(2, '0');
                                }
                            }
                        } catch (e) {
                            console.error('날짜 파싱 오류:', e, createdAt);
                            dateStr = createdAt || '';
                        }
                    }
                    
                    let stars = '';
                    const ratingNum = Number(rating) || 0;
                    for (let i = 1; i <= 5; i++) {
                        stars += i <= ratingNum ? '★' : '☆';
                    }
                    
                    // 이미지 HTML 생성 (여러 이미지 지원)
                    let imgHtml = '';
                    if (imgUrls && imgUrls.length > 0) {
                        imgHtml = '<div class="review-images">';
                        imgUrls.forEach(function(imgPath) {
                            // 이미지 경로에 contextPath 추가
                            let fullPath = imgPath;
                            if (imgPath) {
                                if (imgPath.startsWith('http://') || imgPath.startsWith('https://')) {
                                    // 이미 절대 URL인 경우 그대로 사용
                                    fullPath = imgPath;
                                } else if (imgPath.startsWith('/')) {
                                    // 절대 경로인 경우 contextPath 추가
                                    fullPath = CONTEXT_PATH + imgPath;
                                } else {
                                    // 상대 경로인 경우 contextPath와 / 추가
                                    fullPath = CONTEXT_PATH + '/' + imgPath;
                                }
                            }
                            imgHtml += '<img src="' + fullPath + '" class="review-image" alt="리뷰 이미지" onclick="window.open(this.src, \'_blank\')" style="cursor: pointer; max-width: 200px; max-height: 200px; margin: 5px; border-radius: 8px;">';
                        });
                        imgHtml += '</div>';
                    }
                    
                    // HTML 생성
                    html += '<div class="review-item">';
                    html += '<div class="review-user-info">';
                    html += '<span class="review-user-name">' + (userName || '익명') + '</span>';
                    html += '<span class="review-date">' + dateStr + '</span>';
                    html += '<span class="review-rating">' + stars + '</span>';
                    html += '</div>';
                    html += '<div class="review-content">' + (content || '') + '</div>';
                    if (imgHtml) {
                        html += imgHtml;
                    }
                    html += '</div>';
                });
                
                console.log('생성된 HTML:', html);
                reviewList.innerHTML = html;
            } catch (error) {
                console.error('리뷰 로드 실패:', error);
                const reviewList = document.getElementById('reviewList');
                if (reviewList) {
                    reviewList.innerHTML = '<div style="text-align: center; padding: 40px; color: var(--gray-600);">리뷰를 불러올 수 없습니다.</div>';
                }
            }
        }
        
        document.addEventListener('DOMContentLoaded', loadReviews);
    })();
</script>

<!-- 네이버 지도 -->
<c:if test="${not empty office && office.latitude != null && office.longitude != null}">
<script type="text/javascript" src="https://oapi.map.naver.com/openapi/v3/maps.js?ncpKeyId=${naverMapClientId}"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const mapDiv = document.getElementById('map');
        if (mapDiv) {
            try {
                const map = new naver.maps.Map('map', {
                    center: new naver.maps.LatLng(${office.latitude}, ${office.longitude}),
                    zoom: 15
                });
                
                const marker = new naver.maps.Marker({
                    position: new naver.maps.LatLng(${office.latitude}, ${office.longitude}),
                    map: map
                });
            } catch (e) {
                console.error('지도 로드 실패:', e);
                mapDiv.innerHTML = '<div style="display: flex; align-items: center; justify-content: center; height: 100%; color: var(--gray-600);">지도를 불러올 수 없습니다.</div>';
            }
        }
    });
</script>
</c:if>
<c:if test="${empty office || office.latitude == null || office.longitude == null}">
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const mapDiv = document.getElementById('map');
        if (mapDiv) {
            mapDiv.innerHTML = '<div style="display: flex; align-items: center; justify-content: center; height: 100%; color: var(--gray-600);">위치 정보가 없습니다.</div>';
        }
    });
</script>
</c:if>

<!-- 관리자 차단용 스크립트 -->
<script>
    (function () {
        'use strict';
        const adminSection = document.querySelector('.admin-section');
        if (!adminSection) return;

        let startHour = null;
        const startInput = document.getElementById('adminStartHour');
        const endInput = document.getElementById('adminEndHour');
        const form = document.getElementById('blockForm');

        <c:if test="${not empty targetDate}">
        var d = '${targetDateStr}';
        var el = document.getElementById('adminSelectedTimeInfo');
        if (el) {
            var dt = new Date(d);
            el.textContent = (dt.getMonth() + 1) + '월 ' + dt.getDate() + '일';
        }
        </c:if>

        <c:if test="${not empty blockedSlots}">
        const blockedHours = [];
        <c:forEach var="slot" items="${blockedSlots}">
        <c:set var="startHour" value="${slot.slotStart.hour}"/>
        <c:set var="endHour" value="${slot.slotEnd.hour}"/>
        <c:forEach var="h" begin="${startHour}" end="${endHour - 1}">
        blockedHours.push(${h});
        </c:forEach>
        </c:forEach>

        if (adminSection && blockedHours.length > 0) {
            blockedHours.forEach(function(hour) {
                const slotEl = adminSection.querySelector('[data-hour="' + hour + '"]');
                if (slotEl) {
                    slotEl.style.background = 'var(--gray-400)';
                    slotEl.style.color = 'white';
                    slotEl.style.cursor = 'not-allowed';
                    slotEl.style.opacity = '0.7';
                }
            });
        }
        </c:if>

        adminSection.querySelectorAll('.admin-time-slot').forEach(function (slot) {
            slot.onclick = function () {
                if (this.style.background === 'var(--gray-400)' || this.style.cursor === 'not-allowed') {
                    return;
                }
                const clickedHour = parseInt(this.dataset.hour);

                if (startHour === null) {
                    startHour = clickedHour;
                    adminSection.querySelectorAll('.admin-time-slot').forEach(s => {
                        if (s !== this && s.style.background !== 'var(--gray-400)') {
                            s.style.background = 'var(--white)';
                        }
                    });
                    this.style.background = 'var(--amber)';
                    this.style.color = 'white';
                    const adminTimeInfo = document.getElementById('adminSelectedTimeInfo');
                    if (adminTimeInfo) {
                        const hourStr = String(clickedHour).padStart(2, '0');
                        adminTimeInfo.textContent = hourStr + ':00 선택됨 (종료 시간을 선택하세요)';
                    }
                } else {
                    const minHour = Math.min(startHour, clickedHour);
                    const maxHour = Math.max(startHour, clickedHour);
                    if (startInput) startInput.value = minHour;
                    if (endInput) endInput.value = maxHour + 1;
                    adminSection.querySelectorAll('.admin-time-slot').forEach(function(s) {
                        if (s.style.background !== 'var(--gray-400)') {
                            s.style.background = 'var(--white)';
                            s.style.color = '';
                        }
                    });
                    for (let h = minHour; h <= maxHour; h++) {
                        const slotEl = adminSection.querySelector('[data-hour="' + h + '"]');
                        if (slotEl && slotEl.style.background !== 'var(--gray-400)') {
                            slotEl.style.background = 'var(--amber)';
                            slotEl.style.color = 'white';
                        }
                    }
                    const adminTimeInfo = document.getElementById('adminSelectedTimeInfo');
                    if (adminTimeInfo) {
                        const hours = maxHour - minHour + 1;
                        const minHourStr = String(minHour).padStart(2, '0');
                        const endHourStr = String(maxHour + 1).padStart(2, '0');
                        adminTimeInfo.textContent = minHourStr + ':00 ~ ' + endHourStr + ':00 (' + hours + '시간)';
                    }
                    startHour = null;
                }
            };
        });

        if (form) {
            form.onsubmit = function (e) {
                const submitter = e.submitter;
                if (!submitter.getAttribute('formaction') && (!startInput.value || !endInput.value)) {
                    alert('시간을 선택해주세요.');
                    e.preventDefault();
                    return;
                }
                const currentDate = new URLSearchParams(window.location.search).get('date') ||
                    new Date().toISOString().split('T')[0];
                const dateInput = form.querySelector('input[name="date"]');
                if (dateInput) {
                    dateInput.value = currentDate;
                }
            };
        }
    })();
</script>

<!-- 즐겨찾기 스크립트 -->
<script>
    document.addEventListener('DOMContentLoaded', async () => {
        const btn = document.querySelector('.favorite-btn');
        if (!btn) return;
        
        const roomId = btn.dataset.roomId;
        const officeId = btn.dataset.officeId;

        try {
            const res = await fetch('/api/favorites/check?roomId=' + roomId);
            const data = await res.json();
            if (data.favorite) {
                btn.textContent = '♥';
                btn.classList.add('active');
            }
        } catch (e) {}

        btn.addEventListener('click', async () => {
            const params = new URLSearchParams({ roomId, officeId });
            const res = await fetch('/api/favorites/toggle', {
                method: 'POST',
                headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                body: params
            });

            if (res.ok) {
                const data = await res.json();
                if (data.favorite) {
                    btn.textContent = '♥';
                    btn.classList.add('active');
                } else {
                    btn.textContent = '♡';
                    btn.classList.remove('active');
                }
            }
        });
    });
</script>

<%@ include file="/WEB-INF/views/components/footer.jsp" %>
</body>
</html>
