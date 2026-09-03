package com.yx.doctor.service.impl;

import com.yx.doctor.entity.Doctor;
import com.yx.doctor.mapper.DoctorMapper;
import com.yx.doctor.service.IDoctorService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.yx.pat.entity.Patient;
import com.yx.pat.entity.Registration;
import com.yx.pat.mapper.PatientMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

/**
 * <p>
 *  服务实现类
 * </p>
 *
 */
@Service
public class DoctorServiceImpl extends ServiceImpl<DoctorMapper, Doctor> implements IDoctorService {
    @Autowired
    private PatientMapper patientMapper;
    @Autowired
    private DoctorMapper doctorMapper;
    @Override
    public void savezz(Registration registration) {
        doctorMapper.savezz(registration);
        int rid = registration.getRid();
        UsernamePasswordAuthenticationToken authentication = (UsernamePasswordAuthenticationToken) SecurityContextHolder.getContext().getAuthentication();
        String userName = (String) authentication.getPrincipal();
        int userid = patientMapper.ByUsernameOrId(userName);
        Integer id = this.patientMapper.selectByuseridorid(userid);
        if (id == null) {
            // 用户还没有患者档案，自动创建一个基本档案
            Patient patient = new Patient();
            patient.setUsername(userName);
            patient.setCreateTime(LocalDateTime.now());
            patientMapper.insert(patient);
            Long patientId = patient.getId();
            patientMapper.insertpatuser(userid, patientId);
            id = patientId.intValue();
        }
        this.patientMapper.insertregpat(id, rid);
    }
}
