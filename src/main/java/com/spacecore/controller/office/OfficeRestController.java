package com.spacecore.controller.office;

import com.spacecore.domain.office.Office;
import com.spacecore.dto.office.OfficeDTO;
import com.spacecore.service.office.OfficeService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.parameters.P;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/offices")
public class OfficeRestController {

    private final OfficeService officeService;

    ///  전체 조회
    @GetMapping
    public ResponseEntity<List<Office>> getOfficeList() {
        return ResponseEntity.ok(officeService.list());
    }

    ///  상세 보기
    @GetMapping("/{id}")
    public ResponseEntity<Office> getOffice(@PathVariable Long id) {
        Office office = officeService.get(id);
        return office != null ? ResponseEntity.ok(office)
                              : ResponseEntity.notFound().build();
    }

    ///  생성
    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping
    public ResponseEntity<Office> addOffice(@RequestBody OfficeDTO officeDTO) {
        Office office = new Office();
        office.setName(officeDTO.getName());
        office.setAddress(officeDTO.getAddress());
        office.setStatus(officeDTO.getStatus() == null ? "ACTIVE" : officeDTO.getStatus());

        Long id = officeService.create(office);
        office.setId(id);

        return ResponseEntity.status(201).body(office);
    }

    /// 수정
    @PreAuthorize("hasRole('ADMIN')")
    @PutMapping("/{id}")
    public ResponseEntity<Office> editOffice(@PathVariable Long id,
                                       @RequestBody OfficeDTO officeDTO) {
        Office office = officeService.get(id);
        if (office == null) return ResponseEntity.notFound().build();

        office.setName(officeDTO.getName());
        office.setAddress(officeDTO.getAddress());
        office.setStatus(officeDTO.getStatus());

        officeService.update(office);
        return ResponseEntity.ok(office);
    }

    /// 삭제
    @PreAuthorize("hasRole('ADMIN')")
    @DeleteMapping("/{id}")
    public ResponseEntity<?> removeOffice(@PathVariable Long id) {
        officeService.delete(id);
        return ResponseEntity.noContent().build();
    }
}
