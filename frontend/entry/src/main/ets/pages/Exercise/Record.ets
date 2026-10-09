import { API_BASE_URL } from '../../common/ApiConfig';
import { preferences } from '@kit.ArkData';
import http from '@ohos.net.http';
import { router } from '@kit.ArkUI';

// 声明接口
interface HealthData {
  recordId: number;
  type: string;
  recordedAt: string;
  steps: number;
  calories: number;
  distanceM: number;
  activityType: string;
  durationMin: number;
  averageHeartRate: number;
}

interface HealthRes {
  msg: string;
  code: number;
  data: HealthData[];
}

interface DataRecord {
  type: string;
  icon: Resource;
  date: string; // 新增：用于显示年月日
  time: string; // 修改：固定显示"15min"
  distance: number;
  calories: number;
  heartRate: number;
  color: string;
}

@Component
export struct Record {
  @State records: DataRecord[] = [];
  @State healthData: HealthData[] = [];
  @State offsetX: string = '0%';
  @State bgColor: string = '#4951FF'; // 默认颜色
  @State activeButton: string = 'running';
  @State isLoading: boolean = true;
  @State errorMessage: string = '';

  async aboutToAppear() {
    this.isLoading = true;
    this.errorMessage = '';
    try {
      const preferencesData = await preferences.getPreferences(getContext(), 'token');
      const token = await preferencesData.get('token', '');

      const httpRequest = http.createHttp();
      const response = await httpRequest.request(
        `${API_BASE_URL}/health/records?type=STEPS`,
        {
          method: http.RequestMethod.GET,
          header: { "Authorization": `Bearer ${token}` }
        }
      );

      if (response.responseCode === 200) {
        const result: HealthRes = JSON.parse(response.result as string) as HealthRes;
        this.healthData = result.data;
        this.updateRecords();
      } else {
        this.errorMessage = '运动记录加载失败';
      }
    } catch (error) {
      this.errorMessage = '网络连接失败，请稍后重试';
    } finally {
      this.isLoading = false;
    }
  }

  private updateRecords() {
    // 创建符合DataRecord接口的对象数组
    const newRecords: DataRecord[] = this.healthData.map((item: HealthData) => {
      const isRunning = item.activityType === 'RUN';
      const record: DataRecord = {
        type: isRunning ? '跑步' : '步行',
        icon: isRunning ? $r('app.media.person_running') : $r('app.media.person_walking'),
        date: this.formatDate(item.recordedAt.substring(0, 10)),
        time: `${item.durationMin}min`,
        distance: item.distanceM / 1000,
        calories: item.calories,
        heartRate: item.averageHeartRate,
        color: isRunning ? '#3CBB00' : '#FE7B04',
      };
      return record;
    });

    this.records = newRecords;
  }

  // 新增：日期格式化方法（YYYY-MM-DD → YYYY/MM/DD）
  private formatDate(dateStr: string): string {
    return dateStr.replace(/-/g, '/');
  }

  // 新增：跳转到详情页方法
  private navigateToDetail(record: DataRecord) {
    router.pushUrl({
      url: 'pages/Exercise/record_card',
      params: {
        type: record.type,
        icon: record.icon.id, // 传递图标资源ID
        date: record.date,
        time: record.time,
        distance: record.distance.toFixed(2),
        calories: record.calories,
        heartRate: record.heartRate
      }
    });
  }

  build() {
    Scroll() {
      Column() {
        Row() {
          Text('运动记录')
            .fontSize(30)
            .fontWeight(600)
            .fontColor('#000')
            .margin({ left: 25, top: 30, bottom: 25 })
        }.width('100%')

        Column() {
          Column() {
            Stack({ alignContent: Alignment.Top }) {
              // 胶囊背景
              Button()
                .position({ x: this.offsetX })
                .animation({ duration: 220, curve: Curve.EaseInOut })
                .width('50%')
                .height(40)
                .backgroundColor(this.bgColor)
                .borderRadius(40)


              Row() {
                // 跑步按钮
                Button() {
                  Image($r('app.media.person_running'))
                    .width(20).height(20)
                    .fillColor(this.activeButton === 'running' ? Color.White : '#333333')
                }
                .width('50%')
                .height(40)
                .backgroundColor(Color.Transparent)
                .borderRadius({ topLeft: 40, bottomLeft: 40 })
                .onClick(() => {
                  this.activeButton = 'running';
                  this.offsetX = '0%';
                  this.bgColor = '#3CBB00';
                })

                // 步行按钮
                Button() {
                  Image($r('app.media.person_walking'))
                    .width(20).height(20)
                    .fillColor(this.activeButton === 'walking' ? Color.White : '#333333')
                }
                .width('50%')
                .height(40)
                .backgroundColor(Color.Transparent)
                .borderRadius({ topRight: 40, bottomRight: 40 })
                .onClick(() => {
                  this.activeButton = 'walking';
                  this.offsetX = '50%';
                  this.bgColor = '#FE7B04';
                })
              }
              .width("100%").height(40).justifyContent(FlexAlign.Center)
            }
            .width("100%")
            .margin({ bottom: 30 }).padding(5)

          }
          .width('100%')
          .height(50)
          .backgroundColor("rgba(255,255,255,0.5)")
          .borderRadius(40)
          .backgroundBrightness({ rate: 0.5, lightUpDegree: 0.5 })
          .backgroundBlurStyle(BlurStyle.Thin, {
            colorMode: ThemeColorMode.LIGHT,
            adaptiveColor: AdaptiveColor.DEFAULT,
            scale: 1
          })
        }
        .padding({ left: 15, right: 15 }).margin({ bottom: 10 })

        Column() {
          if (this.isLoading) {
            LoadingProgress().width(44).height(44).margin({ top: 30 })
          } else if (this.errorMessage.length > 0) {
            Text(this.errorMessage).fontColor('#C62828').margin({ top: 30, bottom: 12 })
            Button('重试').onClick(() => this.aboutToAppear())
          } else if (this.records.length === 0) {
            Text('暂无运动记录，点击右下角按钮录入').fontColor('#777').margin({ top: 30 })
          }
          ForEach(this.records.filter(item =>
          (this.activeButton === 'running' && item.type === '跑步') ||
            (this.activeButton === 'walking' && item.type === '步行')
          ), (item: DataRecord) => {
            Stack() {
              Text('')
                .borderRadius(30)
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
                  Stack() {
                    Row() {
                    }.width(28).height(28).borderRadius('50%').backgroundColor(item.color);

                    Image(item.icon).width(16).height(16).fillColor('#fff');
                  }.margin({ right: 10 });

                  Column() {
                    Flex() {
                      Text(item.type).fontSize(10).fontWeight(FontWeight.Bold);
                      Row() {
                        Text(item.date)// 修改：显示日期而非时间
                          .fontColor("#9A8D9C")
                          .fontSize(10)
                          .fontWeight(FontWeight.Bold)
                          .margin({ right: 5 });
                        Image($r('app.media.chevron_right')).width(13).height(13).fillColor("#9A8D9C");
                      }.position({ right: 50 });
                    };

                    Row() {
                      Text(`${item.distance.toFixed(2)}`)
                        .fontSize(20)
                        .fontColor('item.color')
                        .fontWeight(FontWeight.Bold)
                        .margin({ right: 10 });
                      Text('公里')
                        .width('100%')
                        .fontSize(10)
                        .margin({ bottom: 2 })
                        .fontWeight(FontWeight.Bold);
                    }.alignItems(VerticalAlign.Bottom);
                  };

                  Text(item.date)// 修改：显示日期
                    .fontColor("#fff")
                    .fontSize(10)
                    .fontWeight(FontWeight.Bold)
                    .width("100%");
                }.width("100%");

                Divider()
                  .color('#AE8EAF')
                  .margin({ bottom: 10, top: 10 })
                  .strokeWidth(0.3)
                  .opacity(0.5);

                Flex({ justifyContent: FlexAlign.SpaceBetween }) {
                  Row() {
                    Text(`时间   `).fontSize(10).fontWeight(FontWeight.Bold);
                    Text(item.time)// 修改：固定显示"15min"
                      .fontSize(10)
                      .fontColor(item.color)
                      .fontWeight(FontWeight.Bold);
                  };

                  Row() {
                    Text(`消耗   `).fontSize(10).fontWeight(FontWeight.Bold);
                    Text(`${item.calories}千卡`)
                      .fontSize(10)
                      .fontColor(item.color)
                      .fontWeight(FontWeight.Bold);
                  };

                  Row() {
                    Text(`平均心率   `).fontSize(10).fontWeight(FontWeight.Bold);
                    Text(`${item.heartRate}次/分钟`)
                      .fontSize(10)
                      .fontColor(item.color)
                      .fontWeight(FontWeight.Bold);
                  };
                };
              }.width("100%").padding(20)
            }
            .onClick(() => {
              this.navigateToDetail(item); // 添加点击事件
            })
            .padding({ right: 15, left: 15 });

          });
        }.width('100%').height("100%");
      }
    }
    .height("100%")
    .edgeEffect(EdgeEffect.Spring)
    .scrollable(ScrollDirection.Vertical)
    .backgroundImage($r('app.media.back_plus'))
    .backgroundImageSize({ width: '100%', height: '100%' })
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }
}
