package com.spacecore.service.notice;

import com.spacecore.domain.notice.Notice;
import com.spacecore.mapper.notice.NoticeMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class NoticeServiceImpl implements NoticeService {

    private final NoticeMapper noticeMapper;

    @Override
    public List<Notice> findAll() {
        return noticeMapper.findAll();
    }

    @Override
    public Notice findById(long id) {
        Notice notice = noticeMapper.findById(id);
        if (notice == null) {
            throw new IllegalArgumentException("공지를 찾을 수 없습니다. 공지 ID: " + id);
        }
        return notice;
    }

    @Override
    public void create(Notice notice) {
        if (notice.getTitle() == null || notice.getTitle().trim().isEmpty()) {
            throw new IllegalArgumentException("제목을 입력해주세요.");
        }
        if (notice.getContent() == null || notice.getContent().trim().isEmpty()) {
            throw new IllegalArgumentException("내용을 입력해주세요.");
        }
        noticeMapper.insert(notice);
    }

    @Override
    public void update(Notice notice) {
        Notice existNotice = noticeMapper.findById(notice.getId());
        if (existNotice == null) {
            throw new IllegalArgumentException("공지를 찾을 수 없습니다. 공지 ID: " + notice.getId());
        }
        if (notice.getTitle() == null || notice.getTitle().trim().isEmpty()) {
            throw new IllegalArgumentException("제목을 입력해주세요.");
        }

        noticeMapper.update(notice);
    }

    @Override
    public void delete(Long id) {
        Notice notice = noticeMapper.findById(id);
        if (notice == null) {
            throw new IllegalArgumentException("공지를 찾을 수 없습니다. 공지 ID : "+ id);
        }
        noticeMapper.delete(id);
    }
}
