package com.spacecore.service.office;

import com.spacecore.domain.office.Office;

import java.util.List;


public interface OfficeService {

    /// 전체 조회
    List<Office> list();

    /// 단건 조회
    Office get(Long id);

    /// 등록
    Long create(Office office);

    /// 수정
    void update(Office office);

    /// 삭제
    void delete(Long id);
}
