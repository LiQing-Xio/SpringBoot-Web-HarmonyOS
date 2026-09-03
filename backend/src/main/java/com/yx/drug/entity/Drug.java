package com.yx.drug.entity;

import java.io.Serializable;

import com.baomidou.mybatisplus.annotation.TableName;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

/**
 * <p>
 *
 * </p>
 *
 */
@TableName("drug")
@ApiModel(value = "Drug对象", description = "药品")
public class Drug implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long id;

    private String drugname;

    private String manufacturer;

    private String batchnumber;

    private String specification;

    private Long price;

    private Long number;

    private Integer status;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }
    public String getDrugname() {
        return drugname;
    }

    public void setDrugname(String drugname) {
        this.drugname = drugname;
    }
    public String getManufacturer() {
        return manufacturer;
    }

    public void setManufacturer(String manufacturer) {
        this.manufacturer = manufacturer;
    }
    public String getBatchnumber() {
        return batchnumber;
    }

    public void setBatchnumber(String batchnumber) {
        this.batchnumber = batchnumber;
    }
    public String getSpecification() {
        return specification;
    }

    public void setSpecification(String specification) {
        this.specification = specification;
    }
    public Long getPrice() {
        return price;
    }

    public void setPrice(Long price) {
        this.price = price;
    }
    public Long getNumber() {
        return number;
    }

    public void setNumber(Long number) {
        this.number = number;
    }
    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "Drug{" +
            "id=" + id +
            ", drugname=" + drugname +
            ", manufacturer=" + manufacturer +
            ", batchnumber=" + batchnumber +
            ", specification=" + specification +
            ", price=" + price +
            ", number=" + number +
            ", status=" + status +
        "}";
    }
}
