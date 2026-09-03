<template>
    <div class="medication-reminder">
      <el-card class="reminder-card">
        <template #header>
          <h2 class="reminder-title">用药提醒</h2>
        </template>
        <div class="add-reminder">
          <el-form :model="newReminders" label-width="80px">
            <el-form-item label="药品名称">
              <el-input v-model="newReminders.newReminder"></el-input>
            </el-form-item>
            <el-form-item label="用药时间">
              <el-time-picker
                v-model="newReminders.time"
                format="HH:mm"
                value-format="HH:mm"
                placeholder="选择用药时间"
              ></el-time-picker>
            </el-form-item>
            <el-form-item>
              <el-button type="primary" @click="addReminder">添加提醒</el-button>
            </el-form-item>
          </el-form>
        </div>
        <div class="reminder-list">
          <el-table :data="reminders" stripe>
            <el-table-column prop="newReminder" label="药品名称"></el-table-column>
            <el-table-column prop="time" label="用药时间"></el-table-column>
            <el-table-column label="操作">
              <template #default="scope">
                <el-button type="danger" size="mini" @click="deleteReminder(scope.row)">删除</el-button>
              </template>
            </el-table-column>
          </el-table>
        </div>
      </el-card>
    </div>
  </template>
  
  <script>
  import ElementUI from 'element-ui';
  import 'element-ui/lib/theme-chalk/index.css';
  
  export default {
    data() {
      return {
        newReminders: {
          newReminder: '',
          time: ''
        },
        reminders: [
          // {
          //   medicationName: '阿司匹林',
          //   time: '08:00'
          // }
        ]
      };
    },
 
    methods: {
      getList(){
        this.$http.get("/yytx/yytx/list").then((res) => {
                this.reminders = res.data.data;
            });
      },
      addReminder() {
        if (this.newReminders.newReminder && this.newReminders.time) {
          this.$http
            .post("/yytx/yytx/save", this.newReminders)
            .then((res) => {
            
              this.getList();
            });
       
        } else {
          this.$message.warning('请填写药品名称和用药时间');
        }
      },
      deleteReminder(row) {  // 接收行对象参数
  this.$confirm('确定删除该用药提醒吗？', '警告', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(() => {
    this.$http.get("/yytx/yytx/delete?id=" + row.id)
      .then((res) => {
 
          this.$message.success("删除成功");
          this.getList();  // 刷新列表
      
      });
  }).catch(() => {});
}
    },mounted() {
     this.getList();
    }
  };
  </script>
  
  <style scoped>
  .medication-reminder {
    padding: 20px;
    display: flex;
    justify-content: center;
  }
  
  .reminder-card {
    width: 80%;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    border-radius: 8px;
  }
  
  .reminder-title {
    color: #333;
    font-size: 24px;
    font-weight: 600;
    margin: 0;
  }
  
  .add-reminder {
    padding: 20px;
  }
  
  .reminder-list {
    padding: 20px;
  }
  </style>    