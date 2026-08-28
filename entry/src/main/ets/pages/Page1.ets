import { LocationUtils } from "./LocationUtils";
import { BusinessError } from "@kit.BasicServicesKit";

@Entry
@Component
export default struct Page1 {
  @State address: string = '-';
  @State currentTime: string = '-';
  locationUtils: LocationUtils = new LocationUtils();

  build() {
    Column({ space: 10 }) {
      Stack() {
        // TODO 任务5：（1）绘制一个圆形，宽高都为170，填充色#00affe
        Circle({width:300,height:300})
        // .width(170)
        // .height(170)
          .fill('#00affe'); // 圆形背景
        Text("考勤打卡").fontColor(Color.White).fontSize(36).fontWeight(FontWeight.Medium);
      }.onClick(() => {
        this.address='正在请求位置信息...';
        // TODO 任务5-调用this.locationUtils.getAddress方法获取位置信息，此处仅做提示用，无需补充代码
        this.locationUtils.getAddress().then((result) => {
          this.address = result[0]?.placeName || '-';
        }).catch((error: BusinessError) => {
          this.address = error.message;
          console.log(error.message)
        })
        this.currentTime = new Date().toLocaleString();
      })

      Text('当前位置：' + this.address)
      Text('打卡时间：' + this.currentTime)
    }

  }
}