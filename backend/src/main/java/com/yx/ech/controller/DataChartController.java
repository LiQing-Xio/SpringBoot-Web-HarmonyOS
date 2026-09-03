package com.yx.ech.controller;

import com.yx.ech.entity.DataChart;
import com.yx.ech.service.IDataChartService;
import com.yx.sys.entity.SysUser;
import com.yx.sys.service.ISysUserService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;


@Api(tags = "图表",value = "DataChart")
@CrossOrigin
@RestController
@RequestMapping("/ech/dataChart")
public class DataChartController {
    @Autowired
    private IDataChartService dataChartService;

    @ApiOperation(value="查询图",notes = "查询图")
    @GetMapping("/list")
    public List<DataChart> list(){
        return dataChartService.list();

    }
}
