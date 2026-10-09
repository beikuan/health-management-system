import { API_BASE_URL } from '../../common/ApiConfig';
import http from '@ohos.net.http';
import { preferences } from '@kit.ArkData';

interface Res {
  msg: string;
  code: number;
  data: string;
}

@CustomDialog
export struct CustomDialogExample {
  controller?: CustomDialogController;
  @State advice: string = '正在分析，请稍候...';
  @State loading: boolean = true;
  cancel: () => void = () => {};
  confirm: () => void = () => {};

  // 提取数据获取逻辑为独立方法
  private async fetchData() {
    this.loading = true;
    this.advice = '正在分析，请稍候...'; // 重置提示信息

    try {
      const preferencesData = await preferences.getPreferences(getContext(), 'token');
      const token = await preferencesData.get('token', '');

      const httpRequest = http.createHttp();
      const res = await httpRequest.request(
        `${API_BASE_URL}/health/ai/analysis`,
        {
          method: http.RequestMethod.GET,
          header: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${token}`
          }
        }
      );

      if (res.responseCode === 200) {
        const resData: Res = JSON.parse(res.result as string);
        if (resData.code === 200) {
          this.advice = resData.data;
        } else {
          this.advice = '分析失败: ' + resData.msg;
        }
      } else if (res.responseCode === 503) {
        this.advice = 'AI 功能尚未配置，其他健康管理功能仍可正常使用。';
      } else if (res.responseCode === 422) {
        this.advice = '请先录入至少一项健康数据，再生成建议。';
      } else {
        this.advice = '请求失败，状态码: ' + res.responseCode;
      }
    } catch (e) {
      this.advice = '请求异常: ' + JSON.stringify(e);
    } finally {
      this.loading = false;
    }
  }

  // 在弹窗显示时获取数据
  async aboutToAppear() {
    this.fetchData();
  }

  build() {
    Column() {
      Text('健康AI分析')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 10 });
      Text('仅供健康管理参考，不替代医生诊断')
        .fontSize(12)
        .fontColor('#8A8A8A')
        .margin({ bottom: 8 });

      // 将加载提示和进度条组合在一起
      Column() {
        Text(this.advice)
          .fontSize(16)
          .lineHeight(24)
          .textAlign(TextAlign.Center)
          .padding(10);

        // 加载进度条放在文字下方
        if (this.loading) {
          LoadingProgress()
            .width(50)
            .height(50)
            .margin({ top: 10 }); // 在文字下方添加间距
        }
      }
      .width('100%')
      .visibility(this.loading ? Visibility.Visible : Visibility.None) // 仅在加载时显示

      // 结果区域 - 仅在非加载状态显示
      Scroll() {
        Text(this.advice)
          .fontSize(16)
          .lineHeight(24)
          .textAlign(TextAlign.Start)
          .padding(10);

      }
      // .backgroundColor("#FFFFFF")
      .backgroundBrightness({
        rate: 0.5,
        lightUpDegree: 0.5
      })
      .backgroundBlurStyle(BlurStyle.Thin, {
        colorMode: ThemeColorMode.LIGHT,
        adaptiveColor: AdaptiveColor.DEFAULT,
        scale: 1
      })
      .width('100%')
      .height(250)
      .borderRadius(8)
      .borderWidth(1)
      .borderColor('#EEE')
      .visibility(!this.loading ? Visibility.Visible : Visibility.None) // 仅在非加载状态显示

      // 按钮行 - 使用Row水平排列按钮
      Row() {
        // 重新分析按钮
        Button('重新分析')
          .width(120)
          .fontColor('#000000')
          .backgroundColor('#FFFFFF')
          .backgroundBrightness({
            rate: 0.5,
            lightUpDegree: 0.5
          })
          .backgroundBlurStyle(BlurStyle.Thin, {
            colorMode: ThemeColorMode.LIGHT,
            adaptiveColor: AdaptiveColor.DEFAULT,
            scale: 1
          })
          .onClick(() => {
            this.fetchData(); // 重新调用接口获取数据
          })
          .margin({ right: 20 }); // 添加右边距分隔按钮

        // 关闭按钮
        Button('关闭')
          .width(120)
          .fontColor('#000000')
          .backgroundColor('#FFFFFF')
          .backgroundBrightness({
            rate: 0.5,
            lightUpDegree: 0.5
          })
          .backgroundBlurStyle(BlurStyle.Thin, {
            colorMode: ThemeColorMode.LIGHT,
            adaptiveColor: AdaptiveColor.DEFAULT,
            scale: 1
          })
          .onClick(() => {
            this.controller?.close(); // 关闭弹窗
          });
      }
      .width('100%')
      .margin({ top: 20 })
      .justifyContent(FlexAlign.Center) // 居中排列按钮
    }
    .padding(20)
    .width('90%');

  }
}
