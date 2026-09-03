package com.yx.know.entity;

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
@TableName("know")
@ApiModel(value = "Know对象", description = "know")
public class Know implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long id;

    private String name;

    private String img;

    private String content;

    private String type;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getImg() {
        return img;
    }

    public void setImg(String img) {
        this.img = img;
    }
    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }
    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    @Override
    public String toString() {
        return "Know{" +
            "id=" + id +
            ", name=" + name +
            ", img=" + img +
            ", content=" + content +
            ", type=" + type +
        "}";
    }
}
