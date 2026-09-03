package com.yx.know.model;

import com.yx.common.model.PageDTO;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

@Data
public class KnowQueryDTO extends PageDTO {
    @ApiModelProperty("用户字段")
    private String name;

}
