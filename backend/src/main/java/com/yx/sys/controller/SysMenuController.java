package com.yx.sys.controller;

import com.yx.common.constant.SystemConstant;
import com.yx.common.util.PageUtils;
import com.yx.sys.entity.SysMenu;
import com.yx.sys.model.ShowMenu;
import com.yx.sys.model.SysMenuQueryDTO;
import com.yx.sys.model.SysMenuUpdateDTO;
import com.yx.sys.service.ISysMenuService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.stereotype.Controller;

import java.util.List;

@Api(tags = "菜单",value = "SysMenu")
@CrossOrigin
@RestController
@RequestMapping("/sys/sysMenu")
public class SysMenuController {
    @Autowired
private ISysMenuService sysMenuService;
    @ApiOperation(value ="查询菜单信息" ,notes = "查询菜单信息")
    @RequestMapping("/list")
public PageUtils list( SysMenuQueryDTO dto){

        return sysMenuService.listPage(dto);
 }


    @ApiOperation(value ="查询父菜单信息" ,notes = "查询父菜单信息")
    @GetMapping("/listParent")
    public List<SysMenu> listParent(){

        return  sysMenuService.listParent();
    }

    @PostMapping("/save")
    public String save(@RequestBody SysMenu sysMenu){
        if (sysMenu != null){
            sysMenuService.saveOrUpdateMenu(sysMenu);
        }

        return SystemConstant.CHECK_SUCCESS;
    }

    @ApiOperation(value ="根据id查询" ,notes = "id查询")
    @GetMapping("/queryMenuById")
    public SysMenuUpdateDTO queryMenuById(Long menuId){
       SysMenu sysMenu= sysMenuService.queryMenuId(menuId);
        List<SysMenu> parents = sysMenuService.listParent();
        return  new SysMenuUpdateDTO(parents,sysMenu);
    }


    @GetMapping("/deleteMenu")
    public String deleteMenu(Long menuId){

        return   sysMenuService.deleteMenuById(menuId);
    }

    @ApiOperation(value ="获取当前登录菜单" )
    @GetMapping("/getShowMenu")
    public List<ShowMenu>  getShowMenu(){
        return  sysMenuService.getShowMenu();

    }
}
