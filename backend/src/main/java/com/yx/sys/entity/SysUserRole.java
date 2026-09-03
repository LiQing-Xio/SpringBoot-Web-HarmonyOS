package com.yx.sys.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import java.io.Serializable;

/**
 * <p>
 * 用户角色关联表
 * </p>
 */
@TableName("sys_user_role") // 必须和你数据库的关联表名一致！
public class SysUserRole implements Serializable {

    private static final long serialVersionUID = 1L;

    // 用户ID（和sys_user表的user_id对应）
    private Long userId;

    // 角色ID（和sys_role表的role_id对应）
    private Long roleId;

    // getter/setter 必须加
    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public Long getRoleId() {
        return roleId;
    }

    public void setRoleId(Long roleId) {
        this.roleId = roleId;
    }

    @Override
    public String toString() {
        return "SysUserRole{" +
                "userId=" + userId +
                ", roleId=" + roleId +
                '}';
    }
}