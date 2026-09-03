package com.yx.common.annotation;

import java.lang.annotation.*;

////日志注解
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface SystemLog {


        String value() default "";

}
