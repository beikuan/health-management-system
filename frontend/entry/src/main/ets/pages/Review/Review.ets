import { API_BASE_URL } from '../../common/ApiConfig';
import { hmChart, ChartOptions, hmChartType } from "@wuyan/hm_chart"
import http from '@ohos.net.http'
import { preferences } from '@kit.ArkData'

// 类型定义 - 扩展为包含步数和睡眠时间
interface HealthSummaryItem {
  date: string  // 格式如 '2025-06-23'
  calories: number
  steps: number
  sleepMinutes: number
}

interface Res {
  msg: string,
  code: number,
  data: HealthSummaryItem[]
}
interface PieTooltipParams {
  name: string
  value: number
  percent: number
}
interface ChartPieDataItem {
  name: string
  value: number
}
interface FormatterParams {
  dataIndex: number;
  value: number;
  percent: number;
}

@Component
export struct Review {
  // 图表实例引用
  @State caloriesChart: hmChartType | null = null
  @State stepsChart: hmChartType | null = null
  @State sleepChart: hmChartType | null = null

  // 图表配置选项
  @State caloriesOptions: ChartOptions = {}
  @State stepsOptions: ChartOptions = {}
  @State sleepOptions: ChartOptions = {}

  // 数据存储
  @State allData: HealthSummaryItem[] = []
  @State weekIndex: number = 0
  @State weekRange: string = '2025/01/1- 2025/01/7'

  // 统计数据
  @State totalCalories: number = 0
  @State avgCalories: number = 0
  @State totalSteps: number = 0
  @State avgSteps: number = 0
  @State totalSleepMinutes: number = 0
  @State avgSleepMinutes: number = 0

  async aboutToAppear() {
    const preferencesData = await preferences.getPreferences(getContext(), 'token')
    const token = await preferencesData.get('token', '')

    const res = await http.createHttp().request(`${API_BASE_URL}/calories/calories1`, {
      header: { 'Authorization': `Bearer ${token}` }
    })
    const resData: Res = JSON.parse(res.result as string)
    this.allData = resData.data

    // 初始加载图表
    this.updateCharts()
  }

  aboutToUpdate() {
    this.updateCharts()
  }

  updateCharts() {
    const weekData = this.filterWeekData(this.allData, this.weekIndex)
    const xText: string[] = []
    const yCalories: number[] = []
    const ySteps: number[] = []
    const ySleepMinutes: number[] = []

    let totalCalories = 0
    let totalSteps = 0
    let totalSleepMinutes = 0

    weekData.forEach(item => {
      const date = new Date(item.date)
      xText.push(`${date.getMonth() + 1}/${date.getDate()}`)

      yCalories.push(item.calories)
      ySteps.push(item.steps)
      ySleepMinutes.push(item.sleepMinutes)

      totalCalories += item.calories
      totalSteps += item.steps
      totalSleepMinutes += item.sleepMinutes
    })

    this.totalCalories = totalCalories
    this.avgCalories = Math.round(totalCalories / 7)
    this.totalSteps = totalSteps
    this.avgSteps = Math.round(totalSteps / 7)
    this.totalSleepMinutes = totalSleepMinutes
    this.avgSleepMinutes = Math.round(totalSleepMinutes / 7)

    const maxCalories = Math.max(...yCalories, 0)
    const maxSteps = Math.max(...ySteps, 0)
    const maxSleepMinutes = Math.max(...ySleepMinutes, 0)
    const pieData: number[] = []
    for (let i = 0; i < xText.length; i++) {
      pieData.push(ySleepMinutes[i] || 0)
    }


    // 设置卡路里图表配置
    this.caloriesOptions = {
      animation: true,
      grid: { top: '5%', left: '5%', right: '5%', bottom: '5%', containLabel: true },
      xAxis: { type: 'category', data: xText, axisLabel: { color: '#888', rotate: 0, interval: 0 } },
      yAxis: {
        type: 'value',
        min: 0,
        max: maxCalories,
        interval: 200,
        axisLabel: { color: '#888' },
        splitLine: { lineStyle: { color: '#eee' } }
      },
      series: [{
        data: yCalories,
        type: 'bar',
        barWidth: 16,
        itemStyle: { color: '#DA0001', borderRadius: [6, 6, 0, 0] }
      }]
    }

    // 设置步数图表配置
    this.stepsOptions = {
      animation: true,
      grid: {
        top: '5%',
        left: '5%',
        right: '5%',
        bottom: '5%',
        containLabel: true
      },
      xAxis: {
        type: 'category',
        data: xText,
        axisLabel: {
          color: '#888',
          rotate: 0,
          interval: 0
        }
      },
      yAxis: {
        type: 'value',
        min: 0,
        max: maxSteps,
        interval: 4000,
        axisLabel: { color: '#888' },
        splitLine: { lineStyle: { color: '#eee' } }
      },
      series: [{
        data: ySteps,
        type: 'line',  // 修改为折线图

        // 折线图特有配置
        smooth: true,  // 平滑曲线
        symbol: 'circle',  // 数据点标记形状
        symbolSize: 8,  // 标记点大小
        lineStyle: {
          color: '#41BD10',  // 线条颜色
          width: 3  // 线条宽度
        },
        itemStyle: {
          color: '#62EA00',  // 标记点颜色
          borderColor: '#fff',  // 标记点边框颜色
          borderWidth: 1  // 标记点边框宽度
        },

        // 可选：添加面积填充效果
        areaStyle: {
          color: {
            type: 'linear',
            x: 0, y: 0, x2: 0, y2: 1,
            colorStops: [
              { offset: 0, color: 'rgba(0, 218, 1, 0.3)' },  // 顶部透明度
              { offset: 1, color: 'rgba(0, 218, 1, 0)' }     // 底部完全透明
            ]
          }
        }
      }]
    }

    // 设置睡眠图表配置
    this.sleepOptions = {
      legend: {
        orient: 'horizontal',
        bottom: '5%',
        textStyle: {
          fontSize: 12,
          color: '#666'
        },
        data: xText // 把日期直接传给 legend
      },
      tooltip: {
        trigger: 'item',
        formatter: (params: FormatterParams): string => {
          return `${xText[params.dataIndex]}: ${params.value} (${params.percent}%)`
        }
      },
      series: [{
        name: '睡眠',
        type: 'pie',
        radius: ['35%', '70%'],
        avoidLabelOverlap: false,
        itemStyle: { borderColor: '#fff', borderWidth: 3 },
        label: {
          show: true,
          position: 'inside',
          formatter: (params: FormatterParams): string => {
            return `${xText[params.dataIndex]}: ${params.value} (${params.percent}%)`
          },
          fontSize: 10,
          fontWeight: 'bold',
          color: '#000',
        },
        emphasis: {
          label: { show: true, fontSize: 18, fontWeight: 'bold' }
        },
        labelLine: { show: false },
        data: pieData

      }]
    }


    // 应用图表配置
    this.caloriesChart?.setOption(this.caloriesOptions)
    this.stepsChart?.setOption(this.stepsOptions)
    this.sleepChart?.setOption(this.sleepOptions)
  }

  filterWeekData(all: HealthSummaryItem[], weekIndex: number): HealthSummaryItem[] {
    const baseDate = new Date(2025, 0, 0) // 基准日期
    const start = new Date(baseDate)
    start.setDate(baseDate.getDate() + weekIndex * 7)
    const end = new Date(start)
    end.setDate(start.getDate() + 6)

    return all.filter(item => {
      const d = new Date(item.date)
      return d >= start && d <= end
    })
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      // 固定背景层（不随内容滚动）
      Image($r('app.media.back_plus'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
      // 滚动内容层
      Scroll() {
        Column({ space: 12 }) {
          Text('健康数据周统计')
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
            .fontColor('#000')
            .textAlign(TextAlign.Center)
            .width('100%')
            .margin({ left: 15, top: 30 })

          // 周切换器
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            // ⬅️ 左侧按钮（双层）
            Button('<')
              .onClick(() => {
                if (this.weekIndex > 0) {
                  this.weekIndex--
                  this.updateCharts()
                }
              })
              .width(40)
              .height(40)
              .fontSize(20)
              .fontColor('ffffff')
              .backgroundColor('#262525')
              .borderRadius(20)

            Text(`第 ${this.weekIndex + 1} 周`) // 显示为第1周而不是第0周
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor('#000000')
              .alignSelf(ItemAlign.Center)

            Button('>')
              .onClick(() => {
                this.weekIndex++
                this.updateCharts()
              })
              .width(40)
              .height(40)
              .fontSize(20)
              .fontColor('#ffffff')
              .backgroundColor('#262525')
              .borderRadius(20)

          }
          .width('92%')
          .height(50)
          .backgroundBrightness({
            rate: 0.5,
            lightUpDegree: 0.5
          })
          .backgroundBlurStyle(BlurStyle.Thin, {
            colorMode: ThemeColorMode.LIGHT,
            adaptiveColor: AdaptiveColor.DEFAULT,
            scale: 1
          })
          .borderRadius(24)
          .margin({ top: 8, bottom: 20 })
          .alignSelf(ItemAlign.Center)

          // ====== 卡片1：卡路里 ======
          Column({ space: 6 }) {
            Text('活动')
              .fontSize(18).fontColor('#DA0001').fontWeight(FontWeight.Bold)

            Row({ space: 24 }) {
              Column() {
                Text('总卡路里').fontSize(14).fontColor('#DA0001')
                Text(`${this.totalCalories}`).fontSize(20).fontColor('#000').fontWeight(FontWeight.Bold)
                Text('千卡').fontSize(12).fontColor('#DA0001')
              }

              Column() {
                Text('平均每日').fontSize(14).fontColor('#DA0001')
                Text(`${this.avgCalories}`).fontSize(20).fontColor('#000').fontWeight(FontWeight.Bold)
                Text('千卡').fontSize(12).fontColor('#DA0001')
              }
            }

            Column() {
              hmChart({ Options: this.caloriesOptions, myChart: this.caloriesChart })
            }.height(140).width('100%')
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
          .borderRadius(16)
          .padding(12)
          .margin({ bottom: 12 })

          // ====== 卡片2：步数 ======
          Column({ space: 6 }) {
            Text('步数统计')
              .fontSize(18).fontColor('#41BD10').fontWeight(FontWeight.Bold)

            Row({ space: 24 }) {
              Column() {
                Text('总步数').fontSize(14).fontColor('#41BD10')
                Text(`${this.totalSteps}`).fontSize(20).fontColor('#000').fontWeight(FontWeight.Bold)
                Text('步').fontSize(12).fontColor('#41BD10')
              }

              Column() {
                Text('平均每日').fontSize(14).fontColor('#41BD10')
                Text(`${this.avgSteps}`).fontSize(20).fontColor('#000').fontWeight(FontWeight.Bold)
                Text('步').fontSize(12).fontColor('#41BD10')
              }
            }

            Column() {
              hmChart({ Options: this.stepsOptions, myChart: this.stepsChart })
            }.height(140).width('100%')
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
          .borderRadius(16)
          .padding(12)
          .margin({ bottom: 12 })

          // ====== 卡片3：睡眠 ======
          Column({ space: 6 }) {
            Text('睡眠时长')
              .fontSize(18).fontColor('#04BFFF').fontWeight(FontWeight.Bold)

            Row({ space: 24 }) {
              Column() {
                Text('总时长').fontSize(14).fontColor('#04BFFF')
                Text(`${this.totalSleepMinutes}`).fontSize(20).fontColor('#000').fontWeight(FontWeight.Bold)
                Text('分钟').fontSize(12).fontColor('#04BFFF')
              }

              Column() {
                Text('平均每日').fontSize(14).fontColor('#04BFFF')
                Text(`${this.avgSleepMinutes}`).fontSize(20).fontColor('#000').fontWeight(FontWeight.Bold)
                Text('分钟').fontSize(12).fontColor('#04BFFF')
              }
            }

            Column() {
              hmChart({ Options: this.sleepOptions, myChart: this.sleepChart })
            }.height(200).width('100%')
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
          .borderRadius(16)
          .padding(12)
        }
        .padding(16)
        .width('100%')
      }
      .edgeEffect(EdgeEffect.Spring) // 边界效果
      .width('100%')
      .height('100%') // 关键：设置滚动区域高度
    }
    .width('100%')
    .height('100%') // 确保外层占满屏幕
  }
}
