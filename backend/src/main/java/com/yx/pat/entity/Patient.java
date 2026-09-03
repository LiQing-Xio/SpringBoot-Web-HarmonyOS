package com.yx.pat.entity;

import java.io.Serializable;
import java.time.LocalDateTime;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fasterxml.jackson.annotation.JsonFormat;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;



@TableName("patient")
@ApiModel(value = "Patient对象", description = "")
public class Patient implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(type = IdType.AUTO)
    private Long id;

    private String username;

    private Long phone;

    private String sex;

    private Long age;

    private String hf;

    public String getHf() {
        return hf;
    }

    public void setHf(String hf) {
        this.hf = hf;
    }

    @TableField("health_tag")
    private String healthTag;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @TableField("createTime")
    private LocalDateTime createTime;

    @TableField("idCard")
    private String idCard;

    private String address;

    @TableField("biood_type")
    private String bioodType;

    private String genetic;

    private String allergy;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }
    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }
    public Long getPhone() {
        return phone;
    }

    public void setPhone(Long phone) {
        this.phone = phone;
    }
    public String getSex() {
        return sex;
    }

    public void setSex(String sex) {
        this.sex = sex;
    }
    public Long getAge() {
        return age;
    }

    public void setAge(Long age) {
        this.age = age;
    }
    public String getHealthTag() {
        return healthTag;
    }

    public void setHealthTag(String healthTag) {
        this.healthTag = healthTag;
    }
    public LocalDateTime getCreateTime() {
        return createTime;
    }

    public void setCreateTime(LocalDateTime createTime) {
        this.createTime = createTime;
    }
    public String getIdCard() {
        return idCard;
    }

    public void setIdCard(String idCard) {
        this.idCard = idCard;
    }
    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }
    public String getBioodType() {
        return bioodType;
    }

    public void setBioodType(String bioodType) {
        this.bioodType = bioodType;
    }
    public String getGenetic() {
        return genetic;
    }

    public void setGenetic(String genetic) {
        this.genetic = genetic;
    }
    public String getAllergy() {
        return allergy;
    }

    public void setAllergy(String allergy) {
        this.allergy = allergy;
    }

    @Override
    public String toString() {
        return "Patient{" +
            "id=" + id +
            ", username=" + username +
            ", phone=" + phone +
            ", sex=" + sex +
            ", age=" + age +
            ", healthTag=" + healthTag +
            ", createTime=" + createTime +
            ", idCard=" + idCard +
            ", address=" + address +
            ", bioodType=" + bioodType +
            ", genetic=" + genetic +
            ", allergy=" + allergy +
        "}";
    }
}
