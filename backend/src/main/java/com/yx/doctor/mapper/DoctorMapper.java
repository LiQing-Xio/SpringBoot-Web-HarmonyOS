package com.yx.doctor.mapper;

import com.yx.doctor.entity.Doctor;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.yx.pat.entity.Registration;

/**
 * <p>
 *  Mapper 接口
 * </p>
 *
 */
public interface DoctorMapper extends BaseMapper<Doctor> {

    void savezz(Registration registration);
}
