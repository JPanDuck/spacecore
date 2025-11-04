package com.spacecore.mapper.office;

import com.spacecore.domain.office.Office;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface OfficeMapper {

    /// 지점 전체 조회
    List<Office> findAll();

    /// 단건 조회
    Office findById(Long id);

    /// 지점 등록
    void insert(Office office);

    /// 지점 수정
    int update(Office office);

    /// 지점 삭제
    int delete(Long id);

}
