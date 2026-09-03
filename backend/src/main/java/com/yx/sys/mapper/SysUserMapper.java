package com.yx.sys.mapper;

import com.yx.sys.entity.SysUser;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * <p>
 *  Mapper 接口
 * </p>
 *
 */
public interface SysUserMapper extends BaseMapper<SysUser> {

    void deleteRoleByUserId(@Param("userId") Long userId);

    void saveUserAndRole(@Param("userId")Long userId, @Param("roleId")Integer roleId);

    List<Integer> selectRoleIdsByUserId(@Param("userId") Long userId);

    SysUser selectUserName(String username);

    List<SysUser> selectbyname(String userName);
}
