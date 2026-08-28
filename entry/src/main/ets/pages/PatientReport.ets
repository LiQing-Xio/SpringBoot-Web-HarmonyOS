import { router } from '@kit.ArkUI';
import { httpGet } from '../common/HttpUtil';
import { AppColors, AppSizes } from '../common/Theme';

@Entry
@Component
struct PatientReport {
  @State patientInfo: Record<string, Object> = {};
  @State isLoading: boolean = true;

  aboutToAppear() {
    this.loadPatientData();
  }

  async loadPatientData() {
    this.isLoading = true;
    try {
      let resp = await httpGet('/pat/patient/inlist');
      let result = JSON.parse(resp) as Record<string, Object>;
      let data = result['data'] as Record<string, Object>[];
      if (data && data.length > 0) {
        this.patientInfo = data[0];
      }
    } catch (e) { }
    this.isLoading = false;
  }

  build() {
    Column() {
      // Top bar
      Row() {
        Image($r('app.media.ic_back')).width(22).height(22).fillColor(AppColors.PRIMARY_DARK)
          .onClick(() => { router.back(); })
        Text('患者报告')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor(AppColors.TEXT_PRIMARY)
          .margin({ left: 12 })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 12, bottom: 12 })
      .backgroundColor(AppColors.BG_CARD)

      if (this.isLoading) {
        Column() {
          LoadingProgress()
            .width(48)
            .height(48)
            .color(AppColors.PRIMARY)
          Text('加载中...')
            .fontSize(14)
            .fontColor(AppColors.TEXT_HINT)
            .margin({ top: 12 })
        }
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
        .width('100%')
      } else if (Object.keys(this.patientInfo).length === 0) {
        Column() {
          Image($r('app.media.ic_report')).width(48).height(48).fillColor(AppColors.TEXT_HINT)
            .margin({ bottom: 12 })
          Text('暂无报告数据')
            .fontSize(16)
            .fontColor(AppColors.TEXT_HINT)
          Text('请先填写健康记录')
            .fontSize(13)
            .fontColor(AppColors.TEXT_HINT)
            .margin({ top: 4 })
        }
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
        .width('100%')
      } else {
        Scroll() {
          Column() {
            // Patient header card
            Column() {
              Row() {
                Stack() {
                  Circle()
                    .width(56)
                    .height(56)
                    .fill(AppColors.PRIMARY_LIGHT)
                  Image($r('app.media.ic_user')).width(28).height(28).fillColor(AppColors.PRIMARY)
                }
                .margin({ right: 16 })

                Column() {
                  Text((this.patientInfo['username'] as string) || '未知')
                    .fontSize(20)
                    .fontWeight(FontWeight.Bold)
                    .fontColor(AppColors.TEXT_PRIMARY)
                  Row() {
                    Text((this.patientInfo['sex'] as string) || '')
                      .fontSize(13)
                      .fontColor(AppColors.TEXT_SECONDARY)
                    Text(' | ')
                      .fontSize(13)
                      .fontColor(AppColors.BORDER)
                    Text(String(this.patientInfo['age'] || '') + '岁')
                      .fontSize(13)
                      .fontColor(AppColors.TEXT_SECONDARY)
                  }
                  .margin({ top: 4 })
                }
                .alignItems(HorizontalAlign.Start)
              }
              .width('100%')
            }
            .width('92%')
            .padding(AppSizes.PADDING)
            .backgroundColor(AppColors.BG_CARD)
            .borderRadius(AppSizes.RADIUS_LG)
            .shadow({ radius: 8, color: '#0A000000', offsetX: 0, offsetY: 2 })
            .margin({ top: 16 })

            // Basic info section
            Column() {
              Row() {
                Image($r('app.media.ic_file')).width(18).height(18).fillColor(AppColors.PRIMARY).margin({ right: 6 })
                Text('基本信息').fontSize(16).fontWeight(FontWeight.Bold).fontColor(AppColors.PRIMARY)
              }
                .width('100%')
                .margin({ bottom: 12 })

              this.InfoItem('联系电话', String(this.patientInfo['phone'] || '--'))
              this.InfoItem('身份证号', (this.patientInfo['idCard'] as string) || '--')
              this.InfoItem('家庭地址', (this.patientInfo['address'] as string) || '--')
              this.InfoItem('创建时间', (this.patientInfo['createTime'] as string) || '--')
            }
            .width('92%')
            .padding(AppSizes.PADDING)
            .backgroundColor(AppColors.BG_CARD)
            .borderRadius(AppSizes.RADIUS_LG)
            .shadow({ radius: 8, color: '#0A000000', offsetX: 0, offsetY: 2 })
            .margin({ top: 12 })

            // Health info section
            Column() {
              Row() {
                Image($r('app.media.ic_health')).width(18).height(18).fillColor(AppColors.ACCENT_DARK).margin({ right: 6 })
                Text('健康信息').fontSize(16).fontWeight(FontWeight.Bold).fontColor(AppColors.ACCENT_DARK)
              }
                .width('100%')
                .margin({ bottom: 12 })

              this.InfoItem('健康标签', (this.patientInfo['healthTag'] as string) || '--')
              this.InfoItem('血型', (this.patientInfo['bioodType'] as string) || '--')
              this.InfoItem('家族遗传史', (this.patientInfo['genetic'] as string) || '--')
              this.InfoItem('过敏源', (this.patientInfo['allergy'] as string) || '--')
            }
            .width('92%')
            .padding(AppSizes.PADDING)
            .backgroundColor(AppColors.BG_CARD)
            .borderRadius(AppSizes.RADIUS_LG)
            .shadow({ radius: 8, color: '#0A000000', offsetX: 0, offsetY: 2 })
            .margin({ top: 12 })

            // Diagnosis section
            Column() {
              Row() {
                Image($r('app.media.ic_diagnosis')).width(18).height(18).fillColor(AppColors.SUCCESS).margin({ right: 6 })
                Text('医生诊断').fontSize(16).fontWeight(FontWeight.Bold).fontColor(AppColors.SUCCESS)
              }
                .width('100%')
                .margin({ bottom: 12 })

              Text((this.patientInfo['hf'] as string) || '暂无诊断')
                .fontSize(14)
                .fontColor(this.patientInfo['hf'] ? AppColors.TEXT_PRIMARY : AppColors.TEXT_HINT)
                .lineHeight(22)
                .width('100%')
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
    }
    .width('100%')
    .height('100%')
    .backgroundColor(AppColors.BG_PAGE)
  }

  @Builder
  InfoItem(label: string, value: string) {
    Row() {
      Text(label)
        .fontSize(14)
        .fontColor(AppColors.TEXT_SECONDARY)
        .width(85)
      Text(value)
        .fontSize(14)
        .fontColor(AppColors.TEXT_PRIMARY)
        .layoutWeight(1)
    }
    .width('100%')
    .padding({ top: 8, bottom: 8 })
    .borderWidth({ bottom: 0.5 })
    .borderColor(AppColors.DIVIDER)
  }
}
