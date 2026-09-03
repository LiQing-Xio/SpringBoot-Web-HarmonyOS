<template>
    <div class="appointment-container">
      <!-- 顶部标题和面包屑 -->
      <el-breadcrumb separator="/" class="breadcrumb">
        <el-breadcrumb-item :to="{ path: '/Main' }">首页</el-breadcrumb-item>
        <el-breadcrumb-item>预约挂号</el-breadcrumb-item>
      </el-breadcrumb>
  
      <el-card shadow="hover" class="appointment-card">
        <!-- 步骤条 -->
        <el-steps :active="activeStep" finish-status="success" simple>
          <el-step title="选择科室"></el-step>
          <el-step title="选择医生"></el-step>
          <el-step title="选择时间"></el-step>
          <el-step title="确认信息"></el-step>
        </el-steps>
  
        <div class="step-content">
          <!-- 第一步：选择科室 -->
          <div v-show="activeStep === 0" class="step-panel">
            <h3>请选择就诊科室</h3>
            <el-row :gutter="20">
              <el-col 
                v-for="dept in departments" 
                :key="dept.id" 
                :xs="12" 
                :sm="8" 
                :md="6"
              >
                <div 
                  class="dept-card" 
                  :class="{ 'active': selectedDept === dept.id }"
                  @click="selectDept(dept)"
                >
                  <i class="el-icon-first-aid-kit"></i>
                  <h4>{{ dept.name }}</h4>
                  <p>{{ dept.description }}</p>
                </div>
              </el-col>
            </el-row>
          </div>
  
          <!-- 第二步：选择医生 -->
          <div v-show="activeStep === 1" class="step-panel">
            <h3>请选择医生</h3>
         
  
            <el-row :gutter="20" class="doctor-list">
              <el-col 
                v-for="doctor in filteredDoctors" 
                :key="doctor.id" 
                :xs="24" 
                :sm="12" 
                :md="8"
              >
                <el-card shadow="hover" class="doctor-card">
                  <div class="doctor-info">
                    <el-avatar :size="80" :src="doctor.avatar"></el-avatar>
                    <div class="doctor-detail">
                      <h4>{{ doctor.dname }} <el-tag size="mini">{{ doctor.title }}</el-tag></h4>
                      <p class="specialty">擅长：{{ doctor.specialty }}</p>
                      <p class="bio">{{ doctor.bio }}</p>
                    </div>
                  </div>
                  <el-button 
                    type="primary" 
                    size="small" 
                    @click="selectDoctor(doctor)"
                  >
                    选择该医生
                  </el-button>
                </el-card>
              </el-col>
            </el-row>
          </div>
  
          <!-- 第三步：选择时间 -->
          <div v-show="activeStep === 2" class="step-panel">
            <h3>请选择预约时间</h3>
            <div class="date-selector">
              <el-date-picker
                v-model="selectedDay"
                type="date"
                placeholder="选择日期"
                :picker-options="dateOptions"
                @change="loadSchedule"
              ></el-date-picker>
            </div>
  
            <div v-if="timeSlots.length > 0" class="time-slot-container">
              <h4>{{ selectedDay | formatDate }} 可预约时段</h4>
              <div class="time-slots">
                <el-button
                  v-for="slot in timeSlots"
                  :key="slot.id"
                  :class="{ 'selected': selectedSlot === slot.id }"
                  @click="selectTimeSlot(slot)"
                >
                  <div class="slot-time">{{ slot.startTime | formatTime }} - {{ slot.endTime | formatTime }}</div>
                  <div class="slot-status" :class="{ 'full': !slot.available }">
                    {{ slot.available ? '可预约' : '已约满' }}
                  </div>
                </el-button>
              </div>
            </div>
            <el-empty v-else description="该医生当天没有排班"></el-empty>
          </div>
  
          <!-- 第四步：确认信息 -->
          <div v-show="activeStep === 3" class="step-panel confirm-panel">
            <h3>请确认预约信息</h3>
            <el-descriptions :column="1" border>
              <el-descriptions-item label="就诊科室">{{ selectedDeptName }}</el-descriptions-item>
              <el-descriptions-item label="医生姓名">{{ selectedDoctorName }}</el-descriptions-item>
              <el-descriptions-item label="预约时间">{{ selectedTimeText }}</el-descriptions-item>
            </el-descriptions>
  
            <el-form :model="appointmentForm" :rules="rules" ref="form">
              <el-form-item label="症状描述" prop="symptoms">
                <el-input
                  type="textarea"
                  v-model="appointmentForm.symptoms"
                  :rows="4"
                  placeholder="请详细描述您的症状或病情"
                ></el-input>
              </el-form-item>
            </el-form>
  
            <div class="action-buttons">
              <el-button @click="activeStep--">上一步</el-button>
              <el-button 
                type="primary" 
                @click="submitAppointment"
                :loading="submitting"
              >
                提交预约
              </el-button>
            </div>
          </div>
        </div>
      </el-card>
    </div>
  </template>
  
  <script>
  export default {
    data() {
      return {
        activeStep: 0,
        // 科室数据
        departments: [
          { id: 1, name: '统一科室', description: '感冒、发烧、高血压等日常疾病' },
          // { id: 2, name: '外科', description: '创伤、骨折、手术等' },
          // { id: 3, name: '儿科', description: '儿童常见疾病' },
          // { id: 4, name: '妇产科', description: '妇科疾病、孕产检查' },
          // { id: 5, name: '眼科', description: '视力检查、眼部疾病' },
          // { id: 6, name: '口腔科', description: '牙齿治疗、口腔护理' }
        ],
        selectedDept: null,
        // 医生数据
        doctors: [],
        doctorKeyword: '',
        selectedDoctor: null,
        // 时间选择
        selectedDay: new Date(),
        dateOptions: {
          disabledDate(time) {
            // 禁用过去的日期
            return time.getTime() < Date.now() - 24 * 60 * 60 * 1000;
          }
        },
        timeSlots: [],
        selectedSlot: null,
        // 预约表单
        appointmentForm: {
          symptoms: ''
        },
        rules: {
          symptoms: [
            { required: true, message: '请描述您的症状', trigger: 'blur' },
            { min: 10, message: '至少输入10个字符', trigger: 'blur' }
          ]
        },
        submitting: false
      }
    },
    computed: {
      // 过滤医生列表
      filteredDoctors() {
        if (!this.doctorKeyword) return this.doctors;
        return this.doctors.filter(doctor => 
          doctor.dname.includes(this.doctorKeyword)
        );
      },
      // 选中的科室名称
      selectedDeptName() {
        const dept = this.departments.find(d => d.id === this.selectedDept);
        return dept ? dept.name : '';
      },
      // 选中的医生名称
      selectedDoctorName() {
  const doctor = this.doctors.find(d => d.id === this.selectedDoctor);
  console.log('Selected Doctor:', doctor); // 调试输出
  return doctor ? `${doctor.dname} (${doctor.title})` : '未选择医生';
},
      // 选中的时间文本
      selectedTimeText() {
        const slot = this.timeSlots.find(s => s.id === this.selectedSlot);
        if (!slot) return '';
        return `${this.$options.filters.formatDate(this.selectedDay)} ${this.$options.filters.formatTime(slot.startTime)}-${this.$options.filters.formatTime(slot.endTime)}`;
      }
    },
    filters: {
      formatDate(date) {
        if (!date) return '';
        const d = new Date(date);
        return `${d.getMonth() + 1}月${d.getDate()}日`;
      },
      formatTime(time) {
        // 假设time是"HH:mm"格式
        return time || '';
      }
    },
    methods: {
      // 选择科室
      selectDept(dept) {
        this.selectedDept = dept.id;
        this.loadDoctors();
        this.nextStep();
      },
      // 加载医生列表
      async loadDoctors() {
  const res = await this.$http.get("/doc/doc/list");
  this.doctors = res.data.data.map(doctor => ({
    id: doctor.id,
    dname: doctor.dname,
    title: doctor.title,
    specialty: doctor.good,
    bio: doctor.exp
  }));
},
      // 选择医生
      selectDoctor(doctor) {
  if (doctor && doctor.id) {
    this.selectedDoctor = doctor.id;
    this.nextStep();
  } else {
    this.$message.error('无法选择医生，请重试');
  }
},
      // 加载排班时间
      async loadSchedule() {
       
        this.timeSlots = [
          {
            id: 1,
            startTime: '09:00',
            endTime: '09:30',
            available: true
          },
          {
            id: 2,
            startTime: '10:00',
            endTime: '10:30',
            available: true
          },
          {
            id: 3,
            startTime: '14:00',
            endTime: '14:30',
            available: false
          }
        ];
      },
      // 选择时间段
      selectTimeSlot(slot) {
        if (!slot.available) {
          this.$message.warning('该时段已约满，请选择其他时间');
          return;
        }
        this.selectedSlot = slot.id;
        this.nextStep();
      },
      // 下一步
      nextStep() {
        this.activeStep++;
      },
      // 提交预约
      submitAppointment() {
        this.$refs.form.validate(valid => {
          if (valid) {
            this.submitting = true;
            // 模拟API请求
            const formData = {
            ...this.appointmentForm,
            // deptId: this.selectedDept,
            // doctorId: this.selectedDoctor,
            // slotId: this.selectedSlot,
            // appointmentDate: this.selectedDay
          };
          this.$http.post("/doc/doc/save", formData);
            setTimeout(() => {
              this.submitting = false;
              this.$message.success('预约成功！');
              this.$router.push('/main');
            }, 1000);
          }
        });
      }
    }
  }
  </script>
  
  <style scoped>
  .appointment-container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 20px;
  }
  
  .breadcrumb {
    margin-bottom: 20px;
  }
  
  .appointment-card {
    margin-top: 20px;
  }
  
  .step-content {
    margin-top: 30px;
    min-height: 400px;
  }
  
  .dept-card {
    border: 1px solid #ebeef5;
    border-radius: 4px;
    padding: 20px;
    margin-bottom: 20px;
    cursor: pointer;
    transition: all 0.3s;
    text-align: center;
  }
  
  .dept-card:hover {
    border-color: #409EFF;
    box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
  }
  
  .dept-card.active {
    border-color: #409EFF;
    background-color: #f5f7fa;
  }
  
  .dept-card i {
    font-size: 36px;
    color: #409EFF;
    margin-bottom: 10px;
  }
  
  .search-input {
    margin-bottom: 20px;
    max-width: 300px;
  }
  
  .doctor-card {
    margin-bottom: 20px;
  }
  
  .doctor-info {
    display: flex;
    margin-bottom: 15px;
  }
  
  .doctor-detail {
    margin-left: 15px;
  }
  
  .doctor-detail h4 {
    margin: 0 0 5px 0;
  }
  
  .specialty {
    color: #666;
    font-size: 13px;
    margin: 5px 0;
  }
  
  .bio {
    color: #999;
    font-size: 12px;
    margin: 5px 0;
  }
  
  .date-selector {
    margin-bottom: 20px;
  }
  
  .time-slot-container {
    margin-top: 20px;
  }
  
  .time-slots {
    display: flex;
    flex-wrap: wrap;
    gap: 10px;
  }
  
  .time-slots .el-button {
    width: 120px;
    height: 60px;
    display: flex;
    flex-direction: column;
    justify-content: center;
  }
  
  .slot-time {
    font-weight: bold;
  }
  
  .slot-status {
    font-size: 12px;
    margin-top: 5px;
  }
  
  .slot-status.full {
    color: #f56c6c;
  }
  
  .time-slots .el-button.selected {
    background-color: #409EFF;
    color: white;
  }
  
  .confirm-panel {
    max-width: 600px;
    margin: 0 auto;
  }
  
  .action-buttons {
    margin-top: 30px;
    text-align: center;
  }
  </style>