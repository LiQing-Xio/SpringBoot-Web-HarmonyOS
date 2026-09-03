package com.yx.sys.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.yx.common.annotation.SystemLog;
import com.yx.common.util.PageUtils;
import com.yx.sys.entity.SysMenu;
import com.yx.sys.mapper.SysMenuMapper;
import com.yx.sys.model.ShowMenu;
import com.yx.sys.model.SysMenuQueryDTO;
import com.yx.sys.service.ISysMenuService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestBody;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * <p>
 * 菜单管理 服务实现类
 * </p>
 *
 */
@Service
public class SysMenuServiceImpl extends ServiceImpl<SysMenuMapper, SysMenu> implements ISysMenuService {

    @Autowired
    private SysMenuMapper sysMenuMapper;
    @Override
    public PageUtils listPage(SysMenuQueryDTO dto) {
        //先查出所有一级菜单数据，分页是针对一级的数据分页
        QueryWrapper<SysMenu> wrapper = new QueryWrapper<>();
        wrapper.eq("parent_id",0)//查询所有一级菜单
                .like(StringUtils.isNotBlank(dto.getName()),"name",dto.getName())
                .orderByAsc("order_num");
        Page<SysMenu> page = this.page(dto.page(), wrapper);
        //查询出该一级菜单下的所有二级菜单
        List<SysMenu> list = page.getRecords();
        List<SysMenu> menus = list.stream().map(item -> {
            //有子菜单

            Long menuId = item.getMenuId();
           // System.out.println(menuId+"***********************************");
            //判断当前菜单是否可以被删除
            int count = sysMenuMapper.canBeDelete(menuId);
            if (count == 0) {
                item.setCanBeDelete(true);
            }
            else {
                item.setCanBeDelete(false);
            }

            //查询出该一级菜单下的所有二级菜单
            QueryWrapper<SysMenu> wrapper1 = new QueryWrapper<>();
            wrapper1.eq("parent_id", menuId)
                    .orderByAsc("order_num");
            List<SysMenu> subMenus = this.baseMapper.selectList(wrapper1);
            for (SysMenu subMenu : subMenus) {
                //判断当前菜单是否可以被删除
                int count1 = sysMenuMapper.canBeDelete(subMenu.getMenuId());
                if (count1 == 0) {
                    subMenu.setCanBeDelete(true);
                }
                else {
                    subMenu.setCanBeDelete(false);
                }
            }
            item.setChildren(subMenus);
            return item;
        }).collect(Collectors.toList());
        page.setRecords(menus);

        return new PageUtils(page);
    }

    @Override
    public List<SysMenu> listParent() {
        List<SysMenu> list = this.baseMapper.selectList(new QueryWrapper<SysMenu>().eq("parent_id", 0));
//        SysMenu menu = new SysMenu();
//        menu.setMenuId(-1l);
//        menu.setParentId(0l);
//        menu.setName("一级菜单");
//        list.add(menu);
        return list;
    }

    @SystemLog("菜单更新/添加")
    @Override
    public void saveOrUpdateMenu(@RequestBody SysMenu sysMenu) {
        if (sysMenu.getMenuId() > 0)
        {
            //更新
            this.updateById(sysMenu);
        }
        else {
            if (sysMenu.getParentId() == null){
                sysMenu.setParentId(0l);}

            //新增
            this.save(sysMenu);
        }
    }

    @Override
    public SysMenu queryMenuId(Long menuId) {
        return baseMapper.selectById(menuId);
    }

    @SystemLog("删除菜单")
    @Override
    public String deleteMenuById(Long menuId) {

        int count = sysMenuMapper.canBeDelete(menuId);
        if(count == 0){
            //可以删除
            this.baseMapper.deleteById(menuId);
            return "1";
        }
        //不能删除
        return "0";
    }

    @Override
    public List<Integer> queryMenuIdByRoleId(Long roleId) {

        return sysMenuMapper.queryMenuIdByRoleId(roleId);
    }

    @Override
    public List<ShowMenu> getShowMenu() {
        //获取当前登录用户
        UsernamePasswordAuthenticationToken token = (UsernamePasswordAuthenticationToken) SecurityContextHolder.getContext().getAuthentication();
        String username = token.getPrincipal().toString();

        //查询出当前用户所拥有的菜单
        List<SysMenu> list = sysMenuMapper.SelectShowMenuParentByUserNmae(username);
        if(list != null && list.size()>0){
            return   list.stream().map(item -> {
                ShowMenu showMenu = new ShowMenu();
                showMenu.setIcon(item.getIcon());
                showMenu.setLabel(item.getName());
                showMenu.setPath(item.getPath());
                showMenu.setUrl(item.getUrl());
                showMenu.setName(item.getName());
                //获取对应子菜单
                List<SysMenu> subList =   this.baseMapper.selectShowMenuSubByUserNmae(username,item.getMenuId());
                if(subList != null && subList.size()>0){
                    List<ShowMenu> showMenus = new ArrayList<>();
                    for (SysMenu sysMenu : subList) {
                        ShowMenu subMenu = new ShowMenu();
                        subMenu.setIcon(sysMenu.getIcon());
                        subMenu.setLabel(sysMenu.getName());
                        subMenu.setPath(sysMenu.getPath());
                        subMenu.setUrl(sysMenu.getUrl());
                        subMenu.setName(sysMenu.getName());
                        showMenus.add(subMenu);
                    }
                    showMenu.setChildren(showMenus);
                }

                return showMenu;
            }).collect(Collectors.toList());
        }

    return null;
    }
}
