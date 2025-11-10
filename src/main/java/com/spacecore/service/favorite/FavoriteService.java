package com.spacecore.service.favorite;

import com.spacecore.dto.favorite.FavoriteDetailDTO;
import com.spacecore.dto.favorite.FavoriteResponseDTO;

import java.util.List;

public interface FavoriteService {
    //즐겨찾기 토글 (추가 또는 삭제)
    FavoriteResponseDTO toggleFavorite(Long userId, Long roomId, Long officeId);
    
    //오피스 즐겨찾기 토글 (roomId 없이 오피스만 즐겨찾기)
    FavoriteResponseDTO toggleOfficeFavorite(Long userId, Long officeId);

    //사용자별 즐겨찾기 목록 조회 (지점별 그룹화를 위해 FavoriteDetailDTO 사용)
    List<FavoriteDetailDTO> getFavoritesList(Long userId);

    //즐겨찾기 페이지 내에서 개별 삭제
    boolean removeFavorite(Long id, Long userID);

    //즐겨찾기 여부 확인
    boolean isFavorite(Long userId, Long roomId);
    
    //오피스 즐겨찾기 여부 확인
    boolean isOfficeFavorite(Long userId, Long officeId);
}