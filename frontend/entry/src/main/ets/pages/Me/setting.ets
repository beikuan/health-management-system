import { preferences } from '@kit.ArkData';
import { router } from '@kit.ArkUI';

@Entry
@Component
struct Setting {
  build() {
    Column() {
      // 顶部标题栏
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
      }.height(80).width('100%')

      Scroll() {
        Column() {
          // 关于区域 - 修改后
          Stack(){
            Text('')
              .borderRadius(30)
              .backgroundColor("#fff")
              .width('100%')
              .height('60%') // 自适应高度
              .foregroundBlurStyle(BlurStyle.Thin, {
                colorMode: ThemeColorMode.LIGHT,
                adaptiveColor: AdaptiveColor.DEFAULT,
                scale: 0.05
              })
              .opacity(0.7)

            Column() {
              Text('关于这个APP')
                .fontSize(18)
                .fontWeight(FontWeight.Bold)

              Text('      爱自己，就要了解自己。 规律的运动、良好的睡眠、稳定的健康指标，是拥抱精彩生活的基础。\n' + '\n' +
                '      “Me” 正是你全面了解自己的伙伴！它将你分散在 “健身” 和 “健康” 等不同 App 中的宝贵数据聚合一体，通过智能分析与直观展现，' +
                '为你呈现独一无二的运动健康全景图。告别数据孤岛，拥抱一目了然的趋势洞察，让追踪每一步成长都变得轻松、清晰、有动力。\n' + '\n' +
                '      成为更好的 Me，从更懂你的数据开始。')
                .fontColor('#555')
                .fontSize(14)
                .margin({top:5})

              Text('版本号：1.0.0')
                .fontColor('#999')
                .fontSize(12)
                .margin({top:5})
            }
            .padding(15)
            .width('100%') // 确保内容宽度填满
          }
          .margin({bottom:10})
          .layoutWeight(1) // 关键：使Stack高度自适应

          // 退出登录按钮
          Button('退出登录')
            .width('100%')
            .height(40)
            .backgroundColor('rgba(255,235,238,0.5)')
            .fontColor('#ffdb5c5c')
            .margin({ top: 10 ,bottom:10})
            .onClick(async () => {
              // 清除当前用户的缓存信息
              const preferencesData = await preferences.getPreferences(getContext(), 'token')
              await preferencesData.delete('token')
              await preferencesData.flush()
              // 跳转登录页
              router.replaceUrl({ url: 'pages/login/Login' })
            })
        }
        .padding({ left: 15, right: 15, top: 10 })
      }
      .edgeEffect(EdgeEffect.Spring)
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.Off)
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundImage($r('app.media.back_plus'))
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }
}
