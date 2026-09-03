package com.yx.config;

import com.baomidou.mybatisplus.generator.FastAutoGenerator;
import com.baomidou.mybatisplus.generator.config.OutputFile;
import com.baomidou.mybatisplus.generator.engine.FreemarkerTemplateEngine;

import java.util.Collections;

public class MyFastGeneratorConfiguration {
    public static void main(String[] args) {
        FastAutoGenerator.create("jdbc:mysql://localhost:3306/sitoa?serverTimezone=UTC&useUnicode=true&characterEncoding=utf-8&useSSL=true"
                        , "root", "root")
                .globalConfig(builder -> {
                    builder.author("家庭医生") // 设置作者
                            .enableSwagger() // 开启 swagger 模式
                            .fileOverride() // 覆盖已生成文件
                            .outputDir("D://yx"); // 指定输出目录
                })
                .packageConfig(builder -> {
                    builder.parent("com.yx") // 设置父包名
                            .moduleName("yytx") // 设置父包模块名
                            .pathInfo(Collections.singletonMap(OutputFile.xml,
                                    "D://yx")); // 设置mapperXml生成路径
                })
                .strategyConfig(builder -> {
                    builder.addInclude("yytx") // 设置需要生成的表名
//.addTablePrefix("act_fo_")
                    ; // 设置过滤表前缀
                })
                .templateEngine(new FreemarkerTemplateEngine()) // 使用Freemarker引擎模 板，默认的是Velocity引擎模板
                .execute();
    }
}
