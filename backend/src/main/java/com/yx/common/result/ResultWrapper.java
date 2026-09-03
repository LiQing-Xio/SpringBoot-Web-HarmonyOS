package com.yx.common.result;


import com.yx.common.execption.BaseResultCodeEnum;
import com.yx.common.execption.IResultCode;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;


/**
 * 响应数据的统一封装
 */
@Setter
@Getter
public class ResultWrapper<T> {
    @ApiModelProperty("状态码")
    private String code;
    @ApiModelProperty("内容")
    private String message;
    @ApiModelProperty("链路id")
    private String traceId;
    @ApiModelProperty("返回数据内容")
    private T data;

    public ResultWrapper() {
        this(BaseResultCodeEnum.SUCCESS.getCode(), BaseResultCodeEnum.SUCCESS.getMessage());
    }

    public ResultWrapper(String code, String message) {
        this.code = code;
        this.message = message;
    }

    public ResultWrapper(IResultCode resultCode) {
        this(resultCode.getCode(), resultCode.getMessage());
    }

    public ResultWrapper(IResultCode resultCode, T data) {
        this(resultCode);
        this.data = data;
    }

    public ResultWrapper(String code, String message, T data) {
        this(code, message);
        this.data = data;
    }

    public static <T> ResultWrapper<T> success(T data) {
        ResultWrapper<T> objectDataResult = new ResultWrapper<>();
        objectDataResult.setData(data);
        return objectDataResult;
    }

    public static <T> ResultWrapper<T> success() {
        ResultWrapper<T> objectDataResult = new ResultWrapper<>();
        objectDataResult.setData(null);
        return objectDataResult;
    }

    public static <T> ResultWrapper<T> fail(IResultCode resultCode, T t) {
        return new ResultWrapper<>(resultCode.getCode(), resultCode.getMessage(), t);
    }

    public static <T> ResultWrapper<T> fail(String code, String message, T t) {
        return new ResultWrapper<>(code, message, t);
    }

    public static <T> ResultWrapper<T> fail(IResultCode resultCode) {
        return new ResultWrapper<>(resultCode.getCode(), resultCode.getMessage(), null);
    }

    public static <T> ResultWrapper<T> fail(String code, String message) {
        return new ResultWrapper<>(code, message, null);
    }
}
