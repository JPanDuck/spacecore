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
    // 비밀번호 찾기 후 직접 새 비밀번호 입력
    void resetPasswordByUser(String username, String newPassword);
    // 관리자 임시 비밀번호 초기화
    String resetPasswordByAdmin(Long id);

    // 중복체크
    boolean existsByUsername(String username);
    boolean existsByEmail(String email);
    boolean existsByPhone(String phone);
    /** ✅ 내 계정을 제외한 중복 전화번호 검사 */
    boolean existsByPhoneExcludingId(String phone, Long excludeId);
    /** ✅ 아이디와 이메일이 일치하는지 확인 (비밀번호 찾기용) */
    boolean checkUsernameAndEmail(String username, String email);
    //(알림 기능) 모든 관리자에게 알림 발송용
    List<Long> getAllAdminIds();
}