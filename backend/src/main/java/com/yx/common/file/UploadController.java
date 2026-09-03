package com.yx.common.file;

import com.yx.config.FileUploadConfig;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.UUID;

@Configuration
class WebConfig implements WebMvcConfigurer {
    @Autowired
    private FileUploadConfig fileUploadConfig;

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/upload/**")
                .addResourceLocations("file:" + fileUploadConfig.getPath());
    }
}

@RestController
@RequestMapping("/file/file")
public class UploadController {

    @Autowired
    private FileUploadConfig fileUploadConfig;

    @PostMapping("upload")
    public JsonResult upload(MultipartFile file) throws IOException {
        if (file == null || file.isEmpty()) {
            return JsonResult.ok("请选择要上传的文件");
        }

        String filename = file.getOriginalFilename();
        String suffix = filename.substring(filename.lastIndexOf("."));
        filename = UUID.randomUUID() + suffix;

        SimpleDateFormat s = new SimpleDateFormat("/yyyy/MM/dd/");
        String datePath = s.format(new Date());

        // 确保上传目录存在
        String uploadPath = fileUploadConfig.getPath();
        if (!uploadPath.endsWith("/")) {
            uploadPath += "/";
        }

        File dirFile = new File(uploadPath + datePath);
        if(!dirFile.exists()){
            dirFile.mkdirs();
        }

        String filePath = uploadPath + datePath + filename;
        File dest = new File(filePath);
        file.transferTo(dest);

        return JsonResult.ok("/yx/upload" + datePath + filename);
    }

    @PostMapping("remove")
    public JsonResult remove(String imgUrl){
        String uploadPath = fileUploadConfig.getPath();
        if (!uploadPath.endsWith("/")) {
            uploadPath += "/";
        }
        new File(uploadPath + imgUrl.replace("/yx/upload", "")).delete();
        return JsonResult.ok();
    }
}
