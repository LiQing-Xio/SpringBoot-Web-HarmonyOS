package com.yx.sys.mapper;

import com.yx.sys.entity.SysRole;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

/**
 * <p>
 * 角色表 Mapper 接口
 * </p>
 *
 */
public interface SysRoleMapper extends BaseMapper<SysRole> {

    int checkRoleCanDelete(@Param("roleId") Long roleId);

    List<SysRole> queryByUserId(Long userId);

    void deleteMenuByRoleId(@Param("roleId") Long roleId);

    void insterRoleAndMenu(@Param("roleId") Long roleId, @Param("menuId") Integer menuId);

    // 新增：根据角色ID查询角色名（核心）
    @Select("SELECT role_name FROM sys_role WHERE role_id = #{roleId}")
    String getRoleNameByRoleId(Long roleId);
}
