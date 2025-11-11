package com.spacecore.dto.favorite;

import com.spacecore.domain.favorite.Favorite;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * Favorite 목록 조회용
 * - 지점 이름과 룸 이름 포함 (JOIN)
 * */

@Data                                   //@Data는 callSuper = false(기본값)
@EqualsAndHashCode(callSuper = true)    //부모 클래스의 equals()와 hashCode() 결과도 자식 클래스의 계산에 포함 = 부모 클래스의 필드까지 포함해서 비교
public class FavoriteDetailDTO extends Favorite {
    private String officeName;
    private String roomName;
    private Integer capacity;
    private Long priceBase;
    private String thumbnail;
}
