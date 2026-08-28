import { router } from '@kit.ArkUI';
import { AppColors, AppSizes } from '../common/Theme';

@Entry
@Component
struct FamilyDoctor {
  build() {
    Column() {
      // Top bar
      Row() {
        Image($r('app.media.ic_back')).width(22).height(22).fillColor(AppColors.PRIMARY_DARK)
          .onClick(() => { router.back(); })
        Text('家庭医生服务介绍')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor(AppColors.TEXT_PRIMARY)
          .margin({ left: 12 })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 12, bottom: 12 })
      .backgroundColor(AppColors.BG_CARD)

      Scroll() {
        Column() {
          // Hero section
          Column() {
            Image($r('app.media.ic_hospital')).width(56).height(56).fillColor(Color.White)
              .margin({ bottom: 12 })
            Text('家庭医生服务介绍')
              .fontSize(24)
              .fontWeight(FontWeight.Bold)
              .fontColor(Color.White)
          }
          .width('100%')
          .padding({ top: 40, bottom: 40 })
          .linearGradient({
            angle: 135,
            colors: [[AppColors.PRIMARY, 0.0], [AppColors.ACCENT, 1.0]]
          })
          .borderRadius({ bottomLeft: 24, bottomRight: 24 })
          .alignItems(HorizontalAlign.Center)

          // What is cloud hospital
          Column() {
            Row() {
              Image($r('app.media.ic_info')).width(20).height(20).fillColor(AppColors.PRIMARY)
                .margin({ right: 8 })
              Text('什么是家庭医生？')
                .fontSize(18)
                .fontWeight(FontWeight.Bold)
                .fontColor(AppColors.PRIMARY)
            }
            .width('100%')
            .margin({ bottom: 10 })

            Text('家庭医生是一种新型的医疗服务模式，旨在为服务对象提供全面、连续、有效、及时和个性化的医疗保健服务和照顾。通过互联网技术，患者可以在家中享受到优质的医疗资源，实现远程问诊、健康管理、用药提醒等功能。')
              .fontSize(14)
              .fontColor(AppColors.TEXT_SECONDARY)
              .lineHeight(24)
          }
          .width('92%')
          .padding(AppSizes.PADDING)
          .backgroundColor(AppColors.BG_CARD)
          .borderRadius(AppSizes.RADIUS_LG)
          .shadow({ radius: 8, color: '#0A000000', offsetX: 0, offsetY: 2 })
          .margin({ top: 16 })

          // Policy background
          Column() {
            Row() {
              Image($r('app.media.ic_file')).width(20).height(20).fillColor(AppColors.PRIMARY)
                .margin({ right: 8 })
              Text('政策背景')
                .fontSize(18)
                .fontWeight(FontWeight.Bold)
                .fontColor(AppColors.PRIMARY)
            }
            .width('100%')
            .margin({ bottom: 10 })

            // Timeline items
            Column() {
              Row() {
                Column() {
                  Circle()
                    .width(10)
                    .height(10)
                    .fill(AppColors.PRIMARY)
                  Line()
                    .width(1)
                    .height(60)
                    .backgroundColor(AppColors.PRIMARY_LIGHT)
                }
                .margin({ right: 12 })

                Column() {
                  Text('2015年1月14日')
                    .fontSize(13)
                    .fontWeight(FontWeight.Bold)
                    .fontColor(AppColors.PRIMARY)
                  Text('北京市西城区开始试点"契约式家庭医生"服务，确保24小时内预约对口三甲医院的专家号，3天内安排就诊。')
                    .fontSize(13)
                    .fontColor(AppColors.TEXT_SECONDARY)
                    .lineHeight(20)
                    .margin({ top: 4 })
                }
                .layoutWeight(1)
                .alignItems(HorizontalAlign.Start)
              }
              .width('100%')

              Row() {
                Column() {
                  Circle()
                    .width(10)
                    .height(10)
                    .fill(AppColors.ACCENT)
                }
                .margin({ right: 12 })

                Column() {
                  Text('2018年10月')
                    .fontSize(13)
                    .fontWeight(FontWeight.Bold)
                    .fontColor(AppColors.ACCENT_DARK)
                  Text('国家卫生健康委发布《关于规范家庭医生签约服务管理的指导意见》，要求全国家庭医生团队依法依约为签约居民提供基础性和个性化签约服务，并提出十一项签约服务内容。')
                    .fontSize(13)
                    .fontColor(AppColors.TEXT_SECONDARY)
                    .lineHeight(20)
                    .margin({ top: 4 })
                }
                .layoutWeight(1)
                .alignItems(HorizontalAlign.Start)
              }
              .width('100%')
              .margin({ top: 8 })
            }
            .width('100%')
          }
          .width('92%')
          .padding(AppSizes.PADDING)
          .backgroundColor(AppColors.BG_CARD)
          .borderRadius(AppSizes.RADIUS_LG)
          .shadow({ radius: 8, color: '#0A000000', offsetX: 0, offsetY: 2 })
          .margin({ top: 12 })

          // Statistics
          Column() {
            Row() {
              Image($r('app.media.ic_chart')).width(20).height(20).fillColor(AppColors.PRIMARY)
                .margin({ right: 8 })
              Text('统计数据')
                .fontSize(18)
                .fontWeight(FontWeight.Bold)
                .fontColor(AppColors.PRIMARY)
            }
            .width('100%')
            .margin({ bottom: 10 })

            Row() {
              Column() {
                Text('143.5万')
                  .fontSize(28)
                  .fontWeight(FontWeight.Bold)
                  .fontColor(AppColors.PRIMARY)
                Text('全国家庭医生数量')
                  .fontSize(12)
                  .fontColor(AppColors.TEXT_HINT)
                  .margin({ top: 4 })
                Text('截至2021年底')
                  .fontSize(11)
                  .fontColor(AppColors.TEXT_HINT)
              }
              .alignItems(HorizontalAlign.Center)
              .layoutWeight(1)
              .padding(16)
              .backgroundColor(AppColors.PRIMARY_LIGHT)
              .borderRadius(AppSizes.RADIUS)
            }
            .width('100%')
          }
          .width('92%')
          .padding(AppSizes.PADDING)
          .backgroundColor(AppColors.BG_CARD)
          .borderRadius(AppSizes.RADIUS_LG)
          .shadow({ radius: 8, color: '#0A000000', offsetX: 0, offsetY: 2 })
          .margin({ top: 12 })

          // Services
          Column() {
            Row() {
              Image($r('app.media.ic_doctor')).width(20).height(20).fillColor(AppColors.PRIMARY)
                .margin({ right: 8 })
              Text('我们的服务')
                .fontSize(18)
                .fontWeight(FontWeight.Bold)
                .fontColor(AppColors.PRIMARY)
            }
            .width('100%')
            .margin({ bottom: 12 })

            this.ServiceItem($r('app.media.ic_file'), '健康档案管理', '建立完善的个人健康档案')
            this.ServiceItem($r('app.media.ic_calendar'), '预约挂号', '在线预约医生，方便快捷')
            this.ServiceItem($r('app.media.ic_medicine'), '用药提醒', '智能用药提醒，不忘服药')
            this.ServiceItem($r('app.media.ic_chart'), '健康报告', '定期健康数据分析报告')
            this.ServiceItem($r('app.media.ic_knowledge'), '健康知识', '丰富的健康科普知识库')
          }
          .width('92%')
          .padding(AppSizes.PADDING)
          .backgroundColor(AppColors.BG_CARD)
          .borderRadius(AppSizes.RADIUS_LG)
          .shadow({ radius: 8, color: '#0A000000', offsetX: 0, offsetY: 2 })
          .margin({ top: 12, bottom: 30 })
        }
        .width('100%')
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(AppColors.BG_PAGE)
  }

  @Builder
  ServiceItem(icon: Resource, title: string, desc: string) {
    Row() {
      Image(icon).width(24).height(24).fillColor(AppColors.PRIMARY)
        .margin({ right: 12 })
      Column() {
        Text(title)
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .fontColor(AppColors.TEXT_PRIMARY)
        Text(desc)
          .fontSize(12)
          .fontColor(AppColors.TEXT_HINT)
          .margin({ top: 2 })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .padding({ top: 10, bottom: 10 })
    .borderWidth({ bottom: 0.5 })
    .borderColor(AppColors.DIVIDER)
  }
}
