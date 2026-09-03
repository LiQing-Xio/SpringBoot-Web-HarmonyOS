package com.yx.users.service.impl;

import com.yx.users.entity.Users;
import com.yx.users.mapper.UsersMapper;
import com.yx.users.service.IUsersService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

@Service
public class UsersServiceImpl extends ServiceImpl<UsersMapper, Users> implements IUsersService {

}
