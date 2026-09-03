<template>
  <div>
    <el-row>
      <el-col :span="8">
        <el-card class="box-card">
          <div class="user">
            <img src="@/assets/images/user1.jpeg" />
            <div class="userinfo">
              <p class="name">{{ username }}</p>
              <!-- <p class="access">{{ access }}</p> -->
            </div>
          </div>
          <div class="login-info">
            <p>当前日期:<span>{{ today }}</span></p>
            <p>当前登录的地点:<span>{{ LocationPCity }}</span></p>
          </div>
        </el-card>
        <el-card class="box-card" style="margin-top: 35px">
          <el-table :data="tableData" stripe style="width: 100%" height="390px">
            <el-table-column prop="date" label="日期" width="180">
            </el-table-column>
            <el-table-column prop="account" label="账号" width="180">
            </el-table-column>
            <el-table-column prop="type" label="类型"> </el-table-column>
          </el-table>
        </el-card>
        <el-card class="box-card" style="margin-top: 20px">
          <!-- 统计图 -->
          <div ref="echarts1" style="height: 300px"></div>
        </el-card>
      </el-col>
      <el-col :span="16" style="padding-left: 20px">
        <el-card class="box-card system_bulletin" style="margin-bottom: 20px">
          <div slot="header" class="system_title">
            <span>系统公告</span>
          </div>
          <div v-for="item in systemData" :key="item.id" class="system_context item">
            <div>
              {{ item.content }}
            </div>
            <div>
              <i :class="`el-icon-${item.icon}`"> {{ item.date }}</i>
            </div>
          </div>
        </el-card>
        <el-card class="box-card" style="margin-bottom: 20px">
          <div ref="echarts2" style="height: 300px"></div>
        </el-card>

        <el-card class="box-card" style="margin-bottom: 20px">
          <div id="container"></div>
        </el-card>


      </el-col>
    </el-row>
  </div>
</template>
<script>
import * as echarts from "echarts";
export default {
  name: "firstPage",
  data() {
    return {
      access: '',
      today: '',
      LocationPCity: "",
      tableData: [

      ],
      systemData: [],
      dataList: [],
      username: sessionStorage.getItem('username'),
      // username:"",
      access: "",
    };
  },
  methods: {
    getDataList() {
      this.$http.get("/ech/dataChart/list").then((res) => {
        this.dataList = res.data.data;
        this.initCharts(); // 初始化图表
      });
    },
    saltt() {
      this.$http.get("/sys/sysUser/salt")
        .then((res) => {
          if (res.data.code === 200 || res.data.code === "SUCCESS") {
            if (res.data.data && res.data.data.length > 0) {
              this.salt = res.data.data[0].salt;
              console.log("获取到的salt值:", this.salt);
              
              if (this.salt == "1") {
                this.$router.push("/FirstPage");
            
              
              } else {
                this.$router.push("/login");
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
    getrole() {
      this.$http.get(`/sys/sysUser/getrole?username=${this.username}`)
        .then((res) => {
          this.access = res.data.data;
        })
        .catch((error) => {
          console.error("获取角色失败:", error);
        });
    },
    // 获取当前日期
    getCurrentDate() {
      let now = new Date();
      let year = now.getFullYear();
      let month = now.getMonth() + 1;
      let day = now.getDate();
      return year + "-" + month + "-" + day;
    },
    // 获取当前城市
    city() {
      const geolocation = new BMapGL.Geolocation(); // 使用 BMapGL
      var _this = this
      geolocation.getCurrentPosition(function getinfo(position) {
        let city = position.address.city;             //获取城市信息
        let province = position.address.province;     //获取省份信息
        let district = position.address.district;
        let street = position.address.street || "";       // 街道（可能不存在）
        let street_number = position.address.street_number || ""; // 门牌号（可能不存在）

          _this.LocationPCity = province + ' ' + city + ' ' + district+' '+ street + ' ' + street_number;
        console.log("LocationPCity:", _this.LocationPCity, position)
      }, function (e) {
        _this.LocationPCity = "定位失败"
      }, { provider: 'baidu' });
    },

    getGg() {

      this.$http.get("/bul/bulletin/getGg").then((res) => {
        this.systemData = res.data.data;
        this.tableData = res.data.data;
        console.log(this.systemData);
      });
    },
    mapwjm() {
        var map = new BMapGL.Map("container");
    var point = new BMapGL.Point(116.404, 39.915);
    map.centerAndZoom(point, 15); 
    var point = new BMapGL.Point(116.404, 39.915);   
var marker = new BMapGL.Marker(point);        // 创建标注   
map.addOverlay(marker);                     // 将标注添加到地图中

var opts = {
    width: 150,     // 信息窗口宽度
    height: 50,    // 信息窗口高度
    title: "家庭医生社区服务"  // 信息窗口标题
}
var infoWindow = new BMapGL.InfoWindow("线下定位", opts);  // 创建信息窗口对象
map.openInfoWindow(infoWindow, map.getCenter());        // 打开信息窗口
      // 添加缩放控件（测试交互）
      map.addControl(new BMapGL.ZoomControl());
      marker.addEventListener("click", function(){   
        alert("这里是线下地址");  
});
    
    },

    initCharts() {
      var mycharts1 = echarts.init(this.$refs.echarts1);
      var mycharts2 = echarts.init(this.$refs.echarts2);
      // var mycharts3 = echarts.init(this.$refs.echarts3);

      // 指定图表的配置项和数据
      var option1 = {
        title: {
          text: "服务对象统计",
        },
        tooltip: {},
        legend: {
          data: ["查看"],
        },
        xAxis: {
          data: this.dataList.map(item => item.age), // 使用从后端获取的数据
        },
        yAxis: {},
        series: [
          {
            name: "查看",
            type: "bar",
            data: this.dataList.map(item => item.value), // 假设每个item有一个value属性
          },
        ],
      };


      var option2 = {
        title: {
          text: "患者了解方式统计",
        },
        tooltip: {  
          trigger: "axis",
          axisPointer: {
            type: "cross",
            label: {
              backgroundColor: "#6a7985",
            },
          },
        },
        legend: {
          // 系列名称需要与 series 中的 name 对应
          data: ["Email", "Union Ads", "Video Ads", "Direct", "Search Engine"],
        },
        toolbox: {
          feature: {
            saveAsImage: {},
          },
        },
        grid: {
          left: "3%",
          right: "4%",
          bottom: "3%",
          containLabel: true,
        },
        xAxis: [
          {
            type: "category",
            boundaryGap: false,
            data: this.dataList.map(item => item.date),
          },
        ],
        yAxis: [
          {
            type: "value",
          },
        ],
        series: [

          {
            name: "Email",
            type: "line",
            stack: "Total",
            areaStyle: {},
            emphasis: { focus: "series" },

            data: this.dataList.map(item => item.email),
          },
          {
            name: "Union Ads",
            type: "line",
            stack: "Total",
            areaStyle: {},
            emphasis: { focus: "series" },

            data: this.dataList.map(item => item.unionads),
          },
          {
            name: "Video Ads",
            type: "line",
            stack: "Total",
            areaStyle: {},
            emphasis: { focus: "series" },
            data: this.dataList.map(item => item.videods),
          },
          {
            name: "Direct",
            type: "line",
            stack: "Total",
            areaStyle: {},
            emphasis: { focus: "series" },
            data: this.dataList.map(item => item.direct),
          },
          {
            name: "Search Engine",
            type: "line",
            stack: "Total",
            label: { show: true, position: "top" },
            areaStyle: {},
            emphasis: { focus: "series" },

            data: this.dataList.map(item => item.searchengine),
          },
        ],
      };
      ///////////////////////


      mycharts1.setOption(option1);
      mycharts2.setOption(option2);
      // mycharts3.setOption(option3);
    },
  },
  mounted() {
    this.saltt();
    this.mapwjm()
    this.city();
    this.getDataList();
    this.today = this.getCurrentDate();
    this.getrole();
    this.getGg();
  }

};
</script>
<style lang="less" scoped>
#container {
  width: 100%;
  height: 500px; /* 必须设置高度 */
}
.user {
  padding-bottom: 20px;
  margin-bottom: 20px;
  border-bottom: 1px solid #999;
  display: flex;
  align-items: center;

  img {
    margin-left: 40px;
    width: 150px;
    height: 150px;
    border-radius: 50%;
  }

  .userinfo {
    margin-left: 40px;

    .name {
      font-size: 32px;
      margin-bottom: 10px;
    }

    .access {
      color: #999;
      margin-top: 0px;
    }
  }
}

.login-info {
  p {
    font-size: 14px;
    color: #999999;
    line-height: 28px;

    span {
      color: #666666;
      margin-left: 20px;
    }
  }
}

.system_bulletin {
  .system_title {
    font-size: 22px;
    color: #000000;
  }

  .system_context {
    padding-bottom: 10px;
    border-bottom: 1px #f2f2f2 solid;
    margin-bottom: 10px;
    display: flex;
    justify-content: space-between;
    align-items: center;
  }
}
</style>