package com.yx.ech.mapper;

import com.yx.ech.entity.DataChart;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;


public interface DataChartMapper extends BaseMapper<DataChart> {

    void insertValue(long a);
}
