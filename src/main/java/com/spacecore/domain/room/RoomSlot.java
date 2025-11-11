package com.spacecore.domain.room;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class RoomSlot {
    private Long id;
    private Long roomId;
    private Long reservationId;
    private String slotUnit;
    private LocalDateTime slotStart;
    private LocalDateTime slotEnd;
    private String status;
}