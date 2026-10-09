import { Index } from '../IndexPage/IndexPage'
import { Review } from '../Review/Review'
import { Statistics } from '../Statistics/Statistics'
import { Record } from '../Exercise/Record'
import { Mine } from '../Me/Mine'
import { router } from '@kit.ArkUI'

interface Tab {
  text: string,
  icon: Resource,
  activeIcon: Resource
}

@Entry
@Component
struct TabsPage {
  tabsData: Tab[] = [
    {
      text: '今天',
      icon: $r('app.media.face_smile'),
      activeIcon: $r('app.media.face_smile_yellow') // 黄色版本
    },
    {
      text: '回顾',
      icon: $r('app.media.calendarbt'),
      activeIcon: $r('app.media.calendarbt')
    },
    {
      text: '数据统计',
      icon: $r('app.media.data'),
      activeIcon: $r('app.media.data')
    },
    {
      text: '运动记录',
      icon: $r('app.media.person_running'),
      activeIcon: $r('app.media.person_running')
    },
    {
      text: 'Me',
      icon: $r('app.media.circle_user'),
      activeIcon: $r('app.media.circle_user_yellow') // 黄色版本
    }
  ]
  @State activeIndex: number = 0

  @Builder
  tabsBuilder(index: number) {
    Column() {
      if (index >= 1 && index <= 3) {
        // 中间三个加圆框
        Stack() {
          Row() {
          } // 圆背景容器
          .width(28)
          .height(28)
          .backgroundColor(index == this.activeIndex ? '#FEA00A' : '#9C98A8') // 背景色变黄
          .borderRadius(14)
          .border({
            width: 1,
            color: index == this.activeIndex ? '#FEA00A' : '#9C98A8'
          })

          Image(index == this.activeIndex ? this.tabsData[index].activeIcon : this.tabsData[index].icon)
            .width(16)
            .height(16)
        }
      } else {
        // 其他 tab 图标无圆框
        Image(index == this.activeIndex ? this.tabsData[index].activeIcon : this.tabsData[index].icon)
          .width(28)
          .height(28)
      }

      Text(this.tabsData[index].text)
        .margin({ top: 6 })
        .fontColor(index == this.activeIndex ? '#FEA00A' : '#8a8a8a')
        .fontSize(12)
    }
    .alignItems(HorizontalAlign.Center)
  }

  build() {
    Stack() {
      Column() {
        Tabs({ barPosition: BarPosition.End }) {
          TabContent() {
            Index()
          }.tabBar(this.tabsBuilder(0))
          .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])

          TabContent() {
            Review()
          }.tabBar(this.tabsBuilder(1))
          .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])

          TabContent() {
            Statistics()
          }.tabBar(this.tabsBuilder(2))
          .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])

          TabContent() {
            Record()
          }.tabBar(this.tabsBuilder(3))
          .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])

          TabContent() {
            Column() {
              Mine()
            }.height('100%')
          }.tabBar(this.tabsBuilder(4))
          .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
        }
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
        .onChange((index: number) => {
          this.activeIndex = index
        })
        .backgroundColor("#F1F1FB")

      }
      Button('+')
        .fontSize(30)
        .fontColor(Color.White)
        .width(54)
        .height(54)
        .borderRadius(27)
        .backgroundColor('#7C5CFC')
        .position({ right: 18, bottom: 92 })
        .onClick(() => router.pushUrl({ url: 'pages/health/AddHealthRecord' }))
    }.height('100%')
  }
}
