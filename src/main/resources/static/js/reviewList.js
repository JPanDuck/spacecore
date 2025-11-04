document.addEventListener("DOMContentLoaded", () => {
    const base = document.body.dataset.context || "";
    const urlParams = new URLSearchParams(window.location.search);
    // roomId가 없으면 null로 설정하여 모든 리뷰 조회
    const roomIdParam = urlParams.get("roomId");
    const roomId = roomIdParam && roomIdParam !== "" ? roomIdParam : null;
    let currentPage = parseInt(urlParams.get("page") || "1");
    const limit = 10;

    // ===============================
    // 리뷰 요약
    // ===============================
    const loadReviewSummary = async () => {
        try {
            // URL 파라미터에서 roomId를 다시 읽어옴
            const urlParams = new URLSearchParams(window.location.search);
            const currentRoomIdParam = urlParams.get("roomId");
            const currentRoomId = currentRoomIdParam && currentRoomIdParam !== "" ? currentRoomIdParam : null;
            
            // roomId가 있으면 해당 room의 요약, 없으면 전체 요약 조회
            const summaryUrl = currentRoomId 
                ? `${base}/api/reviews/rooms/${currentRoomId}/summary`
                : `${base}/api/reviews/summary`;
            const res = await fetch(summaryUrl);
            const data = await res.json();
            const el = document.getElementById("reviewSummary");

            if (!data || data.totalCount === 0) {
                el.textContent = "아직 등록된 리뷰가 없습니다.";
            } else {
                el.innerHTML = `⭐ 평균 <strong>${data.avgRating?.toFixed(1) ?? "0.0"}</strong>점 
                                (총 <strong>${data.totalCount}</strong>개의 리뷰)`;
            }
        } catch (err) {
            console.error("리뷰 요약 불러오기 실패:", err);
            document.getElementById("reviewSummary").textContent = "요약 정보를 불러오지 못했습니다.";
        }
    };

    // ===============================
    // 리뷰 리스트
    // ===============================
    const loadReviews = async (page = 1, pushState = true) => {
        currentPage = page;
        
        // URL 파라미터에서 roomId를 다시 읽어옴 (리다이렉트 후에도 최신 값 사용)
        const urlParams = new URLSearchParams(window.location.search);
        const currentRoomIdParam = urlParams.get("roomId");
        const currentRoomId = currentRoomIdParam && currentRoomIdParam !== "" ? currentRoomIdParam : null;
        
        // 디버깅: roomId 확인
        console.log("=== 리뷰 로드 ===");
        console.log("URL:", window.location.href);
        console.log("현재 roomId:", currentRoomId);
        console.log("페이지:", page);
        
        const keyword = document.getElementById("keyword")?.value.trim() || "";
        const userName = document.getElementById("userName")?.value.trim() || "";
        const rating = document.getElementById("rating")?.value || "";

        // roomId가 있으면 해당 room의 리뷰만, 없으면 모든 리뷰 조회
        let url;
        if (currentRoomId) {
            url = `${base}/api/reviews/rooms/${currentRoomId}?page=${page}&limit=${limit}`;
        } else {
            // roomId가 없을 때는 전체 리뷰 조회 API 사용
            url = `${base}/api/reviews?page=${page}&limit=${limit}`;
        }
        console.log("API URL:", url);
        if (keyword) url += `&keyword=${encodeURIComponent(keyword)}`;
        if (userName) url += `&userName=${encodeURIComponent(userName)}`;
        if (rating) url += `&rating=${rating}`;

        const area = document.getElementById("reviewList");
        const pagination = document.getElementById("pagination");

        try {
            const res = await fetch(url);
            if (!res.ok) throw new Error("서버 오류");

            const result = await res.json();
            const data = Array.isArray(result.data) ? result.data : [];
            const pageInfo = result.pageInfo || {};

            // 디버깅: API 응답 확인
            console.log("=== API 응답 상세 ===");
            console.log("전체 응답:", JSON.stringify(result, null, 2));
            console.log("리뷰 데이터 개수:", data.length);
            console.log("페이지 정보 객체:", pageInfo);
            console.log("pageInfo.totalCount:", pageInfo.totalCount);
            console.log("pageInfo.totalPages:", pageInfo.totalPages);
            console.log("pageInfo.currentPage:", pageInfo.currentPage);
            console.log("limit:", limit);
            console.log("요청 URL:", url);
            console.log("===================");

            area.innerHTML = "";

            if (data.length === 0) {
                area.innerHTML = `<p class="text-center" style="color:var(--gray-600);">등록된 리뷰가 없습니다.</p>`;
                pagination.innerHTML = "";
                return;
            }

            data.forEach(r => {
                const user = r.userName?.trim() || "작성자 없음";
                const content = r.content?.trim() || "내용이 없습니다.";
                // 제목: 내용의 앞부분 50자만 표시 (줄바꿈 제거)
                const title = content.replace(/\n/g, ' ').substring(0, 50) + (content.length > 50 ? '...' : '');
                const ratingStars = r.rating ? "⭐".repeat(r.rating) : "⭐ 없음";
                const createdAt = r.createdAt || "";
                const hasImages = r.imgUrl && r.imgUrl.trim() !== "";
                const reviewId = r.id;

                area.innerHTML += `
<a href="${base}/reviews/${reviewId}" style="text-decoration:none; color:inherit; display:block;">
    <div class="review-item rounded shadow" 
         style="padding:20px; border:1px solid var(--gray-300); background:var(--white); margin-bottom:20px;
                transition:all 0.3s ease; cursor:pointer;"
         onmouseover="this.style.borderColor='var(--choco)'; this.style.boxShadow='0 4px 8px rgba(0,0,0,0.1)';"
         onmouseout="this.style.borderColor='var(--gray-300)'; this.style.boxShadow='none';">
        <div class="flex-row" style="justify-content:space-between; align-items:center; margin-bottom:10px;">
            <div style="flex:1;">
                <div style="font-weight:600; color:var(--choco); font-size:16px; margin-bottom:5px;">${title}</div>
                <div style="font-size:13px; color:var(--gray-600);">${user} · ${createdAt}</div>
            </div>
            <div style="display:flex; align-items:center; gap:10px;">
                ${hasImages ? '<span style="color:var(--gray-600); font-size:14px;">📷</span>' : ''}
                <span style="color:var(--amber); font-size:18px;">${ratingStars}</span>
            </div>
        </div>
    </div>
</a>`;
            });

            // 페이지네이션 렌더링: totalPages가 0이거나 undefined인 경우 처리
            // totalPages가 없거나 0이면 totalCount를 기반으로 계산
            let totalPages = pageInfo.totalPages;
            if (!totalPages || totalPages === 0) {
                if (pageInfo.totalCount && pageInfo.totalCount > 0) {
                    totalPages = Math.ceil(pageInfo.totalCount / limit);
                } else {
                    totalPages = 1;
                }
            }
            console.log("총 페이지 수 (계산 후):", totalPages);
            console.log("pageInfo.totalCount:", pageInfo.totalCount);
            renderPagination(totalPages);

            if (pushState) {
                let newUrl = `${window.location.pathname}?page=${page}`;
                if (currentRoomId) {
                    newUrl += `&roomId=${currentRoomId}`;
                }
                history.pushState({ page }, "", newUrl);
            }
        } catch (err) {
            console.error("리뷰 로드 실패:", err);
            area.innerHTML = `<p class="text-center" style="color:red;">리뷰를 불러오는 중 오류가 발생했습니다.</p>`;
            pagination.innerHTML = "";
        }
    };

    // ===============================
    // 페이지네이션
    // ===============================
    const renderPagination = (totalPages) => {
        const el = document.getElementById("pagination");
        if (!el) {
            console.error("페이지네이션 요소를 찾을 수 없습니다. id='pagination' 요소가 있는지 확인하세요.");
            return;
        }
        el.innerHTML = "";
        
        // totalPages가 숫자가 아니거나 1 이하인 경우 처리
        const pages = Number(totalPages) || 0;
        if (pages <= 1) {
            console.log("페이지네이션 숨김: 총 페이지 수가 1 이하입니다. (totalPages:", pages, ")");
            return;
        }
        
        console.log("페이지네이션 렌더링:", pages, "페이지");

        let html = '<ul class="pagination-list">';
        if (currentPage > 1)
            html += `<li><a href="#" data-page="${currentPage - 1}">이전</a></li>`;

        for (let i = 1; i <= pages; i++) {
            html += `<li class="${i === currentPage ? 'active' : ''}">
                        <a href="#" data-page="${i}">${i}</a></li>`;
        }

        if (currentPage < pages)
            html += `<li><a href="#" data-page="${currentPage + 1}">다음</a></li>`;

        html += "</ul>";
        el.innerHTML = html;

        el.querySelectorAll("a[data-page]").forEach(a => {
            a.addEventListener("click", e => {
                e.preventDefault();
                const targetPage = parseInt(a.dataset.page);
                loadReviews(targetPage);
            });
        });
    };

    // ===============================
    // 이벤트
    // ===============================
    document.getElementById("searchBtn")?.addEventListener("click", () => loadReviews(1));
    document.getElementById("resetBtn")?.addEventListener("click", () => {
        document.querySelectorAll("#filterForm input, #filterForm select").forEach(el => el.value = "");
        loadReviews(1);
    });

    window.addEventListener("popstate", e => {
        const page = e.state?.page || 1;
        loadReviews(page, false);
    });

    // ===============================
    // 메시지 표시 (URL 파라미터에서)
    // ===============================
    const showMessage = () => {
        const urlParams = new URLSearchParams(window.location.search);
        const message = urlParams.get("message");
        const messageAlert = document.getElementById("messageAlert");
        
        // 서버 측에서 이미 메시지를 표시한 경우는 JavaScript에서 숨김
        // (서버 측 메시지가 있으면 JavaScript 메시지는 표시하지 않음)
        const serverMessage = document.querySelector('[style*="background-color: #fff3cd"]');
        if (serverMessage && serverMessage.textContent.includes("⚠️")) {
            // 서버 측 메시지가 있으면 JavaScript 메시지는 표시하지 않음
            return;
        }
        
        if (message && messageAlert) {
            try {
                const decodedMessage = decodeURIComponent(message);
                messageAlert.textContent = "⚠️ " + decodedMessage;
                messageAlert.style.display = "block";
                
                // 5초 후 자동 숨김
                setTimeout(() => {
                    messageAlert.style.display = "none";
                }, 5000);
            } catch (e) {
                console.error("메시지 디코딩 실패:", e);
            }
        }
    };

    // ✅ 초기 로드
    showMessage(); // 메시지 표시
    loadReviewSummary();
    loadReviews(currentPage, false);
});
