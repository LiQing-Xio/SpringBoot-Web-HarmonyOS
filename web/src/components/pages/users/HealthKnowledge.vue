<template>
    <div class="health-knowledge">
      <el-card class="box-card">
        <h1 class="page-title">健康常识</h1>
        <el-timeline>
          <el-timeline-item
            v-for="item in healthKnowledgeList"
            :key="item.id"
            timestamp=""
            placement="top"
          >
            <el-card class="knowledge-card">
              <h2 class="knowledge-title">{{ item.title }}</h2>
              <p class="knowledge-content">{{ item.content }}</p>
            </el-card>
          </el-timeline-item>
        </el-timeline>
      </el-card>
    </div>
  </template>
   
  <script>
  export default {
    data() {
      return {
        healthKnowledgeList: []
      };
    },
    mounted() {
      this.getHealthKnowledgeList();
    },
    methods: {
      getHealthKnowledgeList() {
        // 假设你使用的是 axios 或类似的 HTTP 客户端
        this.$http.get("/hea/healthknowledge/list")
          .then(response => {
            if (response.data && response.data.code === "SUCCESS") {
              this.healthKnowledgeList = response.data.data;
            } else {
              console.error("Failed to fetch health knowledge list:", response.data.message);
            }
          })
          .catch(error => {
            console.error("Error fetching health knowledge list:", error);
          });
      }
    }
  }
  </script>
   
  <style scoped>
  .health-knowledge {
    max-width: 800px;
    margin: 50px auto;
  }
   
  .page-title {
    text-align: center;
    color: #333;
    margin-bottom: 30px;
    font-size: 28px;
  }
   
  .knowledge-card {
    border: none;
    box-shadow: none; /* 去掉默认阴影，因为 timeline-item 本身有样式 */
  }
   
  .knowledge-title {
    margin: 0 0 10px 0;
    color: #007BFF;
    font-size: 20px;
  }
   
  .knowledge-content {
    margin: 0;
    color: #555;
    line-height: 1.6;
  }
  </style>