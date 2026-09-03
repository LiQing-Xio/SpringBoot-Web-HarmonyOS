package com.yx.bul.model;

import com.yx.common.model.PageDTO;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

@Data
public class BulletinQueryDTO extends PageDTO {
    @ApiModelProperty("字段")
    private String content;
}
