package com.spacecore.mapper.notice;

import com.spacecore.domain.notice.Notice;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface NoticeMapper {

    /// 공지 전체 조회 (고정 공지 우선, 그 다음 최신순)
    List<Notice> findAll();

    /// 공지 상세 조회
    Notice findById(@Param("id") Long id);

    /// 공지 생성
    void insert(Notice notice);

    /// 공지 수정
    void update(Notice notice);

    /// 공지 삭제
    void delete(@Param("id") Long id);

    /// 고정 공지 조회(pinned = 'Y')
    List<Notice> findPinned();
}
