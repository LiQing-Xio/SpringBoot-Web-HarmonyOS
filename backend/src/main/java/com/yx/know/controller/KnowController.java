package com.yx.know.controller;

import com.yx.common.util.PageUtils;
import com.yx.drug.entity.Drug;
import com.yx.drug.model.DrugQueryDTO;
import com.yx.know.entity.Know;
import com.yx.know.model.KnowQueryDTO;
import com.yx.know.service.IKnowService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.stereotype.Controller;


@Api(tags = "知识",value = "Know")
@CrossOrigin
@RestController
@RequestMapping("/know/know")
public class KnowController {
    @Autowired
    IKnowService knowService;

    @ApiOperation(value="查询患者",notes = "查询患者")
    @GetMapping("/list")
    public PageUtils list(@ApiParam(value = "查询的条件") KnowQueryDTO queryDTO){

        return knowService.queryPage(queryDTO);

    }
    @ApiOperation(value="添加",notes = "添加")
    @PostMapping("/save")
    public String save(@RequestBody Know know ) {
        knowService.saveOrUpdateKnow(know);
        return "success";
    }

    @ApiOperation(value="根据id查询",notes = "查询")
    @GetMapping("/queryPatById")
public Know queryPatById(Long id) {
    return knowService.queryPatById(id);
}


    @ApiOperation(value="删除信息",notes = "删除信息")
    @GetMapping("/deleteKnow")
    public String deleteKnow( Long id) {

        return  knowService.deleteKnowById(id);
    }
}
