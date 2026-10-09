import { router } from '@kit.ArkUI';

// 定义路由参数接口
interface RecordParams {
  type: string;
  icon: string;
  date: string;
  time: string;
  distance: string;
  calories: number;
  heartRate: number;
}

@Entry
@Component
struct record_card {
  // 使用类型断言确保参数类型正确
  private params: RecordParams = router.getParams() as RecordParams;
  @State type: string = this.params?.type || '步行';
  @State icon: Resource = $r(this.params?.icon || 'app.media.person_walking');
  @State date: string = this.params?.date || '';
  @State time: string = this.params?.time || '15min';
  @State distance: string = this.params?.distance || '0.00';
  @State calories: number = this.params?.calories || 0;
  @State heartRate: number = this.params?.heartRate || 0;

  build() {

    Column() {
      // 返回按钮和标题
      Row() {
        Row() {
          Image($r('app.media.chevron_left')).fillColor("#FEA00A").width(20).height(20).margin(8)
          Text("返回").fontSize(16).fontColor("#FEA00A")
        }.margin({ right: 80 })
        .onClick(() => {
          router.back()
        })

        Text("运动详情").fontWeight(FontWeight.Bold)
      }.width("100%").margin({ bottom: 20 })

      // 主要内容区域
      Column() {
        // 运动类型卡片
        Column() {
          // 在record_card.ets中修改图标部分
          Stack() {
            Row() {
            }
            .width(60)
            .height(60)
            .borderRadius('50%')
            .backgroundColor(this.type === '跑步' ? '#3CBB00' : '#FE7B04')

            Image(this.type === '跑步' ? $r('app.media.person_running') : $r('app.media.person_walking'))
              .width(35)
              .height(35)
              .fillColor('#fff')
          }
          .width(70)
          .height(70)
          .borderRadius('50%')
          .backgroundColor("rgba(255,255,255,0.7)")
          .margin({ top: 30, bottom: 10 })

          Text(this.type)
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .width("100%")
            .textAlign(TextAlign.Center)
            .margin({ bottom: 20 })

          Row() {
            Text(this.distance)
              .fontSize(35)
              .fontWeight(600)
            Text("  公里")
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
          }
          .alignItems(VerticalAlign.Bottom)
          .margin({ bottom: 10 })

          Text(this.date)
            .fontSize(10)
            .fontColor("#9A8D9C")
            .fontWeight(FontWeight.Bold)

          // 详细信息卡片
          Stack() {
            Text('')
              .borderRadius(50)
              .width('100%')
              .height(85)
              .backgroundBrightness({ rate: 0.5, lightUpDegree: 0.5 })
              .backgroundBlurStyle(BlurStyle.Thin, {
                colorMode: ThemeColorMode.LIGHT,
                adaptiveColor: AdaptiveColor.DEFAULT,
                scale: 1
              })

            Column() {
              Row() {
                // 左侧内容
                Row() {
                  Stack() {
                    Row() {
                    }
                    .width(28)
                    .height(28)
                    .borderRadius('50%')
                    .backgroundColor(this.type === '跑步' ? '#3CBB00' : '#FE7B04')

                    Image(this.type === '跑步' ? $r('app.media.person_running') : $r('app.media.person_walking'))
                      .width(16)
                      .height(16)
                      .fillColor('#fff')
                  }
                  .margin({ right: 10 })

                  Text(this.type)
                    .fontSize(15)
                    .fontWeight(FontWeight.Bold)
                    .margin({ right: 10 })
                }

                // 右侧内容
                Row() {
                  Text(this.distance)
                    .fontSize(18)
                    .fontWeight(FontWeight.Bold)
                    .margin({ right: 10 })
                  Text('公里')
                    .fontSize(10)
                    .fontWeight(FontWeight.Bold)
                }
                .alignItems(VerticalAlign.Bottom)
              }
              .width("100%")
              .justifyContent(FlexAlign.SpaceBetween)

              Divider()
                .color('#AE8EAF')
                .margin({ bottom: 10, top: 10 })
                .strokeWidth(0.3)
                .opacity(0.5)

              Flex({ justifyContent: FlexAlign.SpaceBetween }) {
                Row() {
                  Text(`时间   `).fontSize(10).fontWeight(FontWeight.Bold);
                  Text(this.time)
                    .fontSize(10)
                    .fontColor(this.type === '跑步' ? '#3CBB00' : '#FE7B04')
                    .fontWeight(FontWeight.Bold);
                }

                Row() {
                  Text(`消耗   `).fontSize(10).fontWeight(FontWeight.Bold);
                  Text(`${this.calories}千卡`)
                    .fontSize(10)
                    .fontColor(this.type === '跑步' ? '#3CBB00' : '#FE7B04')
                    .fontWeight(FontWeight.Bold);
                }

                Row() {
                  Text(`平均心率   `).fontSize(10).fontWeight(FontWeight.Bold);
                  Text(`${this.heartRate}次/分钟`)
                    .fontSize(10)
                    .fontColor(this.type === '跑步' ? '#3CBB00' : '#FE7B04')
                    .fontWeight(FontWeight.Bold);
                }
              }
            }
            .width("100%")
            .padding({
              right: 30,
              left: 30,
              top: 30,
              bottom: 20
            })
            .margin({ bottom: 10 })
          }
          .padding({ left: 20, right: 20 })
        }
        .margin({ bottom: 10 })
        .width("100%")
        .borderRadius(30)
        .backgroundBrightness({ rate: 0.5, lightUpDegree: 0.5 })
        .backgroundBlurStyle(BlurStyle.Thin, {
          colorMode: ThemeColorMode.LIGHT,
          adaptiveColor: AdaptiveColor.DEFAULT,
          scale: 1
        })

        // 摘要数据区域
        Column() {
          Column() {
            Text("摘要数据").fontSize(16).fontWeight(900).width("100%").margin({ top: 20, bottom: 10 })
            Row() {
              Column() {
                Row() {
                  Stack() {
                    Row() {
                    }
                    .width(20)
                    .height(20)
                    .borderRadius('50%')
                    .backgroundColor('#08ACEF')

                    Image($r('app.media.mingcute_time_fill'))
                      .height(25)
                      .width(25)
                  }
                  .margin({ right: 5 })

                  Text("时长").fontSize(10).fontColor("#08ACEF").fontWeight(800)
                }
                .width("100%")

                Text(`${this.time}`)
                  .width("100%")
                  .fontWeight(800)
              }
              .width("50%")

              Column() {
                Row() {
                  Stack() {
                    Row() {
                    }
                    .width(20)
                    .height(20)
                    .borderRadius('50%')
                    .backgroundColor('#FF2614')

                    Image($r('app.media.mingcute_fire_fill'))
                      .height(25)
                      .width(25)
                  }
                  .margin({ right: 5 })

                  Text("活动消耗").fontSize(10).fontColor("#FF2614").fontWeight(800)
                }
                .width("100%")

                Row() {
                  Text(`${this.calories}`)
                    .fontWeight(800)
                    .margin({ right: 5 })
                  Text("千卡")
                    .width("100%")
                    .fontSize(8)
                    .fontColor("#9A8D9C")
                    .fontWeight(FontWeight.Bold)
                }
                .alignItems(VerticalAlign.Bottom)
              }
              .width("50%")
            }
            .margin({ bottom: 30 })
          }
          .padding({ left: 20, right: 20 })
        }
        .width("100%")
        .borderRadius(30)
        .backgroundBrightness({ rate: 0.5, lightUpDegree: 0.5 })
        .backgroundBlurStyle(BlurStyle.Thin, {
          colorMode: ThemeColorMode.LIGHT,
          adaptiveColor: AdaptiveColor.DEFAULT,
          scale: 1
        })
      }
      .padding({ left: 20, right: 20 })
    }
    .backgroundImage($r('app.media.back'))
    .height("100%")
    .width("100%")
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }
}