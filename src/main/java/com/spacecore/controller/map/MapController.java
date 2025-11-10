package com.spacecore.controller.map;

import com.spacecore.domain.office.Office;
import com.spacecore.service.office.OfficeService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

/**
 * 지도 페이지를 로드하고 모든 지점 데이터를 Model에 담아 JSP로 전달하는 컨트롤러
 * */

@Controller
@RequestMapping("/map")
@RequiredArgsConstructor
public class MapController {

    //네이버맵 클라이언트ID
    @Value("${naver.map.client.id}")
    private String clientId;

    private final OfficeService officeService;

    //지점 목록 지도 페이지 - 사용자용
    @GetMapping
    public String getOfficeMap(Model model) {
        //DB에서 위도,경도 포함 모든 지점 정보 불러오기
        List<Office> officeList = officeService.list();

        //JSP에서 지점 목록을 순회하며 마커를 생성할 수 있도록 Model에 담아 전달
        model.addAttribute("officeList", officeList);
        model.addAttribute("clientId", clientId);   //네이버맵
        return "map/officeList";
    }

}
