import { API_BASE_URL } from '../../common/ApiConfig';
import { preferences } from '@kit.ArkData';
import http from '@ohos.net.http';
import { HmRingChart } from '../IndexPage/rings'
import { router } from '@kit.ArkUI';
import { url } from '@kit.ArkTS';
import { AIDialog } from './FoodAi';

interface sportData {
  color: string
  type: string,
  dataNow: number,
  dataTarget: number,
  unit: string
}

interface Res {
  msg: string;
  code: number;
  data: Step[];
}

interface Step {
  date: string;
  step: number;
  calorie: number;
}

interface Res1 {
  msg: string;
  code: number;
  data: targetStep[];
}

interface targetStep {
  userId: string,
  targetStep: number;
}

interface Res2 {
  msg: string;
  code: number;
  data: Heat[];
}

interface Heat {
  userId: string,
  targetHeat: number;
}

interface Res3 {
  msg: string;
  code: number;
  data: SportTime[];
}

interface SportTime {
  userId: string,
  sportTime: number;
}


@Entry
@Component
struct FitnessApp {
  @State refreshFlag: boolean = true; // 新增状态变量
  // @State stepData: sportData = { color: '#ffd00d0d', type: ' 步数 ', dataNow: 0, dataTarget: 9000, unit: '步' };
  // @State calorieData: sportData = { color: '#ff14d606', type: ' 热量 ', dataNow: 0, dataTarget: 500, unit: 'kcal' };
  // @State exerciseData: sportData = { color: '#ff09d6ad', type: ' 运动 ', dataNow: 0, dataTarget: 60, unit: 'min' };
  @State menus: sportData[] = [
    {
      color: '#ff0db3d0',
      type: '步数',
      dataNow: 0,
      dataTarget: 0,
      unit: '步'
    },
    {
      color: '#ffd60606',
      type: '热量',
      dataNow: 0,
      dataTarget: 0,
      unit: '千卡'
    },
    {
      color: '#ff09d620',
      type: '运动',
      dataNow: 0,
      dataTarget: 0,
      unit: '分钟'
    }
  ];
  dialogController: CustomDialogController = new CustomDialogController({
    builder: AIDialog(),
    alignment: DialogAlignment.Center,
    customStyle: true,
    maskColor: 'rgba(255,235,238,0.5)'
  });

  async aboutToAppear() {
    await this.onPageShow(); // 初始加载时调用
  }

  async onPageShow() {
    this.refreshFlag = false; //-----------------
    await new Promise<void>(resolve => setTimeout(resolve, 50));
    const preferencesData = await preferences.getPreferences(getContext(), 'token');
    const token = await preferencesData.get('token', '');

    const res = await http.createHttp().request(`${API_BASE_URL}/health/step/count`, {
      header: { "Authorization": `Bearer ${token}` }
    });

    const res1 = await http.createHttp().request(`${API_BASE_URL}/health/step/target`, {
      header: { "Authorization": `Bearer ${token}` }
    });

    const res2 = await http.createHttp().request(`${API_BASE_URL}/health/heat`, {
      header: { "Authorization": `Bearer ${token}` }
    });

    const httpRequest = http.createHttp();
    const res3 = await httpRequest.request(`${API_BASE_URL}/health/sport/time`, {
      header: { "Authorization": `Bearer ${token}` }
    });

    const resData: Res = JSON.parse(res.result as string) as Res;
    const lastIndex = resData.data.length - 1;
    const latestData = lastIndex >= 0 ? resData.data[lastIndex].step : 0;
    const latestCalorieData = lastIndex >= 0 ? resData.data[lastIndex].calorie : 0;

    const resData1: Res1 = JSON.parse(res1.result as string) as Res1;
    const resData2: Res2 = JSON.parse(res2.result as string) as Res2;
    const resData3: Res3 = JSON.parse(res3.result as string) as Res3;

    const targetStep = resData1.data.length > 0 ? resData1.data[0].targetStep : 4000
    const targetHeat = resData2.data.length > 0 ? resData2.data[0].targetHeat : 800
    const sportTime = resData3.data.length > 0 ? resData3.data[0].sportTime : 60

    this.refreshFlag = true;


    this.menus = [
      {
        color: '#ff0db3d0',
        type: ' 步数 ',
        dataNow: latestData,
        dataTarget: targetStep,
        unit: '步'
      },
      {
        color: '#ffd60606',
        type: ' 热量 ',
        dataNow: latestCalorieData,
        dataTarget: targetHeat,
        unit: '千卡'
      },
      {
        color: '#ff09d620',
        type: ' 运动 ',
        dataNow: 0,
        dataTarget: sportTime,
        unit: '分钟'
      }
    ];


  }

  build() {
    Column() {
      // 顶部导航栏：返回按钮 + 标题
      Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
        Image($r('app.media.chevron_left')).width(30).height(30)
          .onClick(() => {
            router.back();
          })
        Text('运动目标')
          .width('80%')
          .fontSize(25)
          .fontColor('#000000')
          .fontWeight(FontWeight.Bold)
          .textAlign(TextAlign.Center)
      }.height(80).width('100%')

      // 可滚动主体内容
      Scroll() {
        Column() {
          // 中间：左侧文字 + 右侧环形图
          Row() {
            Column() {
              Column({ space: 5 }) {
                Text(this.menus[0].type)
                  .fontSize(14)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#E3361A')
                  .textAlign(TextAlign.Center)
                  .width('100%')
                Text(`${this.menus[0].dataNow} / ${this.menus[0].dataTarget}`)
                  .fontSize(12)
                  .fontWeight(FontWeight.Bold)
                  .textAlign(TextAlign.Center)
                  .width('100%')
                Text(this.menus[0].unit)
                  .fontSize(12)
                  .fontColor('#ff9a9a9a')
                  .textAlign(TextAlign.Center)
                  .width('100%')
              }
              .margin({ bottom: 20 })
              .width('100%')

              Column({ space: 5 }) {
                Text(this.menus[1].type)
                  .fontSize(14)
                  .fontColor('#35DA28')
                  .fontWeight(FontWeight.Bold)
                  .textAlign(TextAlign.Center)
                  .width('100%')
                Text(`${this.menus[1].dataNow} / ${this.menus[1].dataTarget}`)
                  .fontSize(14)
                  .fontWeight(FontWeight.Bold)
                  .textAlign(TextAlign.Center)
                  .width('100%')
                Text(this.menus[1].unit)
                  .fontSize(12)
                  .fontColor('#ff9a9a9a')
                  .textAlign(TextAlign.Center)
                  .width('100%')
              }
              .margin({ bottom: 20 })
              .width('100%')

              Column({ space: 5 }) {
                Text(this.menus[2].type)
                  .fontSize(14)
                  .fontColor('#00F2D3')
                  .fontWeight(FontWeight.Bold)
                  .textAlign(TextAlign.Center)
                  .width('100%')
                Text(`${this.menus[2].dataNow} / ${this.menus[2].dataTarget}`)
                  .fontSize(14)
                  .fontWeight(FontWeight.Bold)
                  .textAlign(TextAlign.Center)
                  .width('100%')
                Text(this.menus[2].unit)
                  .fontSize(12)
                  .fontColor('#ff9a9a9a')
                  .textAlign(TextAlign.Center)
                  .width('100%')
              }
              .margin({ bottom: 15 })
              .width('100%')
            }
            .width('25%')
            .padding({ right: 5 })

            Column() {
              if (this.refreshFlag) {
                HmRingChart()
              }
            }
            .width('75%')
          }
          .margin(16)
          .borderRadius(30)
          .backgroundBrightness({
            rate: 0.5,
            lightUpDegree: 0.5
          })
          .backgroundBlurStyle(BlurStyle.Thin, {
            colorMode: ThemeColorMode.LIGHT,
            adaptiveColor: AdaptiveColor.DEFAULT,
            scale: 1
          })
          .padding(10)
          .shadow({ radius: 3, color: '#5297BF' })

          Row() {
            // 左侧标题
            Text('目标设置')
              .fontSize(25)
              .fontWeight(FontWeight.Medium)
              .fontColor('#000000')

            // 右侧AI按钮
            Button({ type: ButtonType.Circle, stateEffect: true }) {
              Image($r('app.media.ai'))
                .width(30)
                .height(30)
            }
            .width(30)
            .height(30)
            .backgroundColor(Color.Transparent)
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
              this.dialogController.open();
            })
          }
          .width('100%')
          .padding({
            left: 16,
            top: 8,
            right: 16,
            bottom: 16
          })
          .justifyContent(FlexAlign.SpaceBetween) // 两端对齐

          // 底部三个小栏目
          Column() {
            Row() {
              Column() {
                Text('每日步数')
                  .fontSize(18)
                  .fontWeight(FontWeight.Bold)
                  .margin({ bottom: 4 })
                Text('设定每日运动目标')
                  .fontSize(14)
                  .fontColor('#888888')
              }
              .layoutWeight(1)
            }
            .width('100%')
            .padding(16)
            .borderRadius(30)
            .margin({ bottom: 12 })
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
              router.pushUrl({ url: "pages/Me/TargetStep" })
            })

            Row() {
              Column() {
                Text('饮食热量')
                  .fontSize(18)
                  .fontWeight(FontWeight.Bold)
                  .margin({ bottom: 4 })
                Text('定制健康饮食方案')
                  .fontSize(14)
                  .fontColor('#888888')
              }
              .layoutWeight(1)
            }
            .width('100%')
            .padding(16)
            .borderRadius(30)
            .margin({ bottom: 12 })
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
              router.pushUrl({ url: "pages/Me/TargetHeat" })
            })

            Row() {
              Column() {
                Text('运动时间')
                  .fontSize(18)
                  .fontWeight(FontWeight.Bold)
                  .margin({ bottom: 4 })
                Text('个性化运动方案')
                  .fontSize(14)
                  .fontColor('#888888')
              }
              .layoutWeight(1)
            }
            .width('100%')
            .padding(16)
            .borderRadius(30)
            .margin({ bottom: 12 })
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
              router.pushUrl({ url: "pages/Me/TargetSportTime" })
            })
          }
          .padding(16)
          .width('100%')
        }
        .width('100%')
      }
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundImage($r('app.media.back_plus'))
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }
}
