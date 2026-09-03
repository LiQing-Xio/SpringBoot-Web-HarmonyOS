package com.yx.common.file;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
@Getter
@NoArgsConstructor
@AllArgsConstructor
public enum StatusCode {
    NOT_LOGIN(1000, "未登录"),
    LOGIN_SUCCESS(1001, "登录成功"),
    PASSWORD_ERROR(1002, "密码错误"),
    USERNAME_ERROR(1003, "用户名错误"),
    USERNAME_ALREADY_EXISTS(1004, "用户名被占用"),
    OPERATION_SUCCESS(2001, "操作成功"),
    OPERATION_FAILED(2002, "操作失败"),
    THROWABLE_ERROR(8000, "Throwable异常"),
    VALIDATED_ERROR(3001, "参数校验失败"),
    DATA_UNEXISTS(5004, "请求数据不存在");
    private Integer code;
    private String msg;
}








