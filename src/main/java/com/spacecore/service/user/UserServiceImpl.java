package com.spacecore.service.user;

import com.spacecore.domain.user.User;
import com.spacecore.dto.common.PageInfoDTO;
import com.spacecore.dto.common.PaginationDTO;
import com.spacecore.mapper.user.UserMapper;
import com.spacecore.mapper.auth.RefreshTokenMapper;
import com.spacecore.service.oauth2.OAuth2AccountService;
import com.spacecore.util.common.PaginationHelper;
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
    private final OAuth2AccountService oAuth2AccountService; // ✅ 추가
    private final RefreshTokenMapper refreshTokenMapper;     // ✅ 추가

    /**
     * ✅ 회원 등록
     */
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

    /**
     * ✅ 사용자 조회
     */
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

    /**
     * ✅ 검색 및 페이징 조회
     */
    @Override
    public PaginationDTO<User> findAllWithSearch(String keyword, int page, int limit) {
        // 키워드가 null이면 빈 문자열로 처리
        if (keyword == null) {
            keyword = "";
        }
        
        // 페이지가 1보다 작으면 1로 설정
        if (page < 1) {
            page = 1;
        }
        
        // limit이 1보다 작으면 10으로 설정
        if (limit < 1) {
            limit = 10;
        }
        
        // offset 계산
        int offset = (page - 1) * limit;
        
        // 전체 개수 조회
        int totalCount = userMapper.countAllWithSearch(keyword);
        
        // 페이징 정보 생성
        PageInfoDTO pageInfo = PaginationHelper.createPageInfo(totalCount, page, limit);
        
        // 데이터 조회
        List<User> users = userMapper.findAllWithSearch(keyword, offset, limit);
        
        return new PaginationDTO<>(users, pageInfo);
    }

    /**
     * ✅ 사용자 정보 수정
     */
    @Override
    public void update(User user) {
        userMapper.update(user);
        log.info("🔄 사용자 정보 수정 완료: {}", user.getId());
    }

    /**
     * ✅ 회원 탈퇴 (모든 관련 데이터 포함 삭제)
     * - oauth2_account
     * - refresh_tokens
     * - users
     */
    @Override
    public void delete(Long id) {
        try {
            // 1️⃣ 소셜 로그인 정보 제거 + revoke 처리
            oAuth2AccountService.deleteAndRevoke(id);
        } catch (Exception e) {
            log.warn("⚠️ OAuth2Account 삭제 중 예외 발생 (userId={}): {}", id, e.getMessage());
        }

        try {
            // 2️⃣ 내부 JWT RefreshToken 삭제
            refreshTokenMapper.deleteByUserId(id);
            log.info("🧹 refresh_token 삭제 완료 (userId={})", id);
        } catch (Exception e) {
            log.warn("⚠️ RefreshToken 삭제 중 예외 발생 (userId={}): {}", id, e.getMessage());
        }

        // 3️⃣ 실제 사용자 삭제
        userMapper.delete(id);
        log.info("🗑️ 사용자 및 관련 계정 정보 삭제 완료: {}", id);
    }

    /**
     * ✅ 비밀번호 변경
     */
    @Override
    public void changePassword(Long id, String rawNewPassword) {
        User user = userMapper.findById(id);
        if (user == null) {
            throw new RuntimeException("해당 사용자를 찾을 수 없습니다. (id=" + id + ")");
        }

        if (passwordEncoder.matches(rawNewPassword, user.getPassword())) {
            throw new IllegalArgumentException("기존 비밀번호와 동일한 비밀번호로 변경할 수 없습니다.");
        }

        String encodedPassword = passwordEncoder.encode(rawNewPassword);
        userMapper.updatePassword(id, encodedPassword);
        log.info("🔑 비밀번호 변경 완료 (userId={}): 기존과 다른 비밀번호로 변경됨", id);
    }

    /**
     * ✅ 사용자 비밀번호 재설정 (본인 요청)
     */
    @Override
    public void resetPasswordByUser(String username, String newPassword) {
        User user = userMapper.findByUsername(username);
        if (user == null) throw new RuntimeException("사용자를 찾을 수 없습니다.");

        String encoded = passwordEncoder.encode(newPassword);
        userMapper.updatePassword(user.getId(), encoded);
        log.info("🔑 사용자 직접 비밀번호 재설정 완료: {}", username);
    }

    /**
     * ✅ 임시 비밀번호 발급 (관리자용)
     */
    @Override
    public String resetPasswordByAdmin(Long id) {
        User user = userMapper.findById(id);
        if (user == null) throw new RuntimeException("사용자를 찾을 수 없습니다. id=" + id);

        String tempPassword = UUID.randomUUID().toString().substring(0, 8);
        String encoded = passwordEncoder.encode(tempPassword);
        userMapper.updateTempPassword(id, encoded, "Y");

        log.info("🧩 관리자 비밀번호 초기화 완료: userId={} → 임시비밀번호={}", id, tempPassword);
        return tempPassword;
    }

    // ✅ 중복체크
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

    /**
     * ✅ 내 계정을 제외한 중복 전화번호 검사
     */
    @Override
    public boolean existsByPhoneExcludingId(String phone, Long excludeId) {
        return userMapper.existsByPhoneExcludingId(phone, excludeId);
    }

    /**
     * ✅ 아이디와 이메일 일치 여부 검사 (비밀번호 찾기용)
     */
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