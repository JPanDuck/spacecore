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
    }
}
