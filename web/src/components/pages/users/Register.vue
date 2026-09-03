<template>
    <div class="register-container">
      <div class="register-form">
        <h2>用户注册</h2>
        <el-form 
          ref="registerForm" 
          :model="registerForm" 
          :rules="rules" 
          label-width="100px"
          class="demo-registerForm"
        >
          <el-form-item label="用户名" prop="username">
            <el-input 
              v-model="registerForm.username" 
              placeholder="请输入用户名"
              clearable
            ></el-input>
          </el-form-item>
          
          <el-form-item label="密码" prop="password">
            <el-input 
              v-model="registerForm.password" 
              placeholder="请输入密码" 
              show-password
              clearable
            ></el-input>
          </el-form-item>
          
          <el-form-item label="确认密码" prop="checkPassword">
            <el-input 
              v-model="registerForm.checkPassword" 
              placeholder="请再次输入密码" 
              show-password
              clearable
            ></el-input>
          </el-form-item>
          
          <el-form-item label="邮箱" prop="email">
            <el-input 
              v-model="registerForm.email" 
              placeholder="请输入邮箱"
              clearable
            ></el-input>
          </el-form-item>
          
          <el-form-item label="手机号" prop="mobile">
            <el-input 
              v-model="registerForm.mobile" 
              placeholder="请输入手机号"
              clearable
              maxlength="11"
            ></el-input>
          </el-form-item>
          
          <el-form-item>
  <el-button 
    type="primary" 
    @click="submitForm('registerForm')"
    :loading="loading"
    style="width: 100%; margin-bottom: 10px;"
  >
    立即注册
  </el-button>
  <el-button 
    @click="resetForm('registerForm')"
    style="width: 100%;"
  >
    重置
  </el-button>
</el-form-item>
        </el-form>
        
        <div class="login-link">
          已有账号？<router-link to="/UserLogin">立即登录</router-link>
        </div>
      </div>
    </div>
  </template>
  
  <script>
  export default {
    name: 'Register',
    data() {
        const checkusername = (rule, value, callback) => {
  if (!value) {
    return callback(new Error("请输入用户名"));
  }
  
  // 先检查长度是否符合要求
  if (value.length < 4 || value.length > 16) {
    return callback(new Error('用户名长度应在4-16个字符之间'));
  }

  // 调用后端接口检查用户名是否存在
  this.$http.get("/sys/sysUser/checkUserName?username=" + encodeURIComponent(value))
    .then((res) => {
      console.log("用户名检查API响应:", res.data); // 调试日志
      
      // 根据你的API返回结构调整
      if (res.data.code === "SUCCESS") {
        if (res.data.data === "fail") {
          // "fail"表示用户名可用
          callback(); 
        } else {
          // 其他情况表示用户名已存在
          callback(new Error("用户名已存在"));
        }
      } else {
        callback(new Error(res.data.message || "验证用户名失败"));
      }
    })
    .catch(error => {
      console.error("检查用户名失败:", error);
      callback(new Error("网络错误，请稍后重试"));
    });
};     
 // 自定义验证规则
      const validateUsername = (rule, value, callback) => {
        if (!value) {
          return callback(new Error('请输入用户名'));
        }
        if (value.length < 4 || value.length > 16) {
          callback(new Error('用户名长度应在4-16个字符之间'));
        } else {
          callback();
        }
      };
      
      const validatePassword = (rule, value, callback) => {
        if (!value) {
          return callback(new Error('请输入密码'));
        }
        if (value.length < 3 || value.length > 20) {
          callback(new Error('密码长度应在3-20个字符之间'));
        } else {
          if (this.registerForm.checkPassword !== '') {
            this.$refs.registerForm.validateField('checkPassword');
          }
          callback();
        }
      };
      
      const validateCheckPassword = (rule, value, callback) => {
        if (!value) {
          return callback(new Error('请再次输入密码'));
        }
        if (value !== this.registerForm.password) {
          callback(new Error('两次输入密码不一致!'));
        } else {
          callback();
        }
      };
      
      const validateEmail = (rule, value, callback) => {
        const emailRegex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$/;
        if (!value) {
          return callback(new Error('请输入邮箱'));
        }
        if (!emailRegex.test(value)) {
          callback(new Error('请输入有效的邮箱地址'));
        } else {
          callback();
        }
      };
      
      const validateMobile = (rule, value, callback) => {
        const mobileRegex = /^1[3-9]\d{9}$/;
        if (!value) {
          return callback(new Error('请输入手机号'));
        }
        if (!mobileRegex.test(value)) {
          callback(new Error('请输入有效的手机号码'));
        } else {
          callback();
        }
      };
      
      return {
        loading: false,
        registerForm: {
          username: '',
          password: '',
          checkPassword: '',
          email: '',
          mobile: ''
        },
        rules: {
            username: [
    { validator: validateUsername, trigger: 'blur' }, // 先检查长度
    { validator: checkusername, trigger: 'blur' }     // 再检查重复
  ],
          password: [
            { validator: validatePassword, trigger: 'blur' }
          ],
          checkPassword: [
            { validator: validateCheckPassword, trigger: 'blur' }
          ],
          email: [
            { validator: validateEmail, trigger: 'blur' }
          ],
          mobile: [
            { validator: validateMobile, trigger: 'blur' }
          ]
        }
      };
    },
    methods: {
        handleSubmitFormData(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          if (this.dialogFormSubmitVisible) {
            return;
          }
          this.dialogFormSubmitVisible = true;
this.dataDialogForm.roleIds=this.roleIds
          this.$http
            .post("/sys/sysUser/save", this.dataDialogForm)
            .then((res) => {
              this.dialogFormVisible = false; // 关闭窗口
              // 清空添加数据的表单
              this.dataDialogForm = {
                userId: 0
              };
              this.dialogFormSubmitVisible = false;
              // 刷新数据
              this.getDataList();
            });
        } else {
          // console.log('error submit!!');
          return false;
        }
      });
    },
    submitForm(formName) {
    this.$refs[formName].validate((valid) => {
      if (valid) {
        this.loading = true; // 显示加载状态
        
      
        const registerData = {
          username: this.registerForm.username,
          password: this.registerForm.password,
          email: this.registerForm.email,
          mobile: this.registerForm.mobile
         
        };
        
        this.$http.post("/sys/sysUser/register", registerData)
          .then(response => {
            this.loading = false;
            if (response.data.code === 200 || response.data.code === "SUCCESS") {
              this.$message.success('注册成功');
              this.$router.push('/UserLogin'); // 跳转到登录页
            } else {
              this.$message.error(response.data.message || '注册失败');
            }
          })
          .catch(error => {
            this.loading = false;
            this.$message.error('注册请求失败: ' + (error.message || '请检查网络'));
          });
      } else {
        console.log('表单验证未通过');
        return false;
      }
    });
  },
      resetForm(formName) {
        this.$refs[formName].resetFields();
      }
    }
  };
  </script>
  
  <style scoped>
  .register-container {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  background-color: #f5f5f5;
}

.register-form {
  width: 500px;
  padding: 30px;
  background: #fff;
  border-radius: 5px;
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
}

.register-form h2 {
  text-align: center;
  margin-bottom: 30px;
  color: #409EFF;
}

.login-link {
  text-align: center;
  margin-top: 20px;
  font-size: 14px;
  color: #666;
}

.login-link a {
  color: #409EFF;
  text-decoration: none;
}

.login-link a:hover {
  text-decoration: underline;
}

/* 按钮样式修改 */
.el-form-item__content {
  display: flex;
  flex-direction: column;
}

.el-button {
  width: 100%;
  margin-left: 0 !important;
}

.el-button + .el-button {
  margin-top: 10px;
  margin-left: 0;
}
  </style>