package com.yx.sys.controller;

import com.yx.common.constant.SystemConstant;
import com.yx.common.util.PageUtils;
import com.yx.sys.entity.SysRole;
import com.yx.sys.entity.SysUser;
import com.yx.sys.model.SysRoleQueryDTO;
import com.yx.sys.model.SysUserQueryDTO;
import com.yx.sys.service.ISysRoleService;
import com.yx.sys.service.ISysUserService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.stereotype.Controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


@Api(tags = "系统用户",value = "SysUser")
@CrossOrigin
@RestController
@RequestMapping("/sys/sysUser")
public class SysUserController {

    @Autowired
    private ISysUserService userService;

    @Autowired
    private ISysRoleService roleService;

  @ApiOperation(value="查询系统用户",notes = "查询用户")
   @GetMapping("/list")
    public PageUtils list(@ApiParam(value = "查询的条件") SysUserQueryDTO queryDTO){
      return userService.queryPage(queryDTO);

    }

    @ApiOperation(value="账号验证是否存在",notes = "账号")
    @GetMapping("/checkUserName")
    public String checkUserName( String username) {
        boolean flag = userService.checkUserName(username);
        return flag? SystemConstant.CHECK_SUCCESS :SystemConstant.CHECK_FAIL;
    }

    @ApiOperation(value="添加账号",notes = "添加账号")
    @PostMapping("/save")
    public String save(@RequestBody SysUser sysUser ) {
        sysUser.setSalt("1");
      userService.saveOrUpdateUser(sysUser);
        return "success";
    }



    @ApiOperation(value="添加账号",notes = "添加账号")
    @PostMapping("/register")
    public String register(@RequestBody SysUser sysUser ) {
      sysUser.setStatus(1);
      sysUser.setSalt("0");
        userService.saveOrUpdateUser1(sysUser);
        return "success";
    }
    @GetMapping("/queryUserById")
    public Map<String,Object> queryUserById(Long userId){
        SysUser sysUser = userService.queryUserById(userId);
        List<SysRole> roles = roleService.list();
        Map<String,Object> map = new HashMap<>();
        map.put("roles",roles);
        map.put("user",sysUser);
        return map;
    }
    @GetMapping("/getrole")
    public String getrole(String username){

        return userService.getrolename(username);
    }
    @GetMapping("/inlist")
    public List<SysUser> inlist(){
        return userService.inlist();
    }
    @ApiOperation(value="添加账号",notes = "添加账号")
    @PostMapping("/insave")
    public String insave(@RequestBody SysUser sysUser ) {
        userService.UpdateUser(sysUser);
        return "success";
    }

    @ApiOperation(value="账号验证是否存在",notes = "账号")
    @GetMapping("/salt")
    public List<SysUser> salt( ) {

        return userService.salt();
    }
}
