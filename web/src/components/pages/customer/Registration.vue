<template>
    <div>
      <el-card class="box-card">
        <div class="mod-role">
          <el-form :inline="true" :model="dataForm" class="demo-form-inline">
            <!-- <el-form-item>
              <el-input v-model="dataForm.username" clearable placeholder="患者姓名"></el-input>
            </el-form-item>
            <el-form-item>
              <el-button @click="getDataList">查询</el-button>
            </el-form-item> -->
          </el-form>
          <el-table :data="dataList" border style="width: 100%">
            <el-table-column type="selection" width="55"> </el-table-column>
            <el-table-column prop="id" label="患者ID">
            </el-table-column>
            <el-table-column prop="username" label="患者姓名">
  
            </el-table-column>
            <el-table-column prop="symptoms" label="病况具体描述">
            </el-table-column>

            
            <el-table-column label="操作" width="250">
              <template slot-scope="scope">
                <el-button size="mini" type="primary" @click="handleEdit(scope.$index, scope.row)">查看</el-button>
                <el-button size="mini" type="success" @click="handleEdita(scope.$index, scope.row)">诊断</el-button>
              </template>
              
            </el-table-column>
          </el-table>
          <!-- <el-pagination @size-change="sizeChangeHandle" @current-change="currentChangeHandle" :current-page="pageIndex"
            :page-sizes="[5, 10, 20, 50, 100]" :page-size="pageSize" :total="totalPage"
            layout="total, sizes, prev, pager, next, jumper" style="margin-top: 30px">
          </el-pagination> -->
        </div>
  
  
        <el-dialog title="查看详情" width="35%" :visible.sync="dialogVisible" @close="closeDialog()">
          
       <el-form :model="dataDialogForm" disabled >
  
  <el-form-item label="患者姓名" label-width="120px" prop="username" >
    <el-input v-model="dataDialogForm.username" placeholder="患者姓名" style="width: 300px"></el-input>
  </el-form-item>
  <el-form-item label="联系电话" label-width="120px" prop="phone">
    <el-input v-model="dataDialogForm.phone" placeholder="联系电话" style="width: 300px"></el-input>
  </el-form-item>
  <el-form-item label="性别" label-width="120px" prop="sex">
    <el-input v-model="dataDialogForm.sex" placeholder="性别" style="width: 300px"></el-input>
  </el-form-item>
  <el-form-item label="年龄" label-width="120px" prop="age">
    <el-input v-model="dataDialogForm.age" placeholder="邮箱" style="width: 300px"></el-input>
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
            <el-button @click="dialogVisible = false">取 消</el-button>
  
          </div>
        </el-dialog>





        <el-dialog title="诊断" width="35%" :visible.sync="dialogVisiblea" @close="closeDialog()">
          
          <el-form :model="dataDialogForm"  >
     
     <el-form-item label="患者姓名" label-width="120px" prop="username" >
       <el-input v-model="dataDialogForm.username" placeholder="患者姓名" style="width: 300px" disabled></el-input>
     </el-form-item>
     <el-form-item label="回复">
    <el-input type="textarea" v-model="dataDialogForm.hf"></el-input>
  </el-form-item>

     
     
     </el-form>
             <div slot="footer" class="dialog-footer">
               <el-button @click="dialogVisible = false">取 消</el-button>
               <el-button type="primary" @click="handleSubmitFormData('ruleForm')">确 定</el-button>
             </div>
           </el-dialog>
  
  
      </el-card>
    </div>
  </template>
  <script>
  export default {
    name:'Registration',
    data() {
     
      return {
        dataForm: {
          username: "",
        },
    
        dataList: [],
        dialogFormVisible: false,
        // pageIndex: 1,
        // pageSize: 5,
        // totalPage: 0,
        dataListLoading: false,
        dialogFormSubmitVisible: false,
        dialogVisible: false,
        dialogVisiblea: false,
        
        dataDialogForm: {
          id: 0,
          username: "",
          password: "",
          email: "",
          mobile: "",
          hf:"",
          status: 1,
        },
        
      };
    },
  
    methods: {
      handleEdit(index, row) {
        this.$http
          .get("/pat/patient/queryPatById?id=" + row.id)
          .then((res) => {
            const user = res.data.data;
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
            this.dialogVisible = true; // 设置对话框可见
          });
      },
      handleSubmitFormData(formName) {

  
          this.dialogFormSubmitVisible = true;
          this.$http
            .post("/pat/patient/hfsave", this.dataDialogForm)
            .then((res) => {
              this.dialogVisiblea = false; // 关闭窗口
              // 清空添加数据的表单
              this.dataDialogForm = {
  
              };
              this.dialogFormSubmitVisible = false;
              // 刷新数据
              this.getDataList();
            });
        
      
    },
      handleEdita(index, row) {
        this.$http
          .get("/pat/patient/queryPatById?id=" + row.id)
          .then((res) => {
            const user = res.data.data;
            this.dataDialogForm = {
              id: user.id,
              hf: user.hf,
              username: user.username,
            //   phone: user.phone, // 将 phone 转换为字符串
            //   sex: user.sex,
            //   age: user.age,
            //   healthTag: user.healthTag,
            //   idCard: user.idCard,
            //   address: user.address,
            //   bioodType: user.bioodType,
            //   genetic: user.genetic,
            //   allergy: user.allergy,
            };
            this.dialogVisiblea = true; // 设置对话框可见
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
     
     
      currentChangeHandle(val) {
        this.pageIndex = val;
        this.getDataList();
      },
      closeDialog() {
        this.dialogVisible = false; // 关闭对话框
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
        // const params = {
        //   params: {
        //     userName: this.dataForm.username,
        //     pageIndex: this.pageIndex,
        //     pageSize: this.pageSize,
        //   },
        // };
  
        this.$http.get("/pat/patient/ghlist").then((res) => {
          this.dataList = res.data.data;
          //this.totalPage = res.data.data.totalCount;
          this.dataListLoading = false;
        });
      },
    }, mounted() {
      this.getDataList();
    }
  };
  </script >
  
