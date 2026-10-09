import { API_BASE_URL } from '../../common/ApiConfig';
import { hmChart, ChartOptions, hmChartType } from "@wuyan/hm_chart"
import { preferences } from '@kit.ArkData';
import http from '@ohos.net.http';

interface Res {
  msg:string,
  code:number,
  data:HeartRate[]
}
interface HeartRate {
  date:string,
  bpm:number
}

@Component
export struct HmLineChart {
  @State myChart: hmChartType | null = null
  @State Options:ChartOptions = {};

  // 页面渲染之前执行
  async aboutToAppear() {
    const preferencesData = await preferences.getPreferences(getContext(), 'token')
    const token = await preferencesData.get('token', '')

    const res = await http.createHttp().request(`${API_BASE_URL}/health/heart/rate`, {
      header: {
        "Authorization": `Bearer ${token}`
      }
    })

    const resData:Res = JSON.parse(res.result as string) as Res

    if (resData.data.length === 0) {
      return;
    }

    const xText: string[] = [];
    const yNumber: number[] = []; // 常量：不可改变
    let min:number = resData.data[0].bpm; // 变量
    let max:number = resData.data[0].bpm;
    for(let i = 0; i < resData.data.length; i++) {
      let heartData:HeartRate = resData.data[i]
      xText.push(heartData.date)
      yNumber.push(heartData.bpm)

      if(heartData.bpm < min) {
        min = heartData.bpm;
      }
      if(heartData.bpm > max) {
        max = heartData.bpm;
      }
    }

    this.myChart?.setOption({

      xAxis: {
        type: 'category',
        data: xText,
        axisLabel: {  // 正确位置：在xAxis内配置标签样式
          show: true,
          interval: 0,  // 显示所有标签
          rotate: -50,  // 逆时针旋转50度
          inside: false, // 标签在坐标轴外侧
          margin: 6     // 标签与轴线的间距
        }
      },
      yAxis: {
        type: 'value',
        min: 0,
        max: max + 20,
        interval: 10
      },
      title: {
        text: '心率趋势（过去30天）',
        left: 'center',
        textStyle: {
          fontSize: 16,
          fontWeight: 'bold',
          color: '#FFFFFF'

          }
        },
      series: [
        {
          data: yNumber,
          type: 'line',
          smooth: true,
          areaStyle: {
            color: {
              type: 'linear',
              x: 0,
              y: 0,
              x2: 0,
              y2: 1,
              colorStops: [
                {offset: 0, color: 'rgba(252, 241, 240, 0.5)'},
                {offset: 1, color: 'rgba(252, 241, 240, 0.3)'}
              ]
            }
          },
          itemStyle: {
            color: '#FF3030' // 这里可以改为你想要的颜色，例如红色
          },
          color: '#E37670',
          symbolSize: 8,
          lineStyle: {
            width: 2,
          }
        }
      ],
      areaStyle: {
        color: 'rgba(252, 241, 240, 0.3)' // 整体30%透明度
      }
    })
  }

  build() {
    Column() {
      Column() {
        hmChart({ Options: this.Options, myChart: this.myChart })
      }
      .width('100%')
      .height('300')
    }
    .height('100%')
    .width('100%')
  }
}
