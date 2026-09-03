package com.yx.common.file;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
public class JsonResult {
    //状态码、提示消息、具体数据
    private Integer code;
    private String msg;
    private Object data;

//    /**
//     * 第1个构造方法:无参构造;
//     * 第2个构造方法:全参构造,用于有具体数据data返回的控制器方法.
//     */
//
//    /**
//     * 第3个构造方法:适用于没有具体数据data返回的控制器方法.
//     */
//    public JsonResult(Integer code, String msg) {
//        this.code = code;
//        this.msg = msg;
//    }

    /**
     * 构造方法:针对于没有具体数据返回的控制器方法,比如:登录、注册.
     */
    public JsonResult(StatusCode statusCode) {
        this.code = statusCode.getCode();
        this.msg = statusCode.getMsg();
    }

    /**
     * 构造方法:针对于有具体数据返回的控制器方法,比如:微博首页列表、微博详情页.
     */
    public JsonResult(StatusCode statusCode, Object data) {
        this.code = statusCode.getCode();
        this.msg = statusCode.getMsg();
        this.data = data;
    }

    /**
     * 进一步优化:
     *   1.针对于所有操作成功[OPERATION_SUCCESS]的场景;
     *   2.因为操作失败的场景每个业务功能都不一样,所以没有办法统一封装.
     * 定义2个静态方法:专门针对于操作成功的场景,用于快速构建JsonResult对象
     *   1.静态方法1：针对于有具体数据返回的控制器方法;
     *   2.静态方法2：针对于没有具体数据返回的控制器方法.
     */
    public static JsonResult ok(Object data){
        return new JsonResult(StatusCode.OPERATION_SUCCESS, data);
    }

    public static JsonResult ok(){
        return ok(null);
    }
}





















