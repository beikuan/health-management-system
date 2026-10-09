import { API_BASE_URL } from '../../common/ApiConfig';
import { preferences } from '@kit.ArkData';
import http from '@ohos.net.http';
import { router } from '@kit.ArkUI';

interface Menu {
  title: string,
  subtitle: string,
  icon: Resource
}

interface UserInfo {
  userId: string,
  name: string
}

interface Res {
  msg: string,
  code: number,
  data: UserInfo
}

@Component
export struct Mine {
  @State userInfo: UserInfo = {
    userId: '',
    name: ''
  }

  async aboutToAppear() {
    await this.onPageShow(); // 初始加载时调用
  }

  async onPageShow() {
    // 获取登录时候缓存的userId
    const preferencesData = await preferences.getPreferences(getContext(), 'token')
    const token = await preferencesData.get('token', '')

    const res = await http.createHttp().request(`${API_BASE_URL}/user/v1/info`, {
      header: {
        "Authorization": `Bearer ${token}`
      }
    })
    const resData: Res = JSON.parse(res.result as string) as Res
    this.userInfo = resData.data
  }

  @State menus: Menu[] = [
    { title: '健康数据', subtitle: '查看历史数据', icon: $r('app.media.background') },
    { title: '锻炼目标', subtitle: '灵活设置你的运动目标', icon: $r('app.media.background') },
    { title: '常用运动类型', subtitle: '可切换‘数据统计’与‘运动记录’中的数据类型', icon: $r('app.media.background') },
    { title: '设置', subtitle: '深色模式|每周第一天....', icon: $r('app.media.background') }
  ]
  @State currentRating: number = 4 // 接收后端输入--------------------------------

  build() {
    Column() {
      Scroll() {
        Column() {
          Row() {
            Text('Me')
              .fontSize(30)
              .fontWeight(600)
              .width("100%")
              .fontColor('#000')
              .margin({ left: 30, top: 30, bottom: 25 })
          }

          Column() {
            Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
              Image($r('app.media.user')).width(120).height(120).objectFit(ImageFit.Contain)
            }

            Text(this.userInfo.name).margin({ top: 10 }).fontWeight(600).fontSize(18)
            Text(`ID:${this.userInfo.userId}`).margin({ top: 10 }).fontColor('#78909c').fontSize(18)
          }.padding({ top: 30 })
          .onClick(() => {
            router.pushUrl({ url: 'pages/login/EditUserInfo' })
          })

          Column() {
            // 心率
            Stack() {
              Text('')
                .borderRadius(25)
                .backgroundColor("#fff")
                .width('100%')
                .height(85)
                .foregroundBlurStyle(BlurStyle.Thin,
                  { colorMode: ThemeColorMode.LIGHT, adaptiveColor: AdaptiveColor.DEFAULT, scale: 0.05 })
                .opacity(0.7)
              Column() {
                Row() {
                  Stack() {
                    Image($r('app.media.heart_rate')).width(48).height(48).fillColor('#fff')
                  }.margin({ right: 10 })

                  Row() {
                    Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceBetween }) {
                      Column() {
                        Text('心率区间').fontSize(15).fontWeight(FontWeight.Bold)
                      }.alignItems(HorizontalAlign.Start)
                    }
                  }

                  Image($r('app.media.chevron_right')).width(16).height(16).position({ right: 0, top: 16 })
                }.alignItems(VerticalAlign.Center)
              }
              .width("100%")
              .margin(10)
              .padding(20)
            }
            .onClick(() => {
              router.pushUrl({ url: 'pages/Me/healthyRate' })
            })

            // 锻炼目标
            Stack() {
              Text('')
                .borderRadius(25)
                .backgroundColor("#fff")
                .width('100%')
                .height(85)
                .foregroundBlurStyle(BlurStyle.Thin,
                  { colorMode: ThemeColorMode.LIGHT, adaptiveColor: AdaptiveColor.DEFAULT, scale: 0.05 })
                .opacity(0.7)
              Column() {
                Row() {
                  Stack() {
                    Image($r('app.media.target')).width(48).height(48).fillColor('#fff')
                  }.margin({ right: 10 })

                  Row() {
                    Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceBetween }) {
                      Column() {
                        Text('锻炼目标').fontSize(15).fontWeight(FontWeight.Bold)
                      }.alignItems(HorizontalAlign.Start)
                    }
                  }

                  Image($r('app.media.chevron_right')).width(16).height(16).position({ right: 0, top: 16 })
                }.alignItems(VerticalAlign.Center)
              }
              .width("100%")
              .margin(10)
              .padding(20)
            }
            .onClick(() => {
              router.pushUrl({ url: "pages/Me/targetSet" })
            })

            // 设置
            Stack() {
              Text('')
                .borderRadius(25)
                .backgroundColor("#fff")
                .width('100%')
                .height(85)
                .foregroundBlurStyle(BlurStyle.Thin,
                  { colorMode: ThemeColorMode.LIGHT, adaptiveColor: AdaptiveColor.DEFAULT, scale: 0.05 })
                .opacity(0.7)
              Column() {
                Row() {
                  Stack() {
                    Image($r('app.media.setting')).width(48).height(48).fillColor('#fff')
                  }.margin({ right: 10 })

                  Row() {
                    Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceBetween }) {
                      Column() {
                        Text('设置').fontSize(15).fontWeight(FontWeight.Bold)
                      }.alignItems(HorizontalAlign.Start)
                    }
                  }

                  Image($r('app.media.chevron_right')).width(16).height(16).position({ right: 0, top: 16 })
                }.alignItems(VerticalAlign.Center)
              }
              .width("100%")
              .margin(10)
              .padding(20)
            }
            .onClick(() => {
              router.pushUrl({ url: 'pages/Me/setting' })
            })

          }.padding({ left: 15, right: 15 }).margin({ top: 40 })
        }
      }
      .edgeEffect(EdgeEffect.Spring)
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.Off)
      .layoutWeight(1) // 这就在这里！
    }
    .width('100%')
    .height('100%')
    .backgroundImage($r('app.media.back_plus'))
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .onVisibleAreaChange([0.0, 1.0], (isVisible: boolean, currentRatio: number) => {
      if (isVisible && currentRatio == 1.0) {
        this.onPageShow()
      }
    })
  }
}
