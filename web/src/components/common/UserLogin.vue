<template>
  <div class="login_container">
    <div class="login_form">
      <p class="login_title">用户登录</p>
      <el-form :model="form" :rules="rules" status-icon label-width="100px" class="demo-ruleForm" ref="formName">
        <el-form-item label="账号" prop="username">
          <el-input v-model="form.username" placeholder="请输入账号"></el-input>
        </el-form-item>
        <el-form-item label="密码" prop="password">
          <el-input type="password" v-model="form.password" placeholder="请输入密码"></el-input>
        </el-form-item>

        <el-form-item>
          <el-button type="primary" size="medium" @click="submitFormData">登录</el-button>
          &#8195; &emsp;&#8195; &emsp;&#8195; &emsp;&#8195;&emsp;&#8195;&emsp;&#8195; &emsp;
          <el-link type="success" @click="reg">还没有账号？注册</el-link>
          <div ><el-link @click="tz" type="primary">员工登录</el-link></div>
        </el-form-item>
      </el-form>
    </div>
  </div>
</template>
<script>
export default {
  name: 'UserLogin',
  data() {
    return {
      form: {
        username: "",
        password: "",
      },
      rules: {
        username: [{ required: true, message: "请输入账号", trigger: "blur" }],
        password: [{ required: true, message: "请输入密码", trigger: "blur" }],
      },
      salt:"",
    };
  }, methods: {
   
    reg(){
      this.$router.push("/Register")
    },
    tz(){
      this.$router.push("/Login")
    },
    // 提交登录表单的数据
    submitFormData(){
      this.$refs['formName'].validate((valid) => {
        if (valid) {
          this.$http.post("/login", this.form)
            .then((res) => {
              if(res.data.code === 200){
                // 表示登录成功
                // 1.存储相关的token信息  token信息在响应的header中
                sessionStorage.setItem("token",res.headers.authorization)
                sessionStorage.setItem("username",this.form.username)
                // sessionStorage.setItem("access",this.form.salt)
                // 2.路由到主页面
                this.$router.push("/Main")
              }else{
                // 表示登录失败
                this.$message.error(res.data.msg)
              }
            });
        } else {
          // console.log('error submit!!');
          return false;
        }
      });
    }
  },
};
</script>
<style lang="less" scoped>
.login_container {
  width: 100%;
  height: 100vh;
  background-color: rgba(242, 242, 242, 1);
  background-image: url(../../assets/userlogin.jpg);
  background-size: cover; // 核心修改：图片覆盖整个容器
  background-position: center center; // 图片居中显示
  //background-position: center bottom;
  background-repeat: no-repeat;
  background-size: 1278px 559px;
  border: none;
  border-radius: 0px;
  display: flex;
  justify-content: center;
  align-items: center;

  .login_form {
    width: 510px;
    margin: 0px auto;
    padding: 0 55px 15px 35px;
    background-color: #fff;
    border: none;
    border-radius: 5px;
    // 添加阴影效果
    box-shadow: 0 0 25px #cac6c6;

    .login_title {
      font-family: "微软雅黑 Bold", "微软雅黑";
      font-weight: 700;
      text-decoration: none;
      color: rgb(0, 121, 254);
      font-size: 32px;
      margin-top: 50px;
      margin-bottom: 30px;
      text-align: center;
    }
  }
}
</style>