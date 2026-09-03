package com.yx.drug.model;

import com.yx.common.model.PageDTO;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

@Data
public class DrugQueryDTO extends PageDTO {
    @ApiModelProperty("字段")
    private String drugName;
}
