package com.yx.know.service;

import com.yx.common.util.PageUtils;
import com.yx.know.entity.Know;
import com.baomidou.mybatisplus.extension.service.IService;
import com.yx.know.model.KnowQueryDTO;

/**
 * <p>
 *  服务类
 * </p>
 *
 */
public interface IKnowService extends IService<Know> {

    PageUtils queryPage(KnowQueryDTO queryDTO);

    void saveOrUpdateKnow(Know know);

    Know queryPatById(Long id);

    String deleteKnowById(Long id);
}
