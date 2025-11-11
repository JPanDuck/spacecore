package com.spacecore.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // 업로드된 파일 URL 매핑
        registry.addResourceHandler("/uploads/**")
                .addResourceLocations("file:///C:/uploads/");
        
        // 리뷰 이미지 파일 URL 매핑
        // 빌드 디렉토리와 소스 디렉토리 모두 지원 (개발 환경)
        String projectRoot = System.getProperty("user.dir");
        // Windows 경로 구분자를 슬래시로 변환
        String normalizedRoot = projectRoot.replace("\\", "/");
        
        registry.addResourceHandler("/img/reviews/**")
                .addResourceLocations(
                    "file:" + normalizedRoot + "/build/resources/main/static/img/reviews/",
                    "file:" + normalizedRoot + "/src/main/resources/static/img/reviews/",
                    "classpath:/static/img/reviews/"
                )
                .resourceChain(false);
    }
}
