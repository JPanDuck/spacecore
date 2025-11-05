package com.spacecore.mapper.user;

import com.spacecore.domain.user.User;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface UserMapper {

    // 조회
    User findByUsername(@Param("username") String username); // 로그인 시 사용
    User findByEmail(@Param("email") String email);           // OAuth2 로그인용
    User findById(@Param("id") Long id);                      // 마이페이지 / 관리자 상세조회
    List<User> findAll();                                     // 관리자 전체 조회

    // ✅ 추가 — OAuth2AuthorizedClientService에서 사용 (이메일 → userId 변환)
    Long findIdByEmail(@Param("email") String email);

    // 등록 / 수정 / 삭제
    void insert(User user);                                   // 회원가입
    void update(User user);                                   // 프로필 수정
    void delete(@Param("id") Long id);                        // 회원탈퇴 / 관리자삭제

    // 비밀번호 관련
    void updatePassword(@Param("id") Long id, @Param("password") String password);
    void updateTempPassword(@Param("id") Long id,
                            @Param("encodedPassword") String encodedPassword,
                            @Param("isTempPw") String isTempPw);

    // 기타
    boolean existsByUsername(@Param("username") String username); // 아이디 중복체크
    boolean existsByEmail(@Param("email") String email);          // 이메일 중복체크
    boolean existsByPhone(@Param("phone") String phone);

    //내 계정을 제외한 중복 전화번호 검사
    boolean existsByPhoneExcludingId(@Param("phone") String phone, @Param("excludeId") Long excludeId);

    //(알림 기능) 모든 관리자에게 알림 발송용
    List<Long> selectAllAdminIds();

}