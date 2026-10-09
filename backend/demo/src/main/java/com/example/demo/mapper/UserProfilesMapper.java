package com.example.demo.mapper;

import com.example.demo.domain.UserProfiles;

public interface UserProfilesMapper {

    int upsert(UserProfiles userProfiles);

}
