<template>
  <div>
    <el-card class="box-card">
      <div class="mod-role">
        <el-form :inline="true" :model="dataForm" class="demo-form-inline">
          <el-form-item>
            <el-input v-model="dataForm.username" clearable placeholder="患者姓名"></el-input>
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
          <el-table-column prop="id" label="患者ID">
          </el-table-column>
          <el-table-column prop="username" label="患者姓名">

          </el-table-column>
          <el-table-column prop="sex" label="性别">
          </el-table-column>
          <el-table-column prop="phone" label="电话">
          </el-table-column>
          <el-table-column prop="age" label="年龄">
          </el-table-column>
          <el-table-column prop="healthTag" label="健康标签">
          </el-table-column>
          <el-table-column prop="createTime" label="就诊日期">
          </el-table-column>
          <el-table-column label="操作" width="250">
            <template slot-scope="scope">
              <el-button size="mini" type="primary" @click="handleEdit(scope.$index, scope.row)">编辑</el-button>
              <el-button size="mini" type="danger" @click="handleDelete(scope.$index, scope.row)">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
        <el-pagination @size-change="sizeChangeHandle" @current-change="currentChangeHandle" :current-page="pageIndex"
          :page-sizes="[5, 10, 20, 50, 100]" :page-size="pageSize" :total="totalPage"
          layout="total, sizes, prev, pager, next, jumper" style="margin-top: 30px">
        </el-pagination>
      </div>


      <el-dialog :title="dataDialogForm.id === 0 ? '新增患者信息' : '更新患者信息'" width="35%" :visible.sync="dialogFormVisible"
        @close="closeDialog()">
        <el-form :model="dataDialogForm" :rules="rules" ref="ruleForm">

          <el-form-item label="患者姓名" label-width="120px" prop="username">
            <el-input v-model="dataDialogForm.username" placeholder="患者姓名" style="width: 300px"></el-input>
          </el-form-item>
          <el-form-item label="联系电话" label-width="120px" prop="phone">
            <el-input v-model="dataDialogForm.phone" placeholder="联系电话" style="width: 300px"></el-input>
          </el-form-item>
          <el-form-item label="性别" label-width="120px" prop="sex">
            <el-input v-model="dataDialogForm.sex" placeholder="性别" style="width: 300px"></el-input>
          </el-form-item>
          <el-form-item label="年龄" label-width="120px" prop="age">
            <el-input v-model="dataDialogForm.age" placeholder="年龄" style="width: 300px"></el-input>
          </el-form-item>
          <el-form-item label="健康标签" label-width="120px" prop="healthTag">
            <el-input v-model="dataDialogForm.healthTag" placeholder="健康标签" style="width: 300px"></el-input>
          </el-form-item>
          <el-form-item label="身份证号" label-width="120px" prop="idCard">
            <el-input v-model="dataDialogForm.idCard" placeholder="身份证号" style="width: 300px"></el-input>
          </el-form-item>
          <el-form-item label="地址" label-width="120px" prop="address">
            <el-input v-model="dataDialogForm.address" placeholder="地址" style="width: 300px"></el-input>
          </el-form-item>
          <el-form-item label="血型" label-width="120px" prop="bioodType">
            <el-input v-model="dataDialogForm.bioodType" placeholder="血型" style="width: 300px"></el-input>
          </el-form-item>
          <el-form-item label="家族遗传史" label-width="120px" prop="genetic">
            <el-input v-model="dataDialogForm.genetic" placeholder="家族遗传史" style="width: 300px"></el-input>
          </el-form-item>
          <el-form-item label="过敏源" label-width="120px" prop="allergy">
            <el-input v-model="dataDialogForm.allergy" placeholder="过敏源" style="width: 300px"></el-input>
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
  name: "Patient",
  data() {
    var checkusername = (rule, value, callback) => {
      if (this.dataDialogForm.id !== 0) {
        if (value === "") {
          callback(new Error("请输入用户名"));
        }
        // 说明是更新操作
        callback();
      } else if (value === "") {
        callback(new Error("请输入用户名"));
      } else {
        // 调用后端接口 检查 角色名称是否存在
        // this.$http
        //   .get("/pat/patient/checkUserName?username=" + value)
        //   .then((res) => {
        //     //console.log(res)
        //     if (res.data.data === "fail") {
        //       // 说明账号不存在，可以使用
        //       callback();
        //     } else {
        //       callback(new Error("账号重复"));
        //     }
        //   });
        callback();
      }
    };
    return {
      dataForm: {
        username: "",
      },
      dataList: [],
      dialogFormVisible: false,
      pageIndex: 1,
      pageSize: 5,
      totalPage: 0,
      dataListLoading: false,
        dialogFormSubmitVisible: false,

      dataDialogForm: {
        id: 0,
        username: "",
        password: "",
        email: "",
        mobile: "",
        status: 1,
      },
      rules: {
        username: [
          { required: true, message: "请输入姓名", trigger: "blur" },
          { validator: checkusername, trigger: "blur" }],

      },
    };
  },

  methods: {
    handleDelete(index,row){
  // 删除角色信息
  this.$confirm("此操作将永久该记录, 是否继续?", "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "warning",
      }) .then(() => {
          if (this.dialogFormSubmitVisible) {
            return;
          }
          this.dialogFormSubmitVisible = true;
          this.$http
            .get("/pat/patient/deletePat?id=" + row.id)
            .then((res) => {
              console.log(res)
              if(res.data.data === '0'){
                // 表示数据不能被删除
                this.$message({
                type: "warning",
                message: "该条记录不允许删除!",
              });
              }else{
                this.$message({
                type: "success",
                message: "删除成功!",
              });
              }
              this.dialogFormSubmitVisible = false;
              // 刷新数据
              this.getDataList();
            });
        })
        .catch(() => {
            this.dialogFormSubmitVisible = false;
          this.$message({
            type: "info",
            message: "已取消删除",
            

          });
        });
    },
    sizeChangeHandle(val) {
      this.pageSize = val;
      this.pageIndex = 1;
      this.getDataList();
    },
    openDialog() {
      this.dialogFormVisible = true;
    },
    handleEdit(index, row) {

      this.$http
        .get("/pat/patient/queryPatById?id=" + row.id)
        .then((res) => {
            const user = res.data.data;
            // this.roles = res.data.data.roles;
            // this.roleIds=user.roleIds
            // 绑定需要更新的数据
            console.log(user)
            this.dataDialogForm = {
              id: user.id, 
              username: user.username,
              phone: user.phone,
              sex: user.sex,
              age: user.age,
              healthTag: user.healthTag,
              idCard: user.idCard,
              address: user.address,
              bioodType: user.bioodType,
              genetic: user.genetic,
              allergy: user.allergy,
            };
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
          this.$http
            .post("/pat/patient/save", this.dataDialogForm)
            .then((res) => {
              this.dialogFormVisible = false; // 关闭窗口
              // 清空添加数据的表单
              this.dataDialogForm = {
  
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
    currentChangeHandle(val) {
      this.pageIndex = val;
      this.getDataList();
    },
    closeDialog() {
      this.dataDialogForm = {
        id: 0,
      };
    },
    getDataList() {
      if (this.dataListLoading) {
        return;
      }
      this.dataListLoading = true;
      // 声明params 查询的参数
      const params = {
        params: {
          userName: this.dataForm.username,
          pageIndex: this.pageIndex,
          pageSize: this.pageSize,
        },
      };
      this.$http.get("/pat/patient/list", params).then((res) => {
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