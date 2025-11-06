package com.spacecore.service.user;

import com.spacecore.domain.user.User;
import com.spacecore.mapper.user.UserMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional
public class UserServiceImpl implements UserService {

    private final UserMapper userMapper;
    private final PasswordEncoder passwordEncoder;

    @Override
    public void register(User user) {
        // username 자동 생성 (OAuth2 가입 시)
        if (user.getUsername() == null || user.getUsername().isEmpty()) {
            if (user.getEmail() != null && user.getEmail().contains("@")) {
                String base = user.getEmail().split("@")[0];
                user.setUsername(base + "_" + System.currentTimeMillis());
            } else {
                user.setUsername("user_" + System.currentTimeMillis());
            }
        }

        // ✅ 비밀번호 암호화 (회원가입 시만 수행)
        if (user.getPassword() != null && !user.getPassword().isEmpty()) {
            user.setPassword(passwordEncoder.encode(user.getPassword()));
        }

        user.setIsTempPassword("N");
        user.setStatus("ACTIVE");
        userMapper.insert(user);
        log.info("✅ 사용자 등록 완료: {}", user.getUsername());
    }

    @Override
    public Optional<User> findByUsername(String username) {
        return Optional.ofNullable(userMapper.findByUsername(username));
    }

    @Override
    public Optional<User> findByEmail(String email) {
        return Optional.ofNullable(userMapper.findByEmail(email));
    }

    @Override
    public User findById(Long id) {
        User user = userMapper.findById(id);
        if (user == null) {
            throw new RuntimeException("User not found with id: " + id);
        }
        return user;
    }

    @Override
    public List<User> findAll() {
        return userMapper.findAll();
    }

    @Override
    public void update(User user) {
        userMapper.update(user);
        log.info("🔄 사용자 정보 수정 완료: {}", user.getId());
    }

    @Override
    public void delete(Long id) {
        userMapper.delete(id);
        log.info("🗑️ 사용자 삭제 완료: {}", id);
    }

    /**
     * ✅ 비밀번호 변경 (Controller에서 이미 인코딩된 상태로 전달됨)
     */
    @Override
    public void changePassword(Long id, String rawNewPassword) {
        User user = userMapper.findById(id);
        if (user == null) {
            throw new RuntimeException("해당 사용자를 찾을 수 없습니다. (id=" + id + ")");
        }

        // ✅ 새 비밀번호가 기존 비밀번호와 같은지 검사
        if (passwordEncoder.matches(rawNewPassword, user.getPassword())) {
            throw new IllegalArgumentException("기존 비밀번호와 동일한 비밀번호로 변경할 수 없습니다.");
        }

        // ✅ 비밀번호 인코딩 후 저장
        String encodedPassword = passwordEncoder.encode(rawNewPassword);
        userMapper.updatePassword(id, encodedPassword);
        log.info("🔑 비밀번호 변경 완료 (userId={}): 기존과 다른 비밀번호로 변경됨", id);
    }

    // 사용자 비밀번호 재설정
    @Override
    public void resetPasswordByUser(String username, String newPassword) {
        User user = userMapper.findByUsername(username);
        if (user == null) throw new RuntimeException("사용자를 찾을 수 없습니다.");

        String encoded = passwordEncoder.encode(newPassword);
        userMapper.updatePassword(user.getId(), encoded);
        log.info("🔑 사용자 직접 비밀번호 재설정 완료: {}", username);
    }

    /**
     * 임시 비밀번호 발급 (관리자용)
     */
    @Override
    public String resetPasswordByAdmin(Long id) {
        User user = userMapper.findById(id);
        if (user == null) throw new RuntimeException("사용자를 찾을 수 없습니다. id=" + id);

        // UUID에서 하이픈을 제거하고 앞 8자리만 사용하여 임시 비밀번호 생성
        String tempPassword = UUID.randomUUID().toString().replace("-", "").substring(0, 8);
        String encoded = passwordEncoder.encode(tempPassword);
        // 임시 비밀번호 설정 및 is_temp_password 플래그를 "Y"로 설정
        userMapper.updateTempPassword(id, encoded, "Y");

        log.info("🧩 관리자 비밀번호 초기화 완료: userId={} → 임시비밀번호={}", id, tempPassword);
        return tempPassword;
    }


    // 중복체크
    @Override
    public boolean existsByUsername(String username) {
        return userMapper.existsByUsername(username);
    }

    @Override
    public boolean existsByEmail(String email) {
        return userMapper.existsByEmail(email);
    }

    @Override
    public boolean existsByPhone(String phone) {
        return userMapper.existsByPhone(phone);
    }

    /** ✅ 내 계정을 제외한 중복 전화번호 검사 */
    @Override
    public boolean existsByPhoneExcludingId(String phone, Long excludeId) {
        return userMapper.existsByPhoneExcludingId(phone, excludeId);
    }

    /** ✅ 아이디와 이메일이 일치하는지 확인 (비밀번호 찾기용) */
    @Override
    public boolean checkUsernameAndEmail(String username, String email) {
        return findByUsername(username)
                .filter(user -> user.getEmail() != null && user.getEmail().equalsIgnoreCase(email))
                .isPresent();
    }

    //(알림 기능) 모든 관리자에게 알림 발송용
    @Override
    public List<Long> getAllAdminIds() {
        return userMapper.selectAllAdminIds();
    }

}