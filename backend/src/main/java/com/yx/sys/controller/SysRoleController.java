package com.yx.sys.controller;

import com.yx.common.constant.SystemConstant;
import com.yx.common.util.PageUtils;
import com.yx.sys.entity.SysRole;
import com.yx.sys.model.SysRoleQueryDTO;
import com.yx.sys.service.ISysRoleService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@Api(tags = "系统角色", value = "SysRole")
@CrossOrigin
@RestController
@RequestMapping("/sys/sysRole")
public class SysRoleController {
    @Autowired
    private ISysRoleService roleService;

    @ApiOperation(value = "角色查询分页", notes = "角色信息")
    @GetMapping("/list")
    public PageUtils list(@ApiParam(value = "查询的条件") SysRoleQueryDTO queryDTO) {
        return roleService.queryPage(queryDTO);
    }

    @GetMapping("/listAll")
    public List<SysRole> listAll() {
        return roleService.list();
    }

    @ApiOperation(value = "角色添加", notes = "角色添加")
    @PostMapping("/save")
    public String save(@RequestBody SysRole sysRole) {
        roleService.saveOrUpdateRole(sysRole);
        return "success";
    }

    @ApiOperation(value = "检查是否存在（角色）", notes = "检查角色")
    @GetMapping("/checkRoleName")
    public String checkRoleName(String roleName) {
        boolean flag = roleService.checkRoleName(roleName);
        return flag ? "success" : "fail";
    }


    @GetMapping("/deleteRole")
    public String deleteRole(Long roleId) {
        boolean flag = roleService.deleteRoleById(roleId);
        return flag ? SystemConstant.CHECK_SUCCESS : SystemConstant.CHECK_FAIL;
    }

    @GetMapping("/disoatherRoleMenu")
    public Map<String,Object> disoatherRoleMenu(Long roleId) {

        return  roleService.disoatherRoleMenu(roleId);
    }


}
