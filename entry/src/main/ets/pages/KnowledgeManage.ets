import { router } from '@kit.ArkUI';
import { httpGet, httpPost } from '../common/HttpUtil';
import { AppColors, AppSizes } from '../common/Theme';

@Entry
@Component
struct KnowledgeManage {
  @State knowledgeList: Record<string, Object>[] = [];
  @State searchKey: string = '';
  @State currentPage: number = 1;
  @State totalCount: number = 0;
  @State showAddForm: boolean = false;
  @State newName: string = '';
  @State newContent: string = '';
  @State newType: string = '';

  aboutToAppear() {
    this.loadKnowledge();
  }

  async loadKnowledge() {
    try {
      let params: Record<string, string> = {
        'current': this.currentPage.toString(),
        'limit': '20'
      };
      if (this.searchKey) {
        params['name'] = this.searchKey;
      }
      let resp = await httpGet('/know/know/list', params);
      let result = JSON.parse(resp) as Record<string, Object>;
      let data = result['data'] as Record<string, Object>;
      if (data) {
        this.knowledgeList = (data['list'] as Record<string, Object>[]) || [];
        this.totalCount = (data['totalCount'] as number) || 0;
      }
    } catch (e) { }
  }

  async saveKnowledge() {
    if (!this.newName || !this.newContent) {
      AlertDialog.show({ message: '请填写标题和内容' });
      return;
    }
    try {
      let body: Record<string, Object> = {
        'name': this.newName as Object,
        'content': this.newContent as Object,
        'type': this.newType as Object
      };
      await httpPost('/know/know/save', body);
      this.showAddForm = false;
      this.newName = '';
      this.newContent = '';
      this.newType = '';
      this.loadKnowledge();
    } catch (e) {
      AlertDialog.show({ message: '保存失败' });
    }
  }

  async deleteKnowledge(id: number) {
    try {
      await httpGet('/know/know/deleteKnow', { 'id': id.toString() });
      this.loadKnowledge();
    } catch (e) { }
  }

  build() {
    Column() {
      // Top bar
      Row() {
        Image($r('app.media.ic_back')).width(22).height(22).fillColor(AppColors.PRIMARY_DARK)
          .onClick(() => { router.back(); })
        Row() {
          Image($r('app.media.ic_knowledge')).width(20).height(20).fillColor(AppColors.PRIMARY).margin({ right: 6 })
          Text('知识管理').fontSize(18).fontWeight(FontWeight.Bold).fontColor(AppColors.TEXT_PRIMARY)
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
          Text('添加知识')
            .fontSize(15)
            .fontWeight(FontWeight.Bold)
            .fontColor(AppColors.PRIMARY)
            .width('100%')
            .margin({ bottom: 10 })

          TextInput({ placeholder: '标题' })
            .height(40).backgroundColor('#F5F7FA').borderRadius(AppSizes.RADIUS).margin({ bottom: 8 })
            .onChange((v: string) => { this.newName = v; })

          TextArea({ placeholder: '内容' })
            .height(100)
            .backgroundColor('#F5F7FA')
            .borderRadius(AppSizes.RADIUS)
            .margin({ bottom: 8 })
            .onChange((v: string) => { this.newContent = v; })

          TextInput({ placeholder: '类型（如：养生、疾病、饮食）' })
            .height(40).backgroundColor('#F5F7FA').borderRadius(AppSizes.RADIUS).margin({ bottom: 8 })
            .onChange((v: string) => { this.newType = v; })

          Button('保存')
            .width('100%').height(40).backgroundColor(AppColors.PRIMARY).borderRadius(AppSizes.RADIUS)
            .onClick(() => { this.saveKnowledge(); })
        }
        .width('92%')
        .padding(AppSizes.PADDING)
        .backgroundColor(AppColors.BG_CARD)
        .borderRadius(AppSizes.RADIUS_LG)
        .margin({ top: 8, left: '4%', right: '4%' })
      }

      // Search
      Row() {
        TextInput({ placeholder: '搜索知识', text: this.searchKey })
          .height(38).backgroundColor('#F5F7FA').borderRadius(19).layoutWeight(1)
          .onChange((v: string) => { this.searchKey = v; })
        Image($r('app.media.ic_search')).width(20).height(20).fillColor(Color.White)
          .padding(9).backgroundColor(AppColors.PRIMARY).borderRadius(19).margin({ left: 8 })
          .onClick(() => { this.currentPage = 1; this.loadKnowledge(); })
      }
      .width('92%')
      .margin({ top: 8, bottom: 8 })

      Text('共 ' + this.totalCount + ' 条知识')
        .fontSize(13)
        .fontColor(AppColors.TEXT_HINT)
        .width('92%')
        .margin({ bottom: 6 })

      // Knowledge list
      List() {
        ForEach(this.knowledgeList, (item: Record<string, Object>, index: number) => {
          ListItem() {
            Column() {
              Row() {
                Image($r('app.media.ic_knowledge')).width(24).height(24).fillColor(AppColors.ACCENT)
                  .margin({ right: 8 })

                Column() {
                  Text((item['name'] as string) || '无标题')
                    .fontSize(15)
                    .fontWeight(FontWeight.Medium)
                    .fontColor(AppColors.TEXT_PRIMARY)
                  Text((item['content'] as string) || '')
                    .fontSize(13)
                    .fontColor(AppColors.TEXT_SECONDARY)
                    .maxLines(2)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                    .margin({ top: 4 })
                    .lineHeight(20)
                }
                .layoutWeight(1)
                .alignItems(HorizontalAlign.Start)

                Image($r('app.media.ic_delete')).width(18).height(18).fillColor(AppColors.DANGER)
                  .onClick(() => {
                    let id = item['id'] as number;
                    let dialogId = id;
                    AlertDialog.show({
                      title: '确认删除',
                      message: '确定删除该知识？',
                      autoCancel: true,
                      confirm: {
                        value: '删除',
                        fontColor: AppColors.DANGER,
                        action: () => { this.deleteKnowledge(dialogId); }
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
                    .fontColor(AppColors.ACCENT_DARK)
                    .backgroundColor(AppColors.ACCENT_LIGHT)
                    .padding({ left: 6, right: 6, top: 2, bottom: 2 })
                    .borderRadius(4)
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
