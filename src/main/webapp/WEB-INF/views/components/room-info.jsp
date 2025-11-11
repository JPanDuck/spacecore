<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- 공간 정보 탭 -->
<div style="margin-top: 30px; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
    <!-- 탭 메뉴 -->
    <div style="display: flex; border-bottom: 2px solid #e0e0e0; margin-bottom: 20px;">
        <button class="tab-btn active" onclick="showTab('intro')"
                style="padding: 12px 24px; background: #ffd700; border: none; border-bottom: 3px solid #ffd700; cursor: pointer; font-weight: bold; margin-right: 2px;">
            공간소개
        </button>
        <button class="tab-btn" onclick="showTab('facility')"
                style="padding: 12px 24px; background: #f5f5f5; border: none; border-bottom: 3px solid transparent; cursor: pointer; margin-right: 2px;">
            시설안내
        </button>
        <button class="tab-btn" onclick="showTab('precautions')"
                style="padding: 12px 24px; background: #f5f5f5; border: none; border-bottom: 3px solid transparent; cursor: pointer;">
            유의사항
        </button>
    </div>

    <!-- 탭 내용 -->
    <div id="tab-intro" class="tab-content" style="display: block;">
        <h3 style="color: #333; margin-bottom: 15px; border-bottom: 2px solid #ffd700; padding-bottom: 10px;">
            ${room.name}
        </h3>
        <div style="line-height: 1.8; color: #555; white-space: pre-line;">
            ${empty room.description ? '등록된 공간소개가 없습니다.' : room.description}
        </div>
    </div>

    <div id="tab-facility" class="tab-content" style="display: none;">
        <h3 style="color: #333; margin-bottom: 15px; border-bottom: 2px solid #ffd700; padding-bottom: 10px;">
            시설안내
        </h3>
        <div style="line-height: 1.8; color: #555; white-space: pre-line;">
            ${empty room.facilityInfo ? '등록된 시설안내가 없습니다.' : room.facilityInfo}
        </div>
    </div>

    <div id="tab-precautions" class="tab-content" style="display: none;">
        <h3 style="color: #333; margin-bottom: 15px; border-bottom: 2px solid #ffd700; padding-bottom: 10px;">
            유의사항
        </h3>
        <div style="line-height: 1.8; color: #555; white-space: pre-line;">
            ${empty room.precautions ? '등록된 유의사항이 없습니다.' : room.precautions}
        </div>
    </div>
</div>

<script>
    function showTab(tabName) {
        // 모든 탭 내용 숨기기
        document.querySelectorAll('.tab-content').forEach(content => {
            content.style.display = 'none';
        });

        // 모든 탭 버튼 비활성화
        document.querySelectorAll('.tab-btn').forEach(btn => {
            btn.style.background = '#f5f5f5';
            btn.style.borderBottom = '3px solid transparent';
            btn.style.fontWeight = 'normal';
        });

        // 선택된 탭 내용 보이기
        document.getElementById('tab-' + tabName).style.display = 'block';

        // 선택된 탭 버튼 활성화
        event.target.style.background = '#ffd700';
        event.target.style.borderBottom = '3px solid #ffd700';
        event.target.style.fontWeight = 'bold';
    }
</script>
