<template>
  <div class="patient-dashboard">
    <!-- 顶部导航 -->
    <div class="header">
      <el-menu class="el-menu-demo" mode="horizontal" background-color="#409EFF" text-color="#fff"
        active-text-color="#ffd04b">
        <el-menu-item index="home" @click="refreshPage">
          <div class="brand">
            <svg class="logo" viewBox="0 0 32 32" xmlns="http://www.w3.org/2000/svg">
              <path d="M16 2.133a12 12 0 0 1 9.8 18.933H24a8 8 0 1 0-16 0H6.2A12 12 0 0 1 16 2.133z" fill="#fff" />
              <path d="M16 22.667a2 2 0 0 1 2 2v4.666h-4v-4.666a2 2 0 0 1 2-2z" fill="#409EFF" />
              <path d="M22 12.667h-2.667V10h-6.666v2.667H10v6.666h2.667V22h6.666v-2.667H22v-6.666z" fill="#fff" />
            </svg>
            <span class="title">家庭医生+</span>
          </div>
        </el-menu-item>
        <!-- 原有导航项... -->

        <el-submenu index="quick-action">
          <template slot="title">
            <i class="el-icon-circle-plus"></i>
            快捷操作
          </template>
          <el-menu-item index="new-record" @click="Jkjl1">
            <i class="el-icon-notebook-2"></i>新建健康记录
          </el-menu-item>
          <el-menu-item index="upload-report" @click="Jkjl2">
            <i class="el-icon-upload"></i>查看健康常识
          </el-menu-item>
        </el-submenu>
        <el-submenu index="5" class="right-menu">
          <template slot="title">个人中心</template>
          <el-menu-item index="5-1" @click="handleCommand1">我的信息</el-menu-item>
          <el-menu-item index="5-2" @click="handleCommand">退出登录</el-menu-item>
        </el-submenu>
      </el-menu>
    </div>
    <router-view></router-view>
  </div>

</template>
<script>
import Jkjl from './jkjl.vue';

export default {
  data() {
    return {

    };
  },
  mounted() {

  },
  methods: {
    refreshPage(){
      this.$router.push('/Main')
    },
   
    Jkjl1(){
      this.$router.push('/jkjl')
    },
    Jkjl2(){
      this.$router.push('/HealthKnowledge')
    },
    handleCommand1() {
      this.$router.push('/usersinfo')
    },
    handleCommand() {
      this.$router.push('/UserLogin')
    },
    handleAction(action) {
      // 处理快速入口点击
      console.log('执行操作:', action)
    },
  }
}

</script>
<style scoped>
.patient-dashboard {
  min-height: 100vh;
  background-color: #f5f7fa;
}

.main-content {
  padding: 20px;
  max-width: 1200px;
  margin: 0 auto;
}

.quick-access {
  margin-bottom: 20px;
}

.action-card {
  text-align: center;
  cursor: pointer;
  transition: transform 0.3s;
}

.action-card:hover {
  transform: translateY(-5px);
}

.action-icon {
  font-size: 40px;
  color: #409EFF;
  margin: 10px 0;
}

.health-overview {
  margin-top: 20px;
}

.todo-item {
  padding: 10px 0;
  border-bottom: 1px solid #eee;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.due-time {
  color: #999;
  font-size: 0.9em;
}

.upcoming-appointments {
  margin-top: 20px;
}

.app-footer {
  background-color: #2c3e50;
  color: #ecf0f1;
  padding: 40px 20px 20px;
  margin-top: 50px;
}

.footer-content {
  max-width: 1200px;
  margin: 0 auto;
}

.footer-section {
  margin-bottom: 30px;
  padding: 0 20px;
}

.footer-section h4 {
  color: #409EFF;
  margin-bottom: 15px;
  font-size: 18px;
}

.contact-item {
  margin: 10px 0;
  display: flex;
  align-items: center;
}

.contact-item i {
  margin-right: 10px;
  font-size: 16px;
}

.certification {
  margin-top: 15px;
  padding: 10px;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 4px;
}

.qrcode img {
  width: 120px;
  height: 120px;
  margin: 15px 0;
  border: 2px solid #409EFF;
  padding: 5px;
  background: white;
}

.copyright {
  text-align: center;
  margin-top: 30px;
  font-size: 0.9em;
  color: #bdc3c7;
}

.el-link {
  display: block;
  margin: 8px 0;
}

.el-menu-demo .right-menu {
  float: right;
}

/* 或者使用flex布局（推荐）*/
.el-menu-demo {
  display: flex;
}

.el-menu-demo>>>.right-menu {
  margin-left: auto;
}

.brand {
  display: flex;
  align-items: center;
  height: 60px;
  cursor: pointer;
  transition: opacity 0.3s;
}

.brand:hover {
  opacity: 0.8;
}

.logo {
  width: 32px;
  height: 32px;
  margin-right: 10px;
}

.title {
  font-size: 20px;
  font-weight: bold;
  color: #fff;
  letter-spacing: 1px;
}

/* 调整右侧菜单位置 */
.el-menu-demo>>>.el-submenu.right-menu {
  float: right;
}

.logo {
  width: 36px;
  height: 36px;
  margin-right: 12px;
  transition: transform 0.3s;
}

.brand:hover .logo {
  transform: rotate(15deg);
}

.title {
  font-family: 'Microsoft YaHei', sans-serif;
  text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.2);
}
</style>