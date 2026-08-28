import { router } from '@kit.ArkUI';
import { AlarmUtil } from '../common/AlarmUtil';
import { httpGet, httpPost, getUsername, setToken, setUsername,GlobalData } from '../common/HttpUtil';
import { AppColors, AppSizes } from '../common/Theme';
import { Patient, Patienta, Bulletin } from '../models/Models';
import Theaddress from './Theaddress';

@Entry
@Component
struct UserHome {
  @State currentTab: number = 0;

  build() {
    Column() {
      // Content area
      Column() {
        if (this.currentTab === 0) {
          UserDashboard()
        } else if (this.currentTab === 1) {
          AppointmentPage()
        } else if (this.currentTab === 2) {
          HealthKnowledgePage()
        } else if (this.currentTab === 3) {
          MedicationReminderPage()
        } else if (this.currentTab === 4) {
          UserProfilePage()
        }
      }
      .layoutWeight(1)
      .width('100%')

      // Bottom tab bar
      Row() {
        this.TabItem(0, $r('app.media.ic_home'), '首页')
        this.TabItem(1, $r('app.media.ic_calendar'), '线上咨询')
        this.TabItem(2, $r('app.media.ic_knowledge'), '健康常识')
        this.TabItem(3, $r('app.media.ic_alarm'), '用药提醒')
        this.TabItem(4, $r('app.media.ic_user'), '我的')
      }
      .width('100%')
      .height(56)
      .backgroundColor(AppColors.TAB_BAR)
      .shadow({ radius: 8, color: '#1A000000', offsetX: 0, offsetY: -2 })
      .justifyContent(FlexAlign.SpaceAround)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(AppColors.BG_PAGE)
  }

  @Builder
  TabItem(index: number, icon: Resource, label: string) {
    Column() {
      Image(icon).width(22).height(22)
        .fillColor(this.currentTab === index ? AppColors.PRIMARY : AppColors.TEXT_HINT)
      Text(label)
        .fontSize(11)
        .fontColor(this.currentTab === index ? AppColors.PRIMARY : AppColors.TEXT_HINT)
        .margin({ top: 2 })
    }
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .layoutWeight(1)
    .height('100%')
    .onClick(() => {
      this.currentTab = index;
    })
  }
}

// ======================== User Dashboard ========================
@Component
struct UserDashboard {
  @State healthData: Patient[] = [];
  @State appointments: Patienta[] = [];
  @State bulletins: Bulletin[] = [];
  @State username: string = getUsername();

  aboutToAppear() {
    this.loadHealthData();
    this.loadAppointments();
    this.loadBulletins();
  }

  async loadHealthData() {
    try {
      let resp = await httpGet('/pat/patient/inlist');
      let result = JSON.parse(resp) as Record<string, Object>;
      let data = result['data'] as Patient[];
      if (data) {
        this.healthData = data;
      }
    } catch (e) { }
  }

  async loadAppointments() {
    try {
      let resp = await httpGet('/pat/patient/jqlist');
      let result = JSON.parse(resp) as Record<string, Object>;
      let data = result['data'] as Patienta[];
      if (data) {
        this.appointments = data;
      }
    } catch (e) { }
  }

  async loadBulletins() {
    try {
      let resp = await httpGet('/bul/bulletin/getGg');
      let result = JSON.parse(resp) as Record<string, Object>;
      let data = result['data'] as Bulletin[];
      if (data) {
        this.bulletins = data;
      }
    } catch (e) { }
  }

  build() {
    Scroll() {
      Column() {
        // Header
        Row() {
          Column() {
            Text('悦享家庭医生')
              .fontSize(22)
              .fontWeight(FontWeight.Bold)
              .fontColor(Color.White)
            Text('欢迎，' + this.username)
              .fontSize(14)
              .fontColor('#FFFFFFCC')
              .margin({ top: 4 })
          }
          .alignItems(HorizontalAlign.Start)
          .layoutWeight(1)

          Image($r('app.media.ic_alarm')).width(24).height(24).fillColor(Color.White)
        }
        .width('100%')
        .padding({ left: 20, right: 20, top: 16, bottom: 20 })
        .linearGradient({
          angle: 135,
          colors: [[AppColors.PRIMARY, 0.0], [AppColors.ACCENT, 1.0]]
        })
        .borderRadius({ bottomLeft: 20, bottomRight: 20 })

        // Quick actions
        Row() {
          this.QuickAction($r('app.media.ic_hospital'), '家庭医生', () => {
            router.pushUrl({ url: 'pages/FamilyDoctor' });
          })
          this.QuickAction($r('app.media.ic_health'), '健康记录', () => {
            router.pushUrl({ url: 'pages/HealthRecord' });
          })
          this.QuickAction($r('app.media.ic_report'), '报告查询', () => {
            router.pushUrl({ url: 'pages/PatientReport' });
          })
          this.QuickAction($r('app.media.ic_medicine'), '用药提醒', () => {
            router.pushUrl({ url: 'pages/UserHome' });
          })
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceEvenly)
        .padding({ top: 16, bottom: 16 })

        // Bulletins card
        Column() {
          Row() {
            Image($r('app.media.ic_bulletin')).width(20).height(20).fillColor(AppColors.PRIMARY)
            Text(' 系统公告')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor(AppColors.TEXT_PRIMARY)
          }
          .width('100%')
          .margin({ bottom: 12 })

          if (this.bulletins.length > 0) {
            ForEach(this.bulletins.slice(0, 5), (item: Bulletin, index: number) => {
              Row() {
                Text('\u2022')
                  .fontSize(16)
                  .fontColor(AppColors.PRIMARY)
                  .margin({ right: 8 })
                Text(item.content || '')
                  .fontSize(13)
                  .fontColor(AppColors.TEXT_SECONDARY)
                  .layoutWeight(1)
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                Text(item.date || '')
                  .fontSize(11)
                  .fontColor(AppColors.TEXT_HINT)
              }
              .width('100%')
              .padding({ top: 8, bottom: 8 })
              .borderWidth({ bottom: 0.5 })
              .borderColor(AppColors.DIVIDER)
              .onClick(() => {
                let title: string = (item.type || '公告') + ' - ' + (item.date || '');
                AlertDialog.show({
                  title: title,
                  message: (item.content || '暂无内容') + '\n\n发布人：' + (item.account || '系统'),
                  autoCancel: true,
                  confirm: { value: '关闭', action: () => { } }
                });
              })
            }, (item: Bulletin, index: number) => 'bul_' + String(item.id || '') + '_' + index)
          } else {
            Text('暂无公告')
              .fontSize(14)
              .fontColor(AppColors.TEXT_HINT)
              .width('100%')
              .textAlign(TextAlign.Center)
              .padding(20)
          }
        }
        .width('92%')
        .padding(AppSizes.PADDING)
        .backgroundColor(AppColors.BG_CARD)
        .borderRadius(AppSizes.RADIUS_LG)
        .shadow({ radius: 8, color: '#0A000000', offsetX: 0, offsetY: 2 })
        .margin({ top: 12 })

        // Health overview
        Column() {
          Row() {
            Image($r('app.media.ic_health')).width(20).height(20).fillColor(AppColors.DANGER)
            Text(' 健康数据概览')
              .fontSize(16).fontWeight(FontWeight.Bold).fontColor(AppColors.TEXT_PRIMARY)
          }
            .width('100%')
            .margin({ bottom: 12 })

          if (this.healthData.length > 0) {
            Row() {
              this.HealthItem('健康标签', this.healthData[0].healthTag || '--')
              this.HealthItem('血型', this.healthData[0].bioodType || '--')
              this.HealthItem('过敏原', this.healthData[0].allergy || '--')
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceEvenly)
          } else {
            Text('暂无健康数据，请先填写健康记录')
              .fontSize(14)
              .fontColor(AppColors.TEXT_HINT)
              .width('100%')
              .textAlign(TextAlign.Center)
              .padding(20)
          }
        }
        .width('92%')
        .padding(AppSizes.PADDING)
        .backgroundColor(AppColors.BG_CARD)
        .borderRadius(AppSizes.RADIUS_LG)
        .shadow({ radius: 8, color: '#0A000000', offsetX: 0, offsetY: 2 })
        .margin({ top: 12 })

        // Recent appointments
        Column() {
          Row() {
            Image($r('app.media.ic_calendar')).width(20).height(20).fillColor(AppColors.PRIMARY)
            Text(' 近期情况')
              .fontSize(16).fontWeight(FontWeight.Bold).fontColor(AppColors.TEXT_PRIMARY)
          }
            .width('100%')
            .margin({ bottom: 12 })

          if (this.appointments.length > 0) {
            ForEach(this.appointments.slice(0, 5), (item: Patienta, index: number) => {
              Row() {
                Column() {
                  Circle()
                    .width(10)
                    .height(10)
                    .fill(AppColors.PRIMARY)
                  Line()
                    .width(1)
                    .height(30)
                    .backgroundColor(AppColors.BORDER)
                }
                .margin({ right: 12 })

                Text(item.symptoms || '暂无描述')
                  .fontSize(14)
                  .fontColor(AppColors.TEXT_SECONDARY)
                  .layoutWeight(1)
              }
              .width('100%')
              .padding({ top: 4, bottom: 4 })
            }, (item: Patienta, index: number) => 'apt_' + String(item.rid || '') + '_' + index)
          } else {
            Text('暂无近期记录')
              .fontSize(14)
              .fontColor(AppColors.TEXT_HINT)
              .width('100%')
              .textAlign(TextAlign.Center)
              .padding(20)
          }
        }
        .width('92%')
        .padding(AppSizes.PADDING)
        .backgroundColor(AppColors.BG_CARD)
        .borderRadius(AppSizes.RADIUS_LG)
        .shadow({ radius: 8, color: '#0A000000', offsetX: 0, offsetY: 2 })
        .margin({ top: 12, bottom: 20 })
      }
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .scrollBar(BarState.Off)
  }

  @Builder
  QuickAction(icon: Resource, label: string, action: () => void) {
    Column() {
      Stack() {
        Circle()
          .width(50)
          .height(50)
          .fill(AppColors.PRIMARY_LIGHT)
        Image(icon).width(26).height(26).fillColor(AppColors.PRIMARY)
      }
      Text(label)
        .fontSize(12)
        .fontColor(AppColors.TEXT_SECONDARY)
        .margin({ top: 6 })
    }
    .onClick(action)
  }

  @Builder
  HealthItem(title: string, value: string) {
    Column() {
      Text(value)
        .fontSize(14)
        .fontWeight(FontWeight.Bold)
        .fontColor(AppColors.PRIMARY)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
      Text(title)
        .fontSize(12)
        .fontColor(AppColors.TEXT_HINT)
        .margin({ top: 4 })
    }
    .alignItems(HorizontalAlign.Center)
    .padding(10)
  }
}

// ======================== Appointment Page ========================
@Component
struct AppointmentPage {
  @State activeStep: number = 0;
  @State doctors: Record<string, Object>[] = [];
  @State selectedDoctor: Record<string, Object> | null = null;
  @State symptoms: string = '';
  @State isSubmitting: boolean = false;
  @State selectedTime: string = '09:00-09:30';
  @State showHistory: boolean = false;
  @State historyList: Record<string, Object>[] = [];
  @State hasActiveAppointment: boolean = false;

  //
  @State patientId: number = 0;
  @State username: string = '';
  @State phone: string = '';
  @State sex: string = '男';
  @State age: string = '';
  @State healthTag: string = '';
  @State idCard: string = '';
  @State bioodType: string = '';
  @State genetic: string = '';
  @State allergy: string = '';
  @State isLoading: boolean = false;
  @State selectedBloodType: number = -1;
  bloodTypes: string[] = ['A', 'B', 'AB', 'O', 'Rh-', '未知'];
  //是否需要上门
  @State needdoor: boolean =false;
  //
  @State address: string = GlobalData.address;
  @State currentTime: string = GlobalData.currentTime;
  /*@State patients: Record<string, Object>[] = [];
  @State searchKey: string = '';
  @State pageIndex: number = 1;
  @State pageSize: number = 10;
  @State totalCount: number = 0;
  @State formData: Record<string, Object> = {};*/

  aboutToAppear() {
    this.loadDoctors();
    this.loadHistory();

    this.loadExistingRecord();
    //this.loadData();
  }

  async loadExistingRecord() {
    try {
      let resp = await httpGet('/pat/patient/inlist');
      let result = JSON.parse(resp) as Record<string, Object>;
      let data = result['data'] as Record<string, Object>[];
      if (data && data.length > 0) {
        let p = data[0];
        this.patientId = (p['id'] as number) || 0;
        this.username = (p['username'] as string) || '';
        this.phone = String(p['phone'] || '');
        this.sex = (p['sex'] as string) || '男';
        this.age = String(p['age'] || '');
        this.healthTag = (p['healthTag'] as string) || '';
        this.idCard = (p['idCard'] as string) || '';
        this.address = (p['address'] as string) || '';
        this.bioodType = (p['bioodType'] as string) || '';
        this.genetic = (p['genetic'] as string) || '';
        this.allergy = (p['allergy'] as string) || '';
        let btIdx = this.bloodTypes.indexOf(this.bioodType);
        if (btIdx >= 0) { this.selectedBloodType = btIdx; }
      }
    } catch (e) { }
  }

  async submitForm() {
    if (!this.username || !this.phone || !this.age || !this.idCard || !this.address) {
      AlertDialog.show({ message: '请完善必填信息' });
      return;
    }
    this.isLoading = true;
    try {
      let body: Record<string, Object> = {
        'username': this.username as Object,
        'phone': Number(this.phone) as Object,
        'sex': this.sex as Object,
        'age': Number(this.age) as Object,
        'healthTag': this.healthTag as Object,
        'idCard': this.idCard as Object,
        'address': this.address as Object,
        'bioodType': this.bioodType as Object,
        'genetic': this.genetic as Object,
        'allergy': this.allergy as Object
      };
      if (this.patientId > 0) {
        body['id'] = this.patientId as Object;
        await httpPost('/pat/patient/save', body);
      } else {
        await httpPost('/pat/patient/savepat', body);
      }
      /*AlertDialog.show({
        message: '健康信息保存成功',
        confirm: {
          value: '确定',
          action: () => {
            router.back();
          }
        }
      });*/
    } catch (e) {
      AlertDialog.show({ message: '保存失败，请重试' });
    }
    this.isLoading = false;
  }
  /*async editItem(id: number) {
    try {
      let resp = await httpGet('/pat/patient/queryPatById', { 'id': id.toString() });
      let result = JSON.parse(resp) as Record<string, Object>;
      let d = result['data'] as Record<string, Object>;
      if (d) { this.formData = d }
    } catch (e) { }
  }*/

  /*async loadData() {
    try {
      let params: Record<string, string> = { 'pageIndex': this.pageIndex.toString(), 'pageSize': this.pageSize.toString() };
      if (this.searchKey) { params['userName'] = this.searchKey; }
      let resp = await httpGet('/pat/patient/list', params);
      let result = JSON.parse(resp) as Record<string, Object>;
      let data = result['data'] as Record<string, Object>;
      if (data) {
        this.patients = (data['list'] as Record<string, Object>[]) || [];
        this.totalCount = (data['totalCount'] as number) || 0;
      }
    } catch (e) { }
  }*/

  async loadDoctors() {
    try {
      let resp = await httpGet('/doc/doc/list');
      let result = JSON.parse(resp) as Record<string, Object>;
      let data = result['data'] as Record<string, Object>[];
      if (data) {
        this.doctors = data;
      }
    } catch (e) { }
  }

  async loadHistory() {
    try {
      let resp = await httpGet('/pat/patient/jqlist');
      let result = JSON.parse(resp) as Record<string, Object>;
      let data = result['data'] as Record<string, Object>[];
      if (data) {
        this.historyList = data;
        // Check if there's a recent appointment without reply (active/pending)
        this.hasActiveAppointment = data.some((item: Record<string, Object>) => {
          return !item['hf'] || (item['hf'] as string) === '';
        });
      }
    } catch (e) { }
  }

  async submitAppointment() {
    if (!this.symptoms || this.symptoms.length < 5) {
      AlertDialog.show({ message: '请详细描述您的症状（至少5个字符）' });
      return;
    }
    /*if (this.hasActiveAppointment) {
      AlertDialog.show({ message: '您已有待处理的预约挂号，请等待医生回复后再次预约' });
      return;
    }*/
    this.isSubmitting = true;
    try {
      if( this.needdoor == true ){
        this.symptoms='[预约检查: '+ this.selectedTime + ' ]' + this.symptoms
      }
      let body: Record<string, string> = { 'symptoms': this.symptoms };
      await httpPost('/doc/doc/save', body);
      AlertDialog.show({ message: '预约成功！' });
      this.activeStep = 0;
      this.symptoms = '';
      this.selectedDoctor = null;
      await this.loadHistory();
    } catch (e) {
      AlertDialog.show({ message: '预约失败，请重试' });
    }
    this.isSubmitting = false;
  }

  build() {
    Scroll() {
      Column() {
        // Title
        Row() {
          Image($r('app.media.ic_calendar')).width(22).height(22).fillColor(AppColors.PRIMARY)
          Text(' 预约咨询').fontSize(20).fontWeight(FontWeight.Bold).fontColor(AppColors.TEXT_PRIMARY)
        }
          .width('100%')
          .padding({ left: 20, top: 16, bottom: 8 })

        // Tab switcher: 预约挂号 / 挂号记录
        Row() {
          Text('预约咨询')
            .fontSize(15)
            .fontWeight(!this.showHistory ? FontWeight.Bold : FontWeight.Normal)
            .fontColor(!this.showHistory ? AppColors.PRIMARY : AppColors.TEXT_HINT)
            .padding({ left: 20, right: 20, top: 8, bottom: 8 })
            .borderRadius(20)
            .backgroundColor(!this.showHistory ? AppColors.PRIMARY_LIGHT : Color.Transparent)
            .onClick(() => { this.showHistory = false; })
          Text('问诊记录')
            .fontSize(15)
            .fontWeight(this.showHistory ? FontWeight.Bold : FontWeight.Normal)
            .fontColor(this.showHistory ? AppColors.PRIMARY : AppColors.TEXT_HINT)
            .padding({ left: 20, right: 20, top: 8, bottom: 8 })
            .borderRadius(20)
            .backgroundColor(this.showHistory ? AppColors.PRIMARY_LIGHT : Color.Transparent)
            .onClick(() => { this.showHistory = true; this.loadHistory(); })
        }
        .width('92%')
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: 8 })

        if (this.showHistory) {
          // History list
          if (this.historyList.length > 0) {
            ForEach(this.historyList, (item: Record<string, Object>, index: number) => {
              Column() {
                Row() {
                  Image($r('app.media.ic_registration')).width(28).height(28).fillColor(AppColors.ACCENT).margin({ right: 10 })
                  Text('问诊记录 #' + (index + 1)).fontSize(15).fontWeight(FontWeight.Bold).fontColor(AppColors.TEXT_PRIMARY).layoutWeight(1)
                  //Text(!item['hf'] || (item['hf'] as string) === '' ? '待诊断' : '已回复')
                  Text(!item['hf'] || (item['hf'] as string) === '' ? '' : '')
                    .fontSize(11)
                    .fontColor(!item['hf'] || (item['hf'] as string) === '' ? AppColors.WARNING : AppColors.SUCCESS)
                    .backgroundColor(!item['hf'] || (item['hf'] as string) === '' ? '#FFF3E0' : '#E8F5E9')
                    .padding({ left: 8, right: 8, top: 3, bottom: 3 })
                    .borderRadius(10)
                }
                .width('100%').margin({ bottom: 8 })
                Text('症状描述：' + ((item['symptoms'] as string) || '暂无'))
                  .fontSize(13).fontColor(AppColors.TEXT_SECONDARY).width('100%').margin({ bottom: 4 })
                if (item['hf'] && (item['hf'] as string) !== '') {
                  Text('医生回复：' + (item['hf'] as string))
                    .fontSize(13).fontColor(AppColors.SUCCESS).width('100%')
                    .padding({ top: 6, bottom: 6, left: 8, right: 8 })
                    .backgroundColor('#F1F8E9').borderRadius(6).margin({ top: 4 })
                }
              }
              .width('92%')
              .padding(AppSizes.PADDING)
              .backgroundColor(AppColors.BG_CARD)
              .borderRadius(AppSizes.RADIUS_LG)
              .shadow({ radius: 4, color: '#08000000', offsetX: 0, offsetY: 1 })
              .margin({ left: '4%', right: '4%', bottom: 10 })
            }, (item: Record<string, Object>, index: number) => 'hist_' + String(item['rid'] || '') + '_' + index)
          } else {
            Column() {
              Image($r('app.media.ic_calendar')).width(48).height(48).fillColor(AppColors.TEXT_HINT).margin({ bottom: 12 })
              Text('暂无记录').fontSize(16).fontColor(AppColors.TEXT_HINT)
              Text('请先进行问诊').fontSize(13).fontColor(AppColors.TEXT_HINT).margin({ top: 4 })
            }
            .width('100%')
            .justifyContent(FlexAlign.Center)
            .padding({ top: 60 })
          }
        } else {
        // Steps indicator
        Row() {
          this.StepDot(0, '选择站点')
          Line().width(30).height(1).backgroundColor(this.activeStep >= 1 ? AppColors.PRIMARY : AppColors.BORDER)
          this.StepDot(1, '选择时间')
          Line().width(30).height(1).backgroundColor(this.activeStep >= 2 ? AppColors.PRIMARY : AppColors.BORDER)
          this.StepDot(2, '确认信息')
        }
        .width('92%')
        .justifyContent(FlexAlign.Center)
        .padding({ top: 8, bottom: 16 })

        // Step content
        if (this.activeStep === 0) {
          // Step 1: Select doctor
          Column() {
            Row(){
              Text('选择服务点')
                .fontSize(18)
                .fontWeight(FontWeight.Medium)
                .fontColor(AppColors.TEXT_PRIMARY)
                .margin({ bottom: 12 })
                .width('60%')
              Row(){
              Text('是否需要上门')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .fontColor(AppColors.TEXT_PRIMARY)
              Checkbox()
                .select(this.needdoor) // 老版本属性：select
                .onChange((isChecked: boolean) => {
                  this.needdoor = isChecked;
                  console.log('当前状态:', this.needdoor);
                })
            }
              .margin({ bottom: 12 ,left: 20})
              .width('35%')
            }


            ForEach(this.doctors, (doc: Record<string, Object>, index: number) => {
              Row() {
                // Avatar circle
                Image($r('app.media.ic_hostp')).width(44).height(44).fillColor(AppColors.PRIMARY)
                .margin({ right: 12 })

                Column() {
                  Row() {
                    Text((doc['dname'] as string) || '服务点')
                      .fontSize(16)
                      .fontWeight(FontWeight.Bold)
                      .fontColor(AppColors.TEXT_PRIMARY)
                    Text(' ' + ((doc['title'] as string) || ''))
                      .fontSize(12)
                      .fontColor(AppColors.PRIMARY)
                      .backgroundColor(AppColors.PRIMARY_LIGHT)
                      .padding({ left: 6, right: 6, top: 2, bottom: 2 })
                      .borderRadius(4)
                      .margin({ left: 6 })
                  }
                  Text('距离：' + ((doc['good'] as string) || ''))
                    .fontSize(13)
                    .fontColor(AppColors.TEXT_SECONDARY)
                    .margin({ top: 4 })
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                  Text((doc['exp'] as string) || '')
                    .fontSize(12)
                    .fontColor(AppColors.TEXT_HINT)
                    .margin({ top: 2 })
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                }
                .layoutWeight(1)
                .alignItems(HorizontalAlign.Start)

                Button('选择')
                  .fontSize(13)
                  .height(32)
                  .backgroundColor(AppColors.PRIMARY)
                  .borderRadius(16)
                  .onClick(() => {
                    this.selectedDoctor = doc;
                    if (this.needdoor == false){
                      this.activeStep = 2
                    }else {
                    this.activeStep = 1;}
                  })
              }
              .width('100%')
              .padding(12)
              .backgroundColor(AppColors.BG_CARD)
              .borderRadius(AppSizes.RADIUS)
              .margin({ bottom: 10 })
              .shadow({ radius: 4, color: '#08000000', offsetX: 0, offsetY: 1 })
            }, (doc: Record<string, Object>, index: number) => 'doc_' + String(doc['id'] || '') + '_' + index)
          }
          .width('92%')
          .padding(AppSizes.PADDING)
        } else if (this.activeStep === 1) {
          // Step 2: Select time
          Column() {

            if (this.needdoor === false){

            }else {
              Text('请选择预约时间')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .fontColor(AppColors.TEXT_PRIMARY)
                .margin({ bottom: 12 })
                .width('100%')

              Flex({ wrap: FlexWrap.Wrap }) {
                ForEach(['08:00-09:30', '09:30-11:00', '11:00-12:30', '12:30-14:00', '14:00-15:30', '15:30-17:00'],
                  (time: string) => {
                    Text(time)
                      .fontSize(14)
                      .fontColor(this.selectedTime === time ? Color.White : AppColors.TEXT_PRIMARY)
                      .backgroundColor(this.selectedTime === time ? AppColors.PRIMARY : '#F5F7FA')
                      .padding({
                        left: 16,
                        right: 16,
                        top: 10,
                        bottom: 10
                      })
                      .borderRadius(AppSizes.RADIUS)
                      .margin(6)
                      .onClick(() => {
                        this.selectedTime = time;
                      })
                  }, (time: string) => time)
              }
              .width('100%')
            }
            Button('下一步')
              .width('100%')
              .height(44)
              .backgroundColor(AppColors.PRIMARY)
              .borderRadius(AppSizes.RADIUS)
              .margin({ top: 20 })
              .onClick(() => {
                this.activeStep = 2;
              })

            Button('上一步')
              .width('100%')
              .height(44)
              .backgroundColor(Color.Transparent)
              .fontColor(AppColors.PRIMARY)
              .borderWidth(1)
              .borderColor(AppColors.PRIMARY)
              .borderRadius(AppSizes.RADIUS)
              .margin({ top: 8 })
              .onClick(() => {
                this.activeStep = 0;
              })
          }
          .width('92%')
          .padding(AppSizes.PADDING)
        } else if (this.activeStep === 2) {
          // Step 3: Confirm
          Column() {
            Text('确认预约信息')
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .fontColor(AppColors.TEXT_PRIMARY)
              .margin({ bottom: 12 })
              .width('100%')

            Column() {
              this.InfoRow('服务站', this.selectedDoctor ?
                ((this.selectedDoctor['dname'] as string) || '') : '')
              this.InfoRow('类型', this.selectedDoctor ?
                ((this.selectedDoctor['title'] as string) || '') : '')
              if(this.needdoor == true){
                this.InfoRow('预约时间', this.selectedTime)
                Theaddress()
                /*Text('父页面读取的位置：' + this.address)
                  .fontSize(20)
                Button('刷新数据').onClick(() => {
                  this.address = GlobalData.address;
                  this.currentTime = GlobalData.currentTime;
                })*/
                //TextInput({ placeholder: '地址', text: (this.formData['address'] as string) || '' }).height(40).backgroundColor('#F5F7FA').borderRadius(8).margin({ bottom: 6 }).onChange((v: string) => { this.formData['address'] = v; })
              }
            }
            .width('100%')
            .padding(12)
            .backgroundColor('#F5F7FA')
            .borderRadius(AppSizes.RADIUS)
            //.margin({ bottom: 16 })

            Text('症状描述')
              .fontSize(14)
              .fontColor(AppColors.TEXT_SECONDARY)
              .margin({ bottom: 6 })
              .width('100%')

            TextArea({ placeholder: '请详细描述您的症状', text: this.symptoms })
              .height(100)
              .backgroundColor('#F5F7FA')
              .borderRadius(AppSizes.RADIUS)
              .onChange((value: string) => {
                this.symptoms = value;
              })

            Button(this.isSubmitting ? '提交中...' : '提交预约')
              .width('100%')
              .height(44)
              .backgroundColor(AppColors.PRIMARY)
              .borderRadius(AppSizes.RADIUS)
              .margin({ top: 20 })
              .enabled(!this.isSubmitting)
              .onClick(() => {
                this.address = GlobalData.address;
                this.submitAppointment();
                this.submitForm();
              })

            Button('上一步')
              .width('100%')
              .height(44)
              .backgroundColor(Color.Transparent)
              .fontColor(AppColors.PRIMARY)
              .borderWidth(1)
              .borderColor(AppColors.PRIMARY)
              .borderRadius(AppSizes.RADIUS)
              .margin({ top: 8 })
              .onClick(() => {
                if (this.needdoor == false){
                  this.activeStep = 0
                }else {
                  this.activeStep = 1;}
              })
          }
          .width('92%')
          .padding(AppSizes.PADDING)
        }
        } // end else (not showHistory)
      }
      .width('100%')
      .justifyContent(FlexAlign.Start)
    }
    .width('100%')
    .height('100%')
    .scrollBar(BarState.Off)
    .align(Alignment.Top)
  }

  @Builder
  StepDot(index: number, label: string) {
    Column() {
      Stack() {
        Circle()
          .width(28)
          .height(28)
          .fill(this.activeStep >= index ? AppColors.PRIMARY : AppColors.BORDER)
        Text('' + (index + 1))
          .fontSize(13)
          .fontColor(Color.White)
          .fontWeight(FontWeight.Bold)
      }
      Text(label)
        .fontSize(11)
        .fontColor(this.activeStep >= index ? AppColors.PRIMARY : AppColors.TEXT_HINT)
        .margin({ top: 4 })
    }
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  InfoRow(label: string, value: string) {
    Row() {
      Text(label + '：')
        .fontSize(14)
        .fontColor(AppColors.TEXT_SECONDARY)
        .width(80)
      Text(value)
        .fontSize(14)
        .fontColor(AppColors.TEXT_PRIMARY)
        .fontWeight(FontWeight.Medium)
    }
    .width('100%')
    .padding({ top: 6, bottom: 6 })
  }
}

// ======================== Health Knowledge Page ========================
@Component
struct HealthKnowledgePage {
  @State knowledgeList: Record<string, Object>[] = [];

  aboutToAppear() {
    this.loadKnowledge();
  }

  async loadKnowledge() {
    try {
      let resp = await httpGet('/hea/healthknowledge/list');
      let result = JSON.parse(resp) as Record<string, Object>;
      let data = result['data'] as Record<string, Object>[];
      if (data) {
        this.knowledgeList = data;
      }
    } catch (e) { }
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.ic_knowledge')).width(22).height(22).fillColor(AppColors.PRIMARY)
        Text(' 健康常识').fontSize(20).fontWeight(FontWeight.Bold).fontColor(AppColors.TEXT_PRIMARY)
      }
        .width('100%')
        .padding({ left: 20, top: 16, bottom: 12 })

      if (this.knowledgeList.length > 0) {
        List() {
          ForEach(this.knowledgeList, (item: Record<string, Object>, index: number) => {
            ListItem() {
              Column() {
                Row() {
                  Stack() {
                    Circle()
                      .width(8)
                      .height(8)
                      .fill(AppColors.PRIMARY)
                  }
                  .margin({ right: 10 })
                  Text((item['title'] as string) || '')
                    .fontSize(16)
                    .fontWeight(FontWeight.Bold)
                    .fontColor(AppColors.PRIMARY)
                    .layoutWeight(1)
                }
                .width('100%')
                .margin({ bottom: 8 })

                Text((item['content'] as string) || '')
                  .fontSize(14)
                  .fontColor(AppColors.TEXT_SECONDARY)
                  .lineHeight(22)
              }
              .width('92%')
              .padding(AppSizes.PADDING)
              .backgroundColor(AppColors.BG_CARD)
              .borderRadius(AppSizes.RADIUS_LG)
              .shadow({ radius: 4, color: '#08000000', offsetX: 0, offsetY: 1 })
              .margin({ left: '4%', right: '4%', bottom: 10 })
            }
          }, (item: Record<string, Object>, index: number) => 'hk_' + String(item['id'] || '') + '_' + index)
        }
        .layoutWeight(1)
        .width('100%')
      } else {
        Column() {
          Image($r('app.media.ic_knowledge')).width(48).height(48).fillColor(AppColors.TEXT_HINT)
            .margin({ bottom: 12 })
          Text('暂无健康常识')
            .fontSize(16)
            .fontColor(AppColors.TEXT_HINT)
        }
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
        .width('100%')
      }
    }
    .width('100%')
    .height('100%')
  }
}

// ======================== Medication Reminder Page ========================
@Component
struct MedicationReminderPage {
  private selectedDate: Date = new Date('2024-03-05');
  @State selH: number = 0
  @State selM: number = 0

  @State isLunar: boolean = false;
  @State reminders: Record<string, Object>[] = [];
  @State newMedName: string = '';
  @State newMedTime: string = '';
  @State showAddForm: boolean = false;

  aboutToAppear() {
    this.loadReminders();
  }

  async loadReminders() {
    try {
      let resp = await httpGet('/yytx/yytx/list');
      let result = JSON.parse(resp) as Record<string, Object>;
      let data = result['data'] as Record<string, Object>[];
      if (data) {
        this.reminders = data;
      }
    } catch (e) { }
  }

  async addReminder() {
    if (!this.newMedName || !this.newMedTime) {
      AlertDialog.show({ message: '请填写药品名称和用药时间' });
      return;
    }
    try {
      let body: Record<string, string> = {
        'newReminder': this.newMedName,
        'time': this.newMedTime
      };
      await httpPost('/yytx/yytx/save', body);
      AlarmUtil.sendNow("悦享家庭医生","提醒添加成功，将在"+ this.newMedTime + "提醒您");
      AlarmUtil.sendAtTime(this.selH,this.selM,"用药提醒",this.newMedTime+": 药品 "+this.newMedName+" 提醒使用");
      this.newMedName = '';
      this.newMedTime = '';
      this.showAddForm = false;
      this.loadReminders();

    } catch (e) {
      AlertDialog.show({ message: '添加失败' });
    }
  }

  async deleteReminder(id: number) {
    try {
      await httpGet('/yytx/yytx/delete', { 'id': id.toString() });
      this.loadReminders();
    } catch (e) { }
  }

  build() {
    Column() {
      // Header
      Row() {
        Row() {
          Image($r('app.media.ic_alarm')).width(22).height(22).fillColor(AppColors.PRIMARY)
          Text(' 用药提醒')
            .fontSize(20).fontWeight(FontWeight.Bold).fontColor(AppColors.TEXT_PRIMARY)
        }.layoutWeight(1)

        Button(this.showAddForm ? '取消' : '添加')
          .fontSize(13)
          .height(34)
          .backgroundColor(this.showAddForm ? AppColors.TEXT_HINT : AppColors.PRIMARY)
          .borderRadius(17)
          .onClick(() => {
            this.showAddForm = !this.showAddForm;
          })
      }
      .width('92%')
      .padding({ top: 16, bottom: 12 })

      // Add form
      if (this.showAddForm) {
        Column() {
          TextInput({ placeholder: '药品名称', text: this.newMedName })
            .height(44)
            .backgroundColor('#F5F7FA')
            .borderRadius(AppSizes.RADIUS)
            .margin({ bottom: 10 })
            .onChange((value: string) => {
              this.newMedName = value;
            })

          /*TextInput({ placeholder: '用药时间（如 08:00）', text: this.newMedTime })
            .height(44)
            .backgroundColor('#F5F7FA')
            .borderRadius(AppSizes.RADIUS)
            .margin({ bottom: 10 })
            .onChange((value: string) => {
              this.newMedTime = value;
            })*/

          TimePicker({
            selected: this.selectedDate,
            format: TimePickerFormat.HOUR_MINUTE
          })
            .disappearTextStyle({ color: Color.Gray, font: { size: '16fp', weight: FontWeight.Bold } })
            .textStyle({ color: '#ff182431', font: { size: '15fp', weight: FontWeight.Normal } })
            .selectedTextStyle({
              color: '#ff000000',
              font: {
                size: '20fp',
                weight: FontWeight.Regular,
                family: "HarmonyOS Sans",
                style: FontStyle.Normal
              }
            })
            .onChange((value) => {
              console.info('222svalue: ' + value.hour);
              console.info('2223svalue: ' + value.minute);
              this.selectedDate.setHours(value.hour, value.minute);
              this.selH=value.hour;
              this.selM=value.minute;

              if(this.selH<10){
                if(this.selM<10){
                  this.newMedTime='0'+ this.selH +':' + '0' + this.selM;
                }else {
                  this.newMedTime='0'+ this.selH +':' + this.selM;
                }
              }else if(this.selM<10){
                this.newMedTime=this.selH +':' + '0' + this.selM;
              }else {
                this.newMedTime=this.selH+':'+this.selM;
              }
            })
            .height('20%')
            .width('90%')
            .margin({ top: 10, left: 20, right: 20 })

          Button('确认添加')
            .width('100%')
            .height(42)
            .backgroundColor(AppColors.PRIMARY)
            .borderRadius(AppSizes.RADIUS)
            .onClick(() => {
              this.addReminder();
            })
        }
        .width('92%')
        .padding(AppSizes.PADDING)
        .backgroundColor(AppColors.BG_CARD)
        .borderRadius(AppSizes.RADIUS_LG)
        .margin({ bottom: 12 })
      }

      // Reminders list
      if (this.reminders.length > 0) {
        List() {
          ForEach(this.reminders, (item: Record<string, Object>, index: number) => {
            ListItem() {
              Row() {
                Image($r('app.media.ic_medicine')).width(32).height(32).fillColor(AppColors.ACCENT)
                .margin({ right: 12 })

                Column() {
                  Text((item['newReminder'] as string) || '')
                    .fontSize(16)
                    .fontWeight(FontWeight.Medium)
                    .fontColor(AppColors.TEXT_PRIMARY)
                  Text('用药时间：' + ((item['time'] as string) || ''))
                    .fontSize(13)
                    .fontColor(AppColors.TEXT_SECONDARY)
                    .margin({ top: 4 })
                }
                .layoutWeight(1)
                .alignItems(HorizontalAlign.Start)

                Image($r('app.media.ic_delete')).width(20).height(20).fillColor(AppColors.DANGER)
                  .onClick(() => {
                    let id = item['id'] as number;
                    AlertDialog.show({
                      title: '确认删除',
                      message: '确定删除该用药提醒吗？',
                      autoCancel: true,
                      confirm: {
                        value: '删除',
                        fontColor: AppColors.DANGER,
                        action: () => {
                          this.deleteReminder(id);
                        }
                      }
                    });
                  })
              }
              .width('92%')
              .padding(AppSizes.PADDING)
              .backgroundColor(AppColors.BG_CARD)
              .borderRadius(AppSizes.RADIUS_LG)
              .shadow({ radius: 4, color: '#08000000', offsetX: 0, offsetY: 1 })
              .margin({ left: '4%', right: '4%', bottom: 10 })
            }
          }, (item: Record<string, Object>, index: number) => 'med_' + String(item['id'] || '') + '_' + index)
        }
        .layoutWeight(1)
        .width('100%')
      } else {
        Column() {
          Image($r('app.media.ic_medicine')).width(48).height(48).fillColor(AppColors.TEXT_HINT)
            .margin({ bottom: 12 })
          Text('暂无用药提醒')
            .fontSize(16)
            .fontColor(AppColors.TEXT_HINT)
          Text('点击右上角添加用药提醒')
            .fontSize(13)
            .fontColor(AppColors.TEXT_HINT)
            .margin({ top: 4 })
        }
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
        .width('100%')
      }
    }
    .width('100%')
    .height('100%')
  }
}

// ======================== User Profile Page ========================
// 新增：定义接口，替代 Record<string, Object>
interface UserInfo {
  username?: string;
  email?: string;
  mobile?: string;
  // 其他字段按需补充
}

interface ApiResponse {
  data?: UserInfo[];
}
/*@Component
struct UserProfilePage {
  @State userInfo: Record<string, Object> = {};
  @State isLoading: boolean = false;

  aboutToAppear() {
    this.loadUserInfo();
    console.log('喵', this.userInfo)
    console.log('userInfo:', this.userInfo)
    console.log('username:', this.userInfo['username'])
  }

  async loadUserInfo() {
    this.isLoading = true;
    try {
      let resp = await httpGet('/sys/sysUser/inlist');
      let result = JSON.parse(resp) as Record<string, Object>;
      let data = result['data'] as Record<string, Object>[];
      if (data && data.length > 0) {
        this.userInfo = data[0];
      }
    } catch (e) { }
    this.isLoading = false;
  }*/
// 在 UserProfilePage 组件外新增（或内部）
@Component
struct ProfileRow {
  @Prop icon: Resource;
  @Prop label: string;
  @Prop value: string;

  build() {
    Row() {
      // 1. 修复 SizeOptions 报错：24 → { width: 24, height: 24 }
      Image(this.icon).size({ width: 24, height: 24 })
      // 2. 修复 marginLeft 报错：marginLeft(12) → margin({ left: 12 })
      Text(this.label).fontSize(16).margin({ left: 12 })
      Blank()
      Text(this.value).fontSize(16).fontColor(Color.Gray)
    }
    .width('100%')
    // 3. 修复 paddingVertical 报错：paddingVertical(12) → padding({ top: 12, bottom: 12 })
    .padding({ top: 12, bottom: 12 })
  }
}
@Component

struct UserProfilePage {
  @State userInfo: UserInfo = {};
  @State isLoading: boolean = false;

  aboutToAppear() {
    this.loadUserInfo();
    // 这里打印没用！异步请求还没返回，删掉也可以
    console.log('喵', this.userInfo)
    console.log('userInfo:', this.userInfo)
    console.log('username:', this.userInfo.username)
  }


  async loadUserInfo() {
    this.isLoading = true;
    try {
      let resp = await httpGet('/sys/sysUser/inlist');
      // 🔥 仅新增这1行日志！打印接口原始返回，看真实字段名
      console.log('接口原始返回：', resp);

      let result = JSON.parse(resp) as ApiResponse;
      let data = result.data;
      if (data && data.length > 0) {
        this.userInfo = data[0];
        // 🔥 新增这1行：赋值后打印，看拿到的真实数据
        console.log('赋值后userInfo：', this.userInfo.username);
      }
    } catch (e) {
      // 🔥 新增这1行：打印请求错误，排查接口调用失败
      console.log('请求失败：', e);
    }
    this.isLoading = false;
  }

  build() {
    Scroll() {
      Column() {
        // Profile header
        Column() {
          Image($r('app.media.ic_user')).width(64).height(64).fillColor(Color.White)
          .margin({ bottom: 12 })

          //Text((this.userInfo['username'] as string) || getUsername())
          Text((this.userInfo.username as string) || getUsername())
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
        }
        .width('100%')
        .padding({ top: 40, bottom: 30 })
        .linearGradient({
          angle: 135,
          colors: [[AppColors.PRIMARY, 0.0], [AppColors.ACCENT, 1.0]]
        })
        .borderRadius({ bottomLeft: 24, bottomRight: 24 })
        .alignItems(HorizontalAlign.Center)

        // Info card
        /*Column() {
          this.ProfileRow($r('app.media.ic_user'), '账号', (this.userInfo.username) || '--')
          //console.log()

          Divider().color(AppColors.DIVIDER)
          this.ProfileRow($r('app.media.ic_info'), '邮箱', (this.userInfo.email) || '--')
          Divider().color(AppColors.DIVIDER)
          this.ProfileRow($r('app.media.ic_alarm'),'手机', (this.userInfo.mobile) || '--')
        }
        .width('92%')
        .padding(AppSizes.PADDING)
        .backgroundColor(AppColors.BG_CARD)
        .borderRadius(AppSizes.RADIUS_LG)
        .shadow({ radius: 8, color: '#0A000000', offsetX: 0, offsetY: 2 })
        .margin({ top: -20 })*/
        Column() {
          ProfileRow({
            icon: $r('app.media.ic_user'),
            label: '账号',
            value: this.userInfo.username || '--'
          })
          Divider().color(AppColors.DIVIDER)
          ProfileRow({
            icon: $r('app.media.ic_info'),
            label: '邮箱',
            value: this.userInfo.email || '--'
          })
          Divider().color(AppColors.DIVIDER)
          ProfileRow({
            icon: $r('app.media.ic_alarm'),
            label: '手机',
            value: this.userInfo.mobile || '--'
          })
        }
        .width('92%')
        .padding(AppSizes.PADDING)
        .backgroundColor(AppColors.BG_CARD)
        .borderRadius(AppSizes.RADIUS_LG)
        .shadow({ radius: 8, color: '#0A000000', offsetX: 0, offsetY: 2 })
        .margin({ top: -20 })

        // Menu items
        Column() {
          this.MenuItem($r('app.media.ic_health'), '健康记录', () => {
            router.pushUrl({ url: 'pages/HealthRecord' });
          })
          Divider().color(AppColors.DIVIDER)
          this.MenuItem($r('app.media.ic_report'), '报告查询', () => {
            router.pushUrl({ url: 'pages/PatientReport' });
          })
          Divider().color(AppColors.DIVIDER)
          this.MenuItem($r('app.media.ic_hospital'), '家庭医生介绍', () => {
            router.pushUrl({ url: 'pages/FamilyDoctor' });
          })
        }
        .width('92%')
        .padding({ left: AppSizes.PADDING, right: AppSizes.PADDING })
        .backgroundColor(AppColors.BG_CARD)
        .borderRadius(AppSizes.RADIUS_LG)
        .shadow({ radius: 8, color: '#0A000000', offsetX: 0, offsetY: 2 })
        .margin({ top: 16 })

        // Logout button
        Button('退出登录')
          .width('92%')
          .height(48)
          .fontSize(16)
          .fontColor(AppColors.DANGER)
          .backgroundColor(AppColors.BG_CARD)
          .borderWidth(1)
          .borderColor(AppColors.DANGER)
          .borderRadius(AppSizes.RADIUS_LG)
          .margin({ top: 24, bottom: 30 })
          .onClick(() => {
            setToken('');
            setUsername('');
            router.replaceUrl({ url: 'pages/Login' });
          })
      }
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .scrollBar(BarState.Off)
  }

  @Builder
  ProfileRow(icon: Resource, label: string, value: string) {
    Row() {
      Image(icon).width(20).height(20).fillColor(AppColors.PRIMARY)
        .margin({ right: 12 })
      Text(label)
        .fontSize(14)
        .fontColor(AppColors.TEXT_SECONDARY)
        .width(60)
      Text(value)
        .fontSize(14)
        .fontColor(AppColors.TEXT_PRIMARY)
        .layoutWeight(1)
        .textAlign(TextAlign.End)
    }
    .width('100%')
    .padding({ top: 14, bottom: 14 })
  }

  @Builder
  MenuItem(icon: Resource, label: string, action: () => void) {
    Row() {
      Image(icon).width(20).height(20).fillColor(AppColors.PRIMARY)
        .margin({ right: 12 })
      Text(label)
        .fontSize(15)
        .fontColor(AppColors.TEXT_PRIMARY)
        .layoutWeight(1)
      Image($r('app.media.ic_back')).width(14).height(14).fillColor(AppColors.TEXT_HINT)
        .rotate({ angle: 180 })
    }
    .width('100%')
    .padding({ top: 14, bottom: 14 })
    .onClick(action)
  }
}
