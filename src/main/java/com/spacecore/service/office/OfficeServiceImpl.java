package com.spacecore.service.office;

import com.spacecore.domain.office.Office;
import com.spacecore.mapper.office.OfficeMapper;
import lombok.AllArgsConstructor;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class OfficeServiceImpl implements OfficeService {

    private final OfficeMapper officeMapper;

    /// 지점 전체 조회
    @Override
    public List<Office> list() {
        return officeMapper.findAll();
    }

    ///  단건 조회
    @Override
    public Office get(Long id) {
        return officeMapper.findById(id);
    }

    /// 등록
    @Override
    @Transactional
    public Long create(Office office) {
        officeMapper.insert(office);
        return office.getId();
    }

    @Override
    @Transactional
    public void update(Office office) {
        officeMapper.update(office);
    }

    @Override
    @Transactional
    public void delete(Long id) {
        officeMapper.delete(id);
    }
}
