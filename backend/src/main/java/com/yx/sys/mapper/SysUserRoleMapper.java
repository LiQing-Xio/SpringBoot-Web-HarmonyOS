package com.yx.sys.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.yx.sys.entity.SysUserRole;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

/**
 * <p>
 * 用户角色关联表 Mapper 接口
 * </p>
 */
@Mapper // 必须加这个注解
public interface SysUserRoleMapper extends BaseMapper<SysUserRole> {

    // 根据用户名查绑定的角色ID
    @Select("SELECT ur.role_id FROM sys_user u LEFT JOIN sys_user_role ur ON u.user_id = ur.user_id WHERE u.username = #{username} LIMIT 1")
    Long getRoleIdByUsername(String username);
}