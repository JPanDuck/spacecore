package com.spacecore.controller.notice;

import com.spacecore.domain.notice.Notice;
import com.spacecore.security.CustomUserDetails;
import com.spacecore.service.notice.NoticeService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequiredArgsConstructor
@RequestMapping("/notices")
public class NoticeController {

    private final NoticeService noticeService;

    @GetMapping({"","/"})
    public String noticeList(Model model) {
        List<Notice> notices = noticeService.findAll();
        model.addAttribute("noticeList", notices);
        return "notice/list";
    }

    @GetMapping("/detail/{id}")
    public String noticeDetail(@PathVariable Long id, Model model) {
        model.addAttribute("notice", noticeService.findById(id));
        return "notice/detail";
    }

    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/add")
    public String addForm(Model model) {
        model.addAttribute("notice", new Notice());
        return "notice/add";
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/add")
    public String addNotice(@ModelAttribute Notice notice,
                            @AuthenticationPrincipal CustomUserDetails user) {
        notice.setUserId(user.getId());
        noticeService.create(notice);
        return "redirect:/notices";
    }

    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/edit/{id}")
    public String editForm(@PathVariable Long id, Model model) {
        model.addAttribute("notice", noticeService.findById(id));
        return "notice/edit";
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/edit")
    public String editNotice(@ModelAttribute Notice notice) {
        noticeService.update(notice);
        return "redirect:/notices/detail/" + notice.getId();
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/delete/{id}")
    public String deleteNotice(@PathVariable("id") Long id) {
        noticeService.delete(id);
        return "redirect:/notices";
    }
}
