<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>지도 (Naver Map)</title>
    <style>
        /* 지도를 담을 div는 높이가 명시적으로 지정되어야 함 */
        #map {
            height: 600px; /* 지도 높이 설정 */
            width: 100%;
        }
        .label {
            background: white;
            border: 1px solid #ccc;
            border-radius: 4px;
            padding: 2px 6px;
            font-size: 12px;
            font-weight: bold;
            white-space: nowrap;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.2);
            position: absolute;
            cursor: pointer;
            /* 지점이름 위치 조정 */
            transform: translate(-50%, -54px);
            left: 50%;
        }
    </style>

    <!-- 네이버 지도 API 로드 -->
    <script type="text/javascript"
            src="https://oapi.map.naver.com/openapi/v3/maps.js?ncpKeyId=${clientId}">
    </script>
</head>
<body>
<h2>지점 위치</h2>
<hr>

<%-- Naver Map이 표시될 영역 --%>
<div id="map"></div>

<script>
    window.onload = function () {
        //서버에서 전달된 지점 목록
        var officeLocations = [
            <c:forEach var="office" items="${officeList}" varStatus="status">
            {
                id: ${office.id},
                name: '${office.name}',
                lat: ${office.latitude},
                lng: ${office.longitude}
            }${!status.last ? ',' : ''}
            </c:forEach>
        ];

        if (officeLocations.length === 0) return;

        //지도 객체 생성
        var map = new naver.maps.Map('map', {
            center: new naver.maps.LatLng(37.5665, 126.9780),
            zoom: 12
        });

        var bounds = new naver.maps.LatLngBounds();

        //마커 및 지점이름을 담을 배열
        var markers = [];
        var labels = [];

        //각 지점에 마커 생성
        officeLocations.forEach(function(office) {
            if (!office.lat || !office.lng) return;

            var position = new naver.maps.LatLng(office.lat, office.lng);

            //마커 생성 - 기본 마커
            var marker = new naver.maps.Marker({
                position: position,
                map: map
            });

            //이름 라벨
            var labelEl = document.createElement('div');
            labelEl.className = 'label';
            labelEl.textContent = office.name;
            labelEl.onclick = function () {
            };
            map.getPanes().floatPane.appendChild(labelEl);

            //마커 클릭 시 상세 페이지 이동
            naver.maps.Event.addListener(marker, 'click', function() {
            });

            markers.push({ marker: marker, position: position });
            labels.push({ el: labelEl, position: position });

            //bounds 확장
            bounds.extend(position);
        });

        //모든 마커가 보이도록 지도 영역 조정
        if (officeLocations.length > 1) {
            map.fitBounds(bounds);
        } else {
            map.setCenter(bounds.getCenter());
            map.setZoom(15);
        }

        //지도 이동/확대 후 라벨 위치 다시 계산 (초기 어긋남 방지)
        function updateLabelPositions() {
            labels.forEach(function(item) {
                var projection = map.getProjection();
                if (!projection) return;
                var pixel = projection.fromCoordToOffset(item.position);
                item.el.style.left = pixel.x + 'px';
                item.el.style.top = pixel.y + 'px';
            });
        }

        //지도 이벤트마다 라벨 위치 갱신
        naver.maps.Event.addListener(map, 'idle', updateLabelPositions);
        naver.maps.Event.addListener(map, 'zoom_changed', updateLabelPositions);
        naver.maps.Event.addListener(map, 'dragend', updateLabelPositions);

        //초기 렌더링 시 한 번 실행
        setTimeout(updateLabelPositions, 300);
    };
</script>

</body>
</html>
