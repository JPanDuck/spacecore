package com.spacecore.service.room;

import com.spacecore.domain.room.Room;

import java.util.List;

public interface RoomService {

    /// 룸 전체 조회
    List<Room> list();

    /// 지점 별 조회
    List<Room> listByOffice(Long officeId);

    /// 룸 단건 조회
    Room get(Long id);

    /// 룸 등록
    Long create(Room room);

    /// 룸 수정
    void update(Room room);

    /// 룸 삭제
    void delete(Long id);
}