document.addEventListener("DOMContentLoaded", () => {
    const base = document.body.dataset.context || "";
    const urlParams = new URLSearchParams(window.location.search);
    const roomId = urlParams.get("roomId") || "1";
    let currentPage = parseInt(urlParams.get("page") || "1");
    const limit = 5;

    // ===============================
    // 리뷰 요약
    // ===============================
    const loadReviewSummary = async () => {
        try {
            const res = await fetch(`${base}/api/reviews/rooms/${roomId}/summary`);
            const data = await res.json();
            const el = document.getElementById("reviewSummary");

            if (!data || data.totalCount === 0) {
                el.textContent = "아직 등록된 리뷰가 없습니다.";
            } else {
                el.innerHTML = `⭐ 평균 <strong>${data.avgRating?.toFixed(1) ?? "0.0"}</strong>점 (총 <strong>${data.totalCount}</strong>개의 리뷰)`;
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

        const keyword = document.getElementById("keyword")?.value.trim() || "";
        const userName = document.getElementById("userName")?.value.trim() || "";
        const rating = document.getElementById("rating")?.value || "";

        let url = `${base}/api/reviews/rooms/${roomId}?page=${page}&limit=${limit}`;
        if (keyword) url += `&keyword=${encodeURIComponent(keyword)}`;
        if (userName) url += `&userName=${encodeURIComponent(userName)}`;
        if (rating) url += `&rating=${rating}`;

        const area = document.getElementById("reviewList");
        const pagination = document.getElementById("pagination");

        try {
            const res = await fetch(url);

            // 200 이외 응답 처리
            if (!res.ok) {
                console.warn("서버 응답 코드:", res.status);
                area.innerHTML = `<p class="text-center" style="color:var(--gray-600);">검색 결과를 찾을 수 없습니다.</p>`;
                pagination.innerHTML = "";
                return;
            }

            let result = {};
            try {
                result = await res.json();
            } catch (e) {
                console.warn("JSON 파싱 실패:", e);
                area.innerHTML = `<p class="text-center" style="color:var(--gray-600);">검색 결과를 찾을 수 없습니다.</p>`;
                pagination.innerHTML = "";
                return;
            }

            // 안전한 구조 접근
            const data = Array.isArray(result.data) ? result.data : [];
            const pageInfo = result.pageInfo || {};
            const isSearchActive = keyword || userName || rating;

            area.innerHTML = "";

            // 검색 결과 없음 처리
            if (data.length === 0) {
                const msg = isSearchActive
                    ? "검색 결과를 찾을 수 없습니다."
                    : "등록된 리뷰가 없습니다.";
                area.innerHTML = `<p class="text-center" style="color:var(--gray-600);">${msg}</p>`;
                pagination.innerHTML = "";
                return;
            }

            // 정상 리스트 렌더링
            data.forEach(r => {
                const user = r.userName?.trim() || "작성자 없음";
                const content = r.content?.trim() || "내용이 없습니다.";
                const hasImage = r.imgUrl && r.imgUrl.trim() !== "";

                area.innerHTML += `
<div class="review-item rounded shadow"
    style="padding:20px; border:1px solid var(--gray-300); background:var(--white); cursor:pointer;"
    onclick="location.href='${base}/reviews/${r.id}'">
    <div class="flex-row" style="justify-content:space-between;">
        <strong style="color:var(--choco);">${user}</strong>
        <span style="color:var(--amber);">${r.rating ? "⭐".repeat(r.rating) : "⭐ 없음"}</span>
    </div>
    <p style="margin:10px 0; color:var(--text-primary); white-space:pre-line;">${content}</p>
    <p style="font-size:14px; color:${hasImage ? 'var(--gray-600)' : 'var(--gray-400)'}; text-align:right;">
        ${hasImage ? "📷 이미지 있음" : "이미지 없음"}
    </p>
    <p style="font-size:13px; color:var(--gray-600); margin-top:8px;">${r.createdAt || ""}</p>
</div>`;
            });

            renderPagination(pageInfo.totalPages || 1);

            if (pushState) {
                const newUrl = `${window.location.pathname}?roomId=${roomId}&page=${page}`;
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
        if (!el) return;
        el.innerHTML = "";
        if (totalPages <= 1) return;

        let html = '<ul class="pagination-list">';
        if (currentPage > 1) {
            html += `<li><a href="#" data-page="${currentPage - 1}">이전</a></li>`;
        }

        for (let i = 1; i <= totalPages; i++) {
            html += `<li class="${i === currentPage ? 'active' : ''}">
                        <a href="#" data-page="${i}">${i}</a></li>`;
        }

        if (currentPage < totalPages) {
            html += `<li><a href="#" data-page="${currentPage + 1}">다음</a></li>`;
        }
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
        document.querySelectorAll("#filterForm .input, #filterForm select").forEach(el => el.value = "");
        loadReviews(1);
    });

    window.addEventListener("popstate", e => {
        const page = e.state?.page || 1;
        loadReviews(page, false);
    });

    // 초기 로드
    loadReviewSummary();
    loadReviews(currentPage, false);
});
