<template>
    <div class="patient-report">
      <el-card class="report-card">
        <template #header>
          <h2 class="report-title">患者报告</h2>
        </template>
        <el-row>
          <el-col :span="12">
            <el-form label-width="120px" class="report-form">
              <el-form-item label="患者姓名">
                <span class="info-text">{{ patientInfo.username }}</span>
              </el-form-item>
              <el-form-item label="联系电话">
                <span class="info-text">{{ patientInfo.phone }}</span>
              </el-form-item>
              <el-form-item label="性别">
                <span class="info-text">{{ patientInfo.sex }}</span>
              </el-form-item>
              <el-form-item label="年龄">
                <span class="info-text">{{ patientInfo.age }}</span>
              </el-form-item>
              <el-form-item label="健康标签">
                <span class="info-text">{{ patientInfo.healthTag }}</span>
              </el-form-item>
              <el-form-item label="时间">
                <span class="info-text">{{ patientInfo.createTime }}</span>
              </el-form-item>
            </el-form>
          </el-col>
          <el-col :span="12">
            <el-form label-width="120px" class="report-form">
              <el-form-item label="身份证号">
                <span class="info-text">{{ patientInfo.idCard }}</span>
              </el-form-item>
              <el-form-item label="地址">
                <span class="info-text">{{ patientInfo.address }}</span>
              </el-form-item>
              <el-form-item label="血型">
                <span class="info-text">{{ patientInfo.bioodType }}</span>
              </el-form-item>
              <el-form-item label="家族遗传史">
                <span class="info-text">{{ patientInfo.genetic }}</span>
              </el-form-item>
              <el-form-item label="过敏源">
                <span class="info-text">{{ patientInfo.allergy }}</span>
              </el-form-item>
              <el-form-item label="医生诊断">
                <span class="info-text">{{ patientInfo.hf }}</span>
              </el-form-item>
            </el-form>
          </el-col>
        </el-row>
      </el-card>
    </div>
  </template>
   
  <script>
  import axios from "axios"; // 确保安装了 axios
   
  export default {
    data() {
      return {
        patientInfo: {}, // 初始化为对象
      };
    },
    mounted() {
      this.getPat();
    },
    methods: {
      getPat() {
        axios
          .get("/pat/patient/inlist") // 使用 axios 发起请求
          .then((res) => {
            if (res.data.code === "SUCCESS" && res.data.data && res.data.data.length > 0) {
              const patientData = res.data.data[0]; // 获取第一个患者数据
   
              // 映射到 patientInfo
              this.patientInfo = {
                id: patientData.id,
                username: patientData.username,
                phone: patientData.phone,
                sex: patientData.sex,
                age: patientData.age,
                healthTag: patientData.healthTag, // 修正字段名称
                createTime: patientData.createTime,
                idCard: patientData.idCard,
                address: patientData.address,
                bioodType: patientData.bioodType, // 修正字段名称
                genetic: patientData.genetic,
                allergy: patientData.allergy,
                hf: patientData.hf,
              };
            } else {
              this.$message.warning("未获取到健康数据");
            }
          })
          .catch((error) => {
            console.error("获取健康数据失败:", error);
            this.$message.error("获取健康数据失败");
          });
      },
    },
  };
  </script>
   
  
  <style scoped>
  .patient-report {
    padding: 20px;
    display: flex;
    justify-content: center;
  }
  
  .report-card {
    width: 80%;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    border-radius: 8px;
  }
  
  .report-title {
    color: #333;
    font-size: 24px;
    font-weight: 600;
    margin: 0;
  }
  
  .report-form {
    padding: 20px;
  }
  
  .el-form-item__label {
    font-weight: 500;
    color: #666;
  }
  
  .info-text {
    color: #333;
    font-size: 16px;
  }
  </style>
      