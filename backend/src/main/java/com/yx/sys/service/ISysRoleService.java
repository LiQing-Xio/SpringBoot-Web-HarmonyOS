package com.yx.sys.service;

import com.yx.common.util.PageUtils;
import com.yx.sys.entity.SysRole;
import com.baomidou.mybatisplus.extension.service.IService;
import com.yx.sys.model.SysRoleQueryDTO;

import java.util.List;
import java.util.Map;

/**
 * <p>
 * 角色表 服务类
 * </p>
 *
 */
public interface ISysRoleService extends IService<SysRole> {
    PageUtils queryPage(SysRoleQueryDTO queryDTO);
    void saveOrUpdateRole(SysRole role);
    void update(SysRole role);
    void deleteBatch(Long[] roleIds);

    boolean checkRoleName(String roleName);

    boolean deleteRoleById(Long roleId);


    List<SysRole> queryByUserId(Long userId);

    Map<String, Object> disoatherRoleMenu(Long roleId);
}
