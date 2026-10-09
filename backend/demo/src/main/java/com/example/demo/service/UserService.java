package com.example.demo.service;

import com.example.demo.domain.User;
import com.example.demo.domain.UserProfiles;
import com.example.demo.mapper.UserProfilesMapper;
import com.example.demo.mapper.UserSetupMapper;
import com.example.demo.mapper.UsersMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;

@Service // 这是业务层代码，用来实现具体的业务逻辑
public class UserService {

    @Autowired // 引入UsersMapper对象
    private UsersMapper usersMapper;
    @Autowired
    private UserProfilesMapper userProfilesMapper;
    @Autowired
    private UserSetupMapper userSetupMapper;
    @Autowired
    private PasswordEncoder passwordEncoder;

    // 注册
    @Transactional
    public int register(User user) {
        // 判断账号有没有重复
        User u = usersMapper.getUserByUsername(user.getUsername());

        // 账号存在
        if(u != null) {
            return 10010;
        }
        // 账号不存在
        String userId = UUID.randomUUID().toString().replace("-", "");
        user.setUserId(userId);
        // 对密码进行加密
        String encodePassword = passwordEncoder.encode(user.getPassword());
        user.setPassword(encodePassword);

        int rs = usersMapper.create(user);
        if (rs <= 0) {
            return 500;
        }
        userSetupMapper.createProfile(userId);
        userSetupMapper.createStepTarget(userId);
        userSetupMapper.createHeatTarget(userId);
        userSetupMapper.createSportTimeTarget(userId);
        for (String habit : List.of("喝水", "刷牙", "早起", "跑步")) {
            userSetupMapper.createHabit(userId, habit);
        }
        return 200;
    }

    // 登录
    public User login(User user) {
        User u = usersMapper.getUserByUsername(user.getUsername());
        if(u != null && passwordEncoder.matches(user.getPassword(), u.getPassword())) {
            return u;
        }
        return null;
    }

    // 获取用户信息
    public User getUserById(String userId) {
        return usersMapper.getUserById(userId);
    }

    // 修改个人信息
    @Transactional
    public int updateUser(User user) {
        // 修改users表的nick_name
        usersMapper.update(user);

        UserProfiles userProfiles = new UserProfiles();
        userProfiles.setBirthday(user.getBirthday());
        userProfiles.setGender(user.getGender());
        userProfiles.setHeightCm(user.getHeight());
        userProfiles.setWeightKg(user.getWeight());
        userProfiles.setUserId(user.getUserId());
        return userProfilesMapper.upsert(userProfiles);
    }

    public List<UserProfiles> getUserProfiles(String userId) {
        return usersMapper.getUserProfiles(userId);
    }
}
