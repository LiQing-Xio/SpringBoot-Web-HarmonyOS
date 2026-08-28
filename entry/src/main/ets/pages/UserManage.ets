import { router } from '@kit.ArkUI';
import { httpGet, httpPost } from '../common/HttpUtil';
import { AppColors, AppSizes } from '../common/Theme';

@Entry
@Component
struct UserManage {
  @State users: Record<string, Object>[] = [];
  @State roles: Record<string, Object>[] = [];
  @State searchKey: string = '';
  @State currentPage: number = 1;
  @State totalCount: number = 0;
  @State showAddForm: boolean = false;
  @State newUser: Record<string, string> = {
    'username': '', 'password': '', 'email': '', 'mobile': ''
  };
  @State selectedRoleId: number = 0;

  aboutToAppear() {
    this.loadUsers();
    this.loadRoles();
  }

  async loadUsers() {
    try {
      let params: Record<string, string> = {
        'current': this.currentPage.toString(),
        'limit': '20'
      };
      if (this.searchKey) {
        params['username'] = this.searchKey;
      }
      let resp = await httpGet('/sys/sysUser/list', params);
      let result = JSON.parse(resp) as Record<string, Object>;
      let data = result['data'] as Record<string, Object>;
      if (data) {
        this.users = (data['list'] as Record<string, Object>[]) || [];
        this.totalCount = (data['totalCount'] as number) || 0;
      }
    } catch (e) { }
  }

  async loadRoles() {
    try {
      let resp = await httpGet('/sys/sysRole/listAll');
      let result = JSON.parse(resp) as Record<string, Object>;
      let data = result['data'] as Record<string, Object>[];
      if (data) {
        this.roles = data;
      }
    } catch (e) { }
  }

  async saveUser() {
    if (!this.newUser['username'] || !this.newUser['password']) {
      AlertDialog.show({ message: '请填写用户名和密码' });
      return;
    }
    try {
      let body: Record<string, Object> = {
        'userId': 0 as Object,
        'username': this.newUser['username'] as Object,
        'password': this.newUser['password'] as Object,
        'email': this.newUser['email'] as Object,
        'mobile': this.newUser['mobile'] as Object,
        'status': 1 as Object,
        'roleIds': this.selectedRoleId > 0 ? [this.selectedRoleId] as Object : [] as Object
      };
      await httpPost('/sys/sysUser/save', body);
      this.showAddForm = false;
      this.newUser = { 'username': '', 'password': '', 'email': '', 'mobile': '' };
      this.loadUsers();
    } catch (e) {
      AlertDialog.show({ message: '保存失败' });
    }
  }

  build() {
    Column() {
      // Top bar
      Row() {
        Image($r('app.media.ic_back')).width(22).height(22).fillColor(AppColors.PRIMARY_DARK)
          .onClick(() => { router.back(); })
        Row() {
          Image($r('app.media.ic_user')).width(20).height(20).fillColor(AppColors.PRIMARY).margin({ right: 6 })
          Text('用户管理').fontSize(18).fontWeight(FontWeight.Bold).fontColor(AppColors.TEXT_PRIMARY)
        }
          .margin({ left: 12 })
          .layoutWeight(1)

        Button(this.showAddForm ? '取消' : '新增')
          .fontSize(13)
          .height(32)
          .width(50)
          .backgroundColor(this.showAddForm ? AppColors.TEXT_HINT : AppColors.PRIMARY)
          .borderRadius(16)
          .onClick(() => { this.showAddForm = !this.showAddForm; })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 12, bottom: 12 })
      .backgroundColor(AppColors.BG_CARD)

      // Add form
      if (this.showAddForm) {
        Column() {
          Text('添加用户')
            .fontSize(15)
            .fontWeight(FontWeight.Bold)
            .fontColor(AppColors.PRIMARY)
            .width('100%')
            .margin({ bottom: 10 })

          TextInput({ placeholder: '用户名' })
            .height(40).backgroundColor('#F5F7FA').borderRadius(AppSizes.RADIUS).margin({ bottom: 8 })
            .onChange((v: string) => { this.newUser['username'] = v; })
          TextInput({ placeholder: '密码' })
            .height(40).backgroundColor('#F5F7FA').borderRadius(AppSizes.RADIUS).margin({ bottom: 8 })
            .type(InputType.Password)
            .onChange((v: string) => { this.newUser['password'] = v; })
          TextInput({ placeholder: '邮箱' })
            .height(40).backgroundColor('#F5F7FA').borderRadius(AppSizes.RADIUS).margin({ bottom: 8 })
            .onChange((v: string) => { this.newUser['email'] = v; })
          TextInput({ placeholder: '手机号' })
            .height(40).backgroundColor('#F5F7FA').borderRadius(AppSizes.RADIUS).margin({ bottom: 8 })
            .onChange((v: string) => { this.newUser['mobile'] = v; })

          // Role selector
          Text('选择角色')
            .fontSize(13)
            .fontColor(AppColors.TEXT_SECONDARY)
            .width('100%')
            .margin({ bottom: 4 })
            .visibility(this.roles.length > 0 ? Visibility.Visible : Visibility.None)

          Flex({ wrap: FlexWrap.Wrap }) {
            ForEach(this.roles, (role: Record<string, Object>, idx: number) => {
              Text((role['roleName'] as string) || '')
                .fontSize(13)
                .fontColor(this.selectedRoleId === (role['roleId'] as number) ? Color.White : AppColors.TEXT_PRIMARY)
                .backgroundColor(this.selectedRoleId === (role['roleId'] as number) ? AppColors.PRIMARY : '#F5F7FA')
                .padding({ left: 12, right: 12, top: 6, bottom: 6 })
                .borderRadius(16)
                .margin(4)
                .onClick(() => { this.selectedRoleId = role['roleId'] as number; })
            }, (role: Record<string, Object>, idx: number) => idx.toString())
          }
          .width('100%')
          .margin({ bottom: 8 })
          .visibility(this.roles.length > 0 ? Visibility.Visible : Visibility.None)

          Button('保存用户')
            .width('100%').height(40).backgroundColor(AppColors.PRIMARY).borderRadius(AppSizes.RADIUS)
            .onClick(() => { this.saveUser(); })
        }
        .width('92%')
        .padding(AppSizes.PADDING)
        .backgroundColor(AppColors.BG_CARD)
        .borderRadius(AppSizes.RADIUS_LG)
        .margin({ top: 8, left: '4%', right: '4%' })
      }

      // Search
      Row() {
        TextInput({ placeholder: '搜索用户名', text: this.searchKey })
          .height(38).backgroundColor('#F5F7FA').borderRadius(19).layoutWeight(1)
          .onChange((v: string) => { this.searchKey = v; })
        Image($r('app.media.ic_search')).width(20).height(20).fillColor(Color.White)
          .padding(9).backgroundColor(AppColors.PRIMARY).borderRadius(19).margin({ left: 8 })
          .onClick(() => { this.currentPage = 1; this.loadUsers(); })
      }
      .width('92%')
      .margin({ top: 8, bottom: 8 })

      // Stats
      Text('共 ' + this.totalCount + ' 个用户')
        .fontSize(13)
        .fontColor(AppColors.TEXT_HINT)
        .width('92%')
        .margin({ bottom: 6 })

      // User list
      List() {
        ForEach(this.users, (item: Record<string, Object>, index: number) => {
          ListItem() {
            Row() {
              Image($r('app.media.ic_user')).width(36).height(36).fillColor(AppColors.PRIMARY)
              .margin({ right: 12 })

              Column() {
                Text((item['username'] as string) || '未知')
                  .fontSize(15)
                  .fontWeight(FontWeight.Medium)
                  .fontColor(AppColors.TEXT_PRIMARY)
                Row() {
                  if (item['email']) {
                    Text('邮箱: ' + (item['email'] as string))
                      .fontSize(12)
                      .fontColor(AppColors.TEXT_HINT)
                  }
                }
                .margin({ top: 2 })
                Row() {
                  if (item['mobile']) {
                    Text('电话: ' + String(item['mobile'] || ''))
                      .fontSize(12)
                      .fontColor(AppColors.TEXT_HINT)
                  }
                  Text('  状态：' + (Number(item['status'] || 0) === 1 ? '正常' : '禁用'))
                    .fontSize(12)
                    .fontColor(Number(item['status'] || 0) === 1 ? AppColors.SUCCESS : AppColors.DANGER)
                }
                .margin({ top: 2 })
              }
              .layoutWeight(1)
              .alignItems(HorizontalAlign.Start)
            }
            .width('92%')
            .padding(12)
            .backgroundColor(AppColors.BG_CARD)
            .borderRadius(AppSizes.RADIUS)
            .shadow({ radius: 4, color: '#08000000', offsetX: 0, offsetY: 1 })
            .margin({ left: '4%', right: '4%', bottom: 8 })
          }
        }, (item: Record<string, Object>, index: number) => index.toString())
      }
      .layoutWeight(1)
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor(AppColors.BG_PAGE)
  }
}
