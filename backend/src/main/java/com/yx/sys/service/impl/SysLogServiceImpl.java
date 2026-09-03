package com.yx.sys.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.yx.common.util.PageUtils;
import com.yx.sys.entity.SysLog;
import com.yx.sys.mapper.SysLogMapper;
import com.yx.sys.model.SysLogQueryDTO;
import com.yx.sys.service.ISysLogService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

/**
 * <p>
 * 系统日志 服务实现类
 * </p>
 *
 */
@Service
public class SysLogServiceImpl extends ServiceImpl<SysLogMapper, SysLog> implements ISysLogService {

    @Override
    public PageUtils listPage(SysLogQueryDTO dto) {
        QueryWrapper<SysLog> wrapper = new QueryWrapper<SysLog>();
        if(StringUtils.isNotEmpty(dto.getMsg())){
            System.out.println("---------->");
            wrapper.and(item->{
                item.like("username",dto.getMsg())
                        .or().like("operation",dto.getMsg());
            });
        }

        Page<SysLog> page = this.page(dto.page(), wrapper);
        return new PageUtils(page);
    }

}
