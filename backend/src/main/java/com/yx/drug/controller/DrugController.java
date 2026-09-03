package com.yx.drug.controller;

import com.yx.common.util.PageUtils;
import com.yx.drug.entity.Drug;
import com.yx.drug.model.DrugQueryDTO;
import com.yx.drug.service.IDrugService;
import com.yx.pat.entity.Patient;
import com.yx.pat.model.PatientQueryDTO;
import com.yx.pat.service.IPatientService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.stereotype.Controller;

/**
 * <p>
 *  前端控制器
 * </p>
 *
 */
@Api(tags = "药品",value = "Drug")
@CrossOrigin
@RestController
@RequestMapping("/drug/drug")
public class DrugController {
    @Autowired
    private IDrugService drugService;

    @ApiOperation(value="查询患者",notes = "查询患者")
    @GetMapping("/list")
    public PageUtils list(@ApiParam(value = "查询的条件") DrugQueryDTO queryDTO){

        return drugService.queryPage(queryDTO);

    }
    @ApiOperation(value="根据id查询",notes = "查询")
    @GetMapping("/queryPhaById")
    public Drug queryPhaById(Long id){
        return drugService.queryPhaById(id);
    }

    @ApiOperation(value="添加",notes = "添加")
    @PostMapping("/save")
    public String save(@RequestBody Drug drug ) {
        drugService.saveOrUpdateDru(drug);
        return "success";
    }
    @ApiOperation(value="删除患者信息",notes = "删除患者信息")
    @GetMapping("/deleteDrug")
    public String deleteDrug( Long id) {

        return  drugService.deleteDrugById(id);
    }


}
