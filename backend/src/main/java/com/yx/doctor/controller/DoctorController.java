package com.yx.doctor.controller;

import com.yx.doctor.entity.Doctor;
import com.yx.doctor.service.IDoctorService;
import com.yx.pat.entity.Registration;
import io.swagger.annotations.Api;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.stereotype.Controller;

import java.util.List;

/**
 * <p>
 *  前端控制器
 * </p>
 *
 */
@Api(tags = "医生",value = "doctor")
@CrossOrigin
@RestController
@RequestMapping("/doc/doc")
public class DoctorController {

    @Autowired
private IDoctorService doctorService;
    @GetMapping("/list")
    public List<Doctor> list(){
        return doctorService.list();
    }
    @PostMapping("/save")
    public String save(@RequestBody Registration registration){
        doctorService.savezz(registration);
        return "redirect:/doc/doc";
    }
}
