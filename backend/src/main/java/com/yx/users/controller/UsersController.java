package com.yx.users.controller;

import com.yx.common.constant.SystemConstant;
import com.yx.users.service.IUsersService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RestController;

@Api(tags = "系统用户",value = "SysUser")
@CrossOrigin
@RestController
@RequestMapping("/users/users")
public class UsersController {
    @Autowired
    private IUsersService usersService;


}
