package com.spacecore.mapper.room;

import com.spacecore.domain.room.RoomImage;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface RoomImageMapper {

    /// 상세페이지용 전체 이미지
    List<RoomImage> findImagesByRoomId(@Param("roomId") Long roomId);

    /// 목록 썸네일 1장 경로(필요 시 서비스에서 직접 호출 가능)
    String findThumbnailPathByRoomId(@Param("roomId") Long roomId);

    /// 대표 사진 교체
    int unsetPrimaryByRoomId(@Param("roomId") Long roomId);
    int setPrimary(@Param("imageId") Long imageId);

    /// 등록/삭제 (업로드 모듈 연동 후 사용)
    int insertOne(RoomImage image);
    int deleteOne(@Param("id") Long id);
    int deleteByRoomId(@Param("roomId") Long roomId);

}
