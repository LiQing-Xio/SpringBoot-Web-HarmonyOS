package com.yx.sys.service;

import com.yx.common.util.PageUtils;
import com.yx.sys.entity.SysLog;
import com.baomidou.mybatisplus.extension.service.IService;
import com.yx.sys.model.SysLogQueryDTO;

/**
 * <p>
 * 系统日志 服务类
 * </p>
 *
 */
public interface ISysLogService extends IService<SysLog> {

    PageUtils listPage(SysLogQueryDTO dto);
}
