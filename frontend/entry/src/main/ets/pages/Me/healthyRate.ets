import { router } from '@kit.ArkUI'
import {HmLineChart} from './healthyRateLine'

@Entry
@Component
struct healthyRate {
  build() {
    Column() {
      Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
        Image($r('app.media.chevron_left')).width(30).height(30)
          .onClick(() => {
            router.back()
          })
        Text('心率区间')
          .width('80%')
          .fontSize(25)
          .fontColor('#000000')
          .fontWeight(FontWeight.Bold)
          .textAlign(TextAlign.Center)
      }
      .height(80)
      .width('100%')

      Scroll() {
        // 添加白色背景容器
        Column() {
          // 内容区域
          Column() {
            Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
              Image($r('app.media.heart_rate'))
                .width(100)
                .height(100)
                .objectFit(ImageFit.Contain)
            }
            .backgroundColor('#E6F6F9')
            .width(100)
            .height(100)
            .borderRadius('50%')
            .margin({ bottom: 80 })

            HmLineChart()
              .height(300)
              .width("100%")
          }
          .padding(20) // 添加内边距使内容不贴边
        }
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
        .width('100%')
      }
      .margin({ top: 10 }) // 与顶部导航栏的间距

    }
    .height('100%')
    .width('100%')
    .backgroundImage($r('app.media.back_plus'))
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }
}