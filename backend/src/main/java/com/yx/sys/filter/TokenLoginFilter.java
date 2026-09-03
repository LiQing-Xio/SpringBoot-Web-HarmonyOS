package com.yx.sys.filter;

import com.alibaba.fastjson.JSON;
import com.yx.common.constant.SystemConstant;
import com.yx.common.result.JWTUtils;
import com.yx.sys.entity.SysUser;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

public class TokenLoginFilter extends UsernamePasswordAuthenticationFilter {

    private AuthenticationManager authenticationManager;

    public TokenLoginFilter(AuthenticationManager authenticationManager){
        this.authenticationManager = authenticationManager;
    }

    /**
     * 具体认证的方法
     * @param request
     * @param response
     * @return
     * @throws AuthenticationException
     */
    @Override
    public Authentication attemptAuthentication(HttpServletRequest request, HttpServletResponse response) throws AuthenticationException {
        SysUser sysUser = null;
        // 提交的数据是JSON字符串。不是表单提交
        try {
            String loginInfo = getRequestJSON(request);
            System.out.println("===== attemptAuthentication 开始 =====");
            System.out.println("接收到的登录JSON: " + loginInfo);
            //调用getRequestJSON方法从请求中获取JSON字符串
            sysUser = JSON.parseObject(loginInfo, SysUser.class);
            System.out.println("解析后的用户名: " + sysUser.getUsername());
            System.out.println("解析后的密码: " + sysUser.getPassword());
            System.out.println("密码长度: " + (sysUser.getPassword() != null ? sysUser.getPassword().length() : 0));
            //将JSON字符串转换为SysUser对象
            UsernamePasswordAuthenticationToken authenticationToken =
                    new UsernamePasswordAuthenticationToken(sysUser.getUsername(),sysUser.getPassword());
            //创建认证令牌
            //从SysUser中获取的用户名和密码初始化令牌
            System.out.println("开始调用认证管理器");
            Authentication result = authenticationManager.authenticate(authenticationToken);
            System.out.println("认证结果: " + (result != null && result.isAuthenticated() ? "成功" : "失败"));
            System.out.println("===== attemptAuthentication 结束 =====");
            return result;
            //调用认证管理器进行实际认证
        } catch (IOException e) {
            System.out.println("IO异常: " + e.getMessage());
            e.printStackTrace();
        } catch (AuthenticationException e) {
            System.out.println("认证异常: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
        return null;
    }

    private String getRequestJSON(HttpServletRequest request) throws IOException {
        BufferedReader streamReader = new BufferedReader(new InputStreamReader(request.getInputStream()));
        //    创建缓冲读取器来读取请求的输入流
        //    request.getInputStream()获取原始请求体数据
        StringBuilder sb = new StringBuilder();
        //创建字符串构建器用于拼接读取的内容
        String inputStr = null;
        while((inputStr = streamReader.readLine() ) != null){
            sb.append(inputStr);
        }
        //循环读取输入流的每一行并追加到字符串构建器
        return sb.toString();
    }

    /**
     * 登录成功的方法
     * @param request
     * @param response
     * @param chain
     * @param authResult
     * @throws IOException
     * @throws ServletException
     */
    @Override
    protected void successfulAuthentication(HttpServletRequest request, HttpServletResponse response
            , FilterChain chain, Authentication authResult) throws IOException, ServletException {
        // 生成Token信息
        Map<String,String> map = new HashMap<>();
        map.put("username",authResult.getName());
        // TODO 还可以存储当前用户具有的角色
        // 生成对应的Token信息
        String token = JWTUtils.getToken(map);
        // 需要把生成的Token信息响应给客户端
        response.addHeader("Authorization", SystemConstant.SYS_TOKEN_PREFIX +token);
        response.addHeader("Access-Control-Expose-Headers","Authorization");
        response.setContentType("application/json;charset=utf-8");
        response.setStatus(HttpServletResponse.SC_OK);
        PrintWriter writer = response.getWriter();
        Map<String,Object> resultMap = new HashMap<>();
        resultMap.put("code", HttpServletResponse.SC_OK);
        resultMap.put("msg","认证通过");
        writer.write(JSON.toJSONString(resultMap));
        writer.flush();
        writer.close();
    }

    /**
     * 登录失败的方法
     * @param request
     * @param response
     * @param failed
     * @throws IOException
     * @throws ServletException
     */
    @Override
    protected void unsuccessfulAuthentication(HttpServletRequest request, HttpServletResponse response, AuthenticationException failed) throws IOException, ServletException {
        response.setContentType("application/json;charset=utf-8");

        response.setStatus(HttpServletResponse.SC_OK);
        PrintWriter writer = response.getWriter();
        Map<String,Object> resultMap = new HashMap<>();
        resultMap.put("code", HttpServletResponse.SC_UNAUTHORIZED);
        resultMap.put("msg","用户名或密码错误!");
        writer.write(JSON.toJSONString(resultMap));
        writer.flush();
        writer.close();
    }
}
