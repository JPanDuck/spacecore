package com.spacecore.controller.room;

import com.spacecore.domain.room.Room;
import com.spacecore.service.office.OfficeService;
import com.spacecore.service.room.RoomService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequiredArgsConstructor
@RequestMapping("/offices/{officeId}/rooms")
public class RoomController {

    private final RoomService roomService;
    private final OfficeService officeService;

    /// 오피스에 해당하는 룸 전체 페이지
    @GetMapping({"","/"})
    public String roomList(@PathVariable("officeId") Long officeId, Model model) {
        // 해당 오피스의 룸만 조회
        model.addAttribute("roomList", roomService.listByOffice(officeId));
        model.addAttribute("officeList", officeService.list());
        model.addAttribute("selectedOfficeId", officeId);
        return "room/list";
    }

    /// 상세 페이지
    @GetMapping("/detail/{id}")
    public String roomDetail(@PathVariable Long id, Model model) {
        model.addAttribute("room", roomService.get(id));
        model.addAttribute("officeList", officeService.list());
        return "room/detail";
    }

    /// 등록 폼
    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/add")
    public String addForm(@PathVariable("officeId") Long officeId, Model model) {
        model.addAttribute("offices", officeService.list());
        model.addAttribute("room", new Room());
        model.addAttribute("officeId", officeId);
        return "room/add";
    }

    /// 등록 처리
    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/add")
    public String addRoom(@ModelAttribute Room room){
        roomService.create(room);
        return "redirect:/offices/" + room.getOfficeId() + "/rooms";
    }

    /// 수정 폼
    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/edit/{id}")
    public String editForm(@PathVariable Long id, Model model) {
        model.addAttribute("room", roomService.get(id));
        model.addAttribute("offices", officeService.list());
        return "room/edit";
    }

    /// 수정
    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/edit")
    public String editRoom(@ModelAttribute Room room){
        roomService.update(room);
        return "redirect:/offices/" + room.getOfficeId() + "/rooms";
    }

    /// 삭제
    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/delete/{id}")
    public String deleteRoom(@PathVariable("id") Long id){
        Room room = roomService.get(id);  // 삭제 전에 officeId 가져오기
        Long officeId = room.getOfficeId();
        roomService.delete(id);
        return "redirect:/offices/" + officeId + "/rooms";
    }
}

