<template>
    <div class="health-form-container">
      <div class="health-form">
        <h2>健康信息记录表</h2>
        <el-form 
          ref="healthForm" 
          :model="healthForm" 
          :rules="rules" 
          label-width="120px"
        >
          <!-- 患者基本信息 -->
          <el-row :gutter="20">
            <el-col :span="12">
              <el-form-item label="患者姓名" prop="username">
                <el-input 
                  v-model="healthForm.username" 
                  placeholder="请输入患者姓名"
                  clearable
                ></el-input>
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="联系电话" prop="phone">
                <el-input 
                  v-model="healthForm.phone" 
                  placeholder="请输入联系电话"
                  clearable
                  maxlength="11"
                ></el-input>
              </el-form-item>
            </el-col>
          </el-row>
  
          <el-row :gutter="20">
            <el-col :span="12">
              <el-form-item label="性别" prop="sex">
                <el-radio-group v-model="healthForm.sex">
                  <el-radio label="男">男</el-radio>
                  <el-radio label="女">女</el-radio>
                </el-radio-group>
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="年龄" prop="age">
                <el-input-number 
                  v-model="healthForm.age" 
                  :min="0" 
                  :max="120"
                  placeholder="请输入年龄"
                ></el-input-number>
              </el-form-item>
            </el-col>
          </el-row>
  
          <el-form-item label="健康标签" prop="healthTag">
            <el-select
              v-model="healthForm.healthTag"
              multiple
              filterable
              allow-create
              placeholder="请选择或输入健康标签"
              style="width: 100%"
            >
              <el-option
                v-for="tag in commonHealthTags"
                :key="tag"
                :label="tag"
                :value="tag"
              ></el-option>
            </el-select>
          </el-form-item>
  
          <el-form-item label="身份证号" prop="idCard">
            <el-input 
              v-model="healthForm.idCard" 
              placeholder="请输入身份证号"
              clearable
              maxlength="18"
            ></el-input>
          </el-form-item>
  
          <el-form-item label="家庭地址" prop="address">
            <el-input
              v-model="healthForm.address"
              placeholder="请输入详细家庭地址"
              style="width: 100%"
            ></el-input>
          </el-form-item>
  
          <el-row :gutter="20">
            <el-col :span="12">
              <el-form-item label="血型" prop="bioodType">
                <el-select
                  v-model="healthForm.bioodType"
                  placeholder="请选择血型"
                  style="width: 100%"
                >
                  <el-option label="A型" value="A"></el-option>
                  <el-option label="B型" value="B"></el-option>
                  <el-option label="AB型" value="AB"></el-option>
                  <el-option label="O型" value="O"></el-option>
                  <el-option label="Rh阴性" value="Rh-"></el-option>
                  <el-option label="未知" value="unknown"></el-option>
                </el-select>
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="家族遗传史" prop="genetic">
                <el-select
                  v-model="healthForm.genetic"
                  multiple
                  placeholder="请选择家族遗传史"
                  style="width: 100%"
                >
                  <el-option label="高血压" value="hypertension"></el-option>
                  <el-option label="糖尿病" value="diabetes"></el-option>
                  <el-option label="心脏病" value="heartDisease"></el-option>
                  <el-option label="癌症" value="cancer"></el-option>
                  <el-option label="精神疾病" value="mentalIllness"></el-option>
                  <el-option label="其他" value="other"></el-option>
                </el-select>
              </el-form-item>
            </el-col>
          </el-row>
  
          <el-form-item label="过敏源" prop="allergy">
            <el-select
              v-model="healthForm.allergy"
              multiple
              filterable
              allow-create
              placeholder="请选择或输入过敏源"
              style="width: 100%"
            >
              <el-option
                v-for="item in commonAllergens"
                :key="item"
                :label="item"
                :value="item"
              ></el-option>
            </el-select>
          </el-form-item>
  
          <el-form-item>
            <el-button 
              type="primary" 
              @click="submitForm('healthForm')"
              :loading="loading"
            >
              提交信息
            </el-button>
            <el-button @click="resetForm('healthForm')">重置</el-button>
          </el-form-item>
        </el-form>
      </div>
    </div>
  </template>
  
  <script>
  export default {
    name: 'HealthRecordForm',
    data() {
      // 验证手机号
      const validatePhone = (rule, value, callback) => {
        const phoneRegex = /^1[3-9]\d{9}$/;
        if (!value) {
          return callback(new Error('请输入联系电话'));
        }
        if (!phoneRegex.test(value)) {
          callback(new Error('请输入有效的手机号码'));
        } else {
          callback();
        }
      };
  
      // 验证身份证号
      const validateIdCard = (rule, value, callback) => {
        const idCardRegex = /^[1-9]\d{5}(18|19|20)\d{2}(0[1-9]|1[0-2])(0[1-9]|[12]\d|3[01])\d{3}[\dXx]$/;
        if (!value) {
          return callback(new Error('请输入身份证号'));
        }
        if (!idCardRegex.test(value)) {
          callback(new Error('请输入有效的身份证号码'));
        } else {
          callback();
        }
      };
  
      return {
        loading: false,
        healthForm: {
          username: '',
          phone: '',
          sex: '男', // 明确设置默认值
          age: null,
          healthTag: [], // 健康标签
          idCard: '',
          address: '',
          bioodType: '', // 明确初始化
          genetic: [],
          allergy: []
        },
        commonHealthTags: [
          '高血压', '糖尿病', '心脏病', '哮喘', '过敏体质', 
          '慢性胃炎', '骨质疏松', '高血脂', '甲状腺疾病'
        ],
        commonAllergens: [
          '青霉素', '头孢类', '花粉', '尘螨', '海鲜', 
          '坚果', '鸡蛋', '牛奶', '大豆', '小麦'
        ],
        rules: {
          username: [
            { required: true, message: '请输入患者姓名', trigger: 'blur' },
            { min: 2, max: 10, message: '长度在2到10个字符', trigger: 'blur' }
          ],
          phone: [
            { required: true, validator: validatePhone, trigger: 'blur' }
          ],
          sex: [
            { required: true, message: '请选择性别', trigger: 'change' }
          ],
          age: [
            { required: true, message: '请输入年龄', trigger: 'blur' }
          ],
          idCard: [
            { required: true, validator: validateIdCard, trigger: 'blur' }
          ],
          address: [
            { required: true, message: '请输入家庭地址', trigger: 'blur' }
          ],
          bioodType: [
            { required: true, message: '请选择血型', trigger: 'change' }
          ]
        }
      };
    },
    methods: {
        submitForm(formName) {
    this.$refs[formName].validate((valid) => {
      if (valid) {
        this.loading = true;
        
        // 确保数组字段不为null
        this.healthForm.healthTag = this.healthForm.healthTag || [];
        this.healthForm.genetic = this.healthForm.genetic || [];
        this.healthForm.allergy = this.healthForm.allergy || [];
        
        // 构造提交数据对象
        const submitData = {
          username: this.healthForm.username,
          phone: this.healthForm.phone,
          sex: this.healthForm.sex || 'male', // 默认值
          age: this.healthForm.age,
          healthTag: this.healthForm.healthTag.join(','), 
          idCard: this.healthForm.idCard,
          address: this.healthForm.address,
          bioodType: this.healthForm.bioodType || '', // 确保不为undefined
          genetic: this.healthForm.genetic.join(','),
          allergy: this.healthForm.allergy.join(',')
        };

        console.log('提交数据:', submitData); // 调试用

        this.$http.post("/pat/patient/savepat", submitData)
          .then(response => {
            this.loading = false;
            if (response.data.code === 200 || response.data.code === "SUCCESS") {
              this.$message.success('健康信息保存成功');
              this.$router.push('/Main');
            } else {
              this.$message.error(response.data.message || '保存失败');
            }
          })
          .catch(error => {
            this.loading = false;
            this.$message.error('保存失败: ' + (error.message || '请检查网络连接'));
          });
      } else {
        this.$message.warning('请完善表单信息');
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
  .health-form-container {
    display: flex;
    justify-content: center;
    align-items: center;
    min-height: 100vh;
    background-color: #f5f7fa;
  }
  
  .health-form {
    width: 800px;
    padding: 30px;
    background: #fff;
    border-radius: 8px;
    box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
  }
  
  .health-form h2 {
    text-align: center;
    margin-bottom: 30px;
    color: #409EFF;
  }
  
  .el-form-item {
    margin-bottom: 22px;
  }
  
  .el-button {
    margin-right: 10px;
  }
  </style>