package com.yx.sys.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.yx.common.annotation.SystemLog;
import com.yx.common.util.PageUtils;
import com.yx.sys.entity.SysMenu;
import com.yx.sys.entity.SysRole;
import com.yx.sys.mapper.SysRoleMapper;
import com.yx.sys.model.SysRoleQueryDTO;
import com.yx.sys.service.ISysMenuService;
import com.yx.sys.service.ISysRoleService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * <p>
 * 角色表 服务实现类
 * </p>
 *
 */
@Service
public class SysRoleServiceImpl extends ServiceImpl<SysRoleMapper, SysRole> implements ISysRoleService {
    @Autowired
    private SysRoleMapper sysRoleMapper;

    @Autowired
    private ISysMenuService menuService;

    @Override
    public PageUtils queryPage(SysRoleQueryDTO queryDTO) {
        QueryWrapper<SysRole> wrapper = new QueryWrapper<SysRole>().
                like(StringUtils.isNotEmpty(queryDTO.getRoleName()),
                        "role_name", queryDTO.getRoleName()
                );
        Page<SysRole> page = this.page(queryDTO.page(), wrapper);

        return new PageUtils(page);
    }

    @SystemLog("添加或者更新角色")
    @Override
    @Transactional
    public void saveOrUpdateRole(SysRole role) {
        //同步维护菜单和角色的关系


        if (role.getRoleId() != null && role.getRoleId() != 0) {
            this.update(role);
            //根据roleid删除分配菜单的信息
            sysRoleMapper.deleteMenuByRoleId(role.getRoleId());
        }
        else {
            this.saveRole(role);
        }
        //新增分配菜单的信息
        List<Integer> menuIds = role.getMenuIds();
        if(menuIds != null && menuIds.size() > 0){
            //说明分配的有相关的菜单信息
            for (Integer menuId : menuIds) {
                sysRoleMapper.insterRoleAndMenu(role.getRoleId(), menuId);

            }
        }
    }

    @Override
    public void update(SysRole role) {

        this.baseMapper.updateById(role);
    }

    @Override
    public void deleteBatch(Long[] roleIds) {

    }

    @Override
    public boolean checkRoleName(String roleName) {
        if (StringUtils.isEmpty(roleName)) {
            return false;
        }
        QueryWrapper<SysRole> queryWrapper = new QueryWrapper<SysRole>().
                eq("role_name", roleName);
        int count = this.count(queryWrapper);

        return count > 0;


    }

    @SystemLog("删除角色")
    @Override
    public boolean deleteRoleById(Long roleId) {
        int count = this.baseMapper.checkRoleCanDelete(roleId);
        if (count == 0) {
            //表示可以删除
            this.baseMapper.deleteById(roleId);
        }
        return count == 0;
    }

    @Override
    public List<SysRole> queryByUserId(Long userId) {

        return sysRoleMapper.queryByUserId(userId);
    }

    @Override
    public Map<String, Object> disoatherRoleMenu(Long roleId) {
        // 查询出所有的菜单信息
        List<SysMenu> parents = menuService.listParent();
        List<Map<String,Object> > list = new ArrayList<>();
        if(parents != null && parents.size() > 0){
            for (SysMenu parent : parents) {
                Map<String,Object> map = new HashMap<>();
                map.put("id",parent.getMenuId());
                map.put("label",parent.getName());
                // 根据这个父菜单编号查询对应的子菜单信息
                Long parentId = parent.getMenuId();
                QueryWrapper<SysMenu> wrapper = new QueryWrapper<>();
                wrapper.eq("parent_id",parentId);
                List<SysMenu> subMenus = menuService.list(wrapper);
                List<Map<String,Object> > subList = new ArrayList<>();
                if(subMenus != null && subMenus.size() > 0){
                    for (SysMenu subMenu : subMenus) {
                        Map<String,Object> subMap = new HashMap<>();
                        subMap.put("id",subMenu.getMenuId());
                        subMap.put("label",subMenu.getName());
                        subList.add(subMap);
                    }
                }
                // 父子菜单关联
                map.put("children",subList);
                list.add(map);
            }
        }
        // 根据角色编号查询分配的菜单编号
        List<Integer> meundIds = menuService.queryMenuIdByRoleId(roleId);
        meundIds.add(43);
        Map<String,Object> resMap = new HashMap<>();
        resMap.put("checks",meundIds);
        resMap.put("treeData",list);
        return resMap;
    }


    public void saveRole(SysRole role) {
        role.setCreateTime(LocalDateTime.now());
        this.save(role);
    }
}
