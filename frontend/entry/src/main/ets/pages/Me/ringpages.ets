import { API_BASE_URL } from '../../common/ApiConfig';
import { preferences } from '@kit.ArkData';
import http from '@ohos.net.http';
import { HmRingChart } from '../IndexPage/rings'

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

interface sportData {
  color: string
  type: string,
  dataNow: number,
  dataTarget: number,
  unit: string
}


@Entry
@Component
struct FitnessApp {

  @State menus: sportData[] = [
    { color: '', type: '', dataNow: 0, dataTarget: 0, unit: '' }
  ];
  @State stepData: sportData = { color: '#ffd00d0d', type: ' 步数 ', dataNow: 0, dataTarget: 9000, unit: '步' };
  @State calorieData: sportData = { color: '#ff14d606', type: ' 热量 ', dataNow: 0, dataTarget: 500, unit: 'kcal' };
  @State exerciseData: sportData = { color: '#ff09d6ad', type: ' 运动 ', dataNow: 0, dataTarget: 60, unit: 'min' };

  async aboutToAppear() {
    const preferencesData = await preferences.getPreferences(getContext(), 'token');
    const token = await preferencesData.get('token', '');

    const res = await http.createHttp().request(`${API_BASE_URL}/health/step/count`, {
      header: { "token": token }
    });

    const resData: Res = JSON.parse(res.result as string) as Res;
    const lastIndex = resData.data.length - 1;
    const latestData = resData.data[lastIndex].step;
    const latestCalorieData = resData.data[lastIndex].calorie;

    this.stepData.dataNow = latestData;
    this.calorieData.dataNow = latestCalorieData;
    this.exerciseData.dataNow = 0;
  }

  build() {
    Column() {
      Scroll() {
        Column() {
          Row() {
            // 左侧数据
            Column() {
              Column({ space: 5 }) {
                Text(this.stepData.type)
                  .fontSize(14)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#E3361A')
                  .textAlign(TextAlign.Center)
                  .width('100%')
                Text(`${this.stepData.dataNow} / ${this.stepData.dataTarget}`)
                  .fontSize(12)
                  .fontWeight(FontWeight.Bold)
                  .textAlign(TextAlign.Center)
                  .width('100%')
                Text(this.stepData.unit)
                  .fontSize(12)
                  .fontColor('#ff9a9a9a')
                  .textAlign(TextAlign.Center)
                  .width('100%')
              }
              .margin({ bottom: 20 })
              .width('100%')

              Column({ space: 5 }) {
                Text(this.calorieData.type)
                  .fontSize(14)
                  .fontColor('#35DA28')
                  .fontWeight(FontWeight.Bold)
                  .textAlign(TextAlign.Center)
                  .width('100%')
                Text(`${this.calorieData.dataNow} / ${this.calorieData.dataTarget}`)
                  .fontSize(14)
                  .fontWeight(FontWeight.Bold)
                  .textAlign(TextAlign.Center)
                  .width('100%')
                Text(this.calorieData.unit)
                  .fontSize(12)
                  .fontColor('#ff9a9a9a')
                  .textAlign(TextAlign.Center)
                  .width('100%')
              }
              .margin({ bottom: 20 })
              .width('100%')

              Column({ space: 5 }) {
                Text(this.exerciseData.type)
                  .fontSize(14)
                  .fontColor('#00F2D3')
                  .fontWeight(FontWeight.Bold)
                  .textAlign(TextAlign.Center)
                  .width('100%')
                Text(`${this.exerciseData.dataNow} / ${this.exerciseData.dataTarget}`)
                  .fontSize(14)
                  .fontWeight(FontWeight.Bold)
                  .textAlign(TextAlign.Center)
                  .width('100%')
                Text(this.exerciseData.unit)
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

            // 右侧环形图
            Column() {
              HmRingChart()
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
        }
      }
    }
  }
}
