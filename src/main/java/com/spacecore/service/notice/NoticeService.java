package com.spacecore.service.notice;


import com.spacecore.domain.notice.Notice;

import java.util.List;

public interface NoticeService {

    /// 공지 전체 조회
    List<Notice> findAll();

    /// 공지 상세 조회
    Notice findById(long id);

    /// 공지 생성
    void create(Notice notice);

    /// 공지 수정
    void update(Notice notice);

    /// 공지 삭제
    void delete(Long id);
}
