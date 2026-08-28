import notification from '@ohos.notification';

interface NormalContent {
  title: string;
  text: string;
}

interface NotificationContent {
  contentType: number;
  normal: NormalContent;
}

interface NotifyRequest {
  id: number;
  content: NotificationContent;
  slotType: number;
}

export class AlarmUtil {

  // 立即发送
  static sendNow(title: string, text: string) {
    AlarmUtil.sendNotification(title, text);
  }

  // 延迟 N 秒发送
  static sendDelay(seconds: number, title: string, text: string) {
    setTimeout(() => {
      AlarmUtil.sendNotification(title, text);
    }, seconds * 1000);
  }

  // 指定 小时:分钟 发送
  static sendAtTime(hour: number, minute: number, title: string, text: string) {
    let now = new Date();
    let target = new Date();

    target.setHours(hour);
    target.setMinutes(minute);
    target.setSeconds(0);

    if (target < now) {
      target.setDate(target.getDate() + 1);
    }

    let delay = target.getTime() - now.getTime();

    setTimeout(() => {
      AlarmUtil.sendNotification(title, text);
    }, delay);
  }

  // 统一发送通知
  private static sendNotification(title: string, text: string) {
    notification.requestEnableNotification(() => {
      let normal: NormalContent = { title, text };
      let content: NotificationContent = { contentType: 0, normal };
      let request: NotifyRequest = {
        id: Date.now(),
        content: content,
        slotType: 1
      };
      notification.publish(request, () => {});
    });
  }
}