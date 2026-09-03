package com.yx.common.swagger;

import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.core.env.Environment;

import javax.annotation.Resource;
import java.net.InetAddress;
import java.util.Optional;

/**
 * @author liao
 */
@Slf4j
public class SwaggerConsole implements ApplicationRunner {

    @Resource
    private Environment environment;

    @Override
    public void run(ApplicationArguments args) throws Exception {
        String appName = environment.getProperty("spring.application.name");
        String contextPath = Optional.ofNullable(environment.getProperty("server.servlet.context-path")).orElse("");
        String host = InetAddress.getLocalHost().getHostAddress();
        String port = Optional.ofNullable(environment.getProperty("server.port")).orElse("8080");
        log.info("\n----------------------------------------------------------\n" +
                "\tApplication '{}' is running! \n" +
                "\tSwagger Doc:  http://{}:{}{}/doc.html\n" +
                "----------------------------------------------------------", appName, host, port, contextPath);
    }

}
