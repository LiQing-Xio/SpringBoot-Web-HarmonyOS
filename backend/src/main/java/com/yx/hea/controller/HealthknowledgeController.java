package com.yx.hea.controller;

import com.yx.hea.entity.Healthknowledge;
import com.yx.hea.service.IHealthknowledgeService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;


@Api(tags = "知识",value = "hea")
@CrossOrigin
@RestController
@RequestMapping("/hea/healthknowledge")
public class HealthknowledgeController {

    @Autowired
    IHealthknowledgeService healthknowledgeService;

    @GetMapping("/list")
    public List<Healthknowledge> list(){
        return healthknowledgeService.list();
    }

    @ApiOperation(value="添加/修改",notes = "添加/修改健康知识")
    @PostMapping("/save")
    public String save(@RequestBody Healthknowledge healthknowledge) {
        healthknowledgeService.saveOrUpdate(healthknowledge);
        return "success";
    }

    @ApiOperation(value="删除",notes = "删除健康知识")
    @GetMapping("/delete")
    public String delete(Long id) {
        healthknowledgeService.removeById(id);
        return "success";
    }
}
