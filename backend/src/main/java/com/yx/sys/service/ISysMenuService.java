package com.yx.sys.service;

import com.yx.common.util.PageUtils;
import com.yx.sys.entity.SysMenu;
import com.baomidou.mybatisplus.extension.service.IService;
import com.yx.sys.model.ShowMenu;
import com.yx.sys.model.SysMenuQueryDTO;

import java.util.List;

/**
 * <p>
 * 菜单管理 服务类
 * </p>
 *
 */
public interface ISysMenuService extends IService<SysMenu> {

    PageUtils listPage(SysMenuQueryDTO dto);

    List<SysMenu> listParent();

    void saveOrUpdateMenu(SysMenu sysMenu);

    SysMenu queryMenuId(Long menuId);

    String deleteMenuById(Long menuId);

    List<Integer> queryMenuIdByRoleId(Long roleId);

    List<ShowMenu> getShowMenu();
}
