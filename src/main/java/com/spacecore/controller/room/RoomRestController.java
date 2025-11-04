package com.spacecore.controller.room;

import com.spacecore.domain.room.Room;
import com.spacecore.service.room.RoomService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/rooms")
public class RoomRestController {

    private final RoomService roomService;

    /// 룸 전체 조회
    @GetMapping
    public ResponseEntity<List<Room>> getAllRooms(){
        return ResponseEntity.ok(roomService.list());
    }

    /// 룸 상세 조회
    @GetMapping("/{id}")
    public ResponseEntity<Room> getRoomById(@PathVariable Long id){
        Room room = roomService.get(id);
        return (room != null) ? ResponseEntity.ok(room) : ResponseEntity.notFound().build();
    }

    /// 생성
    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping
    public ResponseEntity<Room> addRoom(@RequestBody Room room){
        Long id = roomService.create(room);
        room.setId(id);
        return ResponseEntity.status(201).body(room);
    }

    /// 수정
    @PreAuthorize("hasRole('ADMIN')")
    @PutMapping("/{id}")
    public ResponseEntity<Room> editRoom(@PathVariable Long id, @RequestBody Room room){
        room.setId(id);
        roomService.update(room);
        return ResponseEntity.ok(room);
    }

    /// 삭제
    @PreAuthorize("hasRole('ADMIN')")
    @DeleteMapping("/{id}")
    public ResponseEntity<Room> deleteRoom(@PathVariable Long id){
        roomService.delete(id);
        return ResponseEntity.noContent().build();
    }
}
