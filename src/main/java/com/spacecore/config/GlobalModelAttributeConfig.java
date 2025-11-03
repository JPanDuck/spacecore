package com.spacecore.config;

import com.spacecore.dto.common.SearchFilterDTO;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

@ControllerAdvice
public class GlobalModelAttributeConfig {

    /**
     * 모든 Controller에서 @ModelAttribute SearchFilterDTO filter 자동 주입
     */
    @ModelAttribute("filter")
    public SearchFilterDTO defaultSearchFilter() {
        return new SearchFilterDTO(); // 기본값(page=1, limit=10 등)
    }
}
