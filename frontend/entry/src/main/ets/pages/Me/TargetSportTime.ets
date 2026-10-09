import { API_BASE_URL } from '../../common/ApiConfig';
// StepGoalSetting.ets
import promptAction from '@ohos.promptAction';
import { preferences } from '@kit.ArkData';
import http from '@ohos.net.http';
import { PromptAction, router } from '@kit.ArkUI';

interface Res1 {
  msg: string;
  code: number;
  data: SportTime[];
}

interface SportTime {
  userId: string,
  sportTime: number;
}

@Entry
@Component
struct StepGoalSetting {
  // 使用静态数组定义步数选项
  @State presetGoals: number[] = [30, 40, 50, 60, 70, 80, 90, 100, 120, 130, 140, 150];
  @State selectedGoal: number = 60; //初始选中数据
  @State isLoading: boolean = false;
  @State itemHeight: number = 90; // 滑动区域数据的间隔
  @State userId: string = '';
  private scroller: Scroller = new Scroller();

  // 页面显示时加载用户当前设置
  async onPageShow() {
    try {
      const preferencesData = await preferences.getPreferences(getContext(), 'token');
      const token = await preferencesData.get('token', '');

      const httpRequest = http.createHttp();
      const response = await httpRequest.request(`${API_BASE_URL}/health/sport/time`, {
        header: { "Authorization": `Bearer ${token}` }
      });

      const responseData: Res1 = JSON.parse(response.result as string) as Res1;
      if (responseData.data.length > 0) {
        this.userId = responseData.data[0].userId;
      }

      if (!response || !response.result) {
        console.error('HTTP请求返回空结果');
        return;
      }

      let resultString: string;
      if (typeof response.result === 'string') {
        resultString = response.result;
      } else if (typeof response.result.toString === 'function') {
        resultString = response.result.toString();
      } else {
        console.error('无法解析的响应结果类型');
        return;
      }

      let targetData: Res1;
      try {
        targetData = JSON.parse(resultString) as Res1;
      } catch (e) {
        console.error('JSON解析失败:', e);
        return;
      }

      if (targetData?.data?.[0]?.sportTime) {
        this.selectedGoal = targetData.data[0].sportTime;
        // 滚动到当前设置的位置
        const index = this.presetGoals.indexOf(this.selectedGoal);
        if (index > 0) {
          this.scroller.scrollTo({
            xOffset: 0,
            yOffset: index * this.itemHeight - 90,
            animation: { duration: 300 }
          });
        }
      }
    } catch (error) {
      console.error('获取失败:', error);
    }
  }

  // 计算透明度 (基于与选中项的距离)
  calculateOpacity(index: number): number {
    const selectedIndex = this.presetGoals.indexOf(this.selectedGoal);
    const distance = Math.abs(index - selectedIndex);
    return Math.max(0.3, 1 - distance * 0.3);
  }

  // 计算缩放比例 (基于与选中项的距离)
  calculateScale(index: number): number {
    const selectedIndex = this.presetGoals.indexOf(this.selectedGoal);
    const distance = Math.abs(index - selectedIndex);
    return distance === 0 ? 1.1 : Math.max(0.8, 1.1 - distance * 0.1);
  }

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Image($r('app.media.chevron_left'))// 返回图标
          .width(24)
          .height(24)
          .margin({ left: 12, right: 8 })
          .onClick(() => {
            router.back();
          });

        Text('目标运动时长')
          .fontSize(18)
          .fontWeight(FontWeight.Bold);
      }
      .width('100%')
      .height(56)
      .justifyContent(FlexAlign.Start)
      .alignItems(VerticalAlign.Center)
      .margin({ bottom: 10 });

      Divider()

      // 步数选择区域
      Stack() {
        // 视觉引导蒙层 - 突出中心选择区域
        Column() {
          Blank()
            .height(90)
            .backgroundColor('#F5F5F5')
            .opacity(0.2);
          Blank()
            .height(60);
          Blank()
            .height(90)
            .backgroundColor('#F5F5F5')
            .opacity(0.2);
        }
        .width('100%')
        .height(240);


        // 步数选择滚动区域
        Scroll(this.scroller) {
          Column() {
            ForEach(this.presetGoals, (goal: number, index: number) => {
              Row() {
                Text(`${goal.toLocaleString()}分`)// 使用千位分隔符
                  .fontSize(24)
                  .fontWeight(this.selectedGoal === goal ? FontWeight.Bold : FontWeight.Normal)
                  .fontColor(this.selectedGoal === goal ? Color.Black : Color.Gray);
              }
              .width('100%')
              .height(this.itemHeight)
              .justifyContent(FlexAlign.Center)
              .borderRadius(12)
              .backgroundColor(this.selectedGoal === goal ? '#F5F5F5' : Color.White)
              .opacity(this.calculateOpacity(index))
              .scale({ x: this.calculateScale(index), y: this.calculateScale(index) })
              .onClick(() => {
                this.selectedGoal = goal;
                // 平滑滚动到选中项
                this.scroller.scrollTo({
                  xOffset: 0,
                  yOffset: index * this.itemHeight - 90,
                  animation: { duration: 300 }
                });
              });
            });
          }
          .width('100%');
        }
        .width('90%')
        .scrollable(ScrollDirection.Vertical)
        .scrollBar(BarState.Off)

        // .onScrollStop(() => {
        //   // 滚动停止时自动对齐到最近的项
        //   const index = Math.round(this.scroller.currentOffset().yOffset / this.itemHeight)
        //   this.selectedGoal = this.presetGoals[index]
        //   this.scroller.scrollTo({ xOffset: 0, yOffset: index * this.itemHeight })
        // })
      }
      .width('100%')
      .height(450) // 滑动区域高度
      .margin({ bottom: 10 })

      Divider().height(2)

      // 当前选中步数显示
      Row() {
        Image($r('app.media.aim'))// 计步器图标
          .width(40)
          .height(40)
          .margin({ right: 8 });

        Text("").width(2).height(30).backgroundColor("#ffb8b7b7").margin({ left: 5, right: 7 })

        Text(this.selectedGoal.toLocaleString() + ' 分钟').fontWeight(FontWeight.Bold)
          .fontSize(24);
      }
      .width('90%')
      .margin({ top: 30, bottom: 40 })
      .justifyContent(FlexAlign.Center);

      // 保存按钮
      Button('保存')
        .width('90%')
        .height(52)
        .fontSize(24)
        .backgroundColor("#F0F0FA")
        .fontColor('#000000')
        .borderRadius(20)
        .border({ width: 2, color: '#ffffff' })
        .stateEffect(true)
        .enabled(!this.isLoading)
        .onClick(async () => {
          this.isLoading = true;
          try {
            const preferencesData = await preferences.getPreferences(getContext(), 'token');
            const token = await preferencesData.get('token', '');

            const httpRequest = http.createHttp();
            const res = await httpRequest.request(`${API_BASE_URL}/health/sport/update`, {
              header: {
                "Authorization": `Bearer ${token}`,
                "Content-Type": "application/json"
              },
              method: http.RequestMethod.POST,
              extraData: JSON.stringify({
                userId: this.userId,
                sportTime: this.selectedGoal
              })
            });
            if (!res || !res.result) {
              throw new Error('空响应结果');
            }

            let resultString: string;
            if (typeof res.result === 'string') {
              resultString = res.result;
            } else if (typeof res.result.toString === 'function') {
              resultString = res.result.toString();
            } else {
              throw new Error('无法解析的响应类型');
            }

            let resData: Res1;
            try {
              resData = JSON.parse(resultString) as Res1;
            } catch (e) {
              throw new Error('JSON解析失败');
            }

            if (resData.code !== 200) {
              throw new Error(resData.msg || '更新失败');
            }

            promptAction.showToast({
              message: '修改成功',
              duration: 2000,
              bottom: '50%',
              backgroundColor: '#00bcd4'
            });
            router.back();

          } catch (error) {
            console.error('保存失败:', error);
            promptAction.showToast({
              message: '保存失败: ' + (error.message || '未知错误'),
              duration: 2000
            });
          } finally {
            this.isLoading = false;
          }
        });
    }.expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .width('100%')
    .height('100%')
    .backgroundColor("#CDCDF3");

  }
}
