package com.spacecore.controller.notice;

import com.spacecore.domain.notice.Notice;
import com.spacecore.service.notice.NoticeService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/notices")
public class NoticeRestController {

    private final NoticeService noticeService;

    @GetMapping
    public ResponseEntity<List<Notice>> getAllNotice() {
        return ResponseEntity.ok(noticeService.findAll());
    }

    @GetMapping("/{id}")
    public ResponseEntity<Notice> detailNotice(@PathVariable("id") Long id) {
        return ResponseEntity.ok(noticeService.findById(id));
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping
    public ResponseEntity<Void> addNotice(@PathVariable("id") Long id, @RequestBody Notice notice) {
        noticeService.create(notice);
        return ResponseEntity.status(201).build();
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/edit/{id}")
    public ResponseEntity<Void> editNotice(@PathVariable("id") Long id, @RequestBody Notice notice) {
        notice.setId(id);
        noticeService.update(notice);
        return ResponseEntity.noContent().build();
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/delete/{id}")
    public ResponseEntity<Void> deleteNotice(@PathVariable("id") Long id) {
        noticeService.delete(id);
        return ResponseEntity.noContent().build();
    }
}
