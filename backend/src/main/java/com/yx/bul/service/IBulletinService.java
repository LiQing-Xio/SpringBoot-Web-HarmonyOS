package com.yx.bul.service;

import com.yx.bul.entity.Bulletin;
import com.baomidou.mybatisplus.extension.service.IService;
import com.yx.bul.model.BulletinQueryDTO;
import com.yx.common.util.PageUtils;


public interface IBulletinService extends IService<Bulletin> {

    PageUtils queryPage(BulletinQueryDTO queryDTO);

    Bulletin queryPhaById(Long id);

    void saveOrUpdateDru(Bulletin bulletin);

    String deleteDrugById(Long id);
}
