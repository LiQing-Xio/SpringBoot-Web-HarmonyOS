package com.yx.ech.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.io.Serializable;
import java.math.BigDecimal;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

/**
 * <p>
 *
 * </p>
 *
 */
@TableName("data_chart")
@ApiModel(value = "DataChart对象", description = "")
public class DataChart implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(value = "id", type = IdType.AUTO)
    private Integer id;

    private String age;

    private BigDecimal value;

    private String chartType;

    // 新增字段
    private String date;
    private String email;

    @TableField("unionads")
    private String unionads;
    private String videods;
    private String direct;
    private String searchengine;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getAge() {
        return age;
    }

    public void setAge(String age) {
        this.age = age;
    }

    public BigDecimal getValue() {
        return value;
    }

    public void setValue(BigDecimal value) {
        this.value = value;
    }

    public String getChartType() {
        return chartType;
    }

    public void setChartType(String chartType) {
        this.chartType = chartType;
    }

    // 新增getter和setter方法
    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getUnionads() {
        return unionads;
    }

    public void setUnionads(String unionads) {
        this.unionads = unionads;
    }

    public String getVideods() {
        return videods;
    }

    public void setVideods(String videods) {
        this.videods = videods;
    }

    public String getDirect() {
        return direct;
    }

    public void setDirect(String direct) {
        this.direct = direct;
    }

    public String getSearchengine() {
        return searchengine;
    }

    public void setSearchengine(String searchengine) {
        this.searchengine = searchengine;
    }

    @Override
    public String toString() {
        return "DataChart{" +
            "id=" + id +
            ", age=" + age +
            ", value=" + value +
            ", chartType=" + chartType +
            ", date=" + date +
            ", email=" + email +
            ", unionads=" + unionads +
            ", videods=" + videods +
            ", direct=" + direct +
            ", searchengine=" + searchengine +
        "}";
    }
}
