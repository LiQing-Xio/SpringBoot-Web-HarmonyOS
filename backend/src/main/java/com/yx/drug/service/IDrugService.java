package com.yx.drug.service;

import com.yx.common.util.PageUtils;
import com.yx.drug.entity.Drug;
import com.baomidou.mybatisplus.extension.service.IService;
import com.yx.drug.model.DrugQueryDTO;
import com.yx.pat.entity.Patient;

/**
 * <p>
 *  服务类
 * </p>
 *
 */
public interface IDrugService extends IService<Drug> {

    PageUtils queryPage(DrugQueryDTO queryDTO);

    Drug queryPhaById(Long id);

    void saveOrUpdateDru(Drug drug);

    String deleteDrugById(Long id);
}
