package com.spacecore.dto.file;

import lombok.Data;
import org.springframework.web.multipart.MultipartFile;

@Data
public class FileUploadRequestDTO {

    private Long userId;                // 업로드한 사용자 ID
    private String category;            // 파일 분류 (ex: "review", "profile", "notice")
    private MultipartFile file;         // 실제 업로드 파일 - 자동매핑 가능
}
