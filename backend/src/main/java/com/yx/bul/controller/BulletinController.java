package com.yx.bul.controller;

import com.yx.bul.entity.Bulletin;
import com.yx.bul.model.BulletinQueryDTO;
import com.yx.bul.service.IBulletinService;
import com.yx.common.util.PageUtils;
import com.yx.drug.entity.Drug;
import com.yx.drug.model.DrugQueryDTO;
import com.yx.ech.entity.DataChart;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.stereotype.Controller;

import java.util.List;


@Api(tags = "公告",value = "Bulletin")
@CrossOrigin
@RestController
@RequestMapping("/bul/bulletin")
public class BulletinController {

    @Autowired
    IBulletinService bulletinService;

    @ApiOperation(value="查询",notes = "查询")
    @GetMapping("/list")
    public PageUtils list(@ApiParam(value = "查询的条件") BulletinQueryDTO queryDTO){

        return bulletinService.queryPage(queryDTO);

    }


    @ApiOperation(value="根据id查询",notes = "查询")
    @GetMapping("/queryBulById")
    public Bulletin queryPhaById(Long id){
        return bulletinService.queryPhaById(id);
    }

    @ApiOperation(value="添加",notes = "添加")
    @PostMapping("/save")
    public String save(@RequestBody Bulletin bulletin ) {
        bulletinService.saveOrUpdateDru(bulletin);
        return "success";
    }
    @ApiOperation(value="删除患者信息",notes = "删除患者信息")
    @GetMapping("/deleteBul")
    public String deleteDrug( Long id) {

        return  bulletinService.deleteDrugById(id);
    }



    @ApiOperation(value="查询图",notes = "查询图")
    @GetMapping("/getGg")
    public List<Bulletin> list(){
        return bulletinService.list();

    }

}
