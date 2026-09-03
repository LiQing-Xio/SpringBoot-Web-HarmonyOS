<template>
  <div>
    <el-card class="box-card">
      <div class="mod-role">
        <el-form :inline="true" :model="dataForm" class="demo-form-inline">
          <el-form-item>
            <el-input v-model="dataForm.name" clearable placeholder="药品名"></el-input>
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
          <el-table-column prop="id" label="药品id"></el-table-column>
          <el-table-column prop="name" label="药品名"></el-table-column>
      
          <el-table-column prop="content" label="介绍"></el-table-column>
          <el-table-column prop="type" label="类型"></el-table-column>
          
          <el-table-column label="操作" width="250">
            <template slot-scope="scope">
              <el-button size="mini" type="primary" @click="handleEdit(scope.$index, scope.row)">编辑</el-button>
              <el-button size="mini" type="danger" @click="handleDelete(scope.$index, scope.row)">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
        <el-pagination 
          @size-change="sizeChangeHandle" 
          @current-change="currentChangeHandle" 
          :current-page="pageIndex"
          :page-sizes="[5, 10, 20, 50, 100]" 
          :page-size="pageSize" 
          :total="totalPage"
          layout="total, sizes, prev, pager, next, jumper" 
          style="margin-top: 30px">
        </el-pagination>
      </div>

      <el-dialog 
        :title="dataDialogForm.id === 0 ? '新增药品名' : '更新药品信息'" 
        width="35%" 
        :visible.sync="dialogFormVisible"
        @close="closeDialog()">
        <el-form :model="dataDialogForm" :rules="rules" ref="ruleForm">
          <el-form-item label="药品名" label-width="120px" prop="name">
            <el-input v-model="dataDialogForm.name" placeholder="药品名" style="width: 300px"></el-input>
          </el-form-item>
          
          <el-form-item label="介绍" label-width="120px" prop="content">
            <el-input v-model="dataDialogForm.content" placeholder="介绍" style="width: 300px"></el-input>
          </el-form-item>
          <el-form-item label="类型" label-width="120px" prop="type">
            <el-input v-model="dataDialogForm.type" placeholder="类型" style="width: 300px"></el-input>
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
  name: "DrugknowledgebaseList",
  data() {
    var checkusername = (rule, value, callback) => {
      if (this.dataDialogForm.id !== 0) {
        if (value === "") {
          callback(new Error("请输入药品名"));
        }
        callback();
      } else if (value === "") {
        callback(new Error("请输入药品名"));
      } else {
        callback();
      }
    };
    return {
      dataForm: {
        name: "",
      },
      dataList: [],
      dialogFormVisible: false,
      pageIndex: 1,
      pageSize: 5,
      totalPage: 0,
      imageUrl: '',
      dataListLoading: false,
      dialogFormSubmitVisible: false,
      dataDialogForm: {
        id: 0,
        name: "",
        img: "",
        content: "",
        type: ""
      },
      rules: {
        username: [
          { required: true, message: "请输入药品名", trigger: "blur" },
          { validator: checkusername, trigger: "blur" }
        ],
      },
    };
  },

  methods: {
    handleDelete(index, row) {
      this.$confirm("此操作将永久该记录, 是否继续?", "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "warning",
      }).then(() => {
        if (this.dialogFormSubmitVisible) {
          return;
        }
        this.dialogFormSubmitVisible = true;
        this.$http
          .get("/know/know/deleteKnow?id=" + row.id)
          .then((res) => {
            console.log(res)
            if (res.data.data === '0') {
              this.$message({
                type: "warning",
                message: "该条记录不允许删除!",
              });
            } else {
              this.$message({
                type: "success",
                message: "删除成功!",
              });
            }
            this.dialogFormSubmitVisible = false;
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

    handleAvatarSuccess(res) {
      this.dataDialogForm.img = res.data.data;
      this.$message.success('图片上传成功');
    },

    beforeAvatarUpload(file) {
      const isJPG = file.type === 'image/jpeg' || file.type === 'image/png';
      const isLt2M = file.size / 1024 / 1024 < 2;

      if (!isJPG) {
        this.$message.error('上传头像图片只能是 JPG /PNG格式!');
      }
      if (!isLt2M) {
        this.$message.error('上传头像图片大小不能超过 2MB!');
      }
      return isJPG && isLt2M;
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
        .get("/know/know/queryPatById?id=" + row.id)
        .then((res) => {
          const user = res.data.data;
          this.dataDialogForm = {
            id: user.id,
            name: user.name,
            content: user.content,
            type: user.type
          };
          this.dialogFormVisible = true;
        });
    },

    handleSubmitFormData(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          if (this.dialogFormSubmitVisible) {
            return;
          }
          this.dialogFormSubmitVisible = true;
          this.$http
            .post("/know/know/save", this.dataDialogForm)
            .then((res) => {
              this.dialogFormVisible = false;
              this.dataDialogForm = {};
              this.dialogFormSubmitVisible = false;
              this.getDataList();
            });
        } else {
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
      const params = {
        params: {
          name: this.dataForm.name,
          pageIndex: this.pageIndex,
          pageSize: this.pageSize,
        },
      };
      this.$http.get("/know/know/list", params).then((res) => {
        this.dataList = res.data.data.list;
        this.totalPage = res.data.data.totalCount;
        this.dataListLoading = false;
      });
    },
  },
  
  mounted() {
    this.getDataList();
  }
};
</script>

<style>
.avatar-uploader .el-upload {
  border: 1px dashed #d9d9d9;
  border-radius: 6px;
  cursor: pointer;
  position: relative;
  overflow: hidden;
}

.avatar-uploader .el-upload:hover {
  border-color: #409EFF;
}

.avatar-uploader-icon {
  font-size: 28px;
  color: #8c939d;
  width: 178px;
  height: 178px;
  line-height: 178px;
  text-align: center;
}

.avatar {
  width: 178px;
  height: 178px;
  display: block;
}
</style>