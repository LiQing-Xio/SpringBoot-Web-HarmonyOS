<template>
  <div class="patient-dashboard">

    <!-- 主内容区 -->
    <div class="main-content">
      <!-- 快速入口 -->
      <el-row :gutter="20" class="quick-access">
        <el-col :xs="24" :sm="12" :md="6" v-for="(item, index) in quickActions" :key="index">
          <el-card shadow="hover" class="action-card" @click.native="handleAction(item.action)">
            <i :class="item.icon" class="action-icon"></i>
            <h3>{{ item.title }}</h3>
            <p>{{ item.desc }}</p>
          </el-card>
        </el-col>
      </el-row>

      <!-- 健康概览 -->
      <el-row :gutter="20">
        <el-col :span="16">
          <el-card class="health-overview">
            <div slot="header">
              <span>健康数据概览</span>
              <!-- <el-button type="text" @click="viewDetail">查看详情</el-button> -->
            </div>
            <el-table :data="healthData" stripe style="width: 100%">
              <el-table-column prop="date" label="创建日期" width="180"></el-table-column>
              <el-table-column prop="bloodPressure" label="健康标签"></el-table-column>
              <el-table-column prop="bloodSugar" label="血型"></el-table-column>
              <el-table-column prop="weight" label="过敏原"></el-table-column>
            </el-table>
          </el-card>
        </el-col>

        <el-col :span="8">
          <!-- 待办事项 -->
          <el-card class="todo-list">
            <div slot="header">待办事项</div>
            <el-checkbox-group v-model="checkedTodos">
              <div v-for="(todo, index) in todos" :key="index" class="todo-item">
                <el-checkbox :label="todo.id">{{ todo.content }}</el-checkbox>
                <span class="due-time">{{ todo.dueTime }}</span>
              </div>
            </el-checkbox-group>
          </el-card>
        </el-col>
      </el-row>

      <!-- 近期预约 -->
      <el-card class="upcoming-appointments">
        <div slot="header">近期情况</div>
        <el-timeline>
          <el-timeline-item v-for="(appointment, index) in appointments" :key="index">
            {{ appointment.doctor }} - {{ appointment.department }}
          </el-timeline-item>
        </el-timeline>
      </el-card>
    </div>
    <!-- 系统脚注 -->
    <footer class="app-footer">
      <el-row :gutter="20" class="footer-content">
        <el-col :xs="24" :sm="8" class="footer-section">
          <h4>关于我们</h4>
          <p>家庭医生健康管理系统</p>
          <p>致力于提供专业可靠的医疗健康服务</p>
          <div class="certification">
            <i class="el-icon-medal"></i>
            <span>医疗资质认证</span>
          </div>
        </el-col>

        <el-col :xs="24" :sm="8" class="footer-section">
          <h4>联系我们</h4>
          <div class="contact-item">
            <i class="el-icon-phone"></i>
            <span>服务热线：400-1234-5678</span>
          </div>
          <div class="contact-item">
            <i class="el-icon-message"></i>
            <span>邮箱：service@health.com</span>
          </div>
          <div class="contact-item">
            <i class="el-icon-location"></i>
            <span>地址：北京市朝阳区健康大道88号</span>
          </div>
        </el-col>

        <el-col :xs="24" :sm="8" class="footer-section">
          <h4>快速链接</h4>
          <el-link type="info">关于系统</el-link>
          <el-link type="info">帮助中心</el-link>
          <el-link type="info">隐私政策</el-link>
          <div class="qrcode">


          </div>
        </el-col>
      </el-row>

      <div class="copyright">
        <el-divider></el-divider>
        <p>© 2025 家庭医生健康管理系统 京ICP备12345678号-1</p>
        <p>互联网药品信息服务资格证：（京）-经营性-2025-0011</p>
      </div>
    </footer>
  </div>

</template>

<script>
export default {
  data() {
    return {
      quickActions: [
        {
          title: '家庭医生',
          icon: 'el-icon-s-opportunity',
          desc: '什么是家庭医生？',
          action: 'consult'
        },
        {
          title: '预约挂号',
          icon: 'el-icon-date',
          desc: '预约就诊时间',
          action: 'appointment'
        },
        {
          title: '报告查询',
          icon: 'el-icon-document',
          desc: '查看检查结果',
          action: 'report'
        },
        {
          title: '用药提醒',
          icon: 'el-icon-alarm-clock',
          desc: '管理服药计划',
          action: 'medication'
        }
      ],
      healthData: [],
      todos: [
        { id: 1, content: '填写健康问卷', dueTime: '今天 18:00前' },
        { id: 2, content: '查看健康常识', dueTime: '明天 09:00' }
      ],
      checkedTodos: [],
      appointments: [],
      salt: '',
    }
  },
  methods: {
    saltt() {
      this.$http.get("/sys/sysUser/salt")
        .then((res) => {
          if (res.data.code === 200 || res.data.code === "SUCCESS") {
            if (res.data.data && res.data.data.length > 0) {
              this.salt = res.data.data[0].salt;
              console.log("获取到的salt值:", this.salt);

              if (this.salt == "0") {
                this.$router.push("/Main");


              } else {
                this.$router.push("/UserLogin");
                this.$message.error("用户名或者密码错误")
              }
            }
          }
        })
        .catch(error => {
          console.error("获取salt失败:", error);
          this.$router.push("/Main"); // 失败时默认跳转
        });
    },
    getPat() {
      this.$http.get("/pat/patient/inlist")
        .then((res) => {
          if (res.data.code === "SUCCESS" && res.data.data && res.data.data.length > 0) {
            const patientData = res.data.data[0]; // 获取第一个患者数据

            // 映射到表格数据
            this.healthData = [{
              date: patientData.createTime,
              bloodPressure: patientData.healthTag, // 健康标签
              bloodSugar: patientData.bioodType,    // 血型
              weight: patientData.allergy           // 过敏原
            }];

            this.health = res.data.data; // 保存完整健康数据
          } else {
            this.$message.warning('未获取到健康数据');
          }
        })
        .catch(error => {
          console.error('获取健康数据失败:', error);
          this.$message.error('获取健康数据失败');
        });
    },
    getJq() {
      this.$http.get("/pat/patient/jqlist")
        .then((res) => {
          if (res.data.code === "SUCCESS" && res.data.data && res.data.data.length > 0) {
            // 遍历返回的数据数组，将每条数据映射为 appointments 的一个对象
            this.appointments = res.data.data.map(patientData => ({
              doctor: "李医生", 
              department: patientData.symptoms, 
            }));
          } else {
            this.$message.warning('未获取到近期情况数据');
          }
        })
        .catch(error => {
          console.error('获取近期情况数据失败:', error);
          this.$message.error('获取近期情况数据失败');
        });
    },

    handleAction(action) {
      switch (action) {
        case 'consult':
          console.log('跳转到家庭医生页面');
          this.$router.push('/FamilyDoctor');
          break;
        case 'appointment':
          console.log('跳转到预约挂号页面');


          this.$confirm('请确保您已经填写了健康记录（可通过首页的快捷操作的健康记录填写功能），如果没有，请返回首页继续填写', '提示', {
            confirmButtonText: '去填写',
            cancelButtonText: '取消',
            type: 'warning'
          }).then(() => {
            // 用户点击"去填写"，跳转到首页
            this.$router.push('/Main');
          }).catch(() => {

          });
          {
            // 已填写患者信息，正常跳转
            this.$router.push('/registration1');
          }
          break;
        case 'report':
          console.log('跳转到报告查询页面');
          this.$router.push('/bgsc');
          break;
        case 'medication':
          console.log('跳转到用药提醒页面');
          this.$router.push('/yytx');
          break;
        default:
          console.log('未知操作:', action);
      }
    },

    viewDetail() {
      // 查看健康数据详情
    }
  },

  mounted() {
    this.saltt();
    this.getPat();
    this.getJq();
  }
}
</script>

<style scoped>
.patient-dashboard {
  min-height: 100vh;
  background-color: #f5f7fa;
}

.main-content {
  padding: 20px;
  max-width: 1200px;
  margin: 0 auto;
}

.quick-access {
  margin-bottom: 20px;
}

.action-card {
  text-align: center;
  cursor: pointer;
  transition: transform 0.3s;
}

.action-card:hover {
  transform: translateY(-5px);
}

.action-icon {
  font-size: 40px;
  color: #409EFF;
  margin: 10px 0;
}

.health-overview {
  margin-top: 20px;
}

.todo-item {
  padding: 10px 0;
  border-bottom: 1px solid #eee;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.due-time {
  color: #999;
  font-size: 0.9em;
}

.upcoming-appointments {
  margin-top: 20px;
}

.app-footer {
  background-color: #2c3e50;
  color: #ecf0f1;
  padding: 40px 20px 20px;
  margin-top: 50px;
}

.footer-content {
  max-width: 1200px;
  margin: 0 auto;
}

.footer-section {
  margin-bottom: 30px;
  padding: 0 20px;
}

.footer-section h4 {
  color: #409EFF;
  margin-bottom: 15px;
  font-size: 18px;
}

.contact-item {
  margin: 10px 0;
  display: flex;
  align-items: center;
}

.contact-item i {
  margin-right: 10px;
  font-size: 16px;
}

.certification {
  margin-top: 15px;
  padding: 10px;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 4px;
}

.qrcode img {
  width: 120px;
  height: 120px;
  margin: 15px 0;
  border: 2px solid #409EFF;
  padding: 5px;
  background: white;
}

.copyright {
  text-align: center;
  margin-top: 30px;
  font-size: 0.9em;
  color: #bdc3c7;
}

.el-link {
  display: block;
  margin: 8px 0;
}

.el-menu-demo .right-menu {
  float: right;
}

/* 或者使用flex布局（推荐）*/
.el-menu-demo {
  display: flex;
}

.el-menu-demo>>>.right-menu {
  margin-left: auto;
}

.brand {
  display: flex;
  align-items: center;
  height: 60px;
  cursor: pointer;
  transition: opacity 0.3s;
}

.brand:hover {
  opacity: 0.8;
}

.logo {
  width: 32px;
  height: 32px;
  margin-right: 10px;
}

.title {
  font-size: 20px;
  font-weight: bold;
  color: #fff;
  letter-spacing: 1px;
}

/* 调整右侧菜单位置 */
.el-menu-demo>>>.el-submenu.right-menu {
  float: right;
}

.logo {
  width: 36px;
  height: 36px;
  margin-right: 12px;
  transition: transform 0.3s;
}

.brand:hover .logo {
  transform: rotate(15deg);
}

.title {
  font-family: 'Microsoft YaHei', sans-serif;
  text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.2);
}
</style>