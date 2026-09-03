<template>
  <el-card class="box-card">
    <div class="mod-role">
      <el-form :inline="true" :model="dataForm" class="demo-form-inline">
        <el-form-item>
          <el-input
            v-model="dataForm.msg"
            clearable
            placeholder="用户名/用户操作"
          ></el-input>
        </el-form-item>
        <el-form-item>
          <el-button @click="getDataList">查询</el-button>
        </el-form-item>
        
      </el-form>
      <el-table :data="dataList" border style="width: 100%">
        <el-table-column type="selection" > </el-table-column>
        <el-table-column prop="id" label="ID" width="60">
        </el-table-column>
        <!-- <el-table-column prop="username" label="用户名" width="140">
        </el-table-column> -->
        <el-table-column prop="operation" label="用户操作" width="180">
        </el-table-column>
        <el-table-column prop="method" label="请求方法">
        </el-table-column>
        <el-table-column prop="params" label="请求参数" >
        </el-table-column>
        <el-table-column prop="time" label="执行时长(毫秒)" width="140" >
        </el-table-column>
        <!-- <el-table-column prop="ip" label="IP地址"  width="140">
        </el-table-column> -->
        <el-table-column prop="createDate" label="创建时间" width="160">
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
        style="margin-top: 30px"
      >
      </el-pagination>
    </div>

    
  </el-card>
</template>
<script>
export default {
  name: "sysLog",
  data() {   
    return {
      dataForm: {
        msg: "",
      },
      dataList: [],
      pageIndex: 1,
      pageSize: 5,
      totalPage: 0,
      dataListLoading: false
    };
  },
  methods: {
    sizeChangeHandle(val) {
      this.pageSize = val;
      this.pageIndex = 1;
      this.getDataList();
    },
    currentChangeHandle(val) {
      this.pageIndex = val;
      this.getDataList();
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
          msg: this.dataForm.msg,
        },
      };
      this.$http.get("/sys/sysLog/list", params).then((res) => {
        console.log(res)
        this.dataList = res.data.data.list;
        this.totalPage = res.data.data.totalCount;
        this.dataListLoading = false;
      });
    }
  },
  mounted() {
    this.getDataList();
  },
};
</script>