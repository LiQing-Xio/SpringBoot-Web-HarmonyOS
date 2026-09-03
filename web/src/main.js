// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue'
import App from './App'
import router from './router'
// 导入ElementUI
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';
import store from '@/store';
 import axios from 'axios'


// 配置
Vue.use(ElementUI)
Vue.config.productionTip = false

// 配置 axios
Vue.prototype.$http = axios  // 修改内部的$http 为 axios
 axios.defaults.baseURL="http://localhost:8086/yx"
// 添加 Axios 的拦截器
axios.interceptors.request.use(config =>{
  // 每次发送请求我们都携带token信息
  var token = sessionStorage.getItem('token')
  config.headers['Authorization']=token // 请求头带上Token
  return config;
},error=>{
  return Promise.reject(error);
})
/** 使用router钩子函数来处理 */
// main.js 或 router/index.js
router.beforeEach((to, from, next) => {
  const username = sessionStorage.getItem('username');
  const allowPages = ['login', 'UserLogin','Main','registration1','Register']; // 允许无权限访问的路由名称

  if (!allowPages.includes(to.name) && !username) {
    next({ name: 'login' }); // 拦截非白名单页面
  } else {
    next(); // 放行
  }
});

/* eslint-disable no-new */
new Vue({
  el: '#app',
  router, // 挂载Router实例
  store, // 挂载store实例
  components: { App },
  template: '<App/>'
  
})
