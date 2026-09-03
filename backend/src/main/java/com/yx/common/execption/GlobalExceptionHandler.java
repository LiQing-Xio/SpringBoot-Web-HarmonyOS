package com.yx.common.execption;


import com.google.common.collect.Lists;
import com.yx.common.result.ResultWrapper;
import com.yx.common.util.RequestContextUtils;
import com.yx.common.util.SpringContextUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.annotation.Order;
import org.springframework.http.HttpStatus;
import org.springframework.validation.BindException;
import org.springframework.validation.FieldError;
import org.springframework.validation.ObjectError;
import org.springframework.web.HttpRequestMethodNotSupportedException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.method.annotation.MethodArgumentTypeMismatchException;

import javax.validation.ConstraintViolation;
import javax.validation.ConstraintViolationException;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;


/**
 * 自定义的全局异常处理器
 */
@Slf4j
@ControllerAdvice
@Order(ExceptionOrderConstant.EXCEPTION_ORDER_LOW)
public class GlobalExceptionHandler {

    /**
     * 处理全局异常
     */
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    @ResponseBody
    @ExceptionHandler(Exception.class)
    public ResultWrapper<Object> exception(Exception exception) {
        log.error("系统异常", exception);
        return ResultWrapper.fail(BaseResultCodeEnum.SYSTEM_ERROR, getErrorMsgByEnvironment(exception));
    }


    /**
     * 处理业务异常，BizException
     */
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    @ResponseBody
    @ExceptionHandler(BizException.class)
    public ResultWrapper<Object> bizException(BizException bizException) {
        log.warn("业务异常 {}", bizException.getMessage());
        return ResultWrapper.fail(bizException.getCode(), bizException.getMsg());
    }

    /**
     * validate 参数校验错误异常
     */
    @ResponseBody
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResultWrapper<Object> methodArgumentNotValidException(MethodArgumentNotValidException methodArgumentNotValidException) {
        log.error("参数异常 {}", methodArgumentNotValidException.getMessage());
        List<ObjectError> allErrors = methodArgumentNotValidException.getBindingResult().getAllErrors();
        return ResultWrapper.fail(BaseResultCodeEnum.ILLEGAL_ARGUMENT.getCode(), this.getParamErrorMsg(allErrors));
    }

    /**
     * validate 参数校验错误异常
     */
    @ResponseBody
    @ExceptionHandler(value = BindException.class)
    public ResultWrapper<Object> bindException(BindException e) {
        log.error("参数异常 {}", e.getMessage());
        List<ObjectError> allErrors = e.getAllErrors();
        return ResultWrapper.fail(BaseResultCodeEnum.ILLEGAL_ARGUMENT.getCode(), this.getParamErrorMsg(allErrors));
    }

    /**
     * validate 参数校验错误异常
     */
    @ResponseBody
    @ExceptionHandler(value = ConstraintViolationException.class)
    public ResultWrapper<Object> constraintViolationException(ConstraintViolationException e) {
        log.error("参数异常 {}", e.getMessage());
        Set<ConstraintViolation<?>> violations = e.getConstraintViolations();
        List<String> errorArr = violations.stream().map(ConstraintViolation::getMessage).collect(Collectors.toList());
        String errMsg = String.join(" ", errorArr.toArray(new String[]{}));
        return ResultWrapper.fail(BaseResultCodeEnum.ILLEGAL_ARGUMENT.getCode(), errMsg);
    }

    /**
     * 参数异常，举例 String cast to java.lang.integer
     */
    @ResponseBody
    @ExceptionHandler(value = MethodArgumentTypeMismatchException.class)
    public ResultWrapper<Object> methodArgumentTypeMismatchException(MethodArgumentTypeMismatchException e) {
        log.error("参数类型异常 uri {} {}", RequestContextUtils.getRequestUri(), e.getMessage());
        return ResultWrapper.fail(BaseResultCodeEnum.ILLEGAL_ARGUMENT, e.getMessage());
    }

    /**
     * 请求方式错误 get接口， post方式请求
     */
    @ResponseBody
    @ExceptionHandler(value = HttpRequestMethodNotSupportedException.class)
    public ResultWrapper<Object> httpRequestMethodNotSupportedException(HttpRequestMethodNotSupportedException e) {
        log.error("请求异常 uri {} {}", RequestContextUtils.getRequestUri(), e.getMessage());
        return ResultWrapper.fail(BaseResultCodeEnum.ILLEGAL_REQUEST.getCode(), BaseResultCodeEnum.ILLEGAL_REQUEST.getText());
    }

    private String getParamErrorMsg(List<ObjectError> allErrors) {
        List<String> errorArr = Lists.newArrayList();
        for (ObjectError error : allErrors) {
            if (error instanceof FieldError) {
                FieldError fieldError = (FieldError) error;
                errorArr.add(fieldError.getField() + " " + fieldError.getDefaultMessage());
            } else {
                errorArr.add(error.getDefaultMessage());
            }
        }
        return String.join(" ", errorArr.toArray(new String[]{}));
    }

    private String getErrorMsgByEnvironment(Exception exception) {
        StringBuilder errorMsg = new StringBuilder();
        if (SpringContextUtil.isDev() || SpringContextUtil.isTest() || SpringContextUtil.isProd()) {
            errorMsg.append(exception.toString());
            for (StackTraceElement stackTraceElement : exception.getStackTrace()) {
                // 将堆栈信息中第一个业务代码的位置显示出来
                if (stackTraceElement.toString().contains("com.msb")) {
                    errorMsg.append(stackTraceElement);
                    break;
                }
            }
        }
        return errorMsg.toString();
    }

}
