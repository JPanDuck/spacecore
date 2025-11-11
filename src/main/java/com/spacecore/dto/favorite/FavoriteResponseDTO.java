package com.spacecore.dto.favorite;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Favorite 액션 결과 처리용
 * - 사용자가 룸 상세페이지 등에서 즐겨찾기 버튼을 클릭했을 때, 처리결과 응답용
 * */

@Data
@NoArgsConstructor
@AllArgsConstructor
public class FavoriteResponseDTO {
    private boolean favorite;    //토글 후 최종 즐겨찾기 상태 (true: 추가됨, false: 제거됨)
    private String message;
}
