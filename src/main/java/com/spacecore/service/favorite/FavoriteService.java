package com.spacecore.service.favorite;

import com.spacecore.domain.favorite.Favorite;
import com.spacecore.dto.favorite.FavoriteRoomDTO;

import java.util.List;

public interface FavoriteService {
    
    // 즐겨찾기 추가
    void addFavorite(Long userId, Long roomId);
    
    // 즐겨찾기 삭제
    void removeFavorite(Long userId, Long roomId);
    
    // 즐겨찾기 토글
    boolean toggleFavorite(Long userId, Long roomId);
    
    // 즐겨찾기 목록 조회 (룸 정보 포함)
    List<FavoriteRoomDTO> getFavoriteRooms(Long userId);
    
    // 즐겨찾기 여부 확인
    boolean isFavorite(Long userId, Long roomId);
}
