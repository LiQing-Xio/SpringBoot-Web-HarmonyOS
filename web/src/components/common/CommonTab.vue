<template>
  <div class="tabs" >
    <el-tag
      v-for="(item,index ) in tags"
      :key="item.path"
      :effect="$route.name === item.name ? 'dark' : 'plain'"
      @click="changeMenu(item)"
      :closable="item.name !== 'firstPage'"
      @close="handleClose(item,index)"
    >
      {{ item.label }}
    </el-tag>
  </div>
</template>
<script>
import { mapState, mapMutations } from "vuex";
export default {
  name: "commonTab",
  data() {
    return {};
  },
  computed: {
    ...mapState({
      tags: (state) => state.tab.tabsList,
    }),
  },methods:{
    ...mapMutations(['closeTag']),
    changeMenu(item){
        // 点击tab标签我们需要动态的路由
        this.$router.push(item.path)
    },handleClose(item,index){
        // 关闭菜单
        this.closeTag(item)
        // 动态的处理路由
        if(this.$route.name !== item.name){
            return 
        }
        this.$router.push(this.tags[0])
    }
  }
};
</script>
<style lang="less" scoped>
.tabs {
  position: relative;
  //height: 30px;
  overflow: hidden;
  background: #fff;
  //padding-right: 120px;
  box-shadow: 0 5px 10px #ddd;
  padding-bottom: 5px;
  padding-top: 5px;
  padding-left: 10px;
  .el-tag {
    margin-right: 15px;
    cursor: pointer;
  }
}
</style>