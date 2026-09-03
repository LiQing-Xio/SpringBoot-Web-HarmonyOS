package com.yx.pat.controller;

import com.yx.common.util.PageUtils;
import com.yx.pat.entity.Patient;
import com.yx.pat.entity.Patienta;
import com.yx.pat.model.PatientQueryDTO;
import com.yx.pat.service.IPatientService;
import com.yx.sys.entity.SysUser;
import com.yx.sys.model.SysUserQueryDTO;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.stereotype.Controller;

import java.util.List;


@Api(tags = "患者",value = "Patient")
@CrossOrigin
@RestController//表示这是一个RESTful风格的控制器，会自动将返回对象转为JSON格式
@RequestMapping("/pat/patient")//定义控制器的基础路径为"/pat/patient"
public class PatientController {

    @Autowired//自动注入患者服务(IPatientService)，用于处理业务逻辑
    private IPatientService patientService;
    @ApiOperation(value="查询患者",notes = "查询患者")
    @GetMapping("/list")
    public PageUtils list(@ApiParam(value = "查询的条件") PatientQueryDTO queryDTO){

        return patientService.queryPage(queryDTO);

    }

    @ApiOperation(value="根据id查询",notes = "查询")
    @GetMapping("/queryPatById")
    public Patient queryPatById(Long id){
        return patientService.queryPatById(id);
    }


    @ApiOperation(value="添加患者信息",notes = "添加患者信息")
    @PostMapping("/save")
    public String save(@RequestBody Patient patient ) {
        patientService.saveOrUpdateUser(patient);
        return "success";
    }

    @ApiOperation(value="添加患者信息",notes = "添加患者信息")
    @PostMapping("/savepat")
    public String savepat(@RequestBody Patient patient ) {
        patientService.saveOrUpdateUserpat(patient);
        return "success";
    }

    @ApiOperation(value="删除患者信息",notes = "删除患者信息")
    @GetMapping("/deletePat")
    public String deletePat( Long id) {

        return  patientService.deletePatById(id);
    }

    @GetMapping("/ghlist")
    public List<Patienta> ghlist(){

        return patientService.ghqueryPage();

    }
    @ApiOperation(value="回复",notes = "回复")
    @PostMapping("/hfsave")
    public String hfsave(@RequestBody Patienta patienta ) {
        patientService.hfsaveOrUpdateUser(patienta);
        return "success";
    }
    @GetMapping("/inlist")
    public List<Patienta> inlist(){

        return patientService.byidlist();

    }
    @GetMapping("/jqlist")
    public List<Patienta> jqlist(){

        return patientService.byidjqlist();

    }

}
