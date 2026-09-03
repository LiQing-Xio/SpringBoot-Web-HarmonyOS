package com.yx.pat.mapper;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.yx.pat.entity.Patient;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.yx.pat.entity.Patienta;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * <p>
 *  Mapper 接口
 * </p>
 *
 */
public interface PatientMapper extends BaseMapper<Patient> {

    List<Patienta> ghlist();


    void hfsave(@Param("id") Long id, @Param("hf")String hf);

    int ByUsernameOrId(String userName);

    void insertpatuser(@Param("userid")int userid, @Param("id")Long id);



    Integer selectByuseridorid(int userid);

    void insertregpat(@Param("id")int id, @Param("rid")int rid);

    List<Patienta> byidlist(int userid);


    List<Patienta> byidjqlist(int userid);
}
