import { API_BASE_URL } from '../../common/ApiConfig';
import { preferences } from '@kit.ArkData';
import http from '@ohos.net.http';
import promptAction from '@ohos.promptAction'; // 用于显示调试信息

interface DataRecord {
  type: string;
  icon: Resource;
  class: string
}

interface HeartRateRes {
  msg: string;
  code: number;
  data: HeartRate[];
}

interface HeartRate {
  latestValue: number; // 最新心率值（次/分钟）
  latestDate: string; // 最新心率日期（格式如 "2024-01-01"）
  weeklyAvg: number; // 周平均心率
  monthlyAvg: number; // 月平均心率
  yearlyAvg: number; // 年平均心率
}

interface BloodOxygenRes {
  msg: string;
  code: number;
  data: BloodOxygen[];
}

interface BloodOxygen {
  latestValue: number;
  latestDate: string;
  weeklyAvg: number;
  monthlyAvg: number;
  yearlyAvg: number;
}

interface RespirationRes {
  msg: string;
  code: number;
  data: Respiration[];
}

interface Respiration {
  latestValue: number;
  latestDate: string;
  weeklyAvg: number;
  monthlyAvg: number;
  yearlyAvg: number;
}

interface StepsRes {
  msg: string;
  code: number;
  data: Steps[];
}

interface Steps {
  latestValue: number;
  latestDate: string;
  weeklyAvg: number;
  monthlyAvg: number;
  yearlyAvg: number;
}

interface BloodPressureRes {
  msg: string;
  code: number;
  data: BloodPressure[];
}

interface BloodPressure {
  latestValue: number;
  latestDate: string;
  weeklyAvg: number;
  monthlyAvg: number;
  yearlyAvg: number;
}

interface UricAcidRes {
  msg: string;
  code: number;
  data: UricAcid[];
}

interface UricAcid {
  latestValue: number;
  latestDate: string;
  weeklyAvg: number;
  monthlyAvg: number;
  yearlyAvg: number;
}

@Component
export struct Statistics {
  @State offsetX: string = '0%';
  @State bgColor: string = '#3CBB00';
  @State activeButton: string = 'sport';
  private records: DataRecord[] = [
    {
      type: '步数',
      icon: $r('app.media.person_walking'),
      class: 'sport',
    },
    {
      type: '心率',
      icon: $r('app.media.heart_rate_solid'),
      class: 'health',
    },
    {
      type: '血氧',
      icon: $r('app.media.blood_oxygen'),
      class: 'health',
    },
    {
      type: '呼吸率',
      icon: $r('app.media.mingcute_lungs_fill'),
      class: 'health',
    },
    {
      type: '血压',
      icon: $r('app.media.blood_pressure'),
      class: 'health',
    },
    {
      type: '尿酸',
      icon: $r('app.media.blood_oxygen'),
      class: 'health',
    },
  ];
  @State H: HeartRate = {
    latestValue: 0,
    latestDate: "",
    weeklyAvg: 0,
    monthlyAvg: 0,
    yearlyAvg: 0
  };
  @State SpO2: BloodOxygen = {
    latestValue: 0,
    latestDate: "",
    weeklyAvg: 0,
    monthlyAvg: 0,
    yearlyAvg: 0
  };
  @State R: Respiration = {
    latestValue: 0,
    latestDate: "",
    weeklyAvg: 0,
    monthlyAvg: 0,
    yearlyAvg: 0
  };
  @State S: Steps = {
    latestValue: 0,
    latestDate: "",
    weeklyAvg: 0,
    monthlyAvg: 0,
    yearlyAvg: 0
  };
  @State BP: BloodPressure = {
    latestValue: 0,
    latestDate: "",
    weeklyAvg: 0,
    monthlyAvg: 0,
    yearlyAvg: 0
  };
  @State UA: UricAcid = {
    latestValue: 0,
    latestDate: "",
    weeklyAvg: 0,
    monthlyAvg: 0,
    yearlyAvg: 0
  };
  @State isLoading: boolean = true;

  async aboutToAppear() {
    const preferencesData = await preferences.getPreferences(getContext(), 'token')
    const token = await preferencesData.get('token', '')

    const httpClient = http.createHttp();
    const results = await Promise.all([
      httpClient.request(`${API_BASE_URL}/r/heart/rate`, { header: { "Authorization": `Bearer ${token}` } }),
      httpClient.request(`${API_BASE_URL}/r/blood/oxygen`, { header: { "Authorization": `Bearer ${token}` } }),
      httpClient.request(`${API_BASE_URL}/r/respiration`, { header: { "Authorization": `Bearer ${token}` } }),
      httpClient.request(`${API_BASE_URL}/r/step/count`, { header: { "Authorization": `Bearer ${token}` } }),
      httpClient.request(`${API_BASE_URL}/r/blood/pressure`, { header: { "Authorization": `Bearer ${token}` } }),
      httpClient.request(`${API_BASE_URL}/r/uric/acid`, { header: { "Authorization": `Bearer ${token}` } }),
    ]);
    try {
      const HRes: HeartRateRes = JSON.parse(results[0].result as string)
      const SpO2Res: BloodOxygenRes = JSON.parse(results[1].result as string)
      const RRes: RespirationRes = JSON.parse(results[2].result as string)
      const SRes: StepsRes = JSON.parse(results[3].result as string)
      const BPRes: BloodPressureRes = JSON.parse(results[4].result as string)
      const UARes: UricAcidRes = JSON.parse(results[5].result as string)
      if (HRes.code === 200 && HRes.data.length > 0) {
        this.H = HRes.data[0]
      }
      if (SpO2Res.code === 200 && SpO2Res.data.length > 0) {
        this.SpO2 = SpO2Res.data[0]
      }
      if (RRes.code === 200 && RRes.data.length > 0) {
        this.R = RRes.data[0]
      }
      if (SRes.code === 200 && SRes.data.length > 0) {
        this.S = SRes.data[0]
      }
      if (BPRes.code === 200 && BPRes.data.length > 0) {
        this.BP = BPRes.data[0]
      }
      if (UARes.code === 200 && UARes.data.length > 0) {
        this.UA = UARes.data[0]
      }
    } catch (e) {
      promptAction.showToast({ message: '解析失败' });
      console.error('JSON 解析错误:', e)
    } finally {
      this.isLoading = false;
    }
  }

  build() {
    Scroll() {
      Column() {
        Row() {
          Text('数据统计')
            .fontSize(30)
            .fontWeight(600)
            .fontColor('#000')
            .margin({ left: 25, top: 30, bottom: 25 })
        }.width('100%')

        Column() {
          Stack() {
            Text('')
              .borderRadius(25)
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
                  }
                  .width(28).height(28).borderRadius('50%').backgroundColor('#FE7B04')

                  Image($r('app.media.person_walking')).width(16).height(16).fillColor('#fff')
                }.margin({ right: 10 })

                Column() {
                  Flex() {
                    Text('步行').fontSize(10).fontWeight(FontWeight.Bold)
                    Row() {
                      Text(this.S.latestDate).fontColor("#9A8D9C").fontSize(10)
                        .fontWeight(FontWeight.Bold).margin({ right: 5 })
                    }.position({ right: 50 })
                  }

                  Row() {
                    Text(`${this.S.latestValue}`).fontSize(20).fontColor('#FE7B04')
                      .fontWeight(FontWeight.Bold).margin({ right: 10 })
                    Text('步').width('100%').fontSize(10).margin({ bottom: 2 })
                      .fontWeight(FontWeight.Bold)
                  }.alignItems(VerticalAlign.Bottom)
                }
              }.width("100%")

              Divider()
                .color('#AE8EAF').margin({ bottom: 10, top: 10 })
                .strokeWidth(0.3).opacity(0.5)
              Flex({ justifyContent: FlexAlign.SpaceBetween }) {
                Row() {
                  Text(`周均    `).fontSize(10).fontWeight(FontWeight.Bold)
                  Text(`${this.S.weeklyAvg} 步`).fontSize(10).fontColor('#FE7B04')
                    .fontWeight(FontWeight.Bold)
                }

                Row() {
                  Text(`月均    `).fontSize(10).fontWeight(FontWeight.Bold)
                  Text(`${this.S.monthlyAvg} 步`).fontSize(10).fontColor('#FE7B04')
                    .fontWeight(FontWeight.Bold)
                }

                Row() {
                  Text(`年均    `).fontSize(10).fontWeight(FontWeight.Bold)
                  Text(`${this.S.yearlyAvg} 步`).fontSize(10).fontColor('#FE7B04')
                    .fontWeight(FontWeight.Bold)
                }
              }
            }
            .width("100%").padding(20)

          }.padding({ right: 15, left: 15 })

          Stack() {
            Text('')
              .borderRadius(25)
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
                  }
                  .width(28).height(28).borderRadius('50%').backgroundColor('#D90100')

                  Image($r('app.media.heart_rate_solid')).width(32).height(32).fillColor('#fff')
                }.margin({ right: 10 })

                Column() {
                  Flex() {
                    Text('心率').fontSize(10).fontWeight(FontWeight.Bold)
                    Row() {
                      Text(this.H.latestDate).fontColor("#9A8D9C").fontSize(10)
                        .fontWeight(FontWeight.Bold).margin({ right: 5 })
                    }.position({ right: 50 })
                  }

                  Row() {
                    Text(`${this.H.latestValue}`).fontSize(20).fontColor('#D90100')
                      .fontWeight(FontWeight.Bold).margin({ right: 10 })
                    Text('次/分钟').width('100%').fontSize(10).margin({ bottom: 2 })
                      .fontWeight(FontWeight.Bold)
                  }.alignItems(VerticalAlign.Bottom)
                }
              }.width("100%")

              Divider()
                .color('#AE8EAF').margin({ bottom: 10, top: 10 })
                .strokeWidth(0.3).opacity(0.5)
              Flex({ justifyContent: FlexAlign.SpaceBetween }) {
                Row() {
                  Text(`周均    `).fontSize(10).fontWeight(FontWeight.Bold)
                  Text(`${this.H.weeklyAvg} 次/分钟`).fontSize(10).fontColor('#D90100')
                    .fontWeight(FontWeight.Bold)
                }

                Row() {
                  Text(`月均    `).fontSize(10).fontWeight(FontWeight.Bold)
                  Text(`${this.H.monthlyAvg} 次/分钟`).fontSize(10).fontColor('#D90100')
                    .fontWeight(FontWeight.Bold)
                }

                Row() {
                  Text(`年均    `).fontSize(10).fontWeight(FontWeight.Bold)
                  Text(`${this.H.yearlyAvg} 次/分钟`).fontSize(10).fontColor('#D90100')
                    .fontWeight(FontWeight.Bold)
                }
              }
            }
            .width("100%").padding(20)

          }.padding({ right: 15, left: 15 })

          Stack() {
            Text('')
              .borderRadius(25)
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
                  }
                  .width(28).height(28).borderRadius('50%').backgroundColor('#E60B66')

                  Image($r('app.media.blood_pressure')).width(16).height(16).fillColor('#fff')
                }.margin({ right: 10 })

                Column() {
                  Flex() {
                    Text('血压').fontSize(10).fontWeight(FontWeight.Bold)
                    Row() {
                      Text(this.BP.latestDate).fontColor("#9A8D9C").fontSize(10)
                        .fontWeight(FontWeight.Bold).margin({ right: 5 })
                    }.position({ right: 50 })
                  }

                  Row() {
                    Text(`${this.BP.latestValue}`).fontSize(20).fontColor('#E60B66')
                      .fontWeight(FontWeight.Bold).margin({ right: 10 })
                    Text('毫米汞柱').width('100%').fontSize(10).margin({ bottom: 2 })
                      .fontWeight(FontWeight.Bold)
                  }.alignItems(VerticalAlign.Bottom)
                }
              }.width("100%")

              Divider()
                .color('#AE8EAF').margin({ bottom: 10, top: 10 })
                .strokeWidth(0.3).opacity(0.5)
              Flex({ justifyContent: FlexAlign.SpaceBetween }) {
                Row() {
                  Text(`周均  `).fontSize(10).fontWeight(FontWeight.Bold)
                  Text(`${this.BP.weeklyAvg} 毫米汞柱`).fontSize(10).fontColor('#E60B66')
                    .fontWeight(FontWeight.Bold)
                }

                Row() {
                  Text(`月均  `).fontSize(10).fontWeight(FontWeight.Bold)
                  Text(`${this.BP.monthlyAvg} 毫米汞柱`).fontSize(10).fontColor('#E60B66')
                    .fontWeight(FontWeight.Bold)
                }

                Row() {
                  Text(`年均  `).fontSize(10).fontWeight(FontWeight.Bold)
                  Text(`${this.BP.yearlyAvg} 毫米汞柱`).fontSize(10).fontColor('#E60B66')
                    .fontWeight(FontWeight.Bold)
                }
              }
            }
            .width("100%").padding(20)

          }.padding({ right: 15, left: 15 })

          Stack() {
            Text('')
              .borderRadius(25)
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
                  }
                  .width(28).height(28).borderRadius('50%').backgroundColor('#F90948')

                  Image($r('app.media.blood_oxygen')).width(16).height(16).fillColor('#fff')
                }.margin({ right: 10 })

                Column() {
                  Flex() {
                    Text('血氧').fontSize(10).fontWeight(FontWeight.Bold)
                    Row() {
                      Text(this.SpO2.latestDate).fontColor("#9A8D9C").fontSize(10)
                        .fontWeight(FontWeight.Bold).margin({ right: 5 })
                    }.position({ right: 50 })
                  }

                  Row() {
                    Text(`${this.SpO2.latestValue}`).fontSize(20).fontColor('#F90948')
                      .fontWeight(FontWeight.Bold).margin({ right: 10 })
                    Text('%').width('100%').fontSize(15).margin({ bottom: 2 })
                      .fontWeight(FontWeight.Bold)
                  }.alignItems(VerticalAlign.Bottom)
                }
              }.width("100%")

              Divider()
                .color('#AE8EAF').margin({ bottom: 10, top: 10 })
                .strokeWidth(0.3).opacity(0.5)
              Flex({ justifyContent: FlexAlign.SpaceBetween }) {
                Row() {
                  Text(`周均    `).fontSize(10).fontWeight(FontWeight.Bold)
                  Text(`${this.SpO2.weeklyAvg} %`).fontSize(10).fontColor('#F90948')
                    .fontWeight(FontWeight.Bold)
                }

                Row() {
                  Text(`月均    `).fontSize(10).fontWeight(FontWeight.Bold)
                  Text(`${this.H.monthlyAvg} %`).fontSize(10).fontColor('#F90948')
                    .fontWeight(FontWeight.Bold)
                }

                Row() {
                  Text(`年均    `).fontSize(10).fontWeight(FontWeight.Bold)
                  Text(`${this.SpO2.yearlyAvg} %`).fontSize(10).fontColor('#F90948')
                    .fontWeight(FontWeight.Bold)
                }
              }
            }
            .width("100%").padding(20)

          }.padding({ right: 15, left: 15 })


          Stack() {
            Text('')
              .borderRadius(25)
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
                  }
                  .width(28).height(28).borderRadius('50%').backgroundColor('#3EBF05')

                  Image($r('app.media.mingcute_lungs_fill')).width(32).height(32).fillColor('#fff')
                }.margin({ right: 10 })

                Column() {
                  Flex() {
                    Text('呼吸率').fontSize(10).fontWeight(FontWeight.Bold)
                    Row() {
                      Text(this.R.latestDate).fontColor("#9A8D9C").fontSize(10)
                        .fontWeight(FontWeight.Bold).margin({ right: 5 })
                    }.position({ right: 50 })
                  }

                  Row() {
                    Text(`${this.R.latestValue}`).fontSize(20).fontColor('#3EBF05')
                      .fontWeight(FontWeight.Bold).margin({ right: 10 })
                    Text('次/分钟').width('100%').fontSize(10).margin({ bottom: 2 })
                      .fontWeight(FontWeight.Bold)
                  }.alignItems(VerticalAlign.Bottom)
                }
              }.width("100%")

              Divider()
                .color('#AE8EAF').margin({ bottom: 10, top: 10 })
                .strokeWidth(0.3).opacity(0.5)
              Flex({ justifyContent: FlexAlign.SpaceBetween }) {
                Row() {
                  Text(`周均    `).fontSize(10).fontWeight(FontWeight.Bold)
                  Text(`${this.R.weeklyAvg} 次/分钟`).fontSize(10).fontColor('#3EBF05')
                    .fontWeight(FontWeight.Bold)
                }

                Row() {
                  Text(`月均    `).fontSize(10).fontWeight(FontWeight.Bold)
                  Text(`${this.R.monthlyAvg} 次/分钟`).fontSize(10).fontColor('#3EBF05')
                    .fontWeight(FontWeight.Bold)
                }

                Row() {
                  Text(`年均    `).fontSize(10).fontWeight(FontWeight.Bold)
                  Text(`${this.R.yearlyAvg} 次/分钟`).fontSize(10).fontColor('#3EBF05')
                    .fontWeight(FontWeight.Bold)
                }
              }
            }
            .width("100%").padding(20)

          }.padding({ right: 15, left: 15 })

          Stack() {
            Text('')
              .borderRadius(25)
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
                  }
                  .width(28).height(28).borderRadius('50%').backgroundColor('#cb99e2')

                  Image($r('app.media.urci_acid')).width(16).height(16).fillColor('#fff')
                }.margin({ right: 10 })

                Column() {
                  Flex() {
                    Text('尿酸').fontSize(10).fontWeight(FontWeight.Bold)
                    Row() {
                      Text(this.UA.latestDate).fontColor("#9A8D9C").fontSize(10)
                        .fontWeight(FontWeight.Bold).margin({ right: 5 })
                    }.position({ right: 50 })
                  }

                  Row() {
                    Text(`${this.UA.latestValue}`).fontSize(20).fontColor('#cb99e2')
                      .fontWeight(FontWeight.Bold).margin({ right: 10 })
                    Text('umol').width('100%').fontSize(15).margin({ bottom: 2 })
                      .fontWeight(FontWeight.Bold)
                  }.alignItems(VerticalAlign.Bottom)
                }
              }.width("100%")

              Divider()
                .color('#AE8EAF').margin({ bottom: 10, top: 10 })
                .strokeWidth(0.3).opacity(0.5)
              Flex({ justifyContent: FlexAlign.SpaceBetween }) {
                Row() {
                  Text(`周均    `).fontSize(10).fontWeight(FontWeight.Bold)
                  Text(`${this.UA.weeklyAvg} umol`).fontSize(10).fontColor('#cb99e2')
                    .fontWeight(FontWeight.Bold)
                }

                Row() {
                  Text(`月均    `).fontSize(10).fontWeight(FontWeight.Bold)
                  Text(`${this.UA.monthlyAvg} umol`).fontSize(10).fontColor('#cb99e2')
                    .fontWeight(FontWeight.Bold)
                }

                Row() {
                  Text(`年均    `).fontSize(10).fontWeight(FontWeight.Bold)
                  Text(`${this.UA.yearlyAvg} umol`).fontSize(10).fontColor('#cb99e2')
                    .fontWeight(FontWeight.Bold)
                }
              }
            }
            .width("100%").padding(20)

          }.padding({ right: 15, left: 15 })
        }
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
