package com.yx.sys.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.io.Serializable;
import java.util.List;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;


@TableName("sys_menu")
@ApiModel(value = "SysMenu对象", description = "菜单管理")
public class SysMenu implements Serializable {

    private static final long serialVersionUID = 1L;

    @ApiModelProperty("菜单ID")
    @TableId(value = "menu_id", type = IdType.AUTO)
    private Long menuId;

    @ApiModelProperty("父菜单ID，一级菜单为0")
    private Long parentId;

    @ApiModelProperty("菜单名称")
    private String name; // 修改: private String label;

    @ApiModelProperty("菜单URL")
    private String url;

    @ApiModelProperty("授权(多个用逗号分隔，如：user:list,user:create)")
    private String perms;

    @ApiModelProperty("类型   0：目录   1：菜单   2：按钮")
    private Integer type;

    @ApiModelProperty("菜单图标")
    private String icon;

    @ApiModelProperty("排序")
    private Integer orderNum;

    @ApiModelProperty("菜单路径") // 新增
    private String path; // 新增

    @TableField(exist = false)//表示该字段不是数据库字段
    private List<SysMenu> children;

    @TableField(exist = false)//表示该字段不是数据库字段
    private boolean canBeDelete=false;

    public boolean isCanBeDelete() {
        return canBeDelete;
    }

    public void setCanBeDelete(boolean canBeDelete) {
        this.canBeDelete = canBeDelete;
    }

    public List<SysMenu> getChildren() {
        return children;
    }

    public void setChildren(List<SysMenu> children) {
        this.children = children;
    }

    public Long getMenuId() {
        return menuId;
    }

    public void setMenuId(Long menuId) {
        this.menuId = menuId;
    }

    public Long getParentId() {
        return parentId;
    }

    public void setParentId(Long parentId) {
        this.parentId = parentId;
    }

    public String getName() { // 修改: public String getLabel() {
        return name; // 修改: return label;
    }

    public void setName(String name) { // 修改: public void setLabel(String label) {
        this.name = name; // 修改: this.label = label;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public String getPerms() {
        return perms;
    }

    public void setPerms(String perms) {
        this.perms = perms;
    }

    public Integer getType() {
        return type;
    }

    public void setType(Integer type) {
        this.type = type;
    }

    public String getIcon() {
        return icon;
    }

    public void setIcon(String icon) {
        this.icon = icon;
    }

    public Integer getOrderNum() {
        return orderNum;
    }

    public void setOrderNum(Integer orderNum) {
        this.orderNum = orderNum;
    }

    public String getPath() { // 新增
        return path; // 新增
    }

    public void setPath(String path) { // 新增
        this.path = path; // 新增
    }

    @Override
    public String toString() {
        return "SysMenu{" +
            "menuId=" + menuId +
            ", parentId=" + parentId +
            ", name=" + name + // 修改: ", label=" + label +
            ", url=" + url +
            ", perms=" + perms +
            ", type=" + type +
            ", icon=" + icon +
            ", orderNum=" + orderNum +
            ", path=" + path + // 新增
        "}";
    }
}
