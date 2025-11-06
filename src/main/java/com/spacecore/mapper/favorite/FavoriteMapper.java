package com.spacecore.mapper.favorite;

import com.spacecore.domain.favorite.Favorite;
import com.spacecore.dto.favorite.FavoriteRoomDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface FavoriteMapper {
    
    // 즐겨찾기 추가
    void insert(Favorite favorite);
    
    // 즐겨찾기 삭제
    void delete(@Param("userId") Long userId, @Param("roomId") Long roomId);
    
    // 즐겨찾기 조회 (사용자별)
    List<Favorite> findByUserId(@Param("userId") Long userId);
    
    // 즐겨찾기 조회 (특정 룸)
    Favorite findByUserIdAndRoomId(@Param("userId") Long userId, @Param("roomId") Long roomId);
    
    // 즐겨찾기 존재 여부 확인
    boolean existsByUserIdAndRoomId(@Param("userId") Long userId, @Param("roomId") Long roomId);
    
    // 즐겨찾기 목록 조회 (룸 정보 포함)
    List<FavoriteRoomDTO> findFavoriteRoomsByUserId(@Param("userId") Long userId);
}
