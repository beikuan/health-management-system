import { API_BASE_URL } from '../../common/ApiConfig';
import { preferences } from '@kit.ArkData';
import http from '@ohos.net.http';
import { CustomDialogExample } from './ai';
import { HmRingChart } from '../IndexPage/rings';

// 添加这个接口定义
interface ApiResponse<T> {
  msg: string;
  code: number;
  data: T;
}

// 心率
interface Res {
  msg: string,
  code: number,
  data: HeartRate[]
}

interface HeartRate {
  bpm: number
}

// 血氧
interface spo2Res {
  msg: string,
  code: number,
  data: spo2[]
}

interface spo2 {
  spo2: number
}

// 呼吸率
interface RespirationRes {
  msg: string,
  code: number,
  data: Respiration[]
}

interface Respiration {
  rpm: number // 呼吸率
}

// 步数
interface StepsRes {
  msg: string,
  code: number,
  data: Steps[]
}

interface Steps {
  steps: number // 步数
}

// 睡眠时间
interface SleepRes {
  msg: string,
  code: number,
  data: SleepData[]
}

interface SleepData {
  hours: number // 只保留小时数据
}

// 血压接口
interface BloodPressureRes {
  msg: string,
  code: number,
  data: BloodPressure[]
}

interface BloodPressure {
  systolic: number // 收缩压
  diastolic: number // 舒张压
}

// 血糖接口
interface BloodSugarRes {
  msg: string,
  code: number,
  data: BloodSugar[]
}

interface BloodSugar {
  mmol: number // 血糖值(mmol/L)
}

// 尿酸接口
interface UricAcidRes {
  msg: string,
  code: number,
  data: UricAcid[]
}

interface UricAcid {
  umol: number // 尿酸值(μmol/L)
}

// 血脂接口
interface CholesterolRes {
  msg: string,
  code: number,
  data: Cholesterol[]
}

interface Cholesterol {
  mmol: number // 血脂值(mmol/L)
}

interface StepRes {
  msg: string;
  code: number;
  data: Step[];
}

interface Step {
  date: string;
  step: number;
  calorie: number;
}

interface sportData {
  color: string
  type: string,
  dataNow: number,
  dataTarget: number,
  unit: string
}

interface Habit {
  label: string
  current: number
  target: number
  completed: boolean
}

interface HabitRecord {
  habitType: string
  count: number
  target: number
}

interface HabitResponse {
  msg: string
  code: number
  data: HabitRecord[]
}

interface CheckinBody {
  habitType: string
}

interface targetStep {
  userId: string,
  targetStep: number;
}

interface Heat {
  userId: string,
  targetHeat: number;
}

interface SportTime {
  userId: string,
  sportTime: number;
}

@Component
export struct Index {
  @State heartRate: number = 0 // 用于存储心率数据
  @State spo2: number = 0 // 用于存储血氧数据
  @State respirationRate: number = 0 // 用于存储呼吸率数据
  @State stepCount: number = 0
  @State sleepHours: number = 0 // 只保留小时状态
  @State systolic: number = 0 // 收缩压
  @State diastolic: number = 0 // 舒张压
  @State bloodSugar: number = 0 // 用于存储血糖数据
  @State uricAcid: number = 0 // 用于存储尿酸数据
  @State cholesterol: number = 0 // 用于存储血脂数据
  @State currentDate: string = ''
  @State habits: Habit[] = []
  @State loading: boolean = true
  dialogController: CustomDialogController = new CustomDialogController({
    builder: CustomDialogExample(), // 使用 CustomDialogExample 组件
    alignment: DialogAlignment.Center,
    customStyle: true,
    maskColor: 'rgba(255,235,238,0.5)'
  });
  // 新增 indexring 组件的状态变量
  @State refreshRingFlag: boolean = true;
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
  async aboutToAppear1() {
    await this.aboutToAppear(); // 初始加载时调用
  }
  async aboutToAppear() {
    const preferencesData = await preferences.getPreferences(getContext(), 'token')
    const token = await preferencesData.get('token', '')

    const httpClient = http.createHttp();

    // 合并所有请求
    const results = await Promise.all([
    // 健康数据请求
      httpClient.request(`${API_BASE_URL}/health/heart/ratetest`, { header: { "Authorization": `Bearer ${token}` } }),
      httpClient.request(`${API_BASE_URL}/health/BloodOxygen`, { header: { "Authorization": `Bearer ${token}` } }),
      httpClient.request(`${API_BASE_URL}/health/Respiration`, { header: { "Authorization": `Bearer ${token}` } }),
      httpClient.request(`${API_BASE_URL}/health/sleeptime`, { header: { "Authorization": `Bearer ${token}` } }),
      httpClient.request(`${API_BASE_URL}/health/bloodpressure`, { header: { "Authorization": `Bearer ${token}` } }),
      httpClient.request(`${API_BASE_URL}/health/bloodsugar`, { header: { "Authorization": `Bearer ${token}` } }),
      httpClient.request(`${API_BASE_URL}/health/uricacid`, { header: { "Authorization": `Bearer ${token}` } }),
      httpClient.request(`${API_BASE_URL}/health/cholesterol`, { header: { "Authorization": `Bearer ${token}` } }),
      httpClient.request(`${API_BASE_URL}/habit/today`, { header: { "Authorization": `Bearer ${token}` } }),

      // 环形图数据请求
      httpClient.request(`${API_BASE_URL}/health/step/count`, { header: { "Authorization": `Bearer ${token}` } }),
      httpClient.request(`${API_BASE_URL}/health/step/target`, { header: { "Authorization": `Bearer ${token}` } }),
      httpClient.request(`${API_BASE_URL}/health/heat`, { header: { "Authorization": `Bearer ${token}` } }),
      httpClient.request(`${API_BASE_URL}/health/sport/time`, { header: { "Authorization": `Bearer ${token}` } }),
    ]);

    // 健康数据解析
    const heartRes = results[0];
    const spo2Res = results[1];
    const respRes = results[2];
    const sleepRes = results[3];
    const bpRes = results[4];
    const sugarRes = results[5];
    const uricRes = results[6];
    const cholesterolRes = results[7];
    const habitRes = results[8];

    // JSON解析
    const resData: Res = JSON.parse(heartRes.result as string)
    const spo2Data: spo2Res = JSON.parse(spo2Res.result as string)
    const respData: RespirationRes = JSON.parse(respRes.result as string)
    const sleepData: SleepRes = JSON.parse(sleepRes.result as string)
    const bpData: BloodPressureRes = JSON.parse(bpRes.result as string)
    const sugarData: BloodSugarRes = JSON.parse(sugarRes.result as string)
    const uricData: UricAcidRes = JSON.parse(uricRes.result as string)
    const cholesterolData: CholesterolRes = JSON.parse(cholesterolRes.result as string)
    const habitData: HabitResponse = JSON.parse(habitRes.result as string)

    // 更新健康数据
    this.heartRate = resData.data.length > 0 ? resData.data[0].bpm : 0
    this.spo2 = spo2Data.data.length > 0 ? spo2Data.data[0].spo2 : 0
    this.respirationRate = respData.data.length > 0 ? respData.data[0].rpm : 0
    this.sleepHours = sleepData.data.length > 0 ? sleepData.data[0].hours : 0
    this.systolic = bpData.data.length > 0 ? bpData.data[0].systolic : 0
    this.diastolic = bpData.data.length > 0 ? bpData.data[0].diastolic : 0
    this.bloodSugar = sugarData.data.length > 0 ? sugarData.data[0].mmol : 0
    this.uricAcid = uricData.data.length > 0 ? uricData.data[0].umol : 0
    this.cholesterol = cholesterolData.data.length > 0 ? cholesterolData.data[0].mmol : 0

    // 更新打卡数据
    if (habitData.code === 200) {
      this.habits = habitData.data.map((item: HabitRecord) => {
        let target = 1
        switch (item.habitType) {
          case '喝水':
            target = 8;
            break;
          case '早起':
            target = 1;
            break;
          case '跑步':
            target = 2;
            break;
          case '刷牙':
            target = 2;
            break;
        }
        return {
          label: item.habitType,
          current: item.count,
          target: target,
          completed: item.count >= target
        } as Habit
      })
    }

    // 环形图数据解析
    const stepRes = results[9];
    const targetStepRes = results[10];
    const heatRes = results[11];
    const sportTimeRes = results[12];

    const stepData: StepRes = JSON.parse(stepRes.result as string)
    const targetStepData: ApiResponse<targetStep[]> = JSON.parse(targetStepRes.result as string)
    const heatData: ApiResponse<Heat[]> = JSON.parse(heatRes.result as string)
    const sportTimeData: ApiResponse<SportTime[]> = JSON.parse(sportTimeRes.result as string)

    // 更新环形图数据
    const latestStepData: Step | undefined = stepData.data[stepData.data.length - 1];
    const latestData = latestStepData?.step ?? 0;
    const latestCalorieData = latestStepData?.calorie ?? 0;
    const targetStep = targetStepData.data.length > 0 ? targetStepData.data[0].targetStep : 4000
    const targetHeat = heatData.data.length > 0 ? heatData.data[0].targetHeat : 800
    const sportTime = sportTimeData.data.length > 0 ? sportTimeData.data[0].sportTime : 60

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

    // 更新步数状态
    this.stepCount = latestData;

    // 设置日期
    const now = new Date();
    const year = now.getFullYear();
    const month = (now.getMonth() + 1).toString().padStart(2, '0');
    const day = now.getDate().toString().padStart(2, '0');
    this.currentDate = `${year}年${month}月${day}日`;

    this.loading = false
  }

  async onPageShow() {
    try {
      const pref = await preferences.getPreferences(getContext(), 'token')
      const token = await pref.get('token', '')

      const httpReq = http.createHttp()
      const res = await httpReq.request(`${API_BASE_URL}/habit/today`, {
        method: http.RequestMethod.GET,
        header: { 'Authorization': `Bearer ${token}` }
      }) as http.HttpResponse

      const resData: HabitResponse = JSON.parse(res.result as string)
      if (resData.code === 200) {
        this.habits = resData.data.map((item: HabitRecord) => {
          let target = 1
          switch (item.habitType) {
            case '喝水':
              target = 8
              break
            case '早起':
              target = 1
              break
            case '跑步':
              target = 2
              break
            case '刷牙':
              target = 2
              break
          }

          return {
            label: item.habitType,
            current: item.count,
            target: target,
            completed: item.count >= target
          } as Habit
        })
      } else {
        console.error('获取打卡失败:', resData.msg)
      }
    } catch (error) {
      console.error('网络请求失败:', error)
    }
    this.loading = false
  }

  async updateHabit(index: number) {
    if (this.habits[index].completed) {
      return
    }

    const body: CheckinBody = { habitType: this.habits[index].label }

    try {
      const pref = await preferences.getPreferences(getContext(), 'token')
      const token = await pref.get('token', '')

      const res = await http.createHttp().request(`${API_BASE_URL}/habit/checkin`, {
        method: http.RequestMethod.POST,
        header: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${token}`
        },
        extraData: JSON.stringify(body)
      }) as http.HttpResponse

      const resData: HabitResponse = JSON.parse(res.result as string)
      if (resData.code === 200) {
        const updated = [...this.habits]
        updated[index].current++
        if (updated[index].current >= updated[index].target) {
          updated[index].completed = true
        }
        this.habits = updated
      } else {
        console.warn('打卡失败:', resData.msg)
      }
    } catch (error) {
      console.error('打卡异常:', error)
    }
  }

  build() {
    Stack() {
      // 固定背景层（不随内容滚动）
      Image($r('app.media.back_plus'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])

      // 可滚动内容区域
      Scroll() {
        Column() {
          // 顶部标题栏
          Column() {
            Text('今天')
              .fontSize(30)
              .fontWeight(600)
              .width("100%")
              .fontColor('#000')
              .margin({ left: 25, top: 30 })

            Text(this.currentDate)
              .fontSize(12)
              .fontColor('#000000')
              .width("100%")
              .margin({ left: 25, top: 5 })
          }

          // 环形图区域 (原indexring内容)
          Column() {
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
                if (this.refreshRingFlag) {
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
          }.width('100%')

          Text('健康记录')
            .fontSize(30)
            .fontWeight(600)
            .width("100%")
            .fontColor('#000')
            .margin({ left: 25, top: 10, bottom: 10 })

          if (this.loading) {
            Text('加载中...').fontColor('#888').width('100%').textAlign(TextAlign.Center)
          } else {
            Row() {
              ForEach(this.habits, (habit: Habit, index: number) => {
                Column() {
                  Text(`${habit.current}次`)
                    .fontSize(18)
                    .fontColor(habit.completed ? '#FEA713' : '#9C98A7')
                    .margin({ bottom: 8 })

                  Stack() {
                    Image(habit.completed ? $r('app.media.yes') : $r('app.media.add'))
                      .width(48)
                      .height(48)
                      .borderRadius(24)
                  }
                  .margin({ bottom: 8 })

                  Text(habit.label).fontSize(14).fontColor('#666666').margin({ bottom: 8 })

                  Row() {
                    Row()
                      .width(`${Math.min(100, (habit.current / habit.target) * 100)}%`)
                      .height(6)
                      .backgroundColor('#FEA713')
                      .borderRadius(3)
                  }
                  .width('80%')
                  .backgroundColor('#FFFFFF')
                  .borderRadius(3)
                  .clip(true)
                }
                .width('23%')
                .height(180)
                .alignItems(HorizontalAlign.Center)
                .justifyContent(FlexAlign.Center)
                .backgroundBrightness({
                  rate: 0.5,
                  lightUpDegree: 0.5
                })
                .backgroundBlurStyle(BlurStyle.Thin, {
                  colorMode: ThemeColorMode.LIGHT,
                  adaptiveColor: AdaptiveColor.DEFAULT,
                  scale: 1
                })
                .borderRadius(12)
                .margin({ right: 8 })
                .onClick(() => {
                  this.updateHabit(index)
                })
              })
            }
            .width('100%')
            .padding({ left: 16, right: 8 })
            .justifyContent(FlexAlign.SpaceBetween)
          }
          // 健康检测数据标题
          Row() {
            // 左侧图标和标题
            Row() {
              Text('数据')
                .fontSize(30)
                .fontWeight(FontWeight.Medium)
                .fontColor('#000000')

            }

            // 右侧按钮
            Button({ type: ButtonType.Circle, stateEffect: true }) {
              Image($r('app.media.ai'))
                .width(35)
                .height(35)
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
            }
            .width(25)
            .height(25)
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
          .justifyContent(FlexAlign.SpaceBetween)

          // 健康数据九宫格
          GridRow({ gutter: { y: 10 } }) {
            // 心率卡片
            GridCol({ span: 4 }) {
              Column() {
                Image($r('app.media.p1'))
                  .width(70)
                  .height(70)
                  .margin({ right: 5 })

                Text('心率')
                  .fontSize(16)
                  .fontWeight(FontWeight.Medium)
                  .fontColor('#000000')
                  .margin({ bottom: 8 })

                Text(`${this.heartRate}bpm`)
                  .fontSize(15)
                  .fontColor(this.getHeartRateStatusColor(this.heartRate))

                Text(this.getHeartRateStatusText(this.heartRate))
                  .fontSize(12)
                  .fontColor(this.getHeartRateStatusColor(this.heartRate))
                  .margin({ top: 4 })
              }
              .width('90%')
              .padding(10)
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
            }

            // 血氧卡片
            GridCol({ span: 4 }) {
              Column() {
                Image($r('app.media.p2'))
                  .width(70)
                  .height(70)
                  .margin({ right: 5 })

                Text('血氧')
                  .fontSize(16)
                  .fontWeight(FontWeight.Medium)
                  .margin({ bottom: 8 })
                  .fontColor('#000000')

                Text(`${this.spo2}%`)
                  .fontSize(15)
                  .fontColor(this.getSpo2StatusColor(this.spo2))

                Text(this.getSpo2StatusText(this.spo2))
                  .fontSize(12)
                  .fontColor(this.getSpo2StatusColor(this.spo2))
                  .margin({ top: 4 })
              }
              .width('90%')
              .padding(10)
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
            }

            // 呼吸率卡片
            GridCol({ span: 4 }) {
              Column() {
                Image($r('app.media.p3'))
                  .width(70)
                  .height(70)
                  .margin({ right: 5 })

                Text('呼吸率')
                  .fontSize(16)
                  .fontWeight(FontWeight.Medium)
                  .margin({ bottom: 8 })
                  .fontColor('#000000')

                Text(`${this.respirationRate}/min`)
                  .fontSize(15)
                  .fontColor(this.getRespirationStatusColor(this.respirationRate))

                Text(this.getRespirationStatusText(this.respirationRate))
                  .fontSize(12)
                  .fontColor(this.getRespirationStatusColor(this.respirationRate))
                  .margin({ top: 4 })
              }
              .width('90%')
              .padding(10)
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
            }

            // 步数卡片
            GridCol({ span: 4 }) {
              Column() {
                Image($r('app.media.p4'))
                  .width(70)
                  .height(70)
                  .margin({ right: 5 })

                Text('步数')
                  .fontSize(16)
                  .fontWeight(FontWeight.Medium)
                  .margin({ bottom: 8 })
                  .fontColor('#000000')

                Text(`${this.formatSteps(this.stepCount)}`)
                  .fontSize(15)
                  .fontColor(this.getStepsStatusColor(this.stepCount))

                Text(this.getStepsStatusText(this.stepCount))
                  .fontSize(12)
                  .fontColor(this.getStepsStatusColor(this.stepCount))
                  .margin({ top: 4 })
              }
              .width('90%')
              .padding(10)
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
            }

            // 睡眠卡片
            GridCol({ span: 4 }) {
              Column() {
                Image($r('app.media.p5'))
                  .width(70)
                  .height(70)
                  .margin({ right: 5 })

                Text('睡眠')
                  .fontSize(16)
                  .fontWeight(FontWeight.Medium)
                  .margin({ bottom: 8 })
                  .fontColor('#000000')

                Text(`${this.sleepHours}h`)
                  .fontSize(15)
                  .fontColor(this.getSleepStatusColor(this.sleepHours))

                Text(this.getSleepStatusText(this.sleepHours))
                  .fontSize(12)
                  .fontColor(this.getSleepStatusColor(this.sleepHours))
                  .margin({ top: 4 })
              }
              .width('90%')
              .padding(10)
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
            }

            // 血压卡片
            GridCol({ span: 4 }) {
              Column() {
                Image($r('app.media.p6'))
                  .width(70)
                  .height(70)
                  .margin({ right: 5 })

                Text('血压')
                  .fontSize(16)
                  .fontWeight(FontWeight.Medium)
                  .margin({ bottom: 8 })
                  .fontColor('#000000')

                Text(`${this.systolic}/${this.diastolic}`)
                  .fontSize(15)
                  .fontColor(this.getBloodPressureStatusColor(this.systolic, this.diastolic))

                Text(this.getBloodPressureStatusText(this.systolic, this.diastolic))
                  .fontSize(12)
                  .fontColor(this.getBloodPressureStatusColor(this.systolic, this.diastolic))
                  .margin({ top: 4 })
              }
              .width('90%')
              .padding(10)
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
            }

            // 血糖卡片
            GridCol({ span: 4 }) {
              Column() {
                Image($r('app.media.p7'))
                  .width(70)
                  .height(70)
                  .margin({ right: 5 })

                Text('血糖')
                  .fontSize(16)
                  .fontWeight(FontWeight.Medium)
                  .margin({ bottom: 8 })
                  .fontColor('#000000')

                Text(`${this.bloodSugar.toFixed(1)}mmol/L`)
                  .fontSize(15)
                  .fontColor(this.getBloodSugarStatusColor(this.bloodSugar))

                Text(this.getBloodSugarStatusText(this.bloodSugar))
                  .fontSize(12)
                  .fontColor(this.getBloodSugarStatusColor(this.bloodSugar))
                  .margin({ top: 4 })
              }
              .width('90%')
              .padding(10)
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
            }

            // 尿酸卡片
            GridCol({ span: 4 }) {
              Column() {
                Image($r('app.media.p8'))
                  .width(70)
                  .height(70)
                  .margin({ right: 5 })

                Text('尿酸')
                  .fontSize(16)
                  .fontWeight(FontWeight.Medium)
                  .margin({ bottom: 8 })
                  .fontColor('#000000')

                Text(`${this.uricAcid}μmol/L`)
                  .fontSize(14)
                  .fontColor(this.getUricAcidStatusColor(this.uricAcid))

                Text(this.getUricAcidStatusText(this.uricAcid))
                  .fontSize(12)
                  .fontColor(this.getUricAcidStatusColor(this.uricAcid))
                  .margin({ top: 4 })
              }
              .width('90%')
              .padding(10)
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
            }

            // 血脂卡片
            GridCol({ span: 4 }) {
              Column() {
                Image($r('app.media.p9'))
                  .width(70)
                  .height(70)
                  .margin({ right: 5 })

                Text('血脂')
                  .fontSize(16)
                  .fontWeight(FontWeight.Medium)
                  .margin({ bottom: 8 })
                  .fontColor('#000000')

                Text(`${this.cholesterol.toFixed(1)}mmol/L`)
                  .fontSize(15)
                  .fontColor(this.getCholesterolStatusColor(this.cholesterol))

                Text(this.getCholesterolStatusText(this.cholesterol))
                  .fontSize(12)
                  .fontColor(this.getCholesterolStatusColor(this.cholesterol))
                  .margin({ top: 4 })
              }
              .width('90%')
              .padding(10)
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
            }
          }.margin({ left: 10, right: 10 })

          // 底部留白
          Row() {
          }
          .height(20)
        }
      }
      .edgeEffect(EdgeEffect.Spring)
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundBrightness({
      rate: 0.5,
      lightUpDegree: 0.5
    })
    .backgroundBlurStyle(BlurStyle.Thin, {
      colorMode: ThemeColorMode.LIGHT,
      adaptiveColor: AdaptiveColor.DEFAULT,
      scale: 1
    })
  }

  // 获取心率状态颜色
  private getHeartRateStatusColor(bpm: number): string {
    if (bpm < 60) {
      return '#FF3B30'
    }
    if (bpm > 100) {
      return '#FF9500'
    }
    return '#07C160'
  }

  // 获取心率状态文本
  private getHeartRateStatusText(bpm: number): string {
    if (bpm < 60) {
      return '过低'
    }
    if (bpm > 100) {
      return '过高'
    }
    return '正常'
  }

  // 血氧状态颜色判断
  private getSpo2StatusColor(spo2: number): string {
    if (spo2 < 90) {
      return '#FF3B30'
    }
    if (spo2 < 95) {
      return '#FF9500'
    }
    return '#07C160'
  }

  // 血氧状态文本判断
  private getSpo2StatusText(spo2: number): string {
    if (spo2 < 90) {
      return '过低'
    }
    if (spo2 < 95) {
      return '偏低'
    }
    return '正常'
  }

  // 呼吸率状态颜色判断
  private getRespirationStatusColor(rate: number): string {
    if (rate < 12) {
      return '#FF3B30'
    }
    if (rate > 20) {
      return '#FF9500'
    }
    return '#07C160'
  }

  // 呼吸率状态文本判断
  private getRespirationStatusText(rate: number): string {
    if (rate < 12) {
      return '过低'
    }
    if (rate > 20) {
      return '过高'
    }
    return '正常'
  }

  // 步数格式化（添加千位分隔符）
  private formatSteps(steps: number): string {
    return steps.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",")
  }

  // 步数状态颜色判断
  private getStepsStatusColor(steps: number): string {
    const target = 8000
    if (steps < target * 0.7) {
      return '#FF3B30'
    }
    if (steps < target) {
      return '#FF9500'
    }
    return '#07C160'
  }

  // 步数状态文本判断
  private getStepsStatusText(steps: number): string {
    const target = 8000
    if (steps < target * 0.7) {
      return '不足'
    }
    if (steps < target) {
      return '接近目标'
    }
    return '达标'
  }

  // 睡眠状态颜色判断
  private getSleepStatusColor(hours: number): string {
    if (hours < 6) {
      return '#FF3B30'
    }
    if (hours < 8) {
      return '#FF9500'
    }
    return '#07C160'
  }

  // 睡眠状态文本判断
  private getSleepStatusText(hours: number): string {
    if (hours < 6) {
      return '不足'
    }
    if (hours < 8) {
      return '尚可'
    }
    return '充足'
  }

  // 血压状态颜色判断
  private getBloodPressureStatusColor(systolic: number, diastolic: number): string {
    if (systolic > 140 || diastolic > 90) {
      return '#FF3B30'
    }
    if (systolic < 90 || diastolic < 60) {
      return '#FF9500'
    }
    return '#07C160'
  }

  // 血压状态文本判断
  private getBloodPressureStatusText(systolic: number, diastolic: number): string {
    if (systolic > 140 || diastolic > 90) {
      return '偏高'
    }
    if (systolic < 90 || diastolic < 60) {
      return '偏低'
    }
    return '正常'
  }

  // 血糖状态颜色判断
  private getBloodSugarStatusColor(mmol: number): string {
    if (mmol > 7.0) {
      return '#FF3B30'
    }
    if (mmol < 3.9) {
      return '#FF9500'
    }
    return '#07C160'
  }

  // 血糖状态文本判断
  private getBloodSugarStatusText(mmol: number): string {
    if (mmol > 7.0) {
      return '偏高'
    }
    if (mmol < 3.9) {
      return '偏低'
    }
    return '正常'
  }

  // 尿酸状态颜色判断
  private getUricAcidStatusColor(umol: number): string {
    if (umol > 420) {
      return '#FF3B30'
    }
    if (umol < 200) {
      return '#FF9500'
    }
    return '#07C160'
  }

  // 尿酸状态文本判断
  private getUricAcidStatusText(umol: number): string {
    if (umol > 420) {
      return '偏高'
    }
    if (umol < 200) {
      return '偏低'
    }
    return '正常'
  }

  // 血脂状态颜色判断
  private getCholesterolStatusColor(mmol: number): string {
    if (mmol > 5.2) {
      return '#FF3B30'
    }
    if (mmol < 2.8) {
      return '#FF9500'
    }
    return '#07C160'
  }

  // 血脂状态文本判断
  private getCholesterolStatusText(mmol: number): string {
    if (mmol > 5.2) {
      return '偏高'
    }
    if (mmol < 2.8) {
      return '偏低'
    }
    return '正常'
  }
}
