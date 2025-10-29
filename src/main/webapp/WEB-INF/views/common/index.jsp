<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Space Core® | 오피스의 편안함을 가장 먼저 느껴보세요.</title>

    <!-- CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <!-- 폰트 -->
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&family=Montserrat:wght@400;600&display=swap" rel="stylesheet">
</head>
<body>

<%@ include file="../components/header.jsp" %>

<main class="container-1980">

    <!-- ===== Hero Section ===== -->
    <section class="hero-card">
        <video autoplay muted loop playsinline>
            <source src="${pageContext.request.contextPath}/video/office.mp4" type="video/mp4"/>
        </video>
        <div class="overlay">
            <h2>당신의 업무 공간을<br>더 따뜻하고 효율적으로.</h2>
            <p>감각적인 디자인과 여유로운 공간감.<br>지금 바로 당신만의 오피스를 예약해보세요.</p>
            <button class="btn btn-brown">예약 바로가기</button>
        </div>
    </section>

    <!-- ===== Section 1 : 예약 / 지점 탐색 / 오피스 / 미정 ===== -->
    <section class="section mt-80 text-center">
        <br>
        <h2 class="section-title">당신의 공간을 선택하세요</h2>
        <div class="grid-4 mt-40">
            <div class="card-image scroll-fade">
                <img src="${pageContext.request.contextPath}/img/reserve.png" alt="예약">
                <h3>예약</h3>
                <p>간편한 온라인 예약 시스템으로<br>원하는 시간에 공간을 확보하세요.</p>
            </div>
            <div class="card-image scroll-fade">
                <img src="${pageContext.request.contextPath}/img/location.png" alt="지점 탐색">
                <h3>지점 탐색</h3>
                <p>지도 기반으로 가까운 오피스를 찾아보세요.<br>편리한 위치 선택이 가능합니다.</p>
            </div>
            <div class="card-image scroll-fade">
                <img src="${pageContext.request.contextPath}/img/interior.png" alt="오피스">
                <h3>오피스</h3>
                <p>다양한 테마의 공간, 각기 다른 분위기.<br>당신의 일상에 어울리는 오피스를 선택하세요.</p>
            </div>
            <div class="card-image scroll-fade">
                <img src="${pageContext.request.contextPath}/img/Clean.png" alt="미정">
                <h3>개발중 (Coming Soon)</h3>
                <p>새로운 서비스가 준비 중입니다. 곧 만나보실 수 있습니다.</p>
            </div>
        </div>
    </section>

    <!-- ===== Section 2 : 인테리어 / 시스템 / 휴식 ===== -->
    <section class="section mt-80 text-center">
        <br>
        <h2 class="section-title">공간의 품격, 디테일에서 완성됩니다</h2>
        <div class="grid-3 mt-40">

            <div class="card-image scroll-fade">
                <video autoplay muted loop playsinline>
                    <source src="${pageContext.request.contextPath}/video/interior.mp4" type="video/mp4"/>
                    </video>
                <h3>편안한 인테리어</h3>
                <p>따뜻한 색감과 부드러운 조명. 집보다 편안한 오피스 환경을 제공합니다.</p>
            </div>
            <div class="card-image scroll-fade">
                <video autoplay muted loop playsinline>
                    <source src="${pageContext.request.contextPath}/video/system.mp4" type="video/mp4"/>
                </video>
                <h3>쾌적한 시스템</h3>
                <p>자동 공조 및 환기 시스템을 갖춘 최적의 업무 공간을 경험하세요.</p>
            </div>
            <div class="card-image scroll-fade">
                <video autoplay muted loop playsinline>
                    <source src="${pageContext.request.contextPath}/video/rest.mp4" type="video/mp4"/>
                </video>
                <h3>따뜻한 휴식공간</h3>
                <p>잠시 쉬어가는 곳. 언제나 당신을 기다립니다.</p>
            </div>
        </div>
    </section>

    <!-- ===== Section 3 : 특별한 온라인 서비스 ===== -->
    <section class="section mt-80 text-center">
        <br>
        <h2 class="section-title">특별한 온라인 서비스</h2>
        <div class="grid-3 mt-40">
            <div class="card-image">
                <img src="${pageContext.request.contextPath}/img/remote.jpg" alt="원격 설정">
                <h3>원격 설정</h3>
                <p>당신의 계정을 통해 어디서든 공간을 관리하세요.</p>
            </div>
            <div class="card-image">
                <img src="${pageContext.request.contextPath}/img/print.jpg" alt="프린트 서비스">
                <h3>프린트 서비스</h3>
                <p>모든 지점에서 인쇄 가능. 비즈니스 효율성을 극대화합니다.</p>
            </div>
            <div class="card-image">
                <img src="${pageContext.request.contextPath}/img/register.jpg" alt="사전 등록">
                <h3>사전 등록</h3>
                <p>방문 전에 손쉽게 등록 완료. 더 빠른 체크인 경험을 제공합니다.</p>
            </div>
        </div>
    </section>

</main>
<script>
    document.addEventListener("DOMContentLoaded", () => {
        const elements = document.querySelectorAll('.scroll-fade');

        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    // 스크롤 진입 시 활성화
                    entry.target.classList.add('active');
                } else {
                    // 뷰포트에서 벗어나면 비활성화
                    entry.target.classList.remove('active');
                }
            });
        }, { threshold: 0.1 });

        elements.forEach(el => observer.observe(el));
    });
</script>
<%@ include file="../components/footer.jsp" %>

</body>
</html>
