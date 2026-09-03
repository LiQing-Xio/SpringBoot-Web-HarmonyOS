package com.yx.bul.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.yx.bul.entity.Bulletin;
import com.yx.bul.mapper.BulletinMapper;
import com.yx.bul.model.BulletinQueryDTO;
import com.yx.bul.service.IBulletinService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.yx.common.util.PageUtils;
import com.yx.drug.entity.Drug;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;


@Service
public class BulletinServiceImpl extends ServiceImpl<BulletinMapper, Bulletin> implements IBulletinService {

    @Autowired
    private BulletinMapper bulletinMapper;

    @Override
    public PageUtils queryPage(BulletinQueryDTO queryDTO) {
        {
            QueryWrapper<Bulletin> wrapper = new QueryWrapper<Bulletin>().
                    like(StringUtils.isNotEmpty(queryDTO.getContent()),
                            "content", queryDTO.getContent()
                    );
            Page<Bulletin> page = this.page(queryDTO.page(), wrapper);

            return new PageUtils(page);
        }
    }

    @Override
    public Bulletin queryPhaById(Long id) {
        return bulletinMapper.selectById(id);
    }

    @Override
    public void saveOrUpdateDru(Bulletin bulletin) {
        UsernamePasswordAuthenticationToken token = (UsernamePasswordAuthenticationToken) SecurityContextHolder.getContext().getAuthentication();
        String username = token.getPrincipal().toString();
        bulletin.setAccount(username);
        bulletin.setDate(LocalDateTime.now());
        if (bulletin.getId() != null && bulletin.getId() > 0) {
            //更新
            this.updateById(bulletin);
        } else {
            //添加
            this.save(bulletin);

        }
    }

    @Override
    public String deleteDrugById(Long id) {
        this.removeById(id);
        return "1";
    }
}
