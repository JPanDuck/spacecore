package com.spacecore.service.room;

import com.spacecore.domain.room.Room;
import com.spacecore.mapper.room.RoomMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class RoomServiceImpl implements RoomService {

    private final RoomMapper roomMapper;

    /// 룸 전체 조회
    @Override
    public List<Room> list() {
        return roomMapper.findAll();
    }

    /// 지점별 조회
    @Override
    public List<Room> listByOffice(Long officeId) {
        return roomMapper.findByOfficeId(officeId);
    }

    ///  단건 조회
    @Override
    public Room get(Long id) {
        return roomMapper.findById(id);
    }
    /// 룸 등록
    @Override
    @Transactional
    public Long create(Room room) {
        roomMapper.insert(room);
        return room.getId();
    }

    /// 룸 수정
    @Override
    @Transactional
    public void update(Room room) {
        roomMapper.update(room);
    }

    /// 룸 삭제
    @Override
    @Transactional
    public void delete(Long id) {
        roomMapper.delete(id);
    }
}
