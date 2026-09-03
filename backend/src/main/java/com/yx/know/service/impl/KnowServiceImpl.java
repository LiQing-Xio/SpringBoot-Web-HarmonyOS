package com.yx.know.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.yx.common.util.PageUtils;
import com.yx.drug.mapper.DrugMapper;
import com.yx.know.entity.Know;
import com.yx.know.mapper.KnowMapper;
import com.yx.know.model.KnowQueryDTO;
import com.yx.know.service.IKnowService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.yx.pat.entity.Patient;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * <p>
 *  服务实现类
 * </p>
 *
 */
@Service
public class KnowServiceImpl extends ServiceImpl<KnowMapper, Know> implements IKnowService {

    @Autowired
    KnowMapper knowMapper;

    @Override
    public PageUtils queryPage(KnowQueryDTO queryDTO) {
        {
            QueryWrapper<Know> wrapper = new QueryWrapper<Know>().
                    like(StringUtils.isNotEmpty(queryDTO.getName()),
                            "name", queryDTO.getName()
                    );
            Page<Know> page = this.page(queryDTO.page(), wrapper);

            return new PageUtils(page);
        }
    }

    @Override
    public void saveOrUpdateKnow(Know know) {
        if (know.getId() != null && know.getId() > 0){
            this.updateById(know);
        }
        else {
            this.save(know);
        }
    }

    @Override
    public Know queryPatById(Long id) {

        return knowMapper.selectById(id);
    }

    @Override
    public String deleteKnowById(Long id) {
        this.removeById(id);
        return "1";
    }


}
