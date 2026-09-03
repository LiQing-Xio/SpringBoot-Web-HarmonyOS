package com.yx.common.swagger;

import io.swagger.annotations.Api;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import springfox.documentation.builders.ApiInfoBuilder;
import springfox.documentation.builders.PathSelectors;
import springfox.documentation.builders.RequestHandlerSelectors;
import springfox.documentation.oas.annotations.EnableOpenApi;
import springfox.documentation.service.ApiInfo;
import springfox.documentation.service.Contact;
import springfox.documentation.spi.DocumentationType;
import springfox.documentation.spring.web.plugins.Docket;

/**
 * Swagger配置
 *
 * @author lgy
 */
@Slf4j
@Configuration
@EnableOpenApi
public class SwaggerConfiguration {

    @Value("${spring.application.name}")
    private String applicationName;


    @Bean
    public Docket createRestApi() {
        return new Docket(DocumentationType.OAS_30)
                .apiInfo(apiInfo())
                .select()
                .apis(RequestHandlerSelectors.withClassAnnotation(Api.class))
                .paths(PathSelectors.any())
                .build();
    }

    private ApiInfo apiInfo() {
        return new ApiInfoBuilder()
                .title(applicationName)
                .description(applicationName + "接口文档。")
                .contact(new Contact("悦享家庭医生", "", "1350361432@qq.com"))
                .version("1.0")
                .build();
    }

    @Bean
    public com.yx.common.swagger.EnumPropertyBuilderPlugin enumPropertyBuilderPlugin() {
        return new com.yx .common.swagger.EnumPropertyBuilderPlugin();
    }


    @Bean
    public ValidatePropertyBuilderPlugin validatePropertyBuilderPlugin() {
        return new ValidatePropertyBuilderPlugin();
    }

    @Bean
    public SwaggerConsole swaggerConsole() {
        return new SwaggerConsole();
    }
}
