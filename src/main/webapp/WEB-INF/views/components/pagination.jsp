<div class="pagination">
    <c:if test="${pageInfo.totalPages > 1}">
        <ul class="pagination-list">
            <c:forEach var="i" begin="1" end="${pageInfo.totalPages}">
                <li class="${i == pageInfo.currentPage ? 'active' : ''}">
                    <a href="?page=${i}&size=${pageInfo.size}">
                            ${i}
                    </a>
                </li>
            </c:forEach>
        </ul>
    </c:if>
</div>

<style>
    .pagination { text-align: center; margin-top: 30px; }
    .pagination-list { display: inline-flex; list-style: none; gap: 10px; padding: 0; }
    .pagination-list li a {
        display: block; padding: 8px 14px; border: 1px solid var(--gray-300);
        color: var(--text-primary); border-radius: 6px; text-decoration: none;
    }
    .pagination-list li.active a {
        background: var(--amber); color: #fff; border-color: var(--amber);
    }
    .pagination-list li a:hover {
        background: var(--gray-200);
    }
</style>
