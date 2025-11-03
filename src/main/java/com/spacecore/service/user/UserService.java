package com.spacecore.service.user;

import com.spacecore.domain.user.User;

import java.util.List;
import java.util.Optional;

public interface UserService {

    // 회원가입
    void register(User user);

    // 로그인용 (username/email로 사용자 조회)
    Optional<User> findByUsername(String username);
    Optional<User> findByEmail(String email);

    // 마이페이지, 관리자 조회
    User findById(Long id);
    List<User> findAll();

    // 프로필 수정
    void update(User user);

    // 회원 탈퇴
    void delete(Long id);

    // 비밀번호 관련
    void changePassword(Long id, String newPassword);
    void resetPassword(Long id);

    // 중복체크
    boolean existsByUsername(String username);
    boolean existsByEmail(String email);
}
