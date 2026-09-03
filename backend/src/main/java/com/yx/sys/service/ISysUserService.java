package com.yx.sys.service;

import com.yx.common.util.PageUtils;
import com.yx.sys.entity.SysUser;
import com.baomidou.mybatisplus.extension.service.IService;
import com.yx.sys.model.SysUserQueryDTO;

import java.util.List;

/**
 * <p>
 *  服务类
 * </p>
 *
 */
public interface ISysUserService extends IService<SysUser> {

    List<SysUser> queryByUserName(String username);

    PageUtils queryPage(SysUserQueryDTO queryDTO);

    boolean checkUserName(String userName);

    void saveOrUpdateUser(SysUser sysUser);

    SysUser queryUserById(Long userId);

    String getrolename(String username);

    List<SysUser> inlist();

    void UpdateUser(SysUser sysUser);

    List<SysUser> salt();

    void saveOrUpdateUser1(SysUser sysUser);
}
