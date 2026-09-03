package com.yx.sys.controller;

import com.yx.common.util.PageUtils;
import com.yx.sys.entity.SysLog;
import com.yx.sys.model.SysLogQueryDTO;
import com.yx.sys.service.ISysLogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@CrossOrigin
@RequestMapping("/sys/sysLog")
public class SysLogController {

    @Autowired
    private ISysLogService sysLogService;

    @GetMapping("list")
    public PageUtils list(SysLogQueryDTO dto){
        PageUtils pageUtils = sysLogService.listPage(dto);
        return pageUtils;
    }
}
