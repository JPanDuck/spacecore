package com.spacecore.controller.office;


import com.spacecore.domain.office.Office;
import com.spacecore.service.office.OfficeService;
import com.spacecore.service.room.RoomService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequiredArgsConstructor
@RequestMapping("/offices")
public class OfficeController {

    private final OfficeService officeService;
    private final RoomService roomService;

    /// 목록 페이지
    @GetMapping({"","/"})
    public String officeList(Model model) {
        model.addAttribute("officeList", officeService.list());
        return "office/list";
    }

    /// 지점 상세보기
    @GetMapping("/detail/{id}")
    public String officeDetail(@PathVariable Long id, Model model) {
        Office office = officeService.get(id);
        if (office == null) {
            return "redirect:/offices/?error=not_found";
        }
        model.addAttribute("office", office);
        // 해당 지점의 객실 목록 추가
        model.addAttribute("roomList", roomService.listByOffice(id));
        return "office/detail";
    }

    /// 등록 폼
     @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/add")
    public String addForm(Model model) {
        model.addAttribute("office", new Office());
        return "office/add";
    }

    /// 등록 처리
    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/add")
    public String addOffice(@ModelAttribute Office office) {
        officeService.create(office);
        return "redirect:/offices/";
    }

    /// 수정 폼
    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/edit/{id}")
    public String editForm(@PathVariable Long id, Model model){
        model.addAttribute("office", officeService.get(id));
        return "office/edit";
    }

    /// 수정
    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/edit")
    public String editOffice(@ModelAttribute Office office){
        officeService.update(office);
        return "redirect:/offices/detail/"+office.getId();
    }

    ///  삭제
    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/delete/{id}")
    public String deleteOffice(@PathVariable("id") Long id){
        officeService.delete(id);
        return "redirect:/offices/";
    }
}
