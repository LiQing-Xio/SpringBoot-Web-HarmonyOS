<template>
  <div>
    <el-card shadow="hover">
      <el-row :gutter="20">
        <el-col :span="12">
          <div class="grid-content bg-purple">
            <el-form :model="dataDialogForm" status-icon ref="ruleForm" label-width="100px" class="demo-ruleForm">
              <el-form-item label="用户名" label-width="120px" prop="username">
                <el-input v-model="dataDialogForm.username" placeholder="用户名" style="width: 300px" disabled></el-input>
              </el-form-item>
              <el-form-item label="新密码" label-width="120px" prop="password">
                <el-input type="password" v-model="dataDialogForm.password" placeholder="新密码" autocomplete="off"
                  style="width: 300px"></el-input>
              </el-form-item>
              <el-form-item label="邮箱" label-width="120px" prop="email">
                <el-input v-model="dataDialogForm.email" placeholder="邮箱" style="width: 300px"></el-input>
              </el-form-item>
              <el-form-item label="电话" label-width="120px" prop="mobile">
                <el-input v-model="dataDialogForm.mobile" placeholder="电话" style="width: 300px"></el-input>
              </el-form-item>

              <el-form-item>
                <el-button type="primary" @click="handleSubmitFormData('ruleForm')">修改</el-button>

              </el-form-item>
            </el-form>

          </div>
        </el-col>
        <el-col :span="12">
          <div class="grid-content bg-purple">
            <div class="demo-image__placeholder">
              <div class="block">
                <span class="demonstration"></span>
                <img src="@/assets/images/user1.jpeg" />
              </div>
            </div>
          </div>
        </el-col>
      </el-row>


    </el-card>
  </div>
</template>

<script>
export default {
  name: 'infomation',
  data() {

    return {
      dataList: [],
      dataListLoading: false,
      dataDialogForm: {
        username: '',
        password: "",
        email: "",
        mobile: "",

      },
    };
  },
  methods: {
    getDataList() {
      if (this.dataListLoading) return
      this.dataListLoading = true
      this.$http.get("/sys/sysUser/inlist").then((res) => {
        const user = res.data.data[0] // 关键修改点：获取数组第一个元素
        this.dataDialogForm = {
          userId: user.userId,
          username: user.username,
          email: user.email,
          mobile: user.mobile,
          // 注意：密码字段通常不会回显
        }
        this.dataListLoading = false
      })
    },
    handleSubmitFormData(formName) {


      this.$http
        .post("/sys/sysUser/insave", this.dataDialogForm)
        .then((res) => {
          this.dialogFormVisible = false; // 关闭窗口
          // 清空添加数据的表单
          this.dataDialogForm = {
            userId: 0
          };
          this.$message({
            message: "修改成功，1秒后跳转登录页",
            type: "success",
            duration: 1000 // 控制自动关闭时间（毫秒）
          })

          setTimeout(() => {
            this.$router.push("/login")
          }, 2000) // 与 duration 时间保持一致
          // 刷新数据
          this.getDataList();
        });

      ;
    },



  },
  mounted() {
    this.getDataList();
  }
}
</script>
<style scoped>
img {
  margin-left: 40px;
  width: 300px;
  height: 300px;

}
</style>
