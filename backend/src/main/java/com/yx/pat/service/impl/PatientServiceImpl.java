package com.yx.pat.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.yx.common.util.PageUtils;
import com.yx.ech.mapper.DataChartMapper;
import com.yx.pat.entity.Age;
import com.yx.pat.entity.Patient;
import com.yx.pat.entity.Patienta;
import com.yx.pat.mapper.PatientMapper;
import com.yx.pat.model.PatientQueryDTO;
import com.yx.pat.service.IPatientService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

/**
 * <p>
 *  服务实现类
 * </p>
 *
 */
@Service
public class PatientServiceImpl extends ServiceImpl<PatientMapper, Patient> implements IPatientService {

    @Autowired
    private DataChartMapper dataChartMapper;

    @Autowired
    private PatientMapper patientMapper;
    @Override
    public PageUtils queryPage(PatientQueryDTO queryDTO) {
        {
            QueryWrapper<Patient> wrapper = new QueryWrapper<Patient>().
                    like(StringUtils.isNotEmpty(queryDTO.getUserName()),
                            "username", queryDTO.getUserName()
                    );
            Page<Patient> page = this.page(queryDTO.page(), wrapper);

            return new PageUtils(page);
        }
    }

    @Override
    public Patient queryPatById(Long id) {
//        QueryWrapper<Patient> wrapper = new QueryWrapper<>();
//       QueryWrapper<Patient> patient =  wrapper.eq("id",id);
        return patientMapper.selectById(id);
    }

    @Override
    public void saveOrUpdateUser(Patient patient) {
        if(patient.getId()>0){
            //更新
            this.updateById(patient);
        }
        else {
            Long i = patient.getAge();
            if(i != null && i != 0){
         if (i >= Age.AGE_10_20.getValue()&& i <= Age.AGE_21_30.getValue()){
             Long a = 1L;
             dataChartMapper.insertValue(a);
         }
         else if (i >= Age.AGE_21_30.getValue()&& i <= Age.AGE_31_40.getValue()){
             Long a = 2L;
             dataChartMapper.insertValue(a);
         }
         else if (i >= Age.AGE_31_40.getValue()&& i <= Age.AGE_41_50.getValue()){
             Long a = 3L;
             dataChartMapper.insertValue(a);
         }
         else if (i >= Age.AGE_41_50.getValue()&& i <= Age.AGE_51_60.getValue()){
             Long a = 4L;
             dataChartMapper.insertValue(a);
         }
         else if (i >= Age.AGE_51_60.getValue()&& i <= Age.AGE_61_70.getValue()){
             Long a = 5L;
             dataChartMapper.insertValue(a);
         }
         else if (i >= Age.AGE_61_70.getValue()&& i <= Age.AGE_70_ADD.getValue()){
             Long a = 6L;
             dataChartMapper.insertValue(a);
         }
         else {
             Long a = 7L;
             dataChartMapper.insertValue(a);
         }}
            //添加
            patient.setCreateTime(LocalDateTime.now());
            this.save(patient);

        }
    }

    @Override
    public String deletePatById(Long id) {

        this.removeById(id);
        return "1";
    }

    @Override
    public List<Patienta> ghqueryPage() {


        return  patientMapper.ghlist();
    }

    @Override
    public void hfsaveOrUpdateUser(Patienta patienta) {
        if(patienta.getId()>0 && patienta.getId()!=null){
            patientMapper.hfsave(patienta.getId(),patienta.getHf());
        }

    }

    @Override
    public void saveOrUpdateUserpat(Patient patient) {
        if (patient != null && patient.getId() != null && patient.getId() > 0) {
            // 更新
            this.updateById(patient);
        }
        else {
            Long i = patient.getAge();
            if(i != null && i != 0){
                if (i >= Age.AGE_10_20.getValue()&& i <= Age.AGE_21_30.getValue()){
                    Long a = 1L;
                    dataChartMapper.insertValue(a);
                }
                else if (i >= Age.AGE_21_30.getValue()&& i <= Age.AGE_31_40.getValue()){
                    Long a = 2L;
                    dataChartMapper.insertValue(a);
                }
                else if (i >= Age.AGE_31_40.getValue()&& i <= Age.AGE_41_50.getValue()){
                    Long a = 3L;
                    dataChartMapper.insertValue(a);
                }
                else if (i >= Age.AGE_41_50.getValue()&& i <= Age.AGE_51_60.getValue()){
                    Long a = 4L;
                    dataChartMapper.insertValue(a);
                }
                else if (i >= Age.AGE_51_60.getValue()&& i <= Age.AGE_61_70.getValue()){
                    Long a = 5L;
                    dataChartMapper.insertValue(a);
                }
                else if (i >= Age.AGE_61_70.getValue()&& i <= Age.AGE_70_ADD.getValue()){
                    Long a = 6L;
                    dataChartMapper.insertValue(a);
                }
                else {
                    Long a = 7L;
                    dataChartMapper.insertValue(a);
                }}
            //添加
            patient.setCreateTime(LocalDateTime.now());
            this.save(patient);
           Long id = patient.getId();
            UsernamePasswordAuthenticationToken authentication = (UsernamePasswordAuthenticationToken) SecurityContextHolder.getContext().getAuthentication();
            String userName = (String) authentication.getPrincipal();
            int userid = patientMapper.ByUsernameOrId(userName);
            this.patientMapper.insertpatuser(userid,id);
        }
    }

    @Override
    public List<Patienta> byidlist() {
        UsernamePasswordAuthenticationToken authentication = (UsernamePasswordAuthenticationToken) SecurityContextHolder.getContext().getAuthentication();
        String userName = (String) authentication.getPrincipal();
        int userid = patientMapper.ByUsernameOrId(userName);
        return patientMapper.byidlist(userid);
    }

    @Override
    public List<Patienta> byidjqlist() {
        UsernamePasswordAuthenticationToken authentication = (UsernamePasswordAuthenticationToken) SecurityContextHolder.getContext().getAuthentication();
        String userName = (String) authentication.getPrincipal();
        int userid = patientMapper.ByUsernameOrId(userName);
        return patientMapper.byidjqlist(userid);
    }
}
