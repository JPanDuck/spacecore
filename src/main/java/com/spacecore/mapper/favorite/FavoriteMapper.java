package com.spacecore.mapper.favorite;

import com.spacecore.domain.favorite.Favorite;
import com.spacecore.dto.favorite.FavoriteDetailDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface FavoriteMapper {
    //즐겨찾기 추가
    int insertFavorite(Favorite favorite);

    //즐겨찾기 삭제
    int deleteFavorite(@Param("id") Long id, @Param("userId") Long userId);

    //특정 사용자의 룸 즐겨찾기 여부 확인
    Favorite selectFavoriteByRoom(@Param("userId") Long userId, @Param("roomId") Long roomId);

    //특정 사용자의 즐겨찾기 목록 조회 (지점 포함 - 지점별로 룸 목록 조회)
    List<FavoriteDetailDTO> selectFavoritesByUserId(Long userId);

    //특정 사용자의 오피스 즐겨찾기 여부 확인 (roomId가 null인 경우)
    Favorite selectFavoriteByOffice(@Param("userId") Long userId, @Param("officeId") Long officeId);

    //즐겨찾기 여부 확인
    boolean existsByUserAndRoom(@Param("userId") Long userId, @Param("roomId") Long roomId);
    
    //오피스 즐겨찾기 여부 확인
    boolean existsByUserAndOffice(@Param("userId") Long userId, @Param("officeId") Long officeId);
}