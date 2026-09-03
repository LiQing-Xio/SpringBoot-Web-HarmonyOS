package com.yx.yytx.controller;

import com.yx.know.entity.Know;
import com.yx.yytx.entity.Yytx;
import com.yx.yytx.service.IYytxService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
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
@Api(tags = "用药",value = "yytx")
@CrossOrigin
@Controller
@RequestMapping("/yytx/yytx")
public class YytxController {
    @Autowired
    private IYytxService  yytxService;
    @ApiOperation(value="查询",notes = "查询")
    @GetMapping("/list")
    public List<Yytx> list(){

        return yytxService.list();
    }
    @PostMapping("/save")
    public String save(@RequestBody Yytx yytx ){
        yytxService.save(yytx);
        return "1";
    }
    @ApiOperation(value="删除信息",notes = "删除信息")
    @GetMapping("/delete")
    public boolean delete( int id) {

        return  yytxService.removeById(id);
    }
}
