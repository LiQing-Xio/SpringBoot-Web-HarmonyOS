<template>
    <div class="personal-center-container">
      <div class="info-card">
        <h2>个人中心</h2>
   
        <el-descriptions 
          title="个人信息" 
          border 
          :column="1"
          v-loading="loading"
        >
          <el-descriptions-item label="账号">{{ userInfo.username || '--' }}</el-descriptions-item>
          <el-descriptions-item label="邮箱">{{ userInfo.email || '--' }}</el-descriptions-item>
          <el-descriptions-item label="联系方式">{{ userInfo.mobile || '--' }}</el-descriptions-item>
        </el-descriptions>
      </div>
    </div>
  </template>
   
  <script>
  export default {
    name: 'PersonalCenter',
    data() {
      return {
        userInfo: {
          username: '',
          email: '',
          mobile: ''
        },
        loading: false
      };
    },
    created() {
      this.fetchUserInfo(); // 调用统一的方法获取用户信息
    },
    methods: {
      fetchUserInfo() {
        this.loading = true; // 开启加载状态
        this.$http.get("/sys/sysUser/inlist") 
          .then((res) => {
            if (res.data && res.data.data && res.data.data.length > 0) {
              const user = res.data.data[0]; // 获取数组第一个用户
              this.userInfo = {
                username: user.username || '',
                email: user.email || '',
                mobile: user.mobile || ''
              };
            } else {
              console.warn("未获取到用户信息");
            }
          })
          .catch((error) => {
            console.error("获取用户信息失败：", error);
          })
          .finally(() => {
            this.loading = false; // 关闭加载状态
          });
      }
    }
  };
  </script>
   
  <style scoped>
  .personal-center-container {
    display: flex;
    justify-content: center;
    align-items: center;
    min-height: 80vh;
    background-color: #f5f7fa;
  }
   
  .info-card {
    width: 600px;
    padding: 30px;
    background: #fff;
    border-radius: 8px;
    box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
  }
   
  h2 {
    text-align: center;
    margin-bottom: 30px;
    color: #409EFF;
  }
   
  .el-descriptions {
    margin-top: 20px;
  }
   
  .el-descriptions-item__label {
    width: 100px;
    font-weight: bold;
  }
  </style>