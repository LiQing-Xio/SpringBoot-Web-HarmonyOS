import { LocationUtils } from "./LocationUtils";
import { BusinessError } from "@kit.BasicServicesKit";
import { GlobalData } from '../common/HttpUtil';

@Component
export default struct Theaddress {
  @State address: string = '-'; // 绑定输入框的地址数据
  @State currentTime: string = '-';
  locationUtils: LocationUtils = new LocationUtils();

  build() {
    Column({  }) {
      // ✅ 核心布局：一行包含 文字 + 输入框 + 图标+文字
      Row({ space: 10 }) {
        // 1. 文字：当前地址
        Text('当前地址:')
          .fontSize(14)
         // .fontWeight(FontWeight.Medium);

        // 2. 输入框：显示地址，支持手动输入
        TextInput({ placeholder: '请输入地址', text: this.address })
          .width(175) // 输入框宽度，可根据需要调整
          .height(25)
          .border({ width: 1, color: '#ccc', radius: 4 })
          .padding(5)
          .fontSize(11)
          // 输入框内容变化时同步更新address
          .onChange((value) => {
            this.address = value;
            GlobalData.address = value; // 同步到全局
          });

        // 3. 定位区域：图片 + 文字，点击触发定位
        Column({ space: 2}) {
          // 定位图片（dingwei.png，需确保图片路径正确）
          Image($r('app.media.dingwei')) // 鸿蒙图片资源引用方式，需把dingwei.png放在media目录
            .width(20)
            .height(20);
          // 定位文字
          Text('定位')
            .fontSize(10)
            .fontColor('#666');
        }
        .onClick(() => { // 点击定位区域触发获取位置
          this.address = '正在请求位置信息...';
          GlobalData.address = this.address; // 同步全局

          // 调用定位方法
          this.locationUtils.getAddress().then((result) => {
            this.address = result[0]?.placeName || '-';
            this.currentTime = new Date().toLocaleString();
            GlobalData.address = this.address; // 同步全局
            GlobalData.currentTime = this.currentTime;
          }).catch((error: BusinessError) => {
            this.address = error.message;
            this.currentTime = new Date().toLocaleString();
            GlobalData.address = this.address; // 同步全局
            GlobalData.currentTime = this.currentTime;
            console.log(error.message);
          });
          this.currentTime = new Date().toLocaleString();
          GlobalData.currentTime = this.currentTime;
        });
      }
      .padding(10) // 整行内边距
      .width('70%')

      /*// 保留原有的时间显示（可选，不需要可删除）
      Text('当前时间：' + this.currentTime)
        .fontSize(16)
        .margin({ top: 10 });*/
    }
    .height('10%')
    .width('100%')
    .padding(12)
    .backgroundColor('#F5F7FA')
    .margin({ right: '40%' })
  }
}