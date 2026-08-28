import { router } from '@kit.ArkUI';
import { httpPost, httpGet } from '../common/HttpUtil';
import { AppColors, AppSizes } from '../common/Theme';

@Entry
@Component
struct HealthRecord {
  @State patientId: number = 0;
  @State username: string = '';
  @State phone: string = '';
  @State sex: string = '男';
  @State age: string = '';
  @State healthTag: string = '';
  @State idCard: string = '';
  @State address: string = '';
  @State bioodType: string = '';
  @State genetic: string = '';
  @State allergy: string = '';
  @State isLoading: boolean = false;
  @State selectedBloodType: number = -1;
  bloodTypes: string[] = ['A', 'B', 'AB', 'O', 'Rh-', '未知'];

  aboutToAppear() {
    this.loadExistingRecord();
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
      AlertDialog.show({
        message: '健康信息保存成功',
        confirm: {
          value: '确定',
          action: () => {
            router.back();
          }
        }
      });
    } catch (e) {
      AlertDialog.show({ message: '保存失败，请重试' });
    }
    this.isLoading = false;
  }

  build() {
    Column() {
      // Top bar
      Row() {
        Image($r('app.media.ic_back')).width(22).height(22).fillColor(AppColors.PRIMARY_DARK)
          .onClick(() => { router.back(); })
        Text('健康信息记录')
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
          // Patient name
          this.FormLabel('患者姓名 *')
          TextInput({ placeholder: '请输入患者姓名', text: this.username })
            .height(44).backgroundColor('#F5F7FA').borderRadius(AppSizes.RADIUS)
            .onChange((v: string) => { this.username = v; })
            .margin({ bottom: 12 })

          // Phone
          this.FormLabel('联系电话 *')
          TextInput({ placeholder: '请输入联系电话', text: this.phone })
            .height(44).backgroundColor('#F5F7FA').borderRadius(AppSizes.RADIUS)
            .maxLength(11)
            .onChange((v: string) => { this.phone = v; })
            .margin({ bottom: 12 })

          // Sex
          this.FormLabel('性别')
          Row() {
            this.RadioBtn('男', this.sex === '男', () => { this.sex = '男'; })
            this.RadioBtn('女', this.sex === '女', () => { this.sex = '女'; })
          }
          .width('100%')
          .margin({ bottom: 12 })

          // Age
          this.FormLabel('年龄 *')
          TextInput({ placeholder: '请输入年龄', text: this.age })
            .height(44).backgroundColor('#F5F7FA').borderRadius(AppSizes.RADIUS)
            .type(InputType.Number)
            .onChange((v: string) => { this.age = v; })
            .margin({ bottom: 12 })

          // Health tags
          this.FormLabel('健康标签')
          TextInput({ placeholder: '如：高血压,糖尿病', text: this.healthTag })
            .height(44).backgroundColor('#F5F7FA').borderRadius(AppSizes.RADIUS)
            .onChange((v: string) => { this.healthTag = v; })
            .margin({ bottom: 12 })

          // ID card
          this.FormLabel('身份证号 *')
          TextInput({ placeholder: '请输入身份证号', text: this.idCard })
            .height(44).backgroundColor('#F5F7FA').borderRadius(AppSizes.RADIUS)
            .maxLength(18)
            .onChange((v: string) => { this.idCard = v; })
            .margin({ bottom: 12 })

          // Address
          this.FormLabel('家庭地址 *')
          TextInput({ placeholder: '请输入详细家庭地址', text: this.address })
            .height(44).backgroundColor('#F5F7FA').borderRadius(AppSizes.RADIUS)
            .onChange((v: string) => { this.address = v; })
            .margin({ bottom: 12 })

          // Blood type
          this.FormLabel('血型')
          Flex({ wrap: FlexWrap.Wrap }) {
            ForEach(this.bloodTypes, (bt: string, index: number) => {
              Text(bt)
                .fontSize(14)
                .fontColor(this.selectedBloodType === index ? Color.White : AppColors.TEXT_PRIMARY)
                .backgroundColor(this.selectedBloodType === index ? AppColors.PRIMARY : '#F5F7FA')
                .padding({ left: 16, right: 16, top: 8, bottom: 8 })
                .borderRadius(20)
                .margin(4)
                .onClick(() => {
                  this.selectedBloodType = index;
                  this.bioodType = bt;
                })
            }, (bt: string) => bt)
          }
          .width('100%')
          .margin({ bottom: 12 })

          // Genetic
          this.FormLabel('家族遗传史')
          TextInput({ placeholder: '如：高血压,糖尿病', text: this.genetic })
            .height(44).backgroundColor('#F5F7FA').borderRadius(AppSizes.RADIUS)
            .onChange((v: string) => { this.genetic = v; })
            .margin({ bottom: 12 })

          // Allergy
          this.FormLabel('过敏源')
          TextInput({ placeholder: '如：青霉素,花粉', text: this.allergy })
            .height(44).backgroundColor('#F5F7FA').borderRadius(AppSizes.RADIUS)
            .onChange((v: string) => { this.allergy = v; })
            .margin({ bottom: 16 })

          // Submit
          Button(this.isLoading ? '提交中...' : '提交信息')
            .width('100%')
            .height(48)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .backgroundColor(AppColors.PRIMARY)
            .borderRadius(AppSizes.RADIUS_LG)
            .enabled(!this.isLoading)
            .onClick(() => { this.submitForm(); })
            .margin({ bottom: 12 })

          Button('重置')
            .width('100%')
            .height(44)
            .fontSize(14)
            .fontColor(AppColors.TEXT_SECONDARY)
            .backgroundColor('#F5F7FA')
            .borderRadius(AppSizes.RADIUS_LG)
            .margin({ bottom: 30 })
            .onClick(() => {
              this.username = ''; this.phone = ''; this.sex = '男';
              this.age = ''; this.healthTag = ''; this.idCard = '';
              this.address = ''; this.bioodType = ''; this.genetic = '';
              this.allergy = ''; this.selectedBloodType = -1;
            })
        }
        .width('92%')
        .margin({ left: '4%', right: '4%' })
        .padding({ top: 16 })
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(AppColors.BG_PAGE)
  }

  @Builder
  FormLabel(text: string) {
    Text(text)
      .fontSize(14)
      .fontWeight(FontWeight.Medium)
      .fontColor(AppColors.TEXT_PRIMARY)
      .margin({ bottom: 6 })
      .width('100%')
  }

  @Builder
  RadioBtn(label: string, selected: boolean, action: () => void) {
    Row() {
      Stack() {
        Circle()
          .width(20)
          .height(20)
          .fill(Color.Transparent)
          .strokeWidth(2)
          .stroke(selected ? AppColors.PRIMARY : AppColors.BORDER)
        if (selected) {
          Circle()
            .width(12)
            .height(12)
            .fill(AppColors.PRIMARY)
        }
      }
      .margin({ right: 6 })
      Text(label)
        .fontSize(14)
        .fontColor(AppColors.TEXT_PRIMARY)
    }
    .padding({ right: 24, top: 8, bottom: 8 })
    .onClick(action)
  }
}
