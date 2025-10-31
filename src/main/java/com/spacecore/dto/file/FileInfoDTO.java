package com.spacecore.dto.file;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class FileInfoDTO {

    private Long id;                // 파일 PK
    private Long userId;            // 업로더 ID
    private String category;        // 파일 카테고리
    private String originalName;    // 원본 파일명
    private String storedName;      // 서버 저장 파일명 (UUID 등)
    private String filePath;        // 저장 경로
    private String fileUrl;         // 접근 URL
    private String contentType;     // MIME 타입 (image/jpeg 등)
    private Long fileSize;          // 파일 크기 (bytes)
    private LocalDateTime createdAt;// 업로드 일시
}
