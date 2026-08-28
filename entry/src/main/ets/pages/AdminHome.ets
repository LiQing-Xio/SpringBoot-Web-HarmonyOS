import { router } from '@kit.ArkUI';
import { httpGet, httpPost, getUsername, setToken, setUsername } from '../common/HttpUtil';
import { AppColors, AppSizes } from '../common/Theme';
import { geoLocationManager } from '@kit.LocationKit';
import { BusinessError } from '@kit.BasicServicesKit'
import Theaddress from './Theaddress';

interface MenuItem {
  label: string;
  icon: Resource;
  page: string;
  roles: string[];
}

@Entry
@Component
struct AdminHome {
  @State currentPage: string = 'FirstPage';
  @State showDrawer: boolean = false;
  @State userRole: string = ''; // 存储当前用户的角色名
  //
  @State ghList: Record<string, Object>[] = [];
  /*@State menuItems: MenuItem[] = [
    { label: '首页', icon: $r('app.media.ic_home'), page: 'FirstPage',roles: ['超级管理员', '家庭医生11', '患者']},
    { label: '患者管理', icon: $r('app.media.ic_patient'), page: 'Patient' },
    { label: '患者档案', icon: $r('app.media.ic_file'), page: 'PatientFiles' },
    { label: '挂号诊断', icon: $r('app.media.ic_diagnosis'), page: 'Registration' },
    { label: '药品管理', icon: $r('app.media.ic_drug'), page: 'Pharmaceutical' },
    { label: '药品知识库', icon: $r('app.media.ic_knowledge'), page: 'DrugKnowledge' },
    { label: '药品知识管理', icon: $r('app.media.ic_edit'), page: 'DrugKnowledgeList' },
    { label: '用户管理', icon: $r('app.media.ic_user'), page: 'SysUser' },
    { label: '角色管理', icon: $r('app.media.ic_role'), page: 'SysRole' },
    { label: '菜单管理', icon: $r('app.media.ic_menu'), page: 'SysMenu' },
    { label: '系统日志', icon: $r('app.media.ic_log'), page: 'SysLog' },
    { label: '公告管理', icon: $r('app.media.ic_bulletin'), page: 'BulletinList' },
    { label: '健康知识管理', icon: $r('app.media.ic_health'), page: 'HealthKnowledge' },
    { label: '个人信息', icon: $r('app.media.ic_info'), page: 'AdminInfo' },
  ];*/
  // 改造菜单：给每个菜单配置可访问的角色
  @State allMenuItems: MenuItem[] = [
    { label: '首页', icon: $r('app.media.ic_home'), page: 'FirstPage', roles: ['超级管理员', '家庭医生', '志愿者'] },
    { label: '患者管理', icon: $r('app.media.ic_patient'), page: 'Patient', roles: ['超级管理员'] },
    { label: '患者档案', icon: $r('app.media.ic_file'), page: 'PatientFiles', roles: ['超级管理员', '家庭医生'] },
    { label: '诊断回复', icon: $r('app.media.ic_diagnosis'), page: 'Registration', roles: ['超级管理员', '家庭医生','志愿者'] },
    { label: '药品管理', icon: $r('app.media.ic_drug'), page: 'Pharmaceutical', roles: [''] },
    { label: '药品知识库', icon: $r('app.media.ic_knowledge'), page: 'DrugKnowledge', roles: ['超级管理员', '家庭医生', '志愿者'] },
    { label: '药品知识管理', icon: $r('app.media.ic_edit'), page: 'DrugKnowledgeList', roles: ['超级管理员'] },
    { label: '用户管理', icon: $r('app.media.ic_user'), page: 'SysUser', roles: ['超级管理员'] },
    { label: '角色管理', icon: $r('app.media.ic_role'), page: 'SysRole', roles: ['超级管理员'] },
    { label: '菜单管理', icon: $r('app.media.ic_menu'), page: 'SysMenu', roles: ['超级管理员'] },
    { label: '系统日志', icon: $r('app.media.ic_log'), page: 'SysLog', roles: ['超级管理员'] },
    { label: '公告管理', icon: $r('app.media.ic_bulletin'), page: 'BulletinList', roles: ['超级管理员'] },
    { label: '公告', icon: $r('app.media.ic_bulletin'), page: 'BulletinList', roles: ['志愿者', '家庭医生'] },
    { label: '健康知识管理', icon: $r('app.media.ic_health'), page: 'HealthKnowledge', roles: ['超级管理员', '家庭医生'] },
    { label: '个人信息', icon: $r('app.media.ic_info'), page: 'AdminInfo', roles: ['超级管理员', '家庭医生', '志愿者'] },
  ];
  // 组件加载时获取当前用户角色
  async aboutToAppear() {
    //console.log(getAddress())
    const username = getUsername();
    if (username) {
      try {
        let resp = await httpGet('/sys/sysUser/getrole', { 'username': username });
        let result = JSON.parse(resp) as Record<string, Object>;
        this.userRole = (result['data'] as string) || '';
      } catch (e) {
        console.error('获取角色失败', e);
        this.userRole = '志愿者';
      }
    }
    //关于新消息提醒
    try {
      let resp = await httpGet('/pat/patient/ghlist');
      let result = JSON.parse(resp) as Record<string, Object>;
      let data = result['data'] as Record<string, Object>[];
      if (data) { this.ghList = data; }
      // ========== 新增代码开始 ==========
      // 筛选未回复的咨询请求（hf字段为空或不存在）
      const unRepliedCount = this.ghList.filter(item => !item['hf'] || item['hf'] === '').length;
      // 如果有未回复的，弹出提示弹窗
      if (unRepliedCount > 0 && this.userRole!='志愿者') {
        AlertDialog.show({
          message: '提示：您有 '+ unRepliedCount + ' 条待处理的咨询请求',
          confirm: {
            value: '确定',
            action: () => {}
          },
          autoCancel: true
        });
      }
      // ========== 新增代码结束 ==========
    } catch (e) { }
  }
  // 过滤菜单：只返回当前角色有权限的菜单
  getFilteredMenus(): MenuItem[] {
    if (!this.userRole) return [];
    return this.allMenuItems.filter(item => item.roles.includes(this.userRole));
  }

  build() {
    Stack() {
      Column() {
        // Top bar
        Row() {
          Image($r('app.media.ic_menu'))
            .width(24).height(24)
            .fillColor(Color.White)
            .onClick(() => { this.showDrawer = !this.showDrawer; })

          Text('悦享家庭医生 管理后台')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
            .margin({ left: 12 })
            .layoutWeight(1)

          Image($r('app.media.ic_logout'))
            .width(22).height(22)
            .fillColor(Color.White)
            .onClick(() => {
              setToken('');
              setUsername('');
              router.replaceUrl({ url: 'pages/Login' });
            })
        }
        .width('100%')
        .height(56)
        .padding({ left: 16, right: 16 })
        .linearGradient({
          angle: 135,
          colors: [[AppColors.PRIMARY_DARK, 0.0], [AppColors.PRIMARY, 1.0]]
        })

        // Content area
        Column() {
          if (this.currentPage === 'FirstPage') {
            AdminDashboard()
          } else if (this.currentPage === 'Patient') {
            PatientManagePage()
          } else if (this.currentPage === 'PatientFiles') {
            PatientFilesPage()
          } else if (this.currentPage === 'Registration') {
            RegistrationManagePage()
          } else if (this.currentPage === 'Pharmaceutical') {
            PharmaceuticalPage()
          } else if (this.currentPage === 'DrugKnowledge') {
            DrugKnowledgeViewPage()
          } else if (this.currentPage === 'DrugKnowledgeList') {
            DrugKnowledgeManagePage()
          } else if (this.currentPage === 'SysUser') {
            SysUserManagePage()
          } else if (this.currentPage === 'SysRole') {
            SysRoleManagePage()
          } else if (this.currentPage === 'SysMenu') {
            SysMenuManagePage()
          } else if (this.currentPage === 'SysLog') {
            SysLogPage()
          } else if (this.currentPage === 'BulletinList') {
            BulletinListPage()
          } else if (this.currentPage === 'HealthKnowledge') {
            HealthKnowledgeManagePage()
          } else if (this.currentPage === 'AdminInfo') {
            AdminInfoPage()
          }
        }
        .layoutWeight(1)
        .width('100%')
      }
      .width('100%')
      .height('100%')

      // Drawer overlay
      if (this.showDrawer) {
        Row() {
          // Sidebar
          Column() {
            // Sidebar header
            Column() {
              Image($r('app.media.ic_hospital'))
                .width(40).height(40)
                .fillColor(Color.White)
              Text('家庭医生')
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
                .fontColor(Color.White)
                .margin({ top: 8 })
              Text(getUsername())
                .fontSize(13)
                .fontColor('#FFFFFFCC')
                .margin({ top: 4 })
            }
            .width('100%')
            .padding({ top: 40, bottom: 20 })
            .alignItems(HorizontalAlign.Center)
            .linearGradient({
              angle: 180,
              colors: [['#263238', 0.0], ['#37474F', 1.0]]
            })

            // Menu items
            List() {
              ForEach(this.getFilteredMenus(), (item: MenuItem, index: number) => {
                ListItem() {
                  Row() {
                    Image(item.icon)
                      .width(20).height(20)
                      .fillColor(this.currentPage === item.page ? AppColors.PRIMARY : '#CCCCCC')
                      .margin({ right: 14 })
                    Text(item.label)
                      .fontSize(14)
                      .fontColor(this.currentPage === item.page ? AppColors.PRIMARY : '#EEEEEE')
                      .fontWeight(this.currentPage === item.page ? FontWeight.Bold : FontWeight.Normal)
                  }
                  .width('100%')
                  .height(48)
                  .padding({ left: 20, right: 16 })
                  .backgroundColor(this.currentPage === item.page ? '#1A1E88E5' : Color.Transparent)
                  .onClick(() => {
                    this.currentPage = item.page;
                    this.showDrawer = false;
                  })
                }
              }, (item: MenuItem, index: number) => index.toString())
            }
            .layoutWeight(1)
            .width('100%')
            .backgroundColor('#324157')
          }
          .width('70%')
          .height('100%')

          // Overlay tap to close
          Column()
            .layoutWeight(1)
            .height('100%')
            .backgroundColor('#00000066')
            .onClick(() => { this.showDrawer = false; })
        }
        .width('100%')
        .height('100%')
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(AppColors.BG_PAGE)
  }
}

// ======================== Admin Dashboard (FirstPage) ========================
@Component
struct AdminDashboard {
  @State username: string = getUsername();
  @State roleName: string = '';
  @State bulletins: Record<string, Object>[] = [];
  @State chartData: Record<string, Object>[] = [];
  @State today: string = '';

  aboutToAppear() {
    let now = new Date();
    this.today = now.getFullYear() + '-' + (now.getMonth() + 1) + '-' + now.getDate();
    this.loadRole();
    this.loadBulletins();
    this.loadChartData();
    try {
      let locationEnabled = geoLocationManager.isLocationEnabled();
    } catch (err) {
      console.error("1"+"errCode:" + err.code + ", message:"  + err.message);
    }
    let request: geoLocationManager.SingleLocationRequest = {
      'locatingPriority': geoLocationManager.LocatingPriority.PRIORITY_LOCATING_SPEED,
      'locatingTimeoutMs': 10000
    }
    try {
      geoLocationManager.getCurrentLocation(request).then((result) => { // 调用getCurrentLocation获取当前设备位置，通过promise接收上报的位置
        console.log('位置信息'+'current location: ' + JSON.stringify(result));
      })
        .catch((error:BusinessError) => { // 接收上报的错误码
          console.error('位置错误'+'promise, getCurrentLocation: error=' + JSON.stringify(error));
        });
    } catch (err) {
      console.error('位置错误'+"errCode:" + JSON.stringify(err));
    }

  }



  async loadRole() {
    try {
      console.log('【加载角色】请求参数：', this.username);

      let resp = await httpGet('/sys/sysUser/getrole', { 'username': this.username });
      console.log('【加载角色】接口原始返回：', resp);

      let result = JSON.parse(resp) as Record<string, Object>;
      console.log('【加载角色】解析后的数据：', result);
      this.roleName = (result['data'] as string) || '';
      console.log('【加载角色】最终赋值的roleName：', this.roleName);
    } catch (e) { }
  }

  async loadBulletins() {
    try {
      let resp = await httpGet('/bul/bulletin/getGg');
      let result = JSON.parse(resp) as Record<string, Object>;
      let data = result['data'] as Record<string, Object>[];
      if (data) { this.bulletins = data; }
    } catch (e) { }
  }

  async loadChartData() {
    try {
      let resp = await httpGet('/ech/dataChart/list');
      let result = JSON.parse(resp) as Record<string, Object>;
      let data = result['data'] as Record<string, Object>[];
      if (data) { this.chartData = data; }
    } catch (e) { }
  }

  build() {
    Scroll() {
      Column() {
        // Welcome card
        Row() {
          Column() {
            Text('欢迎回来, ' + this.username)
              .fontSize(18).fontWeight(FontWeight.Bold).fontColor(AppColors.TEXT_PRIMARY)
            Text((this.roleName ? '角色: ' + this.roleName + ' | ' : '') + this.today)
              .fontSize(13).fontColor(AppColors.TEXT_SECONDARY).margin({ top: 4 })
          }
          .alignItems(HorizontalAlign.Start).layoutWeight(1)
          Image($r('app.media.ic_user'))
            .width(40).height(40).fillColor(AppColors.PRIMARY)
        }
        .width('92%').padding(16).backgroundColor(AppColors.BG_CARD)
        .borderRadius(AppSizes.RADIUS_LG)
        .shadow({ radius: 8, color: '#0A000000', offsetX: 0, offsetY: 2 })
        .margin({ top: 12 })

        // Stats row
        Row() {
          Column() {
            Image($r('app.media.ic_calendar')).width(24).height(24).fillColor(AppColors.PRIMARY)
            Text(this.today).fontSize(11).fontColor(AppColors.TEXT_SECONDARY).margin({ top: 4 })
          }.layoutWeight(1).alignItems(HorizontalAlign.Center)
          Column() {
            Image($r('app.media.ic_bulletin')).width(24).height(24).fillColor(AppColors.WARNING)
            Text(this.bulletins.length + '条公告').fontSize(11).fontColor(AppColors.TEXT_SECONDARY).margin({ top: 4 })
          }.layoutWeight(1).alignItems(HorizontalAlign.Center)
          Column() {
            Image($r('app.media.ic_chart')).width(24).height(24).fillColor(AppColors.SUCCESS)
            Text(this.chartData.length + '条数据').fontSize(11).fontColor(AppColors.TEXT_SECONDARY).margin({ top: 4 })
          }.layoutWeight(1).alignItems(HorizontalAlign.Center)
        }
        .width('92%').padding(AppSizes.PADDING).backgroundColor(AppColors.BG_CARD)
        .borderRadius(AppSizes.RADIUS_LG)
        .shadow({ radius: 8, color: '#0A000000', offsetX: 0, offsetY: 2 })
        .margin({ top: 12 })

        // Bulletins section
        Column() {
          Row() {
            Image($r('app.media.ic_bulletin')).width(20).height(20).fillColor(AppColors.PRIMARY)
            Text(' 系统公告').fontSize(16).fontWeight(FontWeight.Bold).fontColor(AppColors.TEXT_PRIMARY)
          }.width('100%').margin({ bottom: 10 })
          if (this.bulletins.length > 0) {
            ForEach(this.bulletins.slice(0, 8), (item: Record<string, Object>, index: number) => {
              Row() {
                Text((item['content'] as string) || '').fontSize(13).fontColor(AppColors.TEXT_SECONDARY)
                  .maxLines(1).textOverflow({ overflow: TextOverflow.Ellipsis }).layoutWeight(1)
                Text((item['type'] as string) || '').fontSize(11).fontColor(AppColors.PRIMARY)
                  .backgroundColor(AppColors.PRIMARY_LIGHT)
                  .padding({ left: 6, right: 6, top: 2, bottom: 2 }).borderRadius(4)
              }.width('100%').padding({ top: 8, bottom: 8 })
              .borderWidth({ bottom: 0.5 }).borderColor(AppColors.DIVIDER)
            }, (item: Record<string, Object>, index: number) => 'bul_' + index + '_' + String(item['id'] || ''))
          } else {
            Text('暂无公告').fontSize(14).fontColor(AppColors.TEXT_HINT).padding(20)
          }
        }
        .width('92%').padding(AppSizes.PADDING).backgroundColor(AppColors.BG_CARD)
        .borderRadius(AppSizes.RADIUS_LG)
        .shadow({ radius: 8, color: '#0A000000', offsetX: 0, offsetY: 2 }).margin({ top: 12 })

        // Chart data
        Column() {
          Row() {
            Image($r('app.media.ic_chart')).width(20).height(20).fillColor(AppColors.PRIMARY)
            Text(' 服务对象统计').fontSize(16).fontWeight(FontWeight.Bold).fontColor(AppColors.TEXT_PRIMARY)
          }.width('100%').margin({ bottom: 10 })
          if (this.chartData.length > 0) {
            ForEach(this.chartData, (item: Record<string, Object>, index: number) => {
              Row() {
                Text((item['age'] as string) || '').fontSize(14).fontColor(AppColors.TEXT_PRIMARY).width(80)
                Row() {
                  Row().height(16).width(Math.min(Number(item['value'] || 0) * 2, 200))
                    .backgroundColor(AppColors.PRIMARY).borderRadius(8)
                }.layoutWeight(1).margin({ left: 8 })
                Text(String(item['value'] || 0)).fontSize(13).fontColor(AppColors.TEXT_SECONDARY)
                  .width(50).textAlign(TextAlign.End)
              }.width('100%').padding({ top: 6, bottom: 6 })
            }, (item: Record<string, Object>, index: number) => 'chart_' + index + '_' + String(item['age'] || ''))
          } else {
            Text('暂无数据').fontSize(14).fontColor(AppColors.TEXT_HINT).padding(20)
          }
        }
        .width('92%').padding(AppSizes.PADDING).backgroundColor(AppColors.BG_CARD)
        .borderRadius(AppSizes.RADIUS_LG)
        .shadow({ radius: 8, color: '#0A000000', offsetX: 0, offsetY: 2 })
        .margin({ top: 12, bottom: 20 })
      }.width('100%')
    }.width('100%').height('100%').scrollBar(BarState.Off)
  }
}

// ======================== Patient Management (Patient.vue) ========================
@Component
struct PatientManagePage {
  @State patients: Record<string, Object>[] = [];
  @State searchKey: string = '';
  @State pageIndex: number = 1;
  @State pageSize: number = 10;
  @State totalCount: number = 0;
  @State showForm: boolean = false;
  @State formData: Record<string, Object> = {};

  aboutToAppear() { this.loadData(); }

  async loadData() {
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
  }

  async deleteItem(id: number) {
    try {
      await httpGet('/pat/patient/deletePat', { 'id': id.toString() });
      await this.loadData();
    } catch (e) { }
  }

  async saveItem() {
    try {
      await httpPost('/pat/patient/save', this.formData);
      this.showForm = false;
      this.formData = {};
      await this.loadData();
    } catch (e) { }
  }

  async editItem(id: number) {
    try {
      let resp = await httpGet('/pat/patient/queryPatById', { 'id': id.toString() });
      let result = JSON.parse(resp) as Record<string, Object>;
      let d = result['data'] as Record<string, Object>;
      if (d) { this.formData = d; this.showForm = true; }
    } catch (e) { }
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.ic_patient')).width(22).height(22).fillColor(AppColors.PRIMARY)
        Text(' 患者管理').fontSize(18).fontWeight(FontWeight.Bold).fontColor(AppColors.TEXT_PRIMARY).layoutWeight(1)
        Button('新增').fontSize(12).height(30).backgroundColor(AppColors.PRIMARY).borderRadius(15)
          .onClick(() => { this.formData = {}; this.showForm = true; })
      }.width('92%').padding({ top: 12, bottom: 8 })

      // Search
      /*Row() {
        TextInput({ placeholder: '患者姓名', text: this.searchKey }).height(36).backgroundColor('#F5F7FA')
          .borderRadius(18).layoutWeight(1).onChange((v: string) => { this.searchKey = v; })
        Image($r('app.media.ic_search')).width(20).height(20).fillColor(Color.White)
          .margin({ left: 8 }).padding(8).backgroundColor(AppColors.PRIMARY).borderRadius(18)
          .onClick(() => { this.pageIndex = 1; this.loadData(); })
      }.width('92%').margin({ bottom: 8 })*/

      // Add/Edit form
      if (this.showForm) {
        Scroll() {
          Column() {
            Text(this.formData['id'] ? '编辑患者' : '新增患者').fontSize(15).fontWeight(FontWeight.Bold).fontColor(AppColors.TEXT_PRIMARY).width('100%').margin({ bottom: 8 })
            TextInput({ placeholder: '患者姓名', text: (this.formData['username'] as string) || '' }).height(40).backgroundColor('#F5F7FA').borderRadius(8).margin({ bottom: 6 }).onChange((v: string) => { this.formData['username'] = v; })
            TextInput({ placeholder: '联系电话', text: (this.formData['phone'] as string) || '' }).height(40).backgroundColor('#F5F7FA').borderRadius(8).margin({ bottom: 6 }).onChange((v: string) => { this.formData['phone'] = v; })
            TextInput({ placeholder: '性别', text: (this.formData['sex'] as string) || '' }).height(40).backgroundColor('#F5F7FA').borderRadius(8).margin({ bottom: 6 }).onChange((v: string) => { this.formData['sex'] = v; })
            TextInput({ placeholder: '年龄', text: String(this.formData['age'] || '') }).height(40).backgroundColor('#F5F7FA').borderRadius(8).margin({ bottom: 6 }).onChange((v: string) => { this.formData['age'] = v; })
            TextInput({ placeholder: '健康标签', text: (this.formData['healthTag'] as string) || '' }).height(40).backgroundColor('#F5F7FA').borderRadius(8).margin({ bottom: 6 }).onChange((v: string) => { this.formData['healthTag'] = v; })
            TextInput({ placeholder: '身份证号', text: (this.formData['idCard'] as string) || '' }).height(40).backgroundColor('#F5F7FA').borderRadius(8).margin({ bottom: 6 }).onChange((v: string) => { this.formData['idCard'] = v; })
            TextInput({ placeholder: '地址', text: (this.formData['address'] as string) || '' }).height(40).backgroundColor('#F5F7FA').borderRadius(8).margin({ bottom: 6 }).onChange((v: string) => { this.formData['address'] = v; })
            TextInput({ placeholder: '血型', text: (this.formData['bioodType'] as string) || '' }).height(40).backgroundColor('#F5F7FA').borderRadius(8).margin({ bottom: 6 }).onChange((v: string) => { this.formData['bioodType'] = v; })
            TextInput({ placeholder: '家族遗传史', text: (this.formData['genetic'] as string) || '' }).height(40).backgroundColor('#F5F7FA').borderRadius(8).margin({ bottom: 6 }).onChange((v: string) => { this.formData['genetic'] = v; })
            TextInput({ placeholder: '过敏源', text: (this.formData['allergy'] as string) || '' }).height(40).backgroundColor('#F5F7FA').borderRadius(8).margin({ bottom: 6 }).onChange((v: string) => { this.formData['allergy'] = v; })
            Row() {
              Button('取消').layoutWeight(1).height(40).backgroundColor('#999999').borderRadius(8).margin({ right: 8 }).onClick(() => { this.showForm = false; })
              Button('确定').layoutWeight(1).height(40).backgroundColor(AppColors.PRIMARY).borderRadius(8).onClick(() => { this.saveItem(); })
            }.width('100%')
          }.width('92%').padding(12).backgroundColor(AppColors.BG_CARD).borderRadius(8).margin({ bottom: 8 })
        }.layoutWeight(1)
      }

      // List
      if (!this.showForm) {
        List({ space: 0 }) {
          ForEach(this.patients, (item: Record<string, Object>, index: number) => {
            ListItem() {
              Row() {
                Image($r('app.media.ic_user')).width(36).height(36).fillColor(AppColors.PRIMARY).margin({ right: 10 })
                Column() {
                  Text((item['username'] as string) || '').fontSize(14).fontWeight(FontWeight.Medium).fontColor(AppColors.TEXT_PRIMARY)
                  Text((item['sex'] as string || '') + ' | ' + String(item['age'] || '') + '岁 | ' + String(item['phone'] || ''))
                    .fontSize(11).fontColor(AppColors.TEXT_HINT).margin({ top: 2 })
                  if (item['healthTag']) {
                    Text((item['healthTag'] as string)).fontSize(10).fontColor(AppColors.PRIMARY).backgroundColor(AppColors.PRIMARY_LIGHT)
                      .padding({ left: 6, right: 6, top: 1, bottom: 1 }).borderRadius(4).margin({ top: 3 })
                  }
                }.layoutWeight(1).alignItems(HorizontalAlign.Start)
                Image($r('app.media.ic_edit')).width(18).height(18).fillColor(AppColors.PRIMARY).margin({ right: 12 })
                  .onClick(() => { this.editItem(item['id'] as number); })
                Image($r('app.media.ic_delete')).width(18).height(18).fillColor(AppColors.DANGER)
                  .onClick(() => {
                    AlertDialog.show({ title: '确认删除', message: '确定删除该患者？',
                      autoCancel: true,
                      confirm: { value: '删除', fontColor: AppColors.DANGER, action: () => { this.deleteItem(item['id'] as number); } },
                      cancel: () => { }
                    });
                  })
              }.width('92%').padding(10).backgroundColor(AppColors.BG_CARD).borderRadius(8)
              .shadow({ radius: 4, color: '#08000000', offsetX: 0, offsetY: 1 }).margin({ left: '4%', right: '4%', bottom: 6 })
            }
          }, (item: Record<string, Object>, index: number) => String(item['id'] || '') + '_' + index)
        }.layoutWeight(1).width('100%')
        Row() {
          Button('上一页').fontSize(12).height(30).backgroundColor(this.pageIndex > 1 ? AppColors.PRIMARY : '#CCCCCC').borderRadius(15)
            .onClick(() => { if (this.pageIndex > 1) { this.pageIndex--; this.loadData(); } })
          Text('第' + this.pageIndex + '页 / 共' + this.totalCount + '条').fontSize(12).fontColor(AppColors.TEXT_SECONDARY).margin({ left: 12, right: 12 })
          Button('下一页').fontSize(12).height(30).backgroundColor(AppColors.PRIMARY).borderRadius(15)
            .onClick(() => { this.pageIndex++; this.loadData(); })
        }.width('92%').justifyContent(FlexAlign.Center).padding({ top: 8, bottom: 8 })
      }
    }.width('100%').height('100%')
  }
}

// ======================== Patient Files (PatientFiles.vue) ========================
@Component
struct PatientFilesPage {
  @State patients: Record<string, Object>[] = [];
  @State searchKey: string = '';
  @State pageIndex: number = 1;
  @State pageSize: number = 10;
  @State totalCount: number = 0;
  @State showDetail: boolean = false;
  @State detailData: Record<string, Object> = {};

  aboutToAppear() { this.loadData(); }

  async loadData() {
    try {
      let params: Record<string, string> = { 'pageIndex': this.pageIndex.toString(), 'pageSize': this.pageSize.toString() };
      if (this.searchKey) { params['userName'] = this.searchKey; }
      let resp = await httpGet('/pat/patient/list', params);
      let result = JSON.parse(resp) as Record<string, Object>;
      let data = result['data'] as Record<string, Object>;
      if (data) { this.patients = (data['list'] as Record<string, Object>[]) || []; this.totalCount = (data['totalCount'] as number) || 0; }
    } catch (e) { }
  }

  async viewDetail(id: number) {
    try {
      let resp = await httpGet('/pat/patient/queryPatById', { 'id': id.toString() });
      let result = JSON.parse(resp) as Record<string, Object>;
      let d = result['data'] as Record<string, Object>;
      if (d) { this.detailData = d; this.showDetail = true; }
    } catch (e) { }
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.ic_file')).width(22).height(22).fillColor(AppColors.PRIMARY)
        Text(' 患者档案').fontSize(18).fontWeight(FontWeight.Bold).fontColor(AppColors.TEXT_PRIMARY).layoutWeight(1)
      }.width('92%').padding({ top: 12, bottom: 8 })
      /*Row() {
        TextInput({ placeholder: '患者姓名', text: this.searchKey }).height(36).backgroundColor('#F5F7FA').borderRadius(18).layoutWeight(1).onChange((v: string) => { this.searchKey = v; })
        Image($r('app.media.ic_search')).width(20).height(20).fillColor(Color.White).margin({ left: 8 }).padding(8).backgroundColor(AppColors.PRIMARY).borderRadius(18)
          .onClick(() => { this.pageIndex = 1; this.loadData(); })
      }.width('92%').margin({ bottom: 8 })*/

      if (this.showDetail) {
        Scroll() {
          Column() {
            Text('患者详情').fontSize(16).fontWeight(FontWeight.Bold).fontColor(AppColors.TEXT_PRIMARY).margin({ bottom: 10 })
            this.DetailRow('姓名', (this.detailData['username'] as string) || '')
            this.DetailRow('电话', '15541727134' || '')
            // this.DetailRow('电话', (this.detailData['phone'] as string) || '')
            this.DetailRow('性别', (this.detailData['sex'] as string) || '')
            this.DetailRow('年龄', String(this.detailData['age'] || ''))
            this.DetailRow('健康标签', (this.detailData['healthTag'] as string) || '')
            this.DetailRow('身份证号', (this.detailData['idCard'] as string) || '')
            this.DetailRow('地址', (this.detailData['address'] as string) || '')
            this.DetailRow('血型', (this.detailData['bioodType'] as string) || '')
            this.DetailRow('家族遗传史', (this.detailData['genetic'] as string) || '')
            this.DetailRow('过敏源', (this.detailData['allergy'] as string) || '')
            Button('返回列表').width('100%').height(40).backgroundColor(AppColors.PRIMARY).borderRadius(8).margin({ top: 12 })
              .onClick(() => { this.showDetail = false; })
          }.width('92%').padding(12).backgroundColor(AppColors.BG_CARD).borderRadius(8).margin({ top: 4 })
        }.layoutWeight(1)
      } else {
        List({ space: 0 }) {
          ForEach(this.patients, (item: Record<string, Object>, index: number) => {
            ListItem() {
              Row() {
                Image($r('app.media.ic_user')).width(32).height(32).fillColor(AppColors.PRIMARY).margin({ right: 10 })
                Column() {
                  Text((item['username'] as string) || '').fontSize(14).fontWeight(FontWeight.Medium)
                  Text('血型:' + ((item['bioodType'] as string) || '-') + ' | 过敏:' + ((item['allergy'] as string) || '-'))
                    .fontSize(11).fontColor(AppColors.TEXT_HINT).margin({ top: 2 })
                }.layoutWeight(1).alignItems(HorizontalAlign.Start)
                Button('查看').fontSize(11).height(28).backgroundColor(AppColors.PRIMARY).borderRadius(14)
                  .onClick(() => { this.viewDetail(item['id'] as number); })
              }.width('92%').padding(10).backgroundColor(AppColors.BG_CARD).borderRadius(8)
              .shadow({ radius: 4, color: '#08000000', offsetX: 0, offsetY: 1 }).margin({ left: '4%', right: '4%', bottom: 6 })
            }
          }, (item: Record<string, Object>, index: number) => index.toString())
        }.layoutWeight(1).width('100%')
      }
    }.width('100%').height('100%')
  }

  @Builder DetailRow(label: string, value: string) {
    Row() {
      Text(label + '：').fontSize(13).fontColor(AppColors.TEXT_SECONDARY).width(80)
      Text(value || '-').fontSize(13).fontColor(AppColors.TEXT_PRIMARY).layoutWeight(1)
    }.width('100%').padding({ top: 6, bottom: 6 }).borderWidth({ bottom: 0.5 }).borderColor(AppColors.DIVIDER)
  }
}

// ======================== Registration Management (Registration.vue - 挂号诊断) ========================
@Component
struct RegistrationManagePage {
  @State ghList: Record<string, Object>[] = [];
  @State showDetail: boolean = false;
  @State showDiagnosis: boolean = false;
  @State detailData: Record<string, Object> = {};
  @State diagnosisData: Record<string, Object> = {};
  @State replyText: string = '';
  @State userRole: string = '';

  aboutToAppear() {
    this.loadData().then(()=>{
      // ========== 新增代码开始 ==========
      // 筛选未回复的咨询请求（hf字段为空或不存在）
      const unRepliedCount = this.ghList.filter(item => !item['hf'] || item['hf'] === '').length;
      // 如果有未回复的，弹出提示弹窗
      if (unRepliedCount > 0) {
        AlertDialog.show({
          message: '有待处理的咨询请求',
          confirm: {
            value: '确定',
            action: () => {}
          },
          autoCancel: true
        });
      }
      // ========== 新增代码结束 ==========
    });
    this.i_well_get_a_role()
  }

  async i_well_get_a_role(){
    const username = getUsername();
    if (username) {
      try {
        let resp = await httpGet('/sys/sysUser/getrole', { 'username': username });
        let result = JSON.parse(resp) as Record<string, Object>;
        this.userRole = (result['data'] as string) || '';
      } catch (e) {
        console.error('获取角色失败', e);
        this.userRole = '志愿者';
      }
    }
  }

  async loadData() {
    try {
      let resp = await httpGet('/pat/patient/ghlist');
      let result = JSON.parse(resp) as Record<string, Object>;
      let data = result['data'] as Record<string, Object>[];
      if (data) { this.ghList = data; }
    } catch (e) { }
  }

  async viewDetail(id: number) {
    try {
      let resp = await httpGet('/pat/patient/queryPatById', { 'id': id.toString() });
      let result = JSON.parse(resp) as Record<string, Object>;
      let d = result['data'] as Record<string, Object>;
      if (d) { this.detailData = d; this.showDetail = true; }
    } catch (e) { }
  }

  async openDiagnosis(id: number) {
    try {
      let resp = await httpGet('/pat/patient/queryPatById', { 'id': id.toString() });
      let result = JSON.parse(resp) as Record<string, Object>;
      let d = result['data'] as Record<string, Object>;
      if (d) { this.diagnosisData = d; this.replyText = (d['hf'] as string) || ''; this.showDiagnosis = true; }
    } catch (e) { }
  }

  async submitDiagnosis() {
    try {
      let body: Record<string, Object> = { 'id': this.diagnosisData['id'] as number, 'username': this.diagnosisData['username'] as string, 'hf': this.replyText };
      await httpPost('/pat/patient/hfsave', body);
      this.showDiagnosis = false; this.replyText = ''; await this.loadData();
    } catch (e) { }
  }

  @Builder
  InfoRow(label: string, value: string) {
    Column() {
      Row() {
        Text(label)
          .fontSize(13)
          .fontColor(AppColors.TEXT_PRIMARY)
          .textAlign(TextAlign.Start)
          .layoutWeight(1)

        Text(value)
          .fontSize(13)
          .fontColor(AppColors.TEXT_SECONDARY)
          .textAlign(TextAlign.End)
          .layoutWeight(1)
      }
      .width('100%')
      .padding({ top: 8, bottom: 8 })

      // 分隔线（最后一行不显示）
      if (label !== '地址：') {
        Divider()
          .width('100%')
          .color(AppColors.BORDER)
          .strokeWidth(0.5)
      }
    }
    .width('100%')
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.ic_diagnosis')).width(22).height(22).fillColor(AppColors.PRIMARY)
        Text(' 诊断回复').fontSize(18).fontWeight(FontWeight.Bold).fontColor(AppColors.TEXT_PRIMARY).layoutWeight(1)
      }.width('92%').padding({ top: 12, bottom: 8 })

      if (this.showDetail) {
        Scroll() {
          Column() {
            Text('患者详情').fontSize(16).fontWeight(FontWeight.Bold).margin({ bottom: 10 })
            // 姓名
            this.InfoRow('姓名：', this.detailData['username'] as string || '')
            // 电话
            this.InfoRow('电话：', '15541727134' || '')
            // this.InfoRow('电话：', this.detailData['phone'] as string || '')
            // 性别
            this.InfoRow('性别：', this.detailData['sex'] as string || '')
            // 年龄
            this.InfoRow('年龄：', String(this.detailData['age'] || ''))
            // 血型
            this.InfoRow('血型：', this.detailData['bioodType'] as string || '')
            // 过敏源
            this.InfoRow('过敏源：', this.detailData['allergy'] as string || '')
            // 地址
            this.InfoRow('地址：', this.detailData['address'] as string || '')
            /*Text('患者详情').fontSize(16).fontWeight(FontWeight.Bold).margin({ bottom: 10 })
            Text('姓名：' + ((this.detailData['username'] as string) || '')).fontSize(13).margin({ bottom: 4 })
            Text('电话：' + ((this.detailData['phone'] as string) || '')).fontSize(13).margin({ bottom: 4 })
            Text('性别：' + ((this.detailData['sex'] as string) || '')).fontSize(13).margin({ bottom: 4 })
            Text('年龄：' + String(this.detailData['age'] || '')).fontSize(13).margin({ bottom: 4 })
            Text('血型：' + ((this.detailData['bioodType'] as string) || '')).fontSize(13).margin({ bottom: 4 })
            Text('过敏源：' + ((this.detailData['allergy'] as string) || '')).fontSize(13).margin({ bottom: 4 })
            Text('地址：' + ((this.detailData['address'] as string) || '')).fontSize(13).margin({ bottom: 4 })*/
            Button('返回').width('100%').height(40).backgroundColor(AppColors.PRIMARY).borderRadius(8).margin({ top: 12 })
              .onClick(() => { this.showDetail = false; })
          }.width('92%').padding(12).backgroundColor(AppColors.BG_CARD).borderRadius(8)
        }.layoutWeight(1)
      } else if (this.showDiagnosis) {
        Column() {
          Text('回复 - ' + ((this.diagnosisData['username'] as string) || '')).fontSize(16).fontWeight(FontWeight.Bold).margin({ bottom: 10 })
          TextArea({ placeholder: '输入分析回复...', text: this.replyText }).height(120).backgroundColor('#F5F7FA').borderRadius(8).margin({ bottom: 10 })
            .onChange((v: string) => { this.replyText = v; })
          Row() {
            Button('取消').layoutWeight(1).height(40).backgroundColor('#999999').borderRadius(8).margin({ right: 8 }).onClick(() => { this.showDiagnosis = false; })
            Button('确定').layoutWeight(1).height(40).backgroundColor(AppColors.PRIMARY).borderRadius(8).onClick(() => { this.submitDiagnosis(); })
          }.width('100%')
        }.width('92%').padding(12).backgroundColor(AppColors.BG_CARD).borderRadius(8).margin({ top: 8 })
      } else {
        List({ space: 0 }) {
          ForEach(this.ghList, (item: Record<string, Object>, index: number) => {
            ListItem() {
              Row() {
                Image($r('app.media.ic_registration')).width(32).height(32).fillColor(AppColors.ACCENT).margin({ right: 10 })
                Column() {
                  Text((item['username'] as string) || '').fontSize(14).fontWeight(FontWeight.Medium)
                  Text('症状：' + ((item['symptoms'] as string) || '暂无')).fontSize(11).fontColor(AppColors.TEXT_HINT).margin({ top: 2 })
                  if (item['hf']) { Text('回复：' + (item['hf'] as string)).fontSize(11).fontColor(AppColors.SUCCESS).margin({ top: 2 }) }else{
                    Text('待处理').fontSize(11).fontColor('#FF0000').margin({ top: 2 })
                  }
                }.layoutWeight(1).alignItems(HorizontalAlign.Start)
                Button('查看').fontSize(10).height(26).backgroundColor(AppColors.PRIMARY).borderRadius(13).margin({ right: 6 })
                  .onClick(() => { this.viewDetail(item['id'] as number); })
                if(this.userRole != '志愿者'){
                  Button('回复').fontSize(10).height(26).backgroundColor(AppColors.SUCCESS).borderRadius(13)
                    .onClick(() => { this.openDiagnosis(item['id'] as number); })
                }
              }.width('92%').padding(10).backgroundColor(AppColors.BG_CARD).borderRadius(8)
              .shadow({ radius: 4, color: '#08000000', offsetX: 0, offsetY: 1 }).margin({ left: '4%', right: '4%', bottom: 6 })
            }
          }, (item: Record<string, Object>, index: number) => 'gh_' + String(item['id'] || '') + '_' + String(item['rid'] || '') + '_' + index)
        }.layoutWeight(1).width('100%')
      }
    }.width('100%').height('100%')
  }
}

// ======================== Pharmaceutical (Pharmaceutical.vue - 药品管理) ========================
@Component
struct PharmaceuticalPage {
  @State drugs: Record<string, Object>[] = [];
  @State searchKey: string = '';
  @State pageIndex: number = 1;
  @State pageSize: number = 10;
  @State totalCount: number = 0;
  @State showForm: boolean = false;
  @State formData: Record<string, Object> = {};

  aboutToAppear() { this.loadData(); }

  async loadData() {
    try {
      let params: Record<string, string> = { 'pageIndex': this.pageIndex.toString(), 'pageSize': this.pageSize.toString() };
      if (this.searchKey) { params['drugName'] = this.searchKey; }
      let resp = await httpGet('/drug/drug/list', params);
      let result = JSON.parse(resp) as Record<string, Object>;
      let data = result['data'] as Record<string, Object>;
      if (data) { 
        let list = (data['list'] as Record<string, Object>[]) || [];
        this.drugs = [...list];
        this.totalCount = (data['totalCount'] as number) || 0;
      }
    } catch (e) { }
  }

  async deleteItem(id: number) {
    try { await httpGet('/drug/drug/deleteDrug', { 'id': id.toString() }); await this.loadData(); } catch (e) { }
  }

  async saveItem() {
    try { await httpPost('/drug/drug/save', this.formData); this.showForm = false; this.formData = {}; await this.loadData(); } catch (e) { }
  }

  async editItem(id: number) {
    try {
      let resp = await httpGet('/drug/drug/queryPhaById', { 'id': id.toString() });
      let result = JSON.parse(resp) as Record<string, Object>;
      let d = result['data'] as Record<string, Object>;
      if (d) { this.formData = d; this.showForm = true; }
    } catch (e) { }
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.ic_drug')).width(22).height(22).fillColor(AppColors.PRIMARY)
        Text(' 药品管理').fontSize(18).fontWeight(FontWeight.Bold).fontColor(AppColors.TEXT_PRIMARY).layoutWeight(1)
        Button('入库').fontSize(12).height(30).backgroundColor(AppColors.PRIMARY).borderRadius(15)
          .onClick(() => { this.formData = { 'status': 1 as Object }; this.showForm = true; })
      }.width('92%').padding({ top: 12, bottom: 8 })
      Row() {
        TextInput({ placeholder: '药品名称', text: this.searchKey }).height(36).backgroundColor('#F5F7FA').borderRadius(18).layoutWeight(1).onChange((v: string) => { this.searchKey = v; })
        Image($r('app.media.ic_search')).width(20).height(20).fillColor(Color.White).margin({ left: 8 }).padding(8).backgroundColor(AppColors.PRIMARY).borderRadius(18)
          .onClick(() => { this.pageIndex = 1; this.loadData(); })
      }.width('92%').margin({ bottom: 8 })

      if (this.showForm) {
        Scroll() {
          Column() {
            Text(this.formData['id'] ? '更新药品信息' : '入库药品信息').fontSize(15).fontWeight(FontWeight.Bold).margin({ bottom: 8 })
            TextInput({ placeholder: '药品名称', text: (this.formData['drugname'] as string) || '' }).height(40).backgroundColor('#F5F7FA').borderRadius(8).margin({ bottom: 6 }).onChange((v: string) => { this.formData['drugname'] = v; })
            TextInput({ placeholder: '生产厂家', text: (this.formData['manufacturer'] as string) || '' }).height(40).backgroundColor('#F5F7FA').borderRadius(8).margin({ bottom: 6 }).onChange((v: string) => { this.formData['manufacturer'] = v; })
            TextInput({ placeholder: '生产批号', text: (this.formData['batchnumber'] as string) || '' }).height(40).backgroundColor('#F5F7FA').borderRadius(8).margin({ bottom: 6 }).onChange((v: string) => { this.formData['batchnumber'] = v; })
            TextInput({ placeholder: '规格', text: (this.formData['specification'] as string) || '' }).height(40).backgroundColor('#F5F7FA').borderRadius(8).margin({ bottom: 6 }).onChange((v: string) => { this.formData['specification'] = v; })
            TextInput({ placeholder: '采购价格/元', text: String(this.formData['price'] || '') }).height(40).backgroundColor('#F5F7FA').borderRadius(8).margin({ bottom: 6 }).type(InputType.Number).onChange((v: string) => { this.formData['price'] = v; })
            TextInput({ placeholder: '数量', text: String(this.formData['number'] || '') }).height(40).backgroundColor('#F5F7FA').borderRadius(8).margin({ bottom: 6 }).type(InputType.Number).onChange((v: string) => { this.formData['number'] = v; })
            Row() {
              Button('取消').layoutWeight(1).height(40).backgroundColor('#999999').borderRadius(8).margin({ right: 8 }).onClick(() => { this.showForm = false; })
              Button('确定').layoutWeight(1).height(40).backgroundColor(AppColors.PRIMARY).borderRadius(8).onClick(() => { this.saveItem(); })
            }.width('100%')
          }.width('92%').padding(12).backgroundColor(AppColors.BG_CARD).borderRadius(8)
        }.layoutWeight(1)
      } else {
        List({ space: 0 }) {
          ForEach(this.drugs, (item: Record<string, Object>, index: number) => {
            ListItem() {
              Row() {
                Image($r('app.media.ic_drug')).width(32).height(32).fillColor(AppColors.ACCENT).margin({ right: 10 })
                Column() {
                  Text((item['drugname'] as string) || '').fontSize(14).fontWeight(FontWeight.Medium)
                  Text('厂家：' + ((item['manufacturer'] as string) || '')).fontSize(11).fontColor(AppColors.TEXT_HINT).margin({ top: 2 })
                  Text('规格：' + ((item['specification'] as string) || '') + '  价格：' + String(item['price'] || 0) + '  库存：' + String(item['number'] || 0))
                    .fontSize(11).fontColor(AppColors.TEXT_HINT).margin({ top: 2 })
                  Text((item['status'] as number) === 1 ? '日期正常' : '过期').fontSize(10)
                    .fontColor((item['status'] as number) === 1 ? AppColors.SUCCESS : AppColors.DANGER)
                    .margin({ top: 2 })
                }.layoutWeight(1).alignItems(HorizontalAlign.Start)
                Image($r('app.media.ic_edit')).width(18).height(18).fillColor(AppColors.PRIMARY).margin({ right: 10 })
                  .onClick(() => { this.editItem(item['id'] as number); })
                Image($r('app.media.ic_delete')).width(18).height(18).fillColor(AppColors.DANGER)
                  .onClick(() => { AlertDialog.show({ title: '确认删除', message: '确定删除该药品？', autoCancel: true, confirm: { value: '删除', fontColor: AppColors.DANGER, action: () => { this.deleteItem(item['id'] as number); } }, cancel: () => { } }); })
              }.width('92%').padding(10).backgroundColor(AppColors.BG_CARD).borderRadius(8)
              .shadow({ radius: 4, color: '#08000000', offsetX: 0, offsetY: 1 }).margin({ left: '4%', right: '4%', bottom: 6 })
            }
          }, (item: Record<string, Object>, index: number) => 'drug_' + String(item['id'] || '') + '_' + index)
        }.layoutWeight(1).width('100%')
        Row() {
          Button('上一页').fontSize(12).height(30).backgroundColor(this.pageIndex > 1 ? AppColors.PRIMARY : '#CCCCCC').borderRadius(15).onClick(() => { if (this.pageIndex > 1) { this.pageIndex--; this.loadData(); } })
          Text('第' + this.pageIndex + '页').fontSize(12).fontColor(AppColors.TEXT_SECONDARY).margin({ left: 12, right: 12 })
          Button('下一页').fontSize(12).height(30).backgroundColor(AppColors.PRIMARY).borderRadius(15).onClick(() => { this.pageIndex++; this.loadData(); })
        }.width('92%').justifyContent(FlexAlign.Center).padding({ top: 8, bottom: 8 })
      }
    }.width('100%').height('100%')
  }
}

// ======================== Drug Knowledge View (Drugknowledgebase.vue) ========================
@Component
struct DrugKnowledgeViewPage {
  @State dataList: Record<string, Object>[] = [];
  @State pageIndex: number = 1;
  @State pageSize: number = 10;
  @State totalCount: number = 0;
  @State showDetail: boolean = false;
  @State detailData: Record<string, Object> = {};

  aboutToAppear() { this.loadData(); }

  async loadData() {
    try {
      let params: Record<string, string> = { 'pageIndex': this.pageIndex.toString(), 'pageSize': this.pageSize.toString() };
      let resp = await httpGet('/know/know/list', params);
      let result = JSON.parse(resp) as Record<string, Object>;
      let data = result['data'] as Record<string, Object>;
      if (data) { this.dataList = (data['list'] as Record<string, Object>[]) || []; this.totalCount = (data['totalCount'] as number) || 0; }
    } catch (e) { }
  }

  async viewDetail(id: number) {
    try {
      let resp = await httpGet('/know/know/queryPatById', { 'id': id.toString() });
      let result = JSON.parse(resp) as Record<string, Object>;
      let d = result['data'] as Record<string, Object>;
      if (d) { this.detailData = d; this.showDetail = true; }
    } catch (e) { }
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.ic_knowledge')).width(22).height(22).fillColor(AppColors.PRIMARY)
        Text(' 药品知识库').fontSize(18).fontWeight(FontWeight.Bold).fontColor(AppColors.TEXT_PRIMARY).layoutWeight(1)
      }.width('92%').padding({ top: 12, bottom: 8 })

      if (this.showDetail) {
        Scroll() {
          Column() {
            Text((this.detailData['name'] as string) || '').fontSize(16).fontWeight(FontWeight.Bold).margin({ bottom: 8 })
            Text('类型：' + ((this.detailData['type'] as string) || '')).fontSize(13).fontColor(AppColors.TEXT_SECONDARY).margin({ bottom: 8 })
            Text((this.detailData['content'] as string) || '').fontSize(14).fontColor(AppColors.TEXT_PRIMARY)
            Button('返回').width('100%').height(40).backgroundColor(AppColors.PRIMARY).borderRadius(8).margin({ top: 16 })
              .onClick(() => { this.showDetail = false; })
          }.width('92%').padding(12).backgroundColor(AppColors.BG_CARD).borderRadius(8).margin({ top: 4 })
        }.layoutWeight(1)
      } else {
        List({ space: 0 }) {
          ForEach(this.dataList, (item: Record<string, Object>, index: number) => {
            ListItem() {
              Row() {
                Image($r('app.media.ic_knowledge')).width(32).height(32).fillColor(AppColors.ACCENT).margin({ right: 10 })
                Column() {
                  Text((item['name'] as string) || '').fontSize(14).fontWeight(FontWeight.Medium)
                  Text((item['type'] as string) || '').fontSize(11).fontColor(AppColors.TEXT_HINT).margin({ top: 2 })
                }.layoutWeight(1).alignItems(HorizontalAlign.Start)
                Button('查看').fontSize(11).height(28).backgroundColor(AppColors.SUCCESS).borderRadius(14)
                  .onClick(() => { this.viewDetail(item['id'] as number); })
              }.width('92%').padding(10).backgroundColor(AppColors.BG_CARD).borderRadius(8)
              .shadow({ radius: 4, color: '#08000000', offsetX: 0, offsetY: 1 }).margin({ left: '4%', right: '4%', bottom: 6 })
            }
          }, (item: Record<string, Object>, index: number) => 'kv_' + String(item['id'] || '') + '_' + index)
        }.layoutWeight(1).width('100%')
      }
    }.width('100%').height('100%')
  }
}

// ======================== Drug Knowledge Manage (DrugknowledgebaseList.vue) ========================
@Component
struct DrugKnowledgeManagePage {
  @State dataList: Record<string, Object>[] = [];
  @State searchKey: string = '';
  @State pageIndex: number = 1;
  @State pageSize: number = 10;
  @State totalCount: number = 0;
  @State showForm: boolean = false;
  @State formData: Record<string, Object> = {};

  aboutToAppear() { this.loadData(); }

  async loadData() {
    try {
      let params: Record<string, string> = { 'pageIndex': this.pageIndex.toString(), 'pageSize': this.pageSize.toString() };
      if (this.searchKey) { params['name'] = this.searchKey; }
      let resp = await httpGet('/know/know/list', params);
      let result = JSON.parse(resp) as Record<string, Object>;
      let data = result['data'] as Record<string, Object>;
      if (data) { 
        let list = (data['list'] as Record<string, Object>[]) || [];
        this.dataList = [...list];
        this.totalCount = (data['totalCount'] as number) || 0;
      }
    } catch (e) { }
  }

  async deleteItem(id: number) { try { await httpGet('/know/know/deleteKnow', { 'id': id.toString() }); await this.loadData(); } catch (e) { } }

  async saveItem() { try { await httpPost('/know/know/save', this.formData); this.showForm = false; this.formData = {}; await this.loadData(); } catch (e) { } }

  async editItem(id: number) {
    try {
      let resp = await httpGet('/know/know/queryPatById', { 'id': id.toString() });
      let result = JSON.parse(resp) as Record<string, Object>;
      let d = result['data'] as Record<string, Object>;
      if (d) { this.formData = d; this.showForm = true; }
    } catch (e) { }
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.ic_edit')).width(22).height(22).fillColor(AppColors.PRIMARY)
        Text(' 药品知识管理').fontSize(18).fontWeight(FontWeight.Bold).fontColor(AppColors.TEXT_PRIMARY).layoutWeight(1)
        Button('新增').fontSize(12).height(30).backgroundColor(AppColors.PRIMARY).borderRadius(15)
          .onClick(() => { this.formData = {}; this.showForm = true; })
      }.width('92%').padding({ top: 12, bottom: 8 })
      Row() {
        TextInput({ placeholder: '药品名', text: this.searchKey }).height(36).backgroundColor('#F5F7FA').borderRadius(18).layoutWeight(1).onChange((v: string) => { this.searchKey = v; })
        Image($r('app.media.ic_search')).width(20).height(20).fillColor(Color.White).margin({ left: 8 }).padding(8).backgroundColor(AppColors.PRIMARY).borderRadius(18)
          .onClick(() => { this.pageIndex = 1; this.loadData(); })
      }.width('92%').margin({ bottom: 8 })
      if (this.showForm) {
        Column() {
          Text(this.formData['id'] ? '编辑' : '新增').fontSize(15).fontWeight(FontWeight.Bold).margin({ bottom: 8 })
          TextInput({ placeholder: '药品名', text: (this.formData['name'] as string) || '' }).height(40).backgroundColor('#F5F7FA').borderRadius(8).margin({ bottom: 6 }).onChange((v: string) => { this.formData['name'] = v; })
          TextInput({ placeholder: '介绍', text: (this.formData['content'] as string) || '' }).height(40).backgroundColor('#F5F7FA').borderRadius(8).margin({ bottom: 6 }).onChange((v: string) => { this.formData['content'] = v; })
          TextInput({ placeholder: '类型', text: (this.formData['type'] as string) || '' }).height(40).backgroundColor('#F5F7FA').borderRadius(8).margin({ bottom: 6 }).onChange((v: string) => { this.formData['type'] = v; })
          Row() {
            Button('取消').layoutWeight(1).height(40).backgroundColor('#999999').borderRadius(8).margin({ right: 8 }).onClick(() => { this.showForm = false; })
            Button('确定').layoutWeight(1).height(40).backgroundColor(AppColors.PRIMARY).borderRadius(8).onClick(() => { this.saveItem(); })
          }.width('100%')
        }.width('92%').padding(12).backgroundColor(AppColors.BG_CARD).borderRadius(8).margin({ bottom: 8 })
      }
      if (!this.showForm) {
        List({ space: 0 }) {
          ForEach(this.dataList, (item: Record<string, Object>, index: number) => {
            ListItem() {
              Row() {
                Column() {
                  Text((item['name'] as string) || '').fontSize(14).fontWeight(FontWeight.Medium)
                  Text('类型：' + ((item['type'] as string) || '')).fontSize(11).fontColor(AppColors.TEXT_HINT).margin({ top: 2 })
                }.layoutWeight(1).alignItems(HorizontalAlign.Start)
                Image($r('app.media.ic_edit')).width(18).height(18).fillColor(AppColors.PRIMARY).margin({ right: 10 })
                  .onClick(() => { this.editItem(item['id'] as number); })
                Image($r('app.media.ic_delete')).width(18).height(18).fillColor(AppColors.DANGER)
                  .onClick(() => { AlertDialog.show({ title: '确认', message: '确定删除？', autoCancel: true, confirm: { value: '删除', fontColor: AppColors.DANGER, action: () => { this.deleteItem(item['id'] as number); } }, cancel: () => { } }); })
              }.width('92%').padding(10).backgroundColor(AppColors.BG_CARD).borderRadius(8)
              .shadow({ radius: 4, color: '#08000000', offsetX: 0, offsetY: 1 }).margin({ left: '4%', right: '4%', bottom: 6 })
            }
          }, (item: Record<string, Object>, index: number) => 'km_' + String(item['id'] || '') + '_' + index)
        }.layoutWeight(1).width('100%')
        Row() {
          Button('上一页').fontSize(12).height(30).backgroundColor(this.pageIndex > 1 ? AppColors.PRIMARY : '#CCCCCC').borderRadius(15).onClick(() => { if (this.pageIndex > 1) { this.pageIndex--; this.loadData(); } })
          Text('第' + this.pageIndex + '页').fontSize(12).fontColor(AppColors.TEXT_SECONDARY).margin({ left: 12, right: 12 })
          Button('下一页').fontSize(12).height(30).backgroundColor(AppColors.PRIMARY).borderRadius(15).onClick(() => { this.pageIndex++; this.loadData(); })
        }.width('92%').justifyContent(FlexAlign.Center).padding({ top: 8, bottom: 8 })
      }
    }.width('100%').height('100%')
  }
}

// ======================== SysUser Management (SysUser.vue) ========================
@Component
struct SysUserManagePage {
  @State users: Record<string, Object>[] = [];
  @State searchKey: string = '';
  @State pageIndex: number = 1;
  @State pageSize: number = 10;
  @State totalCount: number = 0;
  @State showForm: boolean = false;
  @State formData: Record<string, Object> = {};
  @State roles: Record<string, Object>[] = [];
  @State roleIds: number[] = [];

  aboutToAppear() { this.loadData(); }

  async loadData() {
    try {
      let params: Record<string, string> = { 'pageIndex': this.pageIndex.toString(), 'pageSize': this.pageSize.toString() };
      if (this.searchKey) { params['userName'] = this.searchKey; }
      let resp = await httpGet('/sys/sysUser/list', params);
      let result = JSON.parse(resp) as Record<string, Object>;
      let data = result['data'] as Record<string, Object>;
      if (data) { this.users = (data['list'] as Record<string, Object>[]) || []; this.totalCount = (data['totalCount'] as number) || 0; }
    } catch (e) { }
  }

  async openAdd() {
    try {
      let resp = await httpGet('/sys/sysRole/listAll');
      let result = JSON.parse(resp) as Record<string, Object>;
      this.roles = (result['data'] as Record<string, Object>[]) || [];
      this.formData = { 'userId': 0 as Object, 'status': 1 as Object }; this.roleIds = []; this.showForm = true;
    } catch (e) { }
  }

  async editItem(userId: number) {
    try {
      let resp = await httpGet('/sys/sysUser/queryUserById', { 'userId': userId.toString() });
      let result = JSON.parse(resp) as Record<string, Object>;
      let data = result['data'] as Record<string, Object>;
      if (data) {
        let user = data['user'] as Record<string, Object>;
        this.roles = (data['roles'] as Record<string, Object>[]) || [];
        this.roleIds = (user['roleIds'] as number[]) || [];
        this.formData = { 'userId': user['userId'] as Object, 'username': user['username'] as Object, 'email': user['email'] as Object, 'mobile': user['mobile'] as Object, 'status': user['status'] as Object };
        this.showForm = true;
      }
    } catch (e) { }
  }

  async saveItem() {
    try {
      let body: Record<string, Object> = {} as Record<string, Object>;
      let keys: string[] = Object.keys(this.formData);
      for (let k of keys) {
        body[k] = this.formData[k];
      }
      body['roleIds'] = this.roleIds as Object;
      await httpPost('/sys/sysUser/save', body);
      this.showForm = false; this.formData = {}; await this.loadData();
    } catch (e) { }
  }

  async toggleStatus(userId: number, currentStatus: number) {
    try {
      let statusBody: Record<string, Object> = {} as Record<string, Object>;
      statusBody['userId'] = userId as Object;
      statusBody['status'] = (currentStatus === 1 ? 0 : 1) as Object;
      await httpPost('/sys/sysUser/save', statusBody);
      await this.loadData();
    } catch (e) { }
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.ic_user')).width(22).height(22).fillColor(AppColors.PRIMARY)
        Text(' 用户管理').fontSize(18).fontWeight(FontWeight.Bold).fontColor(AppColors.TEXT_PRIMARY).layoutWeight(1)
        Button('新增').fontSize(12).height(30).backgroundColor(AppColors.PRIMARY).borderRadius(15).onClick(() => { this.openAdd(); })
      }.width('92%').padding({ top: 12, bottom: 8 })
      Row() {
        TextInput({ placeholder: '用户名', text: this.searchKey }).height(36).backgroundColor('#F5F7FA').borderRadius(18).layoutWeight(1).onChange((v: string) => { this.searchKey = v; })
        Image($r('app.media.ic_search')).width(20).height(20).fillColor(Color.White).margin({ left: 8 }).padding(8).backgroundColor(AppColors.PRIMARY).borderRadius(18)
          .onClick(() => { this.pageIndex = 1; this.loadData(); })
      }.width('92%').margin({ bottom: 8 })

      if (this.showForm) {
        Scroll() {
          Column() {
            Text(((this.formData['userId'] as number) || 0) > 0 ? '编辑用户' : '新增用户').fontSize(15).fontWeight(FontWeight.Bold).margin({ bottom: 8 })
            TextInput({ placeholder: '账号', text: (this.formData['username'] as string) || '' }).height(40).backgroundColor('#F5F7FA').borderRadius(8).margin({ bottom: 6 })
              .enabled(((this.formData['userId'] as number) || 0) === 0)
              .onChange((v: string) => { this.formData['username'] = v; })
            if (((this.formData['userId'] as number) || 0) === 0) {
              TextInput({ placeholder: '密码' }).height(40).backgroundColor('#F5F7FA').borderRadius(8).margin({ bottom: 6 }).type(InputType.Password)
                .onChange((v: string) => { this.formData['password'] = v; })
            }
            TextInput({ placeholder: '邮箱', text: (this.formData['email'] as string) || '' }).height(40).backgroundColor('#F5F7FA').borderRadius(8).margin({ bottom: 6 }).onChange((v: string) => { this.formData['email'] = v; })
            TextInput({ placeholder: '电话', text: (this.formData['mobile'] as string) || '' }).height(40).backgroundColor('#F5F7FA').borderRadius(8).margin({ bottom: 6 }).onChange((v: string) => { this.formData['mobile'] = v; })
            Text('分配角色').fontSize(13).fontColor(AppColors.TEXT_SECONDARY).width('100%').margin({ bottom: 4 })
            Flex({ wrap: FlexWrap.Wrap }) {
              ForEach(this.roles, (role: Record<string, Object>, idx: number) => {
                Text((role['roleName'] as string) || '').fontSize(12)
                  .fontColor(this.roleIds.includes(role['roleId'] as number) ? Color.White : AppColors.TEXT_PRIMARY)
                  .backgroundColor(this.roleIds.includes(role['roleId'] as number) ? AppColors.PRIMARY : '#F5F7FA')
                  .padding({ left: 10, right: 10, top: 5, bottom: 5 }).borderRadius(14).margin(3)
                  .onClick(() => {
                    let rid = role['roleId'] as number;
                    if (this.roleIds.includes(rid)) { this.roleIds = this.roleIds.filter((r: number) => r !== rid); }
                    else { this.roleIds = [...this.roleIds, rid]; }
                  })
              }, (role: Record<string, Object>, idx: number) => idx.toString())
            }.width('100%').margin({ bottom: 8 })
            Row() {
              Button('取消').layoutWeight(1).height(40).backgroundColor('#999999').borderRadius(8).margin({ right: 8 }).onClick(() => { this.showForm = false; })
              Button('确定').layoutWeight(1).height(40).backgroundColor(AppColors.PRIMARY).borderRadius(8).onClick(() => { this.saveItem(); })
            }.width('100%')
          }.width('92%').padding(12).backgroundColor(AppColors.BG_CARD).borderRadius(8)
        }.layoutWeight(1)
      } else {
        List({ space: 0 }) {
          ForEach(this.users, (item: Record<string, Object>, index: number) => {
            ListItem() {
              Row() {
                Image($r('app.media.ic_user')).width(32).height(32).fillColor(AppColors.PRIMARY).margin({ right: 10 })
                Column() {
                  Text((item['username'] as string) || '').fontSize(14).fontWeight(FontWeight.Medium)
                  Text('邮箱:' + ((item['email'] as string) || '') + ' | 电话:' + ((item['mobile'] as string) || '')).fontSize(11).fontColor(AppColors.TEXT_HINT).margin({ top: 2 })
                  Text((item['status'] as number) === 1 ? '正常' : '禁用').fontSize(10)
                    .fontColor((item['status'] as number) === 1 ? AppColors.SUCCESS : AppColors.DANGER).margin({ top: 2 })
                }.layoutWeight(1).alignItems(HorizontalAlign.Start)
                Image($r('app.media.ic_edit')).width(16).height(16).fillColor(AppColors.PRIMARY).margin({ right: 8 })
                  .onClick(() => { this.editItem(item['userId'] as number); })
                Button((item['status'] as number) === 1 ? '禁用' : '激活').fontSize(10).height(24)
                  .backgroundColor((item['status'] as number) === 1 ? AppColors.DANGER : AppColors.SUCCESS).borderRadius(12)
                  .onClick(() => { this.toggleStatus(item['userId'] as number, item['status'] as number); })
              }.width('92%').padding(10).backgroundColor(AppColors.BG_CARD).borderRadius(8)
              .shadow({ radius: 4, color: '#08000000', offsetX: 0, offsetY: 1 }).margin({ left: '4%', right: '4%', bottom: 6 })
            }
          }, (item: Record<string, Object>, index: number) => 'user_' + String(item['userId'] || '') + '_' + index)
        }.layoutWeight(1).width('100%')
        Row() {
          Button('上一页').fontSize(12).height(30).backgroundColor(this.pageIndex > 1 ? AppColors.PRIMARY : '#CCCCCC').borderRadius(15).onClick(() => { if (this.pageIndex > 1) { this.pageIndex--; this.loadData(); } })
          Text('第' + this.pageIndex + '页').fontSize(12).fontColor(AppColors.TEXT_SECONDARY).margin({ left: 12, right: 12 })
          Button('下一页').fontSize(12).height(30).backgroundColor(AppColors.PRIMARY).borderRadius(15).onClick(() => { this.pageIndex++; this.loadData(); })
        }.width('92%').justifyContent(FlexAlign.Center).padding({ top: 8, bottom: 8 })
      }
    }.width('100%').height('100%')
  }
}

// ======================== SysRole Management (SysRole.vue) ========================
@Component
struct SysRoleManagePage {
  @State roles: Record<string, Object>[] = [];
  @State searchKey: string = '';
  @State pageIndex: number = 1;
  @State pageSize: number = 10;
  @State totalCount: number = 0;
  @State showForm: boolean = false;
  @State formData: Record<string, Object> = {};

  aboutToAppear() { this.loadData(); }

  async loadData() {
    try {
      let params: Record<string, string> = { 'pageIndex': this.pageIndex.toString(), 'pageSize': this.pageSize.toString() };
      if (this.searchKey) { params['roleName'] = this.searchKey; }
      let resp = await httpGet('/sys/sysRole/list', params);
      let result = JSON.parse(resp) as Record<string, Object>;
      let data = result['data'] as Record<string, Object>;
      if (data) { this.roles = (data['list'] as Record<string, Object>[]) || []; this.totalCount = (data['totalCount'] as number) || 0; }
    } catch (e) { }
  }

  async deleteItem(roleId: number) { try { await httpGet('/sys/sysRole/deleteRole', { 'roleId': roleId.toString() }); await this.loadData(); } catch (e) { } }

  async saveItem() { try { await httpPost('/sys/sysRole/save', this.formData); this.showForm = false; this.formData = {}; await this.loadData(); } catch (e) { } }

  build() {
    Column() {
      Row() {
        Image($r('app.media.ic_role')).width(22).height(22).fillColor(AppColors.PRIMARY)
        Text(' 角色管理').fontSize(18).fontWeight(FontWeight.Bold).fontColor(AppColors.TEXT_PRIMARY).layoutWeight(1)
        Button('新增').fontSize(12).height(30).backgroundColor(AppColors.PRIMARY).borderRadius(15)
          .onClick(() => { this.formData = { 'roleId': 0 as Object }; this.showForm = true; })
      }.width('92%').padding({ top: 12, bottom: 8 })
      Row() {
        TextInput({ placeholder: '角色名称', text: this.searchKey }).height(36).backgroundColor('#F5F7FA').borderRadius(18).layoutWeight(1).onChange((v: string) => { this.searchKey = v; })
        Image($r('app.media.ic_search')).width(20).height(20).fillColor(Color.White).margin({ left: 8 }).padding(8).backgroundColor(AppColors.PRIMARY).borderRadius(18)
          .onClick(() => { this.pageIndex = 1; this.loadData(); })
      }.width('92%').margin({ bottom: 8 })
      if (this.showForm) {
        Column() {
          Text(((this.formData['roleId'] as number) || 0) > 0 ? '编辑角色' : '新增角色').fontSize(15).fontWeight(FontWeight.Bold).margin({ bottom: 8 })
          TextInput({ placeholder: '角色名称', text: (this.formData['roleName'] as string) || '' }).height(40).backgroundColor('#F5F7FA').borderRadius(8).margin({ bottom: 6 }).onChange((v: string) => { this.formData['roleName'] = v; })
          TextArea({ placeholder: '描述信息', text: (this.formData['remark'] as string) || '' }).height(80).backgroundColor('#F5F7FA').borderRadius(8).margin({ bottom: 6 }).onChange((v: string) => { this.formData['remark'] = v; })
          Row() {
            Button('取消').layoutWeight(1).height(40).backgroundColor('#999999').borderRadius(8).margin({ right: 8 }).onClick(() => { this.showForm = false; })
            Button('确定').layoutWeight(1).height(40).backgroundColor(AppColors.PRIMARY).borderRadius(8).onClick(() => { this.saveItem(); })
          }.width('100%')
        }.width('92%').padding(12).backgroundColor(AppColors.BG_CARD).borderRadius(8).margin({ bottom: 8 })
      }
      if (!this.showForm) {
        List({ space: 0 }) {
          ForEach(this.roles, (item: Record<string, Object>, index: number) => {
            ListItem() {
              Row() {
                Image($r('app.media.ic_role')).width(32).height(32).fillColor(AppColors.ACCENT).margin({ right: 10 })
                Column() {
                  Text((item['roleName'] as string) || '').fontSize(14).fontWeight(FontWeight.Medium)
                  Text((item['remark'] as string) || '').fontSize(11).fontColor(AppColors.TEXT_HINT).margin({ top: 2 })
                }.layoutWeight(1).alignItems(HorizontalAlign.Start)
                Image($r('app.media.ic_edit')).width(16).height(16).fillColor(AppColors.PRIMARY).margin({ right: 10 })
                  .onClick(() => { this.formData = { 'roleId': item['roleId'] as Object, 'roleName': item['roleName'] as Object, 'remark': item['remark'] as Object }; this.showForm = true; })
                Image($r('app.media.ic_delete')).width(16).height(16).fillColor(AppColors.DANGER)
                  .onClick(() => { AlertDialog.show({ title: '确认', message: '确定删除？', autoCancel: true, confirm: { value: '删除', fontColor: AppColors.DANGER, action: () => { this.deleteItem(item['roleId'] as number); } }, cancel: () => { } }); })
              }.width('92%').padding(10).backgroundColor(AppColors.BG_CARD).borderRadius(8)
              .shadow({ radius: 4, color: '#08000000', offsetX: 0, offsetY: 1 }).margin({ left: '4%', right: '4%', bottom: 6 })
            }
          }, (item: Record<string, Object>, index: number) => 'role_' + String(item['roleId'] || '') + '_' + index)
        }.layoutWeight(1).width('100%')
      }
    }.width('100%').height('100%')
  }
}

// ======================== SysMenu Management (sysMap.vue) ========================
@Component
struct SysMenuManagePage {
  @State menuList: Record<string, Object>[] = [];
  @State searchKey: string = '';
  @State pageIndex: number = 1;
  @State pageSize: number = 10;
  @State totalCount: number = 0;
  @State showForm: boolean = false;
  @State formData: Record<string, Object> = {};
  @State parentMenus: Record<string, Object>[] = [];

  aboutToAppear() { this.loadData(); }

  async loadData() {
    try {
      let params: Record<string, string> = { 'pageIndex': this.pageIndex.toString(), 'pageSize': this.pageSize.toString() };
      if (this.searchKey) { params['name'] = this.searchKey; }
      let resp = await httpGet('/sys/sysMenu/list', params);
      let result = JSON.parse(resp) as Record<string, Object>;
      let data = result['data'] as Record<string, Object>;
      if (data) { this.menuList = (data['list'] as Record<string, Object>[]) || []; this.totalCount = (data['totalCount'] as number) || 0; }
    } catch (e) { }
  }

  async deleteItem(menuId: number) { try { await httpGet('/sys/sysMenu/deleteMenu', { 'menuId': menuId.toString() }); await this.loadData(); } catch (e) { } }

  async saveItem() { try { await httpPost('/sys/sysMenu/save', this.formData); this.showForm = false; this.formData = {}; await this.loadData(); } catch (e) { } }

  async openAdd() {
    try {
      let resp = await httpGet('/sys/sysMenu/listParent');
      let result = JSON.parse(resp) as Record<string, Object>;
      this.parentMenus = (result['data'] as Record<string, Object>[]) || [];
      this.formData = { 'menuId': 0 as Object }; this.showForm = true;
    } catch (e) { }
  }

  async editItem(menuId: number) {
    try {
      let resp = await httpGet('/sys/sysMenu/queryMenuById', { 'menuId': menuId.toString() });
      let result = JSON.parse(resp) as Record<string, Object>;
      let data = result['data'] as Record<string, Object>;
      if (data) {
        let menu = data['children'] as Record<string, Object>;
        this.parentMenus = (data['parents'] as Record<string, Object>[]) || [];
        this.formData = { 'menuId': menu['menuId'] as Object, 'name': menu['name'] as Object, 'path': menu['path'] as Object, 'icon': menu['icon'] as Object, 'orderNum': menu['orderNum'] as Object, 'parentId': menu['parentId'] as Object };
        this.showForm = true;
      }
    } catch (e) { }
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.ic_menu')).width(22).height(22).fillColor(AppColors.PRIMARY)
        Text(' 菜单管理').fontSize(18).fontWeight(FontWeight.Bold).fontColor(AppColors.TEXT_PRIMARY).layoutWeight(1)
        Button('新增').fontSize(12).height(30).backgroundColor(AppColors.PRIMARY).borderRadius(15).onClick(() => { this.openAdd(); })
      }.width('92%').padding({ top: 12, bottom: 8 })
      Row() {
        TextInput({ placeholder: '菜单名称', text: this.searchKey }).height(36).backgroundColor('#F5F7FA').borderRadius(18).layoutWeight(1).onChange((v: string) => { this.searchKey = v; })
        Image($r('app.media.ic_search')).width(20).height(20).fillColor(Color.White).margin({ left: 8 }).padding(8).backgroundColor(AppColors.PRIMARY).borderRadius(18)
          .onClick(() => { this.pageIndex = 1; this.loadData(); })
      }.width('92%').margin({ bottom: 8 })
      if (this.showForm) {
        Column() {
          Text(((this.formData['menuId'] as number) || 0) > 0 ? '编辑菜单' : '新增菜单').fontSize(15).fontWeight(FontWeight.Bold).margin({ bottom: 8 })
          TextInput({ placeholder: '菜单名称', text: (this.formData['name'] as string) || '' }).height(40).backgroundColor('#F5F7FA').borderRadius(8).margin({ bottom: 6 }).onChange((v: string) => { this.formData['name'] = v; })
          TextInput({ placeholder: '路由地址', text: (this.formData['path'] as string) || '' }).height(40).backgroundColor('#F5F7FA').borderRadius(8).margin({ bottom: 6 }).onChange((v: string) => { this.formData['path'] = v; })
          TextInput({ placeholder: '图标', text: (this.formData['icon'] as string) || '' }).height(40).backgroundColor('#F5F7FA').borderRadius(8).margin({ bottom: 6 }).onChange((v: string) => { this.formData['icon'] = v; })
          TextInput({ placeholder: '序号', text: String(this.formData['orderNum'] || '') }).height(40).backgroundColor('#F5F7FA').borderRadius(8).margin({ bottom: 6 }).type(InputType.Number).onChange((v: string) => { this.formData['orderNum'] = Number(v); })
          Row() {
            Button('取消').layoutWeight(1).height(40).backgroundColor('#999999').borderRadius(8).margin({ right: 8 }).onClick(() => { this.showForm = false; })
            Button('确定').layoutWeight(1).height(40).backgroundColor(AppColors.PRIMARY).borderRadius(8).onClick(() => { this.saveItem(); })
          }.width('100%')
        }.width('92%').padding(12).backgroundColor(AppColors.BG_CARD).borderRadius(8).margin({ bottom: 8 })
      }
      if (!this.showForm) {
        List({ space: 0 }) {
          ForEach(this.menuList, (item: Record<string, Object>, index: number) => {
            ListItem() {
              Row() {
                Image($r('app.media.ic_menu')).width(28).height(28).fillColor(AppColors.ACCENT).margin({ right: 10 })
                Column() {
                  Text((item['name'] as string) || '').fontSize(14).fontWeight(FontWeight.Medium)
                  Text('路由:' + ((item['path'] as string) || '-') + ' | 序号:' + String(item['orderNum'] || '')).fontSize(11).fontColor(AppColors.TEXT_HINT).margin({ top: 2 })
                }.layoutWeight(1).alignItems(HorizontalAlign.Start)
                Image($r('app.media.ic_edit')).width(16).height(16).fillColor(AppColors.PRIMARY).margin({ right: 8 })
                  .onClick(() => { this.editItem(item['menuId'] as number); })
                if (item['canBeDelete'] as boolean) {
                  Image($r('app.media.ic_delete')).width(16).height(16).fillColor(AppColors.DANGER)
                    .onClick(() => { AlertDialog.show({ title: '确认', message: '确定删除？', autoCancel: true, confirm: { value: '删除', fontColor: AppColors.DANGER, action: () => { this.deleteItem(item['menuId'] as number); } }, cancel: () => { } }); })
                }
              }.width('92%').padding(10).backgroundColor(AppColors.BG_CARD).borderRadius(8)
              .shadow({ radius: 4, color: '#08000000', offsetX: 0, offsetY: 1 }).margin({ left: '4%', right: '4%', bottom: 6 })
            }
          }, (item: Record<string, Object>, index: number) => 'menu_' + String(item['menuId'] || '') + '_' + index)
        }.layoutWeight(1).width('100%')
      }
    }.width('100%').height('100%')
  }
}

// ======================== SysLog (SysLog.vue) ========================
@Component
struct SysLogPage {
  @State logs: Record<string, Object>[] = [];
  @State searchKey: string = '';
  @State pageIndex: number = 1;
  @State pageSize: number = 10;
  @State totalCount: number = 0;

  aboutToAppear() { this.loadData(); }

  async loadData() {
    try {
      let params: Record<string, string> = { 'pageIndex': this.pageIndex.toString(), 'pageSize': this.pageSize.toString() };
      if (this.searchKey) { params['msg'] = this.searchKey; }
      let resp = await httpGet('/sys/sysLog/list', params);
      let result = JSON.parse(resp) as Record<string, Object>;
      let data = result['data'] as Record<string, Object>;
      if (data) { this.logs = (data['list'] as Record<string, Object>[]) || []; this.totalCount = (data['totalCount'] as number) || 0; }
    } catch (e) { }
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.ic_log')).width(22).height(22).fillColor(AppColors.PRIMARY)
        Text(' 系统日志').fontSize(18).fontWeight(FontWeight.Bold).fontColor(AppColors.TEXT_PRIMARY).layoutWeight(1)
      }.width('92%').padding({ top: 12, bottom: 8 })
      Row() {
        TextInput({ placeholder: '用户名/用户操作', text: this.searchKey }).height(36).backgroundColor('#F5F7FA').borderRadius(18).layoutWeight(1).onChange((v: string) => { this.searchKey = v; })
        Image($r('app.media.ic_search')).width(20).height(20).fillColor(Color.White).margin({ left: 8 }).padding(8).backgroundColor(AppColors.PRIMARY).borderRadius(18)
          .onClick(() => { this.pageIndex = 1; this.loadData(); })
      }.width('92%').margin({ bottom: 8 })
      List({ space: 0 }) {
        ForEach(this.logs, (item: Record<string, Object>, index: number) => {
          ListItem() {
            Column() {
              Text((item['operation'] as string) || '').fontSize(14).fontWeight(FontWeight.Medium).fontColor(AppColors.TEXT_PRIMARY)
              Text('方法：' + ((item['method'] as string) || '')).fontSize(11).fontColor(AppColors.TEXT_HINT).margin({ top: 2 }).maxLines(1).textOverflow({ overflow: TextOverflow.Ellipsis })
              Text('参数：' + ((item['params'] as string) || '')).fontSize(11).fontColor(AppColors.TEXT_HINT).margin({ top: 2 }).maxLines(1).textOverflow({ overflow: TextOverflow.Ellipsis })
              Row() {
                Text('耗时：' + String(item['time'] || 0) + 'ms').fontSize(10).fontColor(AppColors.TEXT_SECONDARY)
                Text('  ' + ((item['createDate'] as string) || '')).fontSize(10).fontColor(AppColors.TEXT_SECONDARY)
              }.margin({ top: 4 })
            }.width('92%').padding(10).backgroundColor(AppColors.BG_CARD).borderRadius(8)
            .shadow({ radius: 4, color: '#08000000', offsetX: 0, offsetY: 1 }).margin({ left: '4%', right: '4%', bottom: 6 })
          }
        }, (item: Record<string, Object>, index: number) => 'log_' + String(item['id'] || '') + '_' + index)
      }.layoutWeight(1).width('100%')
      Row() {
        Button('上一页').fontSize(12).height(30).backgroundColor(this.pageIndex > 1 ? AppColors.PRIMARY : '#CCCCCC').borderRadius(15).onClick(() => { if (this.pageIndex > 1) { this.pageIndex--; this.loadData(); } })
        Text('第' + this.pageIndex + '页').fontSize(12).fontColor(AppColors.TEXT_SECONDARY).margin({ left: 12, right: 12 })
        Button('下一页').fontSize(12).height(30).backgroundColor(AppColors.PRIMARY).borderRadius(15).onClick(() => { this.pageIndex++; this.loadData(); })
      }.width('92%').justifyContent(FlexAlign.Center).padding({ top: 8, bottom: 8 })
    }.width('100%').height('100%')
  }
}

// ======================== BulletinList (BulletinList.vue) ========================
@Component
struct BulletinListPage {
  @State bulletins: Record<string, Object>[] = [];
  @State searchKey: string = '';
  @State pageIndex: number = 1;
  @State pageSize: number = 10;
  @State totalCount: number = 0;
  @State showForm: boolean = false;
  @State formData: Record<string, Object> = {};
  @State typeOptions: string[] = ['知识类', '招聘', '其他'];
  @State userRole: string = ''; // 存储当前用户角色

  //aboutToAppear() { this.loadData(); }
  async aboutToAppear() {
    const username = getUsername();
    if (username) {
      try {
        let resp = await httpGet('/sys/sysUser/getrole', { 'username': username });
        let result = JSON.parse(resp) as Record<string, Object>;
        this.userRole = (result['data'] as string) || '';
      } catch (e) {
        console.error('获取角色失败', e);
        this.userRole = '志愿者';
      }
    }
    // 2. 加载公告数据
    this.loadData();
  }

  // 判断是否为管理员（只有管理员能操作）
  isAdmin(): boolean {
    return this.userRole === '超级管理员'; // 可扩展多个管理员角色，如：['超级管理员', '系统管理员'].includes(this.userRole)
  }

  async loadData() {
    try {
      let params: Record<string, string> = { 'pageIndex': this.pageIndex.toString(), 'pageSize': this.pageSize.toString() };
      if (this.searchKey) { params['content'] = this.searchKey; }
      let resp = await httpGet('/bul/bulletin/list', params);
      let result = JSON.parse(resp) as Record<string, Object>;
      let data = result['data'] as Record<string, Object>;
      if (data) { this.bulletins = (data['list'] as Record<string, Object>[]) || []; this.totalCount = (data['totalCount'] as number) || 0; }
    } catch (e) { }
  }

  async deleteItem(id: number) { try { await httpGet('/bul/bulletin/deleteBul', { 'id': id.toString() }); await this.loadData(); } catch (e) { } }

  async saveItem() { try { await httpPost('/bul/bulletin/save', this.formData); this.showForm = false; this.formData = {}; await this.loadData(); } catch (e) { } }

  async editItem(id: number) {
    try {
      let resp = await httpGet('/bul/bulletin/queryBulById', { 'id': id.toString() });
      let result = JSON.parse(resp) as Record<string, Object>;
      let d = result['data'] as Record<string, Object>;
      if (d) { this.formData = d; this.showForm = true; }
    } catch (e) { }
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.ic_bulletin')).width(22).height(22).fillColor(AppColors.PRIMARY)
        if (this.isAdmin()) {
          Text(' 公告管理').fontSize(18).fontWeight(FontWeight.Bold).fontColor(AppColors.TEXT_PRIMARY).layoutWeight(1)
        }else {
          Text(' 公告 ').fontSize(18).fontWeight(FontWeight.Bold).fontColor(AppColors.TEXT_PRIMARY).layoutWeight(1)
        }
        if (this.isAdmin()) {
          Button('新增')
            .fontSize(12)
            .height(30)
            .backgroundColor(AppColors.PRIMARY)
            .borderRadius(15)
            .onClick(() => {
              this.formData = {};
              this.showForm = true;
            })
        }
      }.width('92%').padding({ top: 12, bottom: 8 })
      Row() {
        TextInput({ placeholder: '公告内容', text: this.searchKey }).height(36).backgroundColor('#F5F7FA').borderRadius(18).layoutWeight(1).onChange((v: string) => { this.searchKey = v; })
        Image($r('app.media.ic_search')).width(20).height(20).fillColor(Color.White).margin({ left: 8 }).padding(8).backgroundColor(AppColors.PRIMARY).borderRadius(18)
          .onClick(() => { this.pageIndex = 1; this.loadData(); })
      }.width('92%').margin({ bottom: 8 })
      if (this.showForm) {
        Column() {
          Text(this.formData['id'] ? '编辑公告' : '发布公告').fontSize(15).fontWeight(FontWeight.Bold).margin({ bottom: 8 })
          TextArea({ placeholder: '公告内容', text: (this.formData['content'] as string) || '' }).height(80).backgroundColor('#F5F7FA').borderRadius(8).margin({ bottom: 6 }).onChange((v: string) => { this.formData['content'] = v; })
          Text('公告类型').fontSize(13).fontColor(AppColors.TEXT_SECONDARY).width('100%').margin({ bottom: 4 })
          Flex({ wrap: FlexWrap.Wrap }) {
            ForEach(this.typeOptions, (t: string, idx: number) => {
              Text(t).fontSize(12).fontColor((this.formData['type'] as string) === t ? Color.White : AppColors.TEXT_PRIMARY)
                .backgroundColor((this.formData['type'] as string) === t ? AppColors.PRIMARY : '#F5F7FA')
                .padding({ left: 12, right: 12, top: 6, bottom: 6 }).borderRadius(14).margin(3)
                .onClick(() => { this.formData['type'] = t; })
            }, (t: string) => t)
          }.width('100%').margin({ bottom: 8 })
          Row() {
            Button('取消').layoutWeight(1).height(40).backgroundColor('#999999').borderRadius(8).margin({ right: 8 }).onClick(() => { this.showForm = false; })
            Button('确定').layoutWeight(1).height(40).backgroundColor(AppColors.PRIMARY).borderRadius(8).onClick(() => { this.saveItem(); })
          }.width('100%')
        }.width('92%').padding(12).backgroundColor(AppColors.BG_CARD).borderRadius(8).margin({ bottom: 8 })
      }
      if (!this.showForm) {
        List({ space: 0 }) {
          ForEach(this.bulletins, (item: Record<string, Object>, index: number) => {
            ListItem() {
              Row() {
                Image($r('app.media.ic_bulletin')).width(28).height(28).fillColor(AppColors.WARNING).margin({ right: 10 })
                Column() {
                  Text((item['content'] as string) || '').fontSize(13).fontColor(AppColors.TEXT_PRIMARY).maxLines(2).textOverflow({ overflow: TextOverflow.Ellipsis })
                  Row() {
                    Text((item['type'] as string) || '').fontSize(10).fontColor(AppColors.PRIMARY).backgroundColor(AppColors.PRIMARY_LIGHT).padding({ left: 6, right: 6, top: 1, bottom: 1 }).borderRadius(4)
                    Text('  ' + ((item['date'] as string) || '')).fontSize(10).fontColor(AppColors.TEXT_HINT)
                    Text('  ' + ((item['account'] as string) || '')).fontSize(10).fontColor(AppColors.TEXT_HINT)
                  }.margin({ top: 4 })
                }.layoutWeight(1).alignItems(HorizontalAlign.Start)
                if (this.isAdmin()) {
                Image($r('app.media.ic_edit')).width(16).height(16).fillColor(AppColors.PRIMARY).margin({ right: 8 })
                  .onClick(() => { this.editItem(item['id'] as number); })}
                if (this.isAdmin()) {
                  Image($r('app.media.ic_delete')).width(16).height(16).fillColor(AppColors.DANGER)
                    .onClick(() => {
                      AlertDialog.show({
                        title: '确认',
                        message: '确定删除？',
                        autoCancel: true,
                        confirm: {
                          value: '删除', fontColor: AppColors.DANGER, action: () => {
                            this.deleteItem(item['id'] as number);
                          }
                        },
                        cancel: () => {
                        }
                      });
                    })
                }
              }.width('92%').padding(10).backgroundColor(AppColors.BG_CARD).borderRadius(8)
              .shadow({ radius: 4, color: '#08000000', offsetX: 0, offsetY: 1 }).margin({ left: '4%', right: '4%', bottom: 6 })
            }
          }, (item: Record<string, Object>, index: number) => 'bul_m_' + String(item['id'] || '') + '_' + index)
        }.layoutWeight(1).width('100%')
        Row() {
          Button('上一页').fontSize(12).height(30).backgroundColor(this.pageIndex > 1 ? AppColors.PRIMARY : '#CCCCCC').borderRadius(15).onClick(() => { if (this.pageIndex > 1) { this.pageIndex--; this.loadData(); } })
          Text('第' + this.pageIndex + '页').fontSize(12).fontColor(AppColors.TEXT_SECONDARY).margin({ left: 12, right: 12 })
          Button('下一页').fontSize(12).height(30).backgroundColor(AppColors.PRIMARY).borderRadius(15).onClick(() => { this.pageIndex++; this.loadData(); })
        }.width('92%').justifyContent(FlexAlign.Center).padding({ top: 8, bottom: 8 })
      }
    }.width('100%').height('100%')
  }
}

// ======================== Health Knowledge Manage (hea/healthknowledge) ========================
@Component
struct HealthKnowledgeManagePage {
  @State dataList: Record<string, Object>[] = [];
  @State searchKey: string = '';
  @State showForm: boolean = false;
  @State formData: Record<string, Object> = {};

  aboutToAppear() { this.loadData(); }

  async loadData() {
    try {
      let resp = await httpGet('/hea/healthknowledge/list');
      let result = JSON.parse(resp) as Record<string, Object>;
      let data = result['data'] as Record<string, Object>[];
      if (data) { this.dataList = data; }
    } catch (e) { }
  }

  async saveItem() { try { await httpPost('/hea/healthknowledge/save', this.formData); this.showForm = false; this.formData = {}; await this.loadData(); } catch (e) { } }

  async deleteItem(id: number) { try { await httpGet('/hea/healthknowledge/delete', { 'id': id.toString() }); await this.loadData(); } catch (e) { } }

  build() {
    Column() {
      Row() {
        Image($r('app.media.ic_health')).width(22).height(22).fillColor(AppColors.PRIMARY)
        Text(' 健康知识管理').fontSize(18).fontWeight(FontWeight.Bold).fontColor(AppColors.TEXT_PRIMARY).layoutWeight(1)
        Button('新增').fontSize(12).height(30).backgroundColor(AppColors.PRIMARY).borderRadius(15)
          .onClick(() => { this.formData = {}; this.showForm = true; })
      }.width('92%').padding({ top: 12, bottom: 8 })
      if (this.showForm) {
        Column() {
          Text(this.formData['id'] ? '编辑知识' : '新增知识').fontSize(15).fontWeight(FontWeight.Bold).margin({ bottom: 8 })
          TextInput({ placeholder: '标题', text: (this.formData['title'] as string) || '' }).height(40).backgroundColor('#F5F7FA').borderRadius(8).margin({ bottom: 6 }).onChange((v: string) => { this.formData['title'] = v; })
          TextArea({ placeholder: '内容', text: (this.formData['content'] as string) || '' }).height(120).backgroundColor('#F5F7FA').borderRadius(8).margin({ bottom: 6 }).onChange((v: string) => { this.formData['content'] = v; })
          Row() {
            Button('取消').layoutWeight(1).height(40).backgroundColor('#999999').borderRadius(8).margin({ right: 8 }).onClick(() => { this.showForm = false; })
            Button('确定').layoutWeight(1).height(40).backgroundColor(AppColors.PRIMARY).borderRadius(8).onClick(() => { this.saveItem(); })
          }.width('100%')
        }.width('92%').padding(12).backgroundColor(AppColors.BG_CARD).borderRadius(8).margin({ bottom: 8 })
      }
      if (!this.showForm) {
        List({ space: 0 }) {
          ForEach(this.dataList, (item: Record<string, Object>, index: number) => {
            ListItem() {
              Row() {
                Column() {
                  Text((item['title'] as string) || '').fontSize(14).fontWeight(FontWeight.Medium).fontColor(AppColors.TEXT_PRIMARY)
                  Text((item['content'] as string) || '').fontSize(12).fontColor(AppColors.TEXT_SECONDARY).margin({ top: 4 }).maxLines(3).textOverflow({ overflow: TextOverflow.Ellipsis })
                }.layoutWeight(1).alignItems(HorizontalAlign.Start)
                Image($r('app.media.ic_edit')).width(16).height(16).fillColor(AppColors.PRIMARY).margin({ right: 10 })
                  .onClick(() => { this.formData = { 'id': item['id'] as Object, 'title': item['title'] as Object, 'content': item['content'] as Object }; this.showForm = true; })
                Image($r('app.media.ic_delete')).width(16).height(16).fillColor(AppColors.DANGER)
                  .onClick(() => { AlertDialog.show({ title: '确认', message: '确定删除？', autoCancel: true, confirm: { value: '删除', fontColor: AppColors.DANGER, action: () => { this.deleteItem(item['id'] as number); } }, cancel: () => { } }); })
              }.width('92%').padding(12).backgroundColor(AppColors.BG_CARD).borderRadius(8)
              .shadow({ radius: 4, color: '#08000000', offsetX: 0, offsetY: 1 }).margin({ left: '4%', right: '4%', bottom: 6 })
            }
          }, (item: Record<string, Object>, index: number) => 'hk_' + String(item['id'] || '') + '_' + index)
        }.layoutWeight(1).width('100%').scrollBar(BarState.Auto)
      }
    }.width('100%').height('100%')
  }
}

// ======================== Admin Info (infomation.vue) ========================
@Component
struct AdminInfoPage {
  @State formData: Record<string, Object> = {};
  @State loading: boolean = false;

  aboutToAppear() { this.loadData(); }

  async loadData() {
    try {
      let resp = await httpGet('/sys/sysUser/inlist');
      let result = JSON.parse(resp) as Record<string, Object>;
      let data = result['data'] as Record<string, Object>[];
      if (data && data.length > 0) {
        let user = data[0];
        this.formData = { 'userId': user['userId'] as Object, 'username': user['username'] as Object, 'email': user['email'] as Object, 'mobile': user['mobile'] as Object };
      }
    } catch (e) { }
  }

  async saveInfo() {
    try {
      await httpPost('/sys/sysUser/insave', this.formData);
      AlertDialog.show({ message: '修改成功，请重新登录' });
      setToken(''); setUsername('');
      router.replaceUrl({ url: 'pages/Login' });
    } catch (e) { }
  }

  build() {
    Scroll() {
      Column() {
        Row() {
          Image($r('app.media.ic_info')).width(22).height(22).fillColor(AppColors.PRIMARY)
          Text(' 个人信息').fontSize(18).fontWeight(FontWeight.Bold).fontColor(AppColors.TEXT_PRIMARY)
        }.width('92%').padding({ top: 12, bottom: 12 })

        Column() {
          Image($r('app.media.ic_user')).width(64).height(64).fillColor(AppColors.PRIMARY).margin({ bottom: 16 })
          Text('用户名').fontSize(13).fontColor(AppColors.TEXT_SECONDARY).width('100%').margin({ bottom: 4 })
          TextInput({ text: (this.formData['username'] as string) || '' }).height(40).backgroundColor('#EEEEEE').borderRadius(8).margin({ bottom: 10 }).enabled(false)
          Text('新密码').fontSize(13).fontColor(AppColors.TEXT_SECONDARY).width('100%').margin({ bottom: 4 })
          TextInput({ placeholder: '输入新密码(选填)' }).height(40).backgroundColor('#F5F7FA').borderRadius(8).margin({ bottom: 10 }).type(InputType.Password)
            .onChange((v: string) => { this.formData['password'] = v; })
          Text('邮箱').fontSize(13).fontColor(AppColors.TEXT_SECONDARY).width('100%').margin({ bottom: 4 })
          TextInput({ placeholder: '邮箱', text: (this.formData['email'] as string) || '' }).height(40).backgroundColor('#F5F7FA').borderRadius(8).margin({ bottom: 10 })
            .onChange((v: string) => { this.formData['email'] = v; })
          Text('电话').fontSize(13).fontColor(AppColors.TEXT_SECONDARY).width('100%').margin({ bottom: 4 })
          TextInput({ placeholder: '电话', text: (this.formData['mobile'] as string) || '' }).height(40).backgroundColor('#F5F7FA').borderRadius(8).margin({ bottom: 16 })
            .onChange((v: string) => { this.formData['mobile'] = v; })

          Button('修改').width('100%').height(44).backgroundColor(AppColors.PRIMARY).borderRadius(8).onClick(() => { this.saveInfo(); })
        }
        .width('92%').padding(16).backgroundColor(AppColors.BG_CARD).borderRadius(AppSizes.RADIUS_LG)
        .shadow({ radius: 8, color: '#0A000000', offsetX: 0, offsetY: 2 })
        .alignItems(HorizontalAlign.Center)
      }.width('100%')
    }.width('100%').height('100%').scrollBar(BarState.Off)
  }
}
