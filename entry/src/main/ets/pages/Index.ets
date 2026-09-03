 import { router } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  onPageShow() {
    try {
      router.replaceUrl({ url: 'pages/Login' });
    } catch (e) {
      console.error('Router error: ' + JSON.stringify(e));
    }
  }

  build() {
    Column() {
      Text('\u2695')
        .fontSize(56)
        .fontColor('#1E88E5')
        .margin({ bottom: 12 })
      Text('悦享家庭医生')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1E88E5')
      Text('云医院健康管理系统')
        .fontSize(14)
        .fontColor('#999999')
        .margin({ top: 8 })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .backgroundColor('#F5F7FA')
  }
}