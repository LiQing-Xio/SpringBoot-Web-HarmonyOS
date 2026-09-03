package com.yx.sys.mapper;

import com.yx.sys.entity.SysMenu;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

/**
 * <p>
 * 菜单管理 Mapper 接口
 * </p>
 *
 */
public interface SysMenuMapper extends BaseMapper<SysMenu> {

    @Select("SELECT menu_id, parent_id, label, url, perms, type, icon, order_num FROM sys_menu WHERE parent_id = #{parentId} LIMIT #{page.offset}, #{page.size}")
    List<SysMenu> selectListByParentId(@Param("parentId") Long parentId, @Param("page") Page<SysMenu> page);


    int canBeDelete(Long menuId);

    List<Integer> queryMenuIdByRoleId(@Param("roleId") Long roleId);

    List<SysMenu> SelectShowMenuParentByUserNmae(@Param("username") String username);

    List<SysMenu> selectShowMenuSubByUserNmae(@Param("username")String username, @Param("menuId") Long menuId);
}
