import { abilityAccessCtrl, bundleManager, common } from "@kit.AbilityKit";
import { BusinessError } from "@kit.BasicServicesKit";
import { hilog } from "@kit.PerformanceAnalysisKit";
import { geoLocationManager } from '@kit.LocationKit';

/**
 * 位置服务工具类
 */ 
class LocationUtils {
  public context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
  public latitude: number = 0;
  public longitude: number = 0;
  public currentLocation: string = '';

  //检查当前应用程序是否已经被授予权限
  private checkPermissionGrant(): boolean {
    let hasPermission = false;
    let tokenId: number = 0;
    try {
      let bundleInfo: bundleManager.BundleInfo =
        bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION);
      let appInfo: bundleManager.ApplicationInfo = bundleInfo.appInfo;
      tokenId = appInfo.accessTokenId;
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      hilog.error(0x0000, 'Index',
        `Failed to get bundle info for self. Code is ${err.code}, message is ${err.message}`);
    }
    try {
      let atManager = abilityAccessCtrl.createAtManager();
      let approximatelyLocation = atManager.checkAccessTokenSync(tokenId, 'ohos.permission.APPROXIMATELY_LOCATION');
      let location = atManager.checkAccessTokenSync(tokenId, 'ohos.permission.LOCATION');
      hasPermission = approximatelyLocation === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED &&
        location === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED;
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      hilog.error(0x0000, 'Index', `Failed to check access token. Code is ${err.code}, message is ${err.message}`);
    }
    return hasPermission;
  }

  //向用户请求位置权限
  requestPermissions(): Promise<boolean> {
    let atManager = abilityAccessCtrl.createAtManager();
    // 调用requestPermissionsFromUser()方法向用户申请授权
    return atManager.requestPermissionsFromUser(this.context, ['ohos.permission.APPROXIMATELY_LOCATION',
      'ohos.permission.LOCATION']).then((data) => {
      // -1表示未授权，0：已授权
      return Promise.resolve(data.authResults[0] === 0 && data.authResults[1] === 0)
    })

  }

  //显示权限设置对话框
  private openPermissionsSetting(): Promise<boolean> {
    let atManager = abilityAccessCtrl.createAtManager();
    return atManager.requestPermissionOnSetting(this.context, ['ohos.permission.APPROXIMATELY_LOCATION',
      'ohos.permission.LOCATION']).then((data: Array<abilityAccessCtrl.GrantStatus>) => {
      // -1表示未授权，1表示已授权
      return data[0] === 0 && data[1] === 0;
    })
  }

  // 获取当前位置开关状态，判断位置服务是否开启，若位置服务开启，可直接获取位置信息
  isLocationToggle(): Promise<boolean> {
    let atManager = abilityAccessCtrl.createAtManager();
    // 通过isLocationEnabled()方法判断位置服务是否开启
    let isLocationEnabled = geoLocationManager.isLocationEnabled();
    if (!isLocationEnabled) { // 若位置服务是关闭的，可使用requestGlobalSwitch()方法拉起全局开关设置弹框，以开启位置服务
      return atManager.requestGlobalSwitch(this.context, abilityAccessCtrl.SwitchType.LOCATION)
        .then((data: boolean) => {
          return !!data;
        })
    } else { //若位置服务是打开的，直接获取位置信息
      return Promise.resolve(true);

    }
  }

  //获取位置信息
  async getAddress(): Promise<geoLocationManager.GeoAddress[]> {
    // 1-检查当前应用程序是否已经被授予权限,如果已授权则直接指定定位操作
    let hasPermission = this.checkPermissionGrant();
    // 2-未授权，唤起弹框向用户动态申请授权
    if (!hasPermission) {
      hasPermission = await this.requestPermissions();
    }
    // 3-用户拒绝授权，提示用户必须授权才能访问当前页面的功能，并引导用户到系统设置中打开相应的权限
    if (!hasPermission) {
      // 二次拉起权限设置弹框
      hasPermission = await this.openPermissionsSetting()
    }
    if (hasPermission) {
      // 4-校验位置开关
      hasPermission = await this.isLocationToggle()
    }

    if (!hasPermission) {
      const a: BusinessError<string> = {
        name: "locationError",
        message: "获取位置信息失败",
        code: 500,
        data: ""
      }
      throw a as Error;
    }
    let request: geoLocationManager.SingleLocationRequest = {
      'locatingTimeoutMs': 10000,
      'locatingPriority': geoLocationManager.LocatingPriority.PRIORITY_LOCATING_SPEED
    };

    let location:geoLocationManager.Location;
    //（3）调用位置服务API获取经纬度信息，并赋值给变量location
    location = await geoLocationManager.getCurrentLocation(request);

    // 封装逆地理编码请求对象
    const reverseGeocodeRequest:geoLocationManager.ReverseGeoCodeRequest = {"latitude": location.latitude, "longitude": location.longitude, "maxItems": 1};
    //（4）调用位置服务逆地理编码API，根据上述经纬度获取地址信息，并作为函数返回值返回
    return geoLocationManager.getAddressesFromLocation(reverseGeocodeRequest);
  }
}

export { LocationUtils };