import { API_BASE_URL } from '../../common/ApiConfig';
import { hmChart, ChartOptions, hmChartType } from "@wuyan/hm_chart";
import { preferences } from '@kit.ArkData';
import http from '@ohos.net.http';
import image from "@ohos.multimedia.image";

interface Res {
  msg: string;
  code: number;
  data: Step[];
}

interface Step {
  date: string;
  step: number;
  calorie:number;
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

@Component
export struct HmRingChart {
  @State myChart: hmChartType | null = null;
  @State Options: ChartOptions = {};
  @State refreshFlag: boolean = true; // 新增状态变量

  async aboutToAppear() {
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

    this.renderMultiLayerRingChart(latestData, targetStep, latestCalorieData,targetHeat);
  }

  private renderMultiLayerRingChart(currentSteps: number, targetSteps: number,
    latestCalorieData: number, targetCalorie:number ) {
    const StepPercentage = Math.min(100, (currentSteps / targetSteps) * 100);
    const StepRemainingPercentage = 100 - StepPercentage;

    const CaloriePercentage = Math.min(100, (latestCalorieData / targetCalorie) * 100);
    const CalorieRemainingPercentage = 100 - CaloriePercentage;

    this.myChart?.setOption({
      tooltip: {          // 悬停提示框
        trigger: 'item',  // 触发方式（数据项图形触发）
        formatter: '({d}%)'  // 自定义提示内容
      },
      series: [
      // 外层圆环 - 步数
        {
          type: 'pie',
          radius: ['80%', '100%'],
          startAngle: 90,
          data:[ StepPercentage,StepRemainingPercentage],
          selectedMode: 'single',
          label: { show: false },
          color: [
            '#E3361A',    // 主色 - 苹果红 (不透明)
            'rgba(255, 59, 48, 0.2)' // 剩余部分 - 半透明红
          ],
          itemStyle: {
            borderRadius: 30,
            borderWidth: 0,
          }
        },

        // 中层圆环 - 热量
        {
          type: 'pie',
          radius: ['58%', '78%'],
          startAngle: 90,
          data:[0,0,CaloriePercentage,CalorieRemainingPercentage],
          label: { show: false },
          color: [
            '#35DA28',    // 主色 - 苹果绿
            'rgba(52, 199, 89, 0.2)' // 半透明绿
          ],
          itemStyle: {
            borderRadius:30, // 设置圆角
            borderWidth: 0
          },

        },
        // 内层圆环 - 运动
        {
          type: 'pie',
          radius: ['36%', '56%'],
          startAngle: 90,
          label: { show: false },
          data:[0, 0, 0, 0, 0, 60],
          color: [
            '#00F2D3',    // 主色 - 苹果蓝
            'rgba(0, 122, 255, 0.2)' // 半透明蓝
          ],
          itemStyle: {
            borderRadius: 30, // 设置圆角
            borderWidth: 0
          },
        }
      ],
    });
  }

  build() {
    Column() {
      hmChart({
        Options: this.Options,
        myChart: this.myChart
      })
        .width(200)
        .height(200)
    }

  }
}
