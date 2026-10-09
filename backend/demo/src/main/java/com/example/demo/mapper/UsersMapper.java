package com.example.demo.mapper;

import com.example.demo.domain.*;

import java.util.List;

// 设计对接数据的方法
public interface UsersMapper {

    // 查询用户信息
    // List<User>返回数据类型，查询用户最终得到的是一个包含很多用户的集合
    List<User> list();

    // 根据用户id查询某个用户的信息，1个参数
    User getUserById(String userId);

    // 查询用户数量
    int countUsers();

    // 查询用户信息，根据姓名和邮箱查询用户，2个以上的参数
    List<User> listByCondition(String name, String email);

    // 多个参数
    List<User> listByCondition1(User user);

    List<User> listByCondition2(String userId);

    // 查询返回对应的类，建议每个方法都有单独的类
    // 查询用户基本信息，包含用户id、账号、姓名、邮箱
    List<UserBaseInfo> getBaseList();

    // 查询用户id、姓名、性别、身高
    List<UserBaseProfile> getUserBaseProfile();

    List<UserBaseInfo> test1(String gender, Double heightCm, Double weightKg);

    List<UserBaseInfo> test2(UsersParams params);

    // 查询某年某月每个用户平均步数
    List<UsersAvgSteps> getUsersAvgSteps(String year, String month);

    // [1, 20, 33, 41]
    List<UserBaseInfo> test3(List<Integer> ids);

    UserSteps getUserSteps(String userId);

    // 添加
    int create(User user);

    int update(User user);

    int delete(String userId);

    // 根据账号获取用户信息
    User getUserByUsername(String username);

    List<UserProfiles> getUserProfiles(String userId);
}
