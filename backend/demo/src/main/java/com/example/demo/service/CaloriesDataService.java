package com.example.demo.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
@Service
public class CaloriesDataService {
        @Autowired
        private com.example.demo.mapper.CaloriesData CaloriesData;

        public List<com.example.demo.domain.CaloriesData> getCaloriesCountData(String userId) {
            return CaloriesData.getCaloriesCountData(userId);
        }
    }
