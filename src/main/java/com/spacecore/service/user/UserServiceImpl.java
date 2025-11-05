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
    public void changePassword(Long id, String encodedPassword) {
        userMapper.updatePassword(id, encodedPassword);
        log.info("🔑 비밀번호 변경 완료: userId={}", id);
    }

    /**
     * ✅ 임시 비밀번호 재설정 (관리자용)
     */
    @Override
    public void resetPassword(Long id) {
        String tempPassword = UUID.randomUUID().toString().substring(0, 8);
        String encoded = passwordEncoder.encode(tempPassword);
        userMapper.updatePassword(id, encoded);

        log.info("🧩 관리자용 비밀번호 초기화: userId={} → 임시 비밀번호: {}", id, tempPassword);
    }

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

    @Override
    public boolean existsByPhoneExcludingId(String phone, Long excludeId) {
        return userMapper.existsByPhoneExcludingId(phone, excludeId);
    }

    //(알림 기능) 모든 관리자에게 알림 발송용
    @Override
    public List<Long> getAllAdminIds() {
        return userMapper.selectAllAdminIds();
    }
}