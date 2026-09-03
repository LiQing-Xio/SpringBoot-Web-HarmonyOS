package com.yx.sys.service.impl;

import com.yx.sys.entity.SysRole;
import com.yx.sys.entity.SysUser;
import com.yx.sys.service.ISysRoleService;
import com.yx.sys.service.ISysUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;


@Service
public class UserDetailsServiceImpl implements UserDetailsService {
    @Autowired
    ISysUserService sysUserService;

    @Autowired
    ISysRoleService sysRoleService;
    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        System.out.println("===== loadUserByUsername 开始 =====");
        System.out.println("尝试登录的用户名: " + username);
        // 1.需要根据账号查询
        List<SysUser> list = sysUserService.queryByUserName(username);
        System.out.println("查询到的用户数量: " + (list != null ? list.size() : 0));
        if(list != null && list.size() == 1){
            // 账号是存在的
            SysUser sysUser = list.get(0);
            System.out.println("找到用户: " + sysUser.getUsername());
            System.out.println("数据库中的加密密码: " + sysUser.getPassword());
            System.out.println("密码长度: " + (sysUser.getPassword() != null ? sysUser.getPassword().length() : 0));
            // 根据当前登录的账号查询到关联的角色信息
            List<SysRole> sysRoles = sysRoleService.queryByUserId(sysUser.getUserId());
            List<GrantedAuthority> listRole = new ArrayList<>();
            if(sysRoles != null && sysRoles.size() > 0){
                for (SysRole sysRole : sysRoles) {
                    listRole.add(new SimpleGrantedAuthority(sysRole.getRoleName()));
                }
            }
            System.out.println("用户角色数量: " + listRole.size());
            // 密码模拟的是就数据库查询出来
            System.out.println("===== loadUserByUsername 结束 =====");
            return new User(sysUser.getUsername(),sysUser.getPassword(),listRole);
        }
        System.out.println("用户不存在，抛出异常");
        throw new UsernameNotFoundException("用户名不存在: " + username);
    }
}
