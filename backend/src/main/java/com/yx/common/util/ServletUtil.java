package com.yx.common.util;

import lombok.extern.slf4j.Slf4j;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.HttpServletRequest;
import java.net.Inet4Address;
import java.net.InetAddress;
import java.net.UnknownHostException;

/**
 * Servlet工具类
 */
@Slf4j
public class ServletUtil {

    private ServletUtil() {

    }

    public static String getClientIP(HttpServletRequest request) {
        String strXff = request.getHeader("X-Forwarded-For");
        if (strXff == null || strXff.length() == 0 || "unknown".equals(strXff)) {
            return request.getRemoteAddr();
        }
        String[] strIPs = strXff.split(",");
        for (int i = 0, n = strIPs.length; i < n; i++) {
            strIPs[i] = strIPs[i].trim();
            if (strIPs[i].length() > 0 && !"unknown".equals(strIPs[i])) {
                return strIPs[i];
            }
        }
        return request.getRemoteAddr();
    }

    public static String getClientIP() {
        try {
            ServletRequestAttributes servletRequestAttributes = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
            HttpServletRequest request = servletRequestAttributes.getRequest();
            return getClientIP(request);
        } catch (Exception e) {
            try {
                InetAddress localHost = Inet4Address.getLocalHost();
                return localHost.getHostAddress();
            } catch (UnknownHostException unknownHostException) {

            }
        }
        return "127.0.0.1";
    }

    public HttpServletRequest getRequest() {
        ServletRequestAttributes servletRequestAttributes = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
        return servletRequestAttributes.getRequest();
    }

}
