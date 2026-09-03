package com.yx.sys.model;

import lombok.Getter;

import java.util.List;

public class ShowMenu {
    /*  path: "/MyOrder",
              name: "myOrder",
              label: "VIP订单",
              icon: "setting",
              url: "order/myOrder",*/
    @Getter
    private String path;
    private String name;
    private String label;
    private String icon;
    private String url;
    private List<ShowMenu> children;

    public String getPath() {
        return path;
    }

    public void setPath(String path) {
        this.path = path;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getLabel() {
        return label;
    }

    public void setLabel(String label) {
        this.label = label;
    }

    public String getIcon() {
        return icon;
    }

    public void setIcon(String icon) {
        this.icon = icon;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public List<ShowMenu> getChildren() {
        return children;
    }

    public void setChildren(List<ShowMenu> children) {
        this.children = children;
    }
}
