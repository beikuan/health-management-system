import { API_BASE_URL } from '../../common/ApiConfig';
import http from '@ohos.net.http';
import { preferences } from '@kit.ArkData';

interface Res {
  msg: string;
  code: number;
  data: string;
}

@CustomDialog
export struct AIDialog {
  controller?: CustomDialogController;
  @State advice: string = '正在分析，请稍候...';
  @State loading: boolean = true;

  cancel: () => void = () => {};
  confirm: () => void = () => {};

  // 提取数据获取逻辑
  private async fetchData() {
    this.loading = true;
    this.advice = '正在分析，请稍候...';

    try {
      const pref = await preferences.getPreferences(getContext(), 'token');
      const token = await pref.get('token', '');

      const httpReq = http.createHttp();
      const res = await httpReq.request(
        `${API_BASE_URL}/health/ai/targetanalysis`,
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
          this.advice = `分析失败：${resData.msg}`;
        }
      } else if (res.responseCode === 503) {
        this.advice = 'AI 功能尚未配置，其他健康管理功能仍可正常使用。';
      } else if (res.responseCode === 422) {
        this.advice = '请先设置健康目标，再生成建议。';
      } else {
        this.advice = `请求失败，状态码: ${res.responseCode}`;
      }
    } catch (e) {
      this.advice = '请求异常: ' + JSON.stringify(e);
    } finally {
      this.loading = false;
    }
  }

  aboutToAppear() {
    this.fetchData();
  }

  build() {
    Column() {
      // 标题区域
      Text('AI 健康饮食建议')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 10 });
      Text('仅供健康管理参考，不替代医生诊断')
        .fontSize(12)
        .fontColor('#8A8A8A')
        .margin({ bottom: 8 });

      // 加载状态区域
      Column() {
        Text(this.advice)
          .fontSize(16)
          .lineHeight(24)
          .textAlign(TextAlign.Center)
          .padding(10);

        if (this.loading) {
          LoadingProgress()
            .width(50)
            .height(50)
            .margin({ top: 10 });
        }
      }
      .width('100%')
      .visibility(this.loading ? Visibility.Visible : Visibility.None)

      // 结果展示区域
      Scroll() {
        Text(this.advice)
          .fontSize(16)
          .lineHeight(24)
          .textAlign(TextAlign.Start)
          .padding(10);
      }
      .backgroundBrightness({
        rate: 0.5,
        lightUpDegree: 0.5
      })
      .backgroundBlurStyle(BlurStyle.Thin, {
        colorMode: ThemeColorMode.LIGHT,
        adaptiveColor: AdaptiveColor.DEFAULT,
        scale: 1
      })
      .borderRadius(8)
      .borderWidth(1)
      .borderColor('#EEE')
      .width('100%')
      .height(250)
      .visibility(!this.loading ? Visibility.Visible : Visibility.None)

      // 按钮区域
      Row() {
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
            this.fetchData();
          })
          .margin({ right: 20 });

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
            this.controller?.close();
          });
      }
      .width('100%')
      .margin({ top: 20 })
      .justifyContent(FlexAlign.Center)
    }
    .padding(20)
    .width('90%')
    .backgroundColor(Color.White)
    .borderRadius(16)
  }
}
