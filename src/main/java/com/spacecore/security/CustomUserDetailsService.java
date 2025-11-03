package com.spacecore.security;

import com.spacecore.domain.user.User;
import com.spacecore.service.user.UserService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

/**
 * CustomUserDetailsService
 * ------------------------
 * - Spring Security에서 username 기반으로 사용자 인증 정보를 로드하는 핵심 서비스
 * - AuthenticationManager → DaoAuthenticationProvider → 여기 호출
 * - JWT / OAuth2 / 기본 로그인 모두 공통으로 사용자 로드 가능
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class CustomUserDetailsService implements UserDetailsService {

    private final UserService userService;

    /**
     * 사용자명(username)으로 사용자 정보 로드
     * @param username 로그인 시 입력한 username
     * @return UserDetails (Spring Security 인증용 객체)
     * @throws UsernameNotFoundException 사용자 없을 시 예외 발생
     */
    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {

        User user = userService.findByUsername(username)
                .orElseThrow(() -> new UsernameNotFoundException("사용자를 찾을 수 없습니다: " + username));

        log.info("사용자 인증 로드: {}", username);

        // Spring Security의 UserDetails 로 변환
        return new CustomUserDetails(user);
    }
}
