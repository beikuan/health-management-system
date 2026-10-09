import { preferences } from '@kit.ArkData';
import { router } from '@kit.ArkUI';
import { ApiClient } from '../common/ApiClient';

@Entry
@Component
struct Index {
  @State message: string = '正在检查登录状态…';

  async aboutToAppear() {
    const preferencesData = await preferences.getPreferences(getContext(), 'token');
    const token = await preferencesData.get('token', '');
    if (token.toString().length === 0) {
      router.replaceUrl({ url: 'pages/login/Login' });
      return;
    }

    try {
      const response = await ApiClient.request(getContext(), '/user/v1/info');
      if (response.responseCode === 200) {
        router.replaceUrl({ url: 'pages/tabs/TabsPage' });
      } else if (response.responseCode !== 401) {
        this.message = '服务暂时不可用，请稍后重试';
      }
    } catch (error) {
      this.message = '网络连接失败，请检查后端服务';
    }
  }

  build() {
    Column({ space: 16 }) {
      LoadingProgress().width(48).height(48).color('#7C5CFC');
      Text(this.message).fontSize(16).fontColor('#5D6175');
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .backgroundColor('#F6F5FC');
  }
}
