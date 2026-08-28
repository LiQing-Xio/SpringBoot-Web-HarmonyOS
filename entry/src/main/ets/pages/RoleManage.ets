import { router } from '@kit.ArkUI';
import { httpGet, httpPost } from '../common/HttpUtil';
import { AppColors, AppSizes } from '../common/Theme';

@Entry
@Component
struct RoleManage {
  @State roles: Record<string, Object>[] = [];
  @State searchKey: string = '';
  @State currentPage: number = 1;
  @State totalCount: number = 0;
  @State showAddForm: boolean = false;
  @State newRoleName: string = '';
  @State newRemark: string = '';

  aboutToAppear() {
    this.loadRoles();
  }

  async loadRoles() {
    try {
      let params: Record<string, string> = {
        'current': this.currentPage.toString(),
        'limit': '20'
      };
      if (this.searchKey) {
        params['roleName'] = this.searchKey;
      }
      let resp = await httpGet('/sys/sysRole/list', params);
      let result = JSON.parse(resp) as Record<string, Object>;
      let data = result['data'] as Record<string, Object>;
      if (data) {
        this.roles = (data['list'] as Record<string, Object>[]) || [];
        this.totalCount = (data['totalCount'] as number) || 0;
      }
    } catch (e) { }
  }

  async saveRole() {
    if (!this.newRoleName) {
      AlertDialog.show({ message: '请输入角色名称' });
      return;
    }
    try {
      let body: Record<string, Object> = {
        'roleName': this.newRoleName as Object,
        'remark': this.newRemark as Object
      };
      await httpPost('/sys/sysRole/save', body);
      this.showAddForm = false;
      this.newRoleName = '';
      this.newRemark = '';
      this.loadRoles();
    } catch (e) {
      AlertDialog.show({ message: '保存失败' });
    }
  }

  async deleteRole(roleId: number) {
    try {
      await httpGet('/sys/sysRole/deleteRole', { 'roleId': roleId.toString() });
      this.loadRoles();
    } catch (e) { }
  }

  build() {
    Column() {
      // Top bar
      Row() {
        Image($r('app.media.ic_back')).width(22).height(22).fillColor(AppColors.PRIMARY_DARK)
          .onClick(() => { router.back(); })
        Row() {
          Image($r('app.media.ic_role')).width(20).height(20).fillColor(AppColors.PRIMARY).margin({ right: 6 })
          Text('角色管理').fontSize(18).fontWeight(FontWeight.Bold).fontColor(AppColors.TEXT_PRIMARY)
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
          Text('添加角色')
            .fontSize(15)
            .fontWeight(FontWeight.Bold)
            .fontColor(AppColors.PRIMARY)
            .width('100%')
            .margin({ bottom: 10 })

          TextInput({ placeholder: '角色名称' })
            .height(40).backgroundColor('#F5F7FA').borderRadius(AppSizes.RADIUS).margin({ bottom: 8 })
            .onChange((v: string) => { this.newRoleName = v; })
          TextInput({ placeholder: '备注说明' })
            .height(40).backgroundColor('#F5F7FA').borderRadius(AppSizes.RADIUS).margin({ bottom: 8 })
            .onChange((v: string) => { this.newRemark = v; })

          Button('保存角色')
            .width('100%').height(40).backgroundColor(AppColors.PRIMARY).borderRadius(AppSizes.RADIUS)
            .onClick(() => { this.saveRole(); })
        }
        .width('92%')
        .padding(AppSizes.PADDING)
        .backgroundColor(AppColors.BG_CARD)
        .borderRadius(AppSizes.RADIUS_LG)
        .margin({ top: 8, left: '4%', right: '4%' })
      }

      // Search
      Row() {
        TextInput({ placeholder: '搜索角色', text: this.searchKey })
          .height(38).backgroundColor('#F5F7FA').borderRadius(19).layoutWeight(1)
          .onChange((v: string) => { this.searchKey = v; })
        Image($r('app.media.ic_search')).width(20).height(20).fillColor(Color.White)
          .padding(9).backgroundColor(AppColors.PRIMARY).borderRadius(19).margin({ left: 8 })
          .onClick(() => { this.currentPage = 1; this.loadRoles(); })
      }
      .width('92%')
      .margin({ top: 8, bottom: 8 })

      Text('共 ' + this.totalCount + ' 个角色')
        .fontSize(13)
        .fontColor(AppColors.TEXT_HINT)
        .width('92%')
        .margin({ bottom: 6 })

      // Role list
      List() {
        ForEach(this.roles, (item: Record<string, Object>, index: number) => {
          ListItem() {
            Row() {
              Image($r('app.media.ic_role')).width(36).height(36).fillColor(AppColors.ACCENT)
              .margin({ right: 12 })

              Column() {
                Text((item['roleName'] as string) || '未知角色')
                  .fontSize(15)
                  .fontWeight(FontWeight.Medium)
                  .fontColor(AppColors.TEXT_PRIMARY)
                if (item['remark']) {
                  Text((item['remark'] as string))
                    .fontSize(12)
                    .fontColor(AppColors.TEXT_HINT)
                    .margin({ top: 2 })
                }
                if (item['createTime']) {
                  Text('创建：' + (item['createTime'] as string))
                    .fontSize(11)
                    .fontColor(AppColors.TEXT_HINT)
                    .margin({ top: 2 })
                }
              }
              .layoutWeight(1)
              .alignItems(HorizontalAlign.Start)

              Image($r('app.media.ic_delete')).width(18).height(18).fillColor(AppColors.DANGER)
                .onClick(() => {
                  let roleId = item['roleId'] as number;
                  AlertDialog.show({
                    title: '确认删除',
                    message: '确定删除该角色？',
                    autoCancel: true,
                    confirm: {
                      value: '删除',
                      fontColor: AppColors.DANGER,
                      action: () => { this.deleteRole(roleId); }
                    },
                    cancel: () => { }
                  });
                })
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
