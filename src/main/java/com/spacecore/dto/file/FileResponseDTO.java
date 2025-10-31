package com.spacecore.dto.file;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class FileResponseDTO {

    private Long id;            // 파일 ID
    private String originalName; // 원본 파일명
    private String fileUrl;      // 접근 가능한 URL
}
