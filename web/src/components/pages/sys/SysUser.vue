<template>
  <div>
    <el-card class="box-card">
      <div class="mod-role">
        <el-form :inline="true" :model="dataForm" class="demo-form-inline">
          <el-form-item>
            <el-input v-model="dataForm.username" clearable placeholder="用户名"></el-input>
          </el-form-item>
          <el-form-item>
            <el-button @click="getDataList">查询</el-button>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" @click="openDialog()">新增</el-button>
          </el-form-item>
        </el-form>
        <el-table :data="dataList" border style="width: 100%">
          <el-table-column type="selection" width="55"> </el-table-column>
          <el-table-column prop="userId" label="ID">
          </el-table-column>
          <el-table-column prop="username" label="用户名">
          </el-table-column>
          <el-table-column prop="email" label="邮箱">
          </el-table-column>
          <el-table-column prop="mobile" label="电话">
          </el-table-column>
          <el-table-column prop="status" label="状态">
            <template slot-scope="scope">
              <span>{{ scope.row.status == 1 ? '正常' : '禁用' }}</span>
            </template>
          </el-table-column>
          <el-table-column prop="createTime" label="创建时间">
          </el-table-column>
          <el-table-column label="操作">
            <template slot-scope="scope">
              <el-button size="mini" type="primary" @click="handleEdit(scope.$index, scope.row)">编辑</el-button>
              <el-button v-if="scope.row.status === 1" size="mini" type="danger"
                @click="handleUpdateStatus(scope.$index, scope.row)">禁用</el-button>
              <el-button v-if="scope.row.status !== 1" size="mini" type="success"
                @click="handleUpdateStatus(scope.$index, scope.row)">激活</el-button>
            </template>
          </el-table-column>
        </el-table>
        <el-pagination @size-change="sizeChangeHandle" @current-change="currentChangeHandle" :current-page="pageIndex"
          :page-sizes="[5, 10, 20, 50, 100]" :page-size="pageSize" :total="totalPage"
          layout="total, sizes, prev, pager, next, jumper" style="margin-top: 30px">
        </el-pagination>
      </div>

      <el-dialog :title="dataDialogForm.userId === 0 ? '新增用户' : '更新用户'" width="35%" :visible.sync="dialogFormVisible"
        @close="closeDialog()">
        <el-form :model="dataDialogForm" :rules="rules" ref="ruleForm">
          <el-form-item label="账号" label-width="120px" prop="username">
            <el-input v-model="dataDialogForm.username" placeholder="账号" :disabled="dataDialogForm.userId > 0"
              style="width: 300px"></el-input>
          </el-form-item>
          <el-form-item v-if="dataDialogForm.userId === 0" label="密码" label-width="120px" prop="password">
            <el-input type="password" v-model="dataDialogForm.password" style="width: 300px"></el-input>
          </el-form-item>
          <el-form-item label="邮箱" label-width="120px" prop="email">
            <el-input v-model="dataDialogForm.email" placeholder="邮箱" style="width: 300px"></el-input>
          </el-form-item>
          <el-form-item label="电话" label-width="120px" prop="mobile">
            <el-input v-model="dataDialogForm.mobile" placeholder="电话" style="width: 300px"></el-input>
          </el-form-item>
          <el-form-item label="状态" label-width="120px" prop="status">
            <el-select v-model="dataDialogForm.status" placeholder="状态">
              <el-option v-for="item in StatusList" :label="item.label" :value="item.value"
                :key="item.value"></el-option>

            </el-select>
          </el-form-item>


          <el-form-item label="分配角色" label-width="120px" prop="roleIds">
            <el-checkbox-group v-model="roleIds">
              <el-checkbox v-for="role in roles" :key="role.roleId" :label="role.roleId">{{ role.roleName }}</el-checkbox>

            </el-checkbox-group>
          </el-form-item>

        </el-form>
        <div slot="footer" class="dialog-footer">
          <el-button @click="dialogFormVisible = false">取 消</el-button>
          <el-button type="primary" @click="handleSubmitFormData('ruleForm')">确 定</el-button>
        </div>
      </el-dialog>
    </el-card>
  </div>
</template>
<script>
export default {
  name: "sysUser",
  data() {
    var checkusername = (rule, value, callback) => {
      if (this.dataDialogForm.userId !== 0) {
        if (value === "") {
          callback(new Error("请输入用户名"));
        }
        // 说明是更新操作
        callback();
      } else if (value === "") {
        callback(new Error("请输入账号"));
      } else {
        // 调用后端接口 检查 角色名称是否存在
        this.$http
          .get("/sys/sysUser/checkUserName?username=" + value)
          .then((res) => {
            //console.log(res)
            if (res.data.data === "fail") {
              // 说明账号不存在，可以使用
              callback();
            } else {
              callback(new Error("账号重复"));
            }
          });
        //callback();
      }
    };
    var checkpassword = (rule, value, callback) => {
      if (this.dataDialogForm.userId !== 0) {

        // 说明是更新操作
        callback();
      } else {
        if (value === "") {
          callback(new Error("请输入密码"));
        } else { callback(); }

      }

    };
    return {
      dataForm: {
        username: "",
      },
      dataList: [],
      roles: [],
      roleIds:[],
      pageIndex: 1,
      pageSize: 5,
      totalPage: 0,
      dataListLoading: false,
      dialogFormVisible: false,
      dialogFormSubmitVisible: false,
      StatusList: [
        {
          label: '激活',
          value: 1
        }, {
          label: '禁用',
          value: 0

        }
      ],
      dataDialogForm: {
        userId: 0,
        username: "",
        password: "",
        email: "",
        mobile: "",
        status: 1,


      },
      rules: {
        username: [
          { required: true, message: "请输入账号", trigger: "blur" },
          { validator: checkusername, trigger: "blur" }],
        password: [
          { validator: checkpassword, trigger: "blur" },
        ],
      },
    };
  },
  methods: {
    handleUpdateStatus(index, row) {


      var msg = row.status === 1 ? '禁用' : '激活';
      //组装表单数据
      var userStatus = {
        userId: row.userId,
        status: row.status === 1 ? 0 : 1
      }
      this.$confirm("是否确认" + msg + "？", "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: 'warning'
      }).then(() => {
        if (this.dialogFormSubmitVisible) {
          return;
        }
        this.dialogFormSubmitVisible = true;

        // 发送请求禁用用户
        this.$http
          .post("/sys/sysUser/save", userStatus)
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
      })
        .catch(() => {
          this.$message({
            type: 'info',
            message: '已取消' + msg
          });
        });
    },

    handleEdit(index, row) {

      this.$http
        .get("/sys/sysUser/queryUserById?userId=" + row.userId)
        .then((res) => {

          if (res.data && res.data.data) {
            const user = res.data.data.user;
            this.roles = res.data.data.roles;
            this.roleIds=user.roleIds
         
            // 绑定需要更新的数据
            this.dataDialogForm = {
          
              userId: user.userId,
              username: user.username,
              email: user.email,
              mobile: user.mobile,
              status: user.status,
            };

            this.dialogFormVisible = true;
          } else {
            console.error("Invalid response structure:", res);
            this.$message.error("无法获取用户信息，请稍后再试");
          }
        })
        .catch((error) => {
          console.error("Error fetching user data:", error);
          this.$message.error("请求失败，请检查网络连接或联系管理员");
        });
    },
    closeDialog() {
      this.dataDialogForm = {
        userId: 0,
        status: 1,
      };
this.roleIds=[]
    },
    sizeChangeHandle(val) {
      this.pageSize = val;
      this.pageIndex = 1;
      this.getDataList();
    },
    currentChangeHandle(val) {
      this.pageIndex = val;
      this.getDataList();
    },
    openDialog() {
      this.$http
        .get("/sys/sysRole/listAll")
        .then((res) => {
          this.roles = res.data.data;

          this.dialogFormVisible = true;

        })

    },
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

    getDataList() {
      if (this.dataListLoading) {
        return;
      }
      this.dataListLoading = true;
      // 声明params 查询的参数
      const params = {
        params: {
          pageIndex: this.pageIndex,
          pageSize: this.pageSize,
          userName: this.dataForm.username,
        },
      };
      this.$http.get("/sys/sysUser/list", params).then((res) => {
        this.dataList = res.data.data.list;
        this.totalPage = res.data.data.totalCount;
        this.dataListLoading = false;
      });
    },
  }, mounted() {
    this.getDataList();
  }
};
</script>
