package com.spacecore.domain.room;

import lombok.Data;

import java.time.LocalDate;

@Data
public class RoomSlot {
    private Long id;
    private Long roomId;
    private Long reservationId;
    private String slotUnit;
    private LocalDate slotStart;
    private LocalDate slotEnd;
    private String status;
}
