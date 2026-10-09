package com.example.demo.controller;

import com.example.demo.domain.CaloriesData;
import com.example.demo.domain.R;
import com.example.demo.service.CaloriesDataService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.context.request.RequestContextHolder;

import java.util.List;

@RestController
@RequestMapping("/calories")
public class CaloriesDataController {

    @Autowired
    private CaloriesDataService caloriesDataService;

    /**
     * 获取指定用户的每日卡路里数据（默认过去 30 天）
     */
    @GetMapping("/calories1")
    public R getCaloriesData() {
        String userId = (String) RequestContextHolder.getRequestAttributes().getAttribute("userId", 0);
        List<CaloriesData>data=caloriesDataService.getCaloriesCountData(userId);
        return R.to("查询成功", 200, data);
    }


}
