externals:{
    module.exports = {
      configureWebpack: {
        externals: {
          BMap: 'BMap' // 正确声明百度地图作为外部依赖
        }
      }
    };
  }