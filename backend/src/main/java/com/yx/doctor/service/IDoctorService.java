package com.yx.doctor.service;

import com.yx.doctor.entity.Doctor;
import com.baomidou.mybatisplus.extension.service.IService;
import com.yx.pat.entity.Registration;

/**
 * <p>
 *  服务类
 * </p>
 *
 */
public interface IDoctorService extends IService<Doctor> {

    void savezz(Registration registration);
}
