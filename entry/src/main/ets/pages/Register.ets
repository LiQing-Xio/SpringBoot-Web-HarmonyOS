import { router } from '@kit.ArkUI';
import { httpPost, httpGet } from '../common/HttpUtil';
import { AppColors, AppSizes } from '../common/Theme';

@Entry
@Component
struct Register {
  @State username: string = '';
  @State password: string = '';
  @State confirmPassword: string = '';
  @State email: string = '';
  @State mobile: string = '';
  @State isLoading: boolean = false;
  @State errorMsg: string = '';
  @State successMsg: string = '';

  async doRegister() {
    if (!this.username || !this.password || !this.confirmPassword || !this.email || !this.mobile) {
      this.errorMsg = '请填写所有字段';
      return;
    }
    if (this.username.length < 4 || this.username.length > 16) {
      this.errorMsg = '用户名长度应在4-16个字符之间';
      return;
    }
    if (this.password.length < 3) {
      this.errorMsg = '密码长度至少3个字符';
      return;
    }
    if (this.password !== this.confirmPassword) {
      this.errorMsg = '两次输入密码不一致';
      return;
    }
    let emailRegex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$/;
    if (!emailRegex.test(this.email)) {
      this.errorMsg = '请输入有效的邮箱地址';
      return;
    }
    let phoneRegex = /^1[3-9]\d{9}$/;
    if (!phoneRegex.test(this.mobile)) {
      this.errorMsg = '请输入有效的手机号码';
      return;
    }

    this.isLoading = true;
    this.errorMsg = '';

    try {
      // Check username availability
      let checkResp = await httpGet('/sys/sysUser/checkUserName', { 'username': this.username });
      let checkResult = JSON.parse(checkResp) as Record<string, Object>;
      let checkData = checkResult['data'] as string;
      if (checkData === 'success') {
        this.errorMsg = '用户名已存在';
        this.isLoading = false;
        return;
      }

      // Register
      let registerData: Record<string, string> = {
        'username': this.username,
        'password': this.password,
        'email': this.email,
        'mobile': this.mobile
      };
      let resp = await httpPost('/sys/sysUser/register', registerData);
      let result = JSON.parse(resp.data) as Record<string, Object>;
      let code = result['code'] as string;
      if (code === 'SUCCESS' || resp.code === 200) {
        this.successMsg = '注册成功，请登录';
        this.errorMsg = '';
        setTimeout(() => {
          router.back();
        }, 1500);
      } else {
        let msg = result['message'] as string;
        this.errorMsg = msg || '注册失败';
      }
    } catch (err) {
      this.errorMsg = '网络错误，请检查连接';
    }
    this.isLoading = false;
  }

  build() {
    Stack() {
      Column()
        .width('100%')
        .height('100%')
        .linearGradient({
          angle: 135,
          colors: [['#E3F2FD', 0.0], ['#BBDEFB', 0.5], ['#E0F2F1', 1.0]]
        })

      Column() {
        // Back button
        Row() {
          Text('\u2190')
            .fontSize(24)
            .fontColor(AppColors.PRIMARY_DARK)
            .onClick(() => {
              router.back();
            })
          Text('返回登录')
            .fontSize(14)
            .fontColor(AppColors.PRIMARY_DARK)
            .margin({ left: 8 })
            .onClick(() => {
              router.back();
            })
        }
        .width('100%')
        .margin({ bottom: 20 })

        // Title
        Text('用户注册')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor(AppColors.PRIMARY_DARK)
          .margin({ bottom: 24 })

        // Form card
        Column() {
          // Username
          Column() {
            Text('用户名')
              .fontSize(13)
              .fontColor(AppColors.TEXT_SECONDARY)
              .margin({ bottom: 6 })
            TextInput({ placeholder: '4-16个字符', text: this.username })
              .height(44)
              .backgroundColor('#F5F7FA')
              .borderRadius(AppSizes.RADIUS)
              .onChange((value: string) => {
                this.username = value;
              })
          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)
          .margin({ bottom: 12 })

          // Password
          Column() {
            Text('密码')
              .fontSize(13)
              .fontColor(AppColors.TEXT_SECONDARY)
              .margin({ bottom: 6 })
            TextInput({ placeholder: '请输入密码', text: this.password })
              .height(44)
              .type(InputType.Password)
              .backgroundColor('#F5F7FA')
              .borderRadius(AppSizes.RADIUS)
              .onChange((value: string) => {
                this.password = value;
              })
          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)
          .margin({ bottom: 12 })

          // Confirm Password
          Column() {
            Text('确认密码')
              .fontSize(13)
              .fontColor(AppColors.TEXT_SECONDARY)
              .margin({ bottom: 6 })
            TextInput({ placeholder: '请再次输入密码', text: this.confirmPassword })
              .height(44)
              .type(InputType.Password)
              .backgroundColor('#F5F7FA')
              .borderRadius(AppSizes.RADIUS)
              .onChange((value: string) => {
                this.confirmPassword = value;
              })
          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)
          .margin({ bottom: 12 })

          // Email
          Column() {
            Text('邮箱')
              .fontSize(13)
              .fontColor(AppColors.TEXT_SECONDARY)
              .margin({ bottom: 6 })
            TextInput({ placeholder: '请输入邮箱', text: this.email })
              .height(44)
              .backgroundColor('#F5F7FA')
              .borderRadius(AppSizes.RADIUS)
              .onChange((value: string) => {
                this.email = value;
              })
          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)
          .margin({ bottom: 12 })

          // Mobile
          Column() {
            Text('手机号')
              .fontSize(13)
              .fontColor(AppColors.TEXT_SECONDARY)
              .margin({ bottom: 6 })
            TextInput({ placeholder: '请输入手机号', text: this.mobile })
              .height(44)
              .backgroundColor('#F5F7FA')
              .borderRadius(AppSizes.RADIUS)
              .maxLength(11)
              .onChange((value: string) => {
                this.mobile = value;
              })
          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)
          .margin({ bottom: 12 })

          // Error / Success message
          if (this.errorMsg) {
            Text(this.errorMsg)
              .fontSize(13)
              .fontColor(AppColors.DANGER)
              .margin({ top: 4 })
              .width('100%')
          }
          if (this.successMsg) {
            Text(this.successMsg)
              .fontSize(13)
              .fontColor(AppColors.SUCCESS)
              .margin({ top: 4 })
              .width('100%')
          }

          // Register button
          Button(this.isLoading ? '注册中...' : '立即注册')
            .width('100%')
            .height(48)
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .backgroundColor(AppColors.PRIMARY)
            .borderRadius(AppSizes.RADIUS_LG)
            .margin({ top: 16 })
            .enabled(!this.isLoading)
            .onClick(() => {
              this.doRegister();
            })
        }
        .width('100%')
        .padding(AppSizes.PADDING_LG)
        .backgroundColor(AppColors.BG_CARD)
        .borderRadius(AppSizes.RADIUS_LG)
        .shadow({
          radius: 20,
          color: '#1A000000',
          offsetX: 0,
          offsetY: 4
        })
      }
      .width('85%')
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height('100%')
  }
}
