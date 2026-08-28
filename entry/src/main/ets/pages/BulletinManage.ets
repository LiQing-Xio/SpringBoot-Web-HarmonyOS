import { router } from '@kit.ArkUI';
import { httpGet, httpPost } from '../common/HttpUtil';
import { AppColors, AppSizes } from '../common/Theme';

@Entry
@Component
struct BulletinManage {
  @State bulletins: Record<string, Object>[] = [];
  @State searchKey: string = '';
  @State currentPage: number = 1;
  @State totalCount: number = 0;
  @State showAddForm: boolean = false;
  @State newContent: string = '';
  @State newType: string = '';
  @State newAccount: string = '';

  aboutToAppear() {
    this.loadBulletins();
  }

  async loadBulletins() {
    try {
      let params: Record<string, string> = {
        'current': this.currentPage.toString(),
        'limit': '20'
      };
      if (this.searchKey) {
        params['content'] = this.searchKey;
      }
      let resp = await httpGet('/bul/bulletin/list', params);
      let result = JSON.parse(resp) as Record<string, Object>;
      let data = result['data'] as Record<string, Object>;
      if (data) {
        this.bulletins = (data['list'] as Record<string, Object>[]) || [];
        this.totalCount = (data['totalCount'] as number) || 0;
      }
    } catch (e) { }
  }

  async saveBulletin() {
    if (!this.newContent) {
      AlertDialog.show({ message: '请输入公告内容' });
      return;
    }
    try {
      let body: Record<string, Object> = {
        'content': this.newContent as Object,
        'type': this.newType as Object,
        'account': this.newAccount as Object
      };
      await httpPost('/bul/bulletin/save', body);
      this.showAddForm = false;
      this.newContent = '';
      this.newType = '';
      this.newAccount = '';
      this.loadBulletins();
    } catch (e) {
      AlertDialog.show({ message: '保存失败' });
    }
  }

  async deleteBulletin(id: number) {
    try {
      await httpGet('/bul/bulletin/deleteBul', { 'id': id.toString() });
      this.loadBulletins();
    } catch (e) { }
  }

  build() {
    Column() {
      // Top bar
      Row() {
        Image($r('app.media.ic_back')).width(22).height(22).fillColor(AppColors.PRIMARY_DARK)
          .onClick(() => { router.back(); })
        Row() {
          Image($r('app.media.ic_bulletin')).width(20).height(20).fillColor(AppColors.PRIMARY).margin({ right: 6 })
          Text('公告管理').fontSize(18).fontWeight(FontWeight.Bold).fontColor(AppColors.TEXT_PRIMARY)
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
          Text('发布公告')
            .fontSize(15)
            .fontWeight(FontWeight.Bold)
            .fontColor(AppColors.PRIMARY)
            .width('100%')
            .margin({ bottom: 10 })

          TextArea({ placeholder: '公告内容' })
            .height(80)
            .backgroundColor('#F5F7FA')
            .borderRadius(AppSizes.RADIUS)
            .margin({ bottom: 8 })
            .onChange((v: string) => { this.newContent = v; })

          Row() {
            TextInput({ placeholder: '类型（如：通知）' })
              .height(40).backgroundColor('#F5F7FA').borderRadius(AppSizes.RADIUS).layoutWeight(1)
              .onChange((v: string) => { this.newType = v; })
            TextInput({ placeholder: '发布者' })
              .height(40).backgroundColor('#F5F7FA').borderRadius(AppSizes.RADIUS).layoutWeight(1).margin({ left: 8 })
              .onChange((v: string) => { this.newAccount = v; })
          }
          .width('100%')
          .margin({ bottom: 8 })

          Button('发布')
            .width('100%').height(40).backgroundColor(AppColors.PRIMARY).borderRadius(AppSizes.RADIUS)
            .onClick(() => { this.saveBulletin(); })
        }
        .width('92%')
        .padding(AppSizes.PADDING)
        .backgroundColor(AppColors.BG_CARD)
        .borderRadius(AppSizes.RADIUS_LG)
        .margin({ top: 8, left: '4%', right: '4%' })
      }

      // Search
      Row() {
        TextInput({ placeholder: '搜索公告', text: this.searchKey })
          .height(38).backgroundColor('#F5F7FA').borderRadius(19).layoutWeight(1)
          .onChange((v: string) => { this.searchKey = v; })
        Image($r('app.media.ic_search')).width(20).height(20).fillColor(Color.White)
          .padding(9).backgroundColor(AppColors.PRIMARY).borderRadius(19).margin({ left: 8 })
          .onClick(() => { this.currentPage = 1; this.loadBulletins(); })
      }
      .width('92%')
      .margin({ top: 8, bottom: 8 })

      Text('共 ' + this.totalCount + ' 条公告')
        .fontSize(13)
        .fontColor(AppColors.TEXT_HINT)
        .width('92%')
        .margin({ bottom: 6 })

      // Bulletin list
      List() {
        ForEach(this.bulletins, (item: Record<string, Object>, index: number) => {
          ListItem() {
            Column() {
              Row() {
                Image($r('app.media.ic_bulletin')).width(24).height(24).fillColor(AppColors.WARNING)
                  .margin({ right: 8 })
                Column() {
                  Text((item['content'] as string) || '')
                    .fontSize(14)
                    .fontColor(AppColors.TEXT_PRIMARY)
                    .maxLines(2)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                }
                .layoutWeight(1)
                .alignItems(HorizontalAlign.Start)

                Image($r('app.media.ic_delete')).width(18).height(18).fillColor(AppColors.DANGER)
                  .onClick(() => {
                    let id = item['id'] as number;
                    AlertDialog.show({
                      title: '确认删除',
                      message: '确定删除该公告？',
                      autoCancel: true,
                      confirm: {
                        value: '删除',
                        fontColor: AppColors.DANGER,
                        action: () => { this.deleteBulletin(id); }
                      },
                      cancel: () => { }
                    });
                  })
              }
              .width('100%')

              Row() {
                if (item['type']) {
                  Text((item['type'] as string))
                    .fontSize(11)
                    .fontColor(AppColors.PRIMARY)
                    .backgroundColor(AppColors.PRIMARY_LIGHT)
                    .padding({ left: 6, right: 6, top: 2, bottom: 2 })
                    .borderRadius(4)
                }
                if (item['account']) {
                  Text((item['account'] as string))
                    .fontSize(11)
                    .fontColor(AppColors.TEXT_HINT)
                    .margin({ left: 8 })
                }
                Blank()
                if (item['date']) {
                  Text((item['date'] as string))
                    .fontSize(11)
                    .fontColor(AppColors.TEXT_HINT)
                }
              }
              .width('100%')
              .margin({ top: 8 })
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
