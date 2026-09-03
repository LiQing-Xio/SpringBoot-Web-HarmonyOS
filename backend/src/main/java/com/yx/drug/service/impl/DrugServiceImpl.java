package com.yx.drug.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.yx.common.util.PageUtils;
import com.yx.drug.entity.Drug;
import com.yx.drug.mapper.DrugMapper;
import com.yx.drug.model.DrugQueryDTO;
import com.yx.drug.service.IDrugService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * <p>
 * 服务实现类
 * </p>
 *
 */
@Service
public class DrugServiceImpl extends ServiceImpl<DrugMapper, Drug> implements IDrugService {

    @Autowired
    DrugMapper drugMapper;

    @Override
    public PageUtils queryPage(DrugQueryDTO queryDTO) {
        {
            QueryWrapper<Drug> wrapper = new QueryWrapper<Drug>().
                    like(StringUtils.isNotEmpty(queryDTO.getDrugName()),
                            "drugname", queryDTO.getDrugName()
                    );
            Page<Drug> page = this.page(queryDTO.page(), wrapper);

            return new PageUtils(page);
        }
    }

    @Override
    public Drug queryPhaById(Long id) {
        return drugMapper.selectById(id);
    }

    @Override
    public void saveOrUpdateDru(Drug drug) {
        if (drug.getId() != null && drug.getId() > 0) {
            //更新
            this.updateById(drug);
        } else {
            //添加
            this.save(drug);

        }
    }

    @Override
    public String deleteDrugById(Long id) {
        this.removeById(id);
        return "1";
    }
}
