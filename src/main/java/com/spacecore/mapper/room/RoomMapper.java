package com.spacecore.mapper.room;

import com.spacecore.domain.room.Room;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface RoomMapper {
    /// 전체 조회
    List<Room> findAll();

    /// 지점별 조회
    List<Room> findByOfficeId(@Param("value") Long officeId);

    /// 단건 조회
    Room findById(Long id);

    /// 룸 등록
    int insert(Room room);

    /// 룸 수정
    int update(Room room);

    /// 룸 삭제
    int delete(Long id);
}
