package com.example.demo.service;

import com.example.demo.domain.User;
import com.example.demo.domain.UserProfiles;
import com.example.demo.mapper.UserProfilesMapper;
import com.example.demo.mapper.UserSetupMapper;
import com.example.demo.mapper.UsersMapper;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.crypto.password.PasswordEncoder;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class UserServiceTest {
    @Mock UsersMapper usersMapper;
    @Mock UserProfilesMapper userProfilesMapper;
    @Mock UserSetupMapper userSetupMapper;
    @Mock PasswordEncoder passwordEncoder;
    @InjectMocks UserService service;

    @Test
    void registerCreatesProfileTargetsAndHabits() {
        User user = new User();
        user.setUsername("alice");
        user.setPassword("secret123");
        when(usersMapper.getUserByUsername("alice")).thenReturn(null);
        when(passwordEncoder.encode("secret123")).thenReturn("encoded");
        when(usersMapper.create(any(User.class))).thenReturn(1);

        assertEquals(200, service.register(user));
        assertNotNull(user.getUserId());
        assertEquals("encoded", user.getPassword());
        verify(userSetupMapper).createProfile(user.getUserId());
        verify(userSetupMapper).createStepTarget(user.getUserId());
        verify(userSetupMapper).createHeatTarget(user.getUserId());
        verify(userSetupMapper).createSportTimeTarget(user.getUserId());
        verify(userSetupMapper, times(4)).createHabit(eq(user.getUserId()), anyString());
    }

    @Test
    void registerRejectsDuplicateUsername() {
        User user = new User();
        user.setUsername("alice");
        when(usersMapper.getUserByUsername("alice")).thenReturn(new User());
        assertEquals(10010, service.register(user));
        verify(usersMapper, never()).create(any());
    }

    @Test
    void loginWithUnknownUserReturnsNull() {
        User credentials = new User();
        credentials.setUsername("missing");
        credentials.setPassword("secret123");
        when(usersMapper.getUserByUsername("missing")).thenReturn(null);
        assertNull(service.login(credentials));
        verify(passwordEncoder, never()).matches(anyString(), anyString());
    }

    @Test
    void loginWithWrongPasswordReturnsNull() {
        User stored = new User();
        stored.setPassword("encoded");
        User credentials = new User();
        credentials.setUsername("alice");
        credentials.setPassword("wrong-password");
        when(usersMapper.getUserByUsername("alice")).thenReturn(stored);
        when(passwordEncoder.matches("wrong-password", "encoded")).thenReturn(false);
        assertNull(service.login(credentials));
    }

    @Test
    void updateProfileUsesCurrentUserAndUpsertsMissingProfile() {
        User user = new User();
        user.setUserId("user-a");
        user.setName("Alice");
        when(userProfilesMapper.upsert(any(UserProfiles.class))).thenReturn(1);
        assertEquals(1, service.updateUser(user));
        verify(usersMapper).update(user);
        verify(userProfilesMapper).upsert(argThat(profile -> "user-a".equals(profile.getUserId())));
    }
}
