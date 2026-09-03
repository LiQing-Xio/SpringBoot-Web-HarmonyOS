package com.yx.yytx.entity;

import java.io.Serializable;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

/**
 * <p>
 *
 * </p>
 *
 */
@ApiModel(value = "Yytx对象", description = "")
@TableName("yytx")
public class Yytx implements Serializable {

    private static final long serialVersionUID = 1L;

    private Integer id;

    @TableField("newReminder")
    private String newReminder;

    private String time;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }
    public String getNewReminder() {
        return newReminder;
    }

    public void setNewReminder(String newReminder) {
        this.newReminder = newReminder;
    }
    public String getTime() {
        return time;
    }

    public void setTime(String time) {
        this.time = time;
    }

    @Override
    public String toString() {
        return "Yytx{" +
            "id=" + id +
            ", newReminder=" + newReminder +
            ", time=" + time +
        "}";
    }
}
