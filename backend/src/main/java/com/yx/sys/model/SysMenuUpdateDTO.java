package com.yx.sys.model;

import com.yx.common.model.PageDTO;
import com.yx.sys.entity.SysMenu;
import io.swagger.annotations.ApiModelProperty;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class SysMenuUpdateDTO extends PageDTO {
    @ApiModelProperty("更新数据需要的dto")
   private List<SysMenu> parents;
    private SysMenu children;
}
