package com.yx.sys.service.impl;

import javax.annotation.Resource;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.yx.common.annotation.SystemLog;
import com.yx.common.constant.SystemConstant;
import com.yx.common.util.PageUtils;
import com.yx.sys.entity.SysRole;
import com.yx.sys.entity.SysUser;
import com.yx.sys.mapper.SysUserMapper;
import com.yx.sys.model.SysUserQueryDTO;
import com.yx.sys.service.ISysUserService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.yx.sys.mapper.SysUserRoleMapper;  // 新增
import com.yx.sys.mapper.SysRoleMapper;    // 新增

import java.time.LocalDateTime;
import java.util.List;

/**
 * <p>
 *  服务实现类
 * </p>
 *
 */
@Service
public class SysUserServiceImpl extends ServiceImpl<SysUserMapper, SysUser> implements ISysUserService {

    @Autowired
    private SysUserMapper sysUserMapper;
    @Override
    public List<SysUser> queryByUserName(String username) {
        QueryWrapper<SysUser> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq(StringUtils.isNotEmpty(username),"username",username);
        queryWrapper.eq("status", SystemConstant.USER_STATUS_NORMAL);
        return this.baseMapper.selectList(queryWrapper);
    }

    @Override
    public List<SysUser> salt() {
        UsernamePasswordAuthenticationToken authentication = (UsernamePasswordAuthenticationToken) SecurityContextHolder.getContext().getAuthentication();
        String userName = (String) authentication.getPrincipal();
        SysUser query = new SysUser();
        query.setUsername(userName);
        return this.queryUser(query);
    }

    @Override
    public void saveOrUpdateUser1(SysUser sysUser) {

        if (sysUser != null && sysUser.getUserId() != null && sysUser.getUserId() > 0) {
            // 更新
            this.updateById(sysUser);
        }
        else{
            //添加
            sysUser.setCreateTime(LocalDateTime.now());

            // 注册用户没有认证上下文，设置为null（自注册用户）
            sysUser.setCreateUserId(null);
            //密码需要做加密
            BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
            String password = encoder.encode(sysUser.getPassword());
            sysUser.setPassword(password);
            this.save(sysUser);


        }
    }

    @Override
    public PageUtils queryPage(SysUserQueryDTO queryDTO) {
        QueryWrapper<SysUser> wrapper = new QueryWrapper<SysUser>().
                like(StringUtils.isNotEmpty(queryDTO.getUserName()),
                        "username", queryDTO.getUserName()
                );
        Page<SysUser> page = this.page(queryDTO.page(), wrapper);

        return new PageUtils(page);
    }

    @Override
    public boolean checkUserName(String userName) {

        List<SysUser> list = baseMapper.selectList(new QueryWrapper<SysUser>().
                eq("username", userName));
       if(list != null && list.size() > 0){
           return true;
       }
        return false;
    }


    @Transactional
    @SystemLog("用户的添加/更新")
    @Override
    public void saveOrUpdateUser(SysUser sysUser) {
        if(sysUser.getUserId()>0){

            //更新
            this.updateById(sysUser);
        }
        else{
            //添加
            sysUser.setCreateTime(LocalDateTime.now());

            sysUser.setCreateUserId(this.getCurrentUserId());
            //密码需要做加密
            BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
            String password = encoder.encode(sysUser.getPassword());
            sysUser.setPassword(password);
            this.save(sysUser);


        }
        //角色分配保存
        if(sysUser.getUserId() > 0){
            this.baseMapper.deleteRoleByUserId(sysUser.getUserId());
        }
        if(sysUser.getRoleIds() != null && sysUser.getRoleIds().size()>0){
            for (Integer roleId : sysUser.getRoleIds()) {
                this.baseMapper.saveUserAndRole(sysUser.getUserId(),roleId);
            }
        }
    }
private  List<SysUser> queryUser(SysUser user){
        QueryWrapper<SysUser> wrapper = new QueryWrapper<>();
        wrapper.eq(StringUtils.isNotBlank(user.getUsername()),"username",user.getUsername())
                .eq(StringUtils.isNotBlank(user.getEmail()),"email",user.getEmail())
                .eq(StringUtils.isNotBlank(user.getMobile()),"mobile",user.getMobile())
                .eq(user.getUserId() != null && user.getUserId()>0,"user_id",user.getUserId());
        return this.baseMapper.selectList(wrapper);
}
    @Override
    public SysUser queryUserById(Long userId) {
        SysUser user = new SysUser();
        user.setUserId(userId);
        List<SysUser> list = queryUser(user);
        if(list != null && list.size()>0){
            SysUser sysUser = list.get(0);
            sysUser.setPassword(null);

            //根据当前用户查询角色信息
            List<Integer> roleIds = this.baseMapper.selectRoleIdsByUserId(sysUser.getUserId());
            sysUser.setRoleIds(roleIds);
            return sysUser;

        }

        return null;
    }

//     @Override
//     public String getrolename(String username) {
//        SysUser sysUser =  sysUserMapper.selectUserName(username);
//       if( sysUser.getUsername().equals("admin")){
//           return "超级管理员";
//       }
//       else {
//           return "家庭医生";
//       }
//     }
    // 新增：必须注入两个Mapper
    @Resource
    private SysUserRoleMapper sysUserRoleMapper;
    @Resource
    private SysRoleMapper sysRoleMapper;
    @Override
    public String getrolename(String username) {
        try {
            Long roleId = sysUserRoleMapper.getRoleIdByUsername(username);
            if (roleId == null) {
                return "普通用户";
            }
            String roleName = sysRoleMapper.getRoleNameByRoleId(roleId);
            return roleName == null ? "普通用户" : roleName;
        } catch (Exception e) {
            e.printStackTrace();
            return "普通用户";
        }
    }

    @Override
    public List<SysUser> inlist() {
        UsernamePasswordAuthenticationToken authentication = (UsernamePasswordAuthenticationToken) SecurityContextHolder.getContext().getAuthentication();
        String userName = (String) authentication.getPrincipal();

        return  sysUserMapper.selectbyname(userName);
    }

    @Override
    public void UpdateUser(SysUser sysUser) {
        if(sysUser.getUserId()>0){
            BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
            String password = encoder.encode(sysUser.getPassword());
            sysUser.setPassword(password);
            //更新
            this.updateById(sysUser);
        }
    }



    public  Long getCurrentUserId(){
        //设置添加数据账号
        UsernamePasswordAuthenticationToken authentication = (UsernamePasswordAuthenticationToken) SecurityContextHolder.getContext().getAuthentication();
        String userName = (String) authentication.getPrincipal();
        List<SysUser> list = this.baseMapper.selectList(new QueryWrapper<SysUser>().eq("username", userName));
   if(list !=null && list.size()==1){
       SysUser sysUser = list.get(0);
       return sysUser.getUserId();
   }
   return null;
    }
}
