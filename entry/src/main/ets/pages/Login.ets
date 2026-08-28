import { router } from '@kit.ArkUI';
import { httpLogin, setToken, setUsername, httpGet, setRole } from '../common/HttpUtil';
import { AppColors, AppSizes } from '../common/Theme';

@Entry
@Component
struct Login {
  @State username: string = '';
  @State password: string = '';
  @State isLoading: boolean = false;
  @State errorMsg: string = '';
  @State isUserLogin: boolean = false;

  async doLogin() {
    if (!this.username || !this.password) {
      this.errorMsg = '请输入账号和密码';
      return;
    }
    this.isLoading = true;
    this.errorMsg = '';
    try {
      let resp = await httpLogin(this.username, this.password);
      let result = JSON.parse(resp.data) as Record<string, Object>;
      let code = result['code'] as number;
      if (code === 200) {
        let headerObj = resp.header as Record<string, string>;
        let token = headerObj['authorization'] || '';
        setToken(token);
        setUsername(this.username);
        // Check role via salt
        try {
          let saltResp = await httpGet('/sys/sysUser/salt');
          let saltResult = JSON.parse(saltResp) as Record<string, Object>;
          let saltData = saltResult['data'] as Record<string, string>[];
          if (saltData && saltData.length > 0) {
            let salt = saltData[0]['salt'];
            if (salt === '0') {
              // Normal user
              setRole('user');
              router.replaceUrl({ url: 'pages/UserHome' });
              //router.replaceUrl({ url: 'pages/Page1' });
            } else if (salt === '1') {
              // Admin/Employee
              setRole('admin');
              router.replaceUrl({ url: 'pages/AdminHome' });
            } else {
              setRole('user');
              router.replaceUrl({ url: 'pages/UserHome' });
            }
          } else {
            if (this.isUserLogin) {
              setRole('user');
              router.replaceUrl({ url: 'pages/UserHome' });
            } else {
              setRole('admin');
              router.replaceUrl({ url: 'pages/AdminHome' });
            }
          }
        } catch (e) {
          if (this.isUserLogin) {
            setRole('user');
            router.replaceUrl({ url: 'pages/UserHome' });
          } else {
            setRole('admin');
            router.replaceUrl({ url: 'pages/AdminHome' });
          }
        }
      } else {
        let msg = result['msg'] as string;
        this.errorMsg = msg || '登录失败';
      }
    } catch (err) {
      this.errorMsg = '网络错误，请检查连接';
    }
    this.isLoading = false;
  }

  build() {
    Stack() {
      // Background
      Column()
        .width('100%')
        .height('100%')
        .linearGradient({
          angle: 135,
          colors: [['#E3F2FD', 0.0], ['#BBDEFB', 0.5], ['#E0F2F1', 1.0]]
        })

      Column() {
        // Logo area
        Column() {
          // Medical cross icon
          Stack() {
            Circle()
              .width(80)
              .height(80)
              .fill(AppColors.PRIMARY)
              .opacity(0.1)
            Text('\u2695')
              .fontSize(40)
              .fontColor(AppColors.PRIMARY)
          }
          .margin({ bottom: 12 })

          Text('悦享家庭医生')
            .fontSize(26)
            .fontWeight(FontWeight.Bold)
            .fontColor(AppColors.PRIMARY_DARK)
            .margin({ bottom: 4 })
            .onClick(() => {
              router.replaceUrl({ url: 'pages/Page1' });
          })

          Text('云医院健康管理系统')
            .fontSize(14)
            .fontColor(AppColors.TEXT_SECONDARY)
        }
        .margin({ bottom: 40 })

        // Login type switch
        Row() {
          Text('员工登录')
            .fontSize(16)
            .fontWeight(this.isUserLogin ? FontWeight.Normal : FontWeight.Bold)
            .fontColor(this.isUserLogin ? AppColors.TEXT_HINT : AppColors.PRIMARY)
            .padding({ left: 20, right: 20, top: 10, bottom: 10 })
            .borderRadius(20)
            .backgroundColor(this.isUserLogin ? Color.Transparent : AppColors.PRIMARY_LIGHT)
            .onClick(() => {
              this.isUserLogin = false;
            })

          Text('用户登录')
            .fontSize(16)
            .fontWeight(this.isUserLogin ? FontWeight.Bold : FontWeight.Normal)
            .fontColor(this.isUserLogin ? AppColors.PRIMARY : AppColors.TEXT_HINT)
            .padding({ left: 20, right: 20, top: 10, bottom: 10 })
            .borderRadius(20)
            .backgroundColor(this.isUserLogin ? AppColors.PRIMARY_LIGHT : Color.Transparent)
            .onClick(() => {
              this.isUserLogin = true;
            })
        }
        .justifyContent(FlexAlign.Center)
        .width('100%')
        .margin({ bottom: 30 })

        // Login card
        Column() {
          // Username
          Row() {
            Image($r('app.media.ic_user')).width(20).height(20).fillColor(AppColors.PRIMARY)
              .margin({ right: 10 })
            TextInput({ placeholder: '请输入账号', text: this.username })
              .layoutWeight(1)
              .height(44)
              .backgroundColor(Color.Transparent)
              .onChange((value: string) => {
                this.username = value;
              })
          }
          .width('100%')
          .padding({ left: 16, right: 16 })
          .backgroundColor('#F5F7FA')
          .borderRadius(AppSizes.RADIUS)
          .margin({ bottom: 16 })

          // Password
          Row() {
            Image($r('app.media.ic_setting')).width(20).height(20).fillColor(AppColors.PRIMARY)
              .margin({ right: 10 })
            TextInput({ placeholder: '请输入密码', text: this.password })
              .layoutWeight(1)
              .height(44)
              .type(InputType.Password)
              .backgroundColor(Color.Transparent)
              .onChange((value: string) => {
                this.password = value;
              })
          }
          .width('100%')
          .padding({ left: 16, right: 16 })
          .backgroundColor('#F5F7FA')
          .borderRadius(AppSizes.RADIUS)
          .margin({ bottom: 8 })

          // Error message
          if (this.errorMsg) {
            Text(this.errorMsg)
              .fontSize(13)
              .fontColor(AppColors.DANGER)
              .margin({ top: 8, bottom: 8 })
              .width('100%')
          }

          // Login button
          Button(this.isLoading ? '登录中...' : '登  录')
            .width('100%')
            .height(48)
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .backgroundColor(AppColors.PRIMARY)
            .borderRadius(AppSizes.RADIUS_LG)
            .margin({ top: 20 })
            .enabled(!this.isLoading)
            .onClick(() => {
              this.doLogin();
            })

          // Register link (only for user login)
          if (this.isUserLogin) {
            Row() {
              Text('还没有账号？')
                .fontSize(14)
                .fontColor(AppColors.TEXT_HINT)
              Text('立即注册')
                .fontSize(14)
                .fontColor(AppColors.PRIMARY)
                .fontWeight(FontWeight.Medium)
                .onClick(() => {
                  router.pushUrl({ url: 'pages/Register' });
                })
            }
            .margin({ top: 20 })
            .justifyContent(FlexAlign.Center)
            .width('100%')
          }
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
