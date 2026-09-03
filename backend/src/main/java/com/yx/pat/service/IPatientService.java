package com.yx.pat.service;

import com.yx.common.util.PageUtils;
import com.yx.pat.entity.Patient;
import com.baomidou.mybatisplus.extension.service.IService;
import com.yx.pat.entity.Patienta;
import com.yx.pat.model.PatientQueryDTO;

import java.util.List;

/**
 * <p>
 *  服务类
 * </p>
 *
 */
public interface IPatientService extends IService<Patient> {

    PageUtils queryPage(PatientQueryDTO queryDTO);

    Patient queryPatById(Long id);

    void saveOrUpdateUser(Patient patient);

    String deletePatById(Long id);

    List<Patienta> ghqueryPage();

    void hfsaveOrUpdateUser(Patienta patienta);

    void saveOrUpdateUserpat(Patient patient);

    List<Patienta> byidlist();

    List<Patienta> byidjqlist();
}
