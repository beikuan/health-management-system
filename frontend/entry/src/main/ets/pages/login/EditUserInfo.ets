import { API_BASE_URL } from '../../common/ApiConfig';
import { prompt, PromptAction, router } from '@kit.ArkUI'
import { preferences } from '@kit.ArkData';
import http from '@ohos.net.http';
import { HmCalendar } from '@ohmos/calendar'

interface UserInfo {
  userId: string,
  name: string,
  birthday: string,
  sex: string,
  height: number,
  weight: number
}

interface Res {
  msg: string,
  code: number,
  data: UserInfo
}

interface InputStatus {
  nickname: boolean,
  sex: boolean,
  height: boolean,
  weight: boolean
}

interface Usr {
  msg: string,
  code: number,
  data: User[]
}

interface User {
  userId: string,
  birthday: string,
  gender: string,
  heightCm: number,
  weightKg: number
}

@Entry
@Component
struct EditUserInfo {
  @State selectedGenderIndex: number = 0;
  @State userInfo: UserInfo = {
    userId: '',
    name: '',
    birthday: '',
    sex: '',
    height: 0,
    weight: 0
  }
  @State userinfo: User = {
    userId: '',
    birthday: '',
    gender: '',
    heightCm: 0,
    weightKg: 0
  }
  @State inputStatus: InputStatus = {
    nickname: false,
    sex: false,
    height: false,
    weight: false
  }
  private uiContext: UIContext = this.getUIContext();
  private promptAction: PromptAction = this.uiContext.getPromptAction();

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
    const user = await http.createHttp().request(`${API_BASE_URL}/user/userinfo`, {
      header: { "Authorization": `Bearer ${token}` }
    });

    const resData: Res = JSON.parse(res.result as string) as Res

    const userData: Usr = JSON.parse(user.result as string) as Usr
    this.userInfo = resData.data
    if (userData.data.length > 0) {
      this.userinfo = userData.data[0]
    }


    this.userInfo = resData.data
  }

  build() {
    Column() {
      Scroll() {
        Column() {
          // 头部
          Stack() {
            Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
              Text('修改个人信息').fontColor('#fff').fontSize(30).fontWeight(900)
              Text('更新您的健康资料').fontColor('#5D6A85').margin({ top: 10 })
            }.height(100).width('100%')

            Row() {
              Image($r('app.media.chevron_left'))
                .width(30)
                .height(30)
                .position({ top: 20 })
                .fillColor("#fff")
                .onClick(() => {
                  router.back()
                })
            }
            .width('100%').height(80)
          }.padding({ left: 25, right: 25 })


          // 顶部标题

          // 头像
          Column() {
            Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
              Image($r('app.media.user')).width(100).height(100).objectFit(ImageFit.Contain)
            }.backgroundColor('#E6F6F9').width(100).height(100).borderRadius('50%')
          }

          // 输入表单
          Column() {
            Column() {
              Text('昵称').width('100%').fontColor('#fff').fontWeight(FontWeight.Bold)
              TextInput({ text: this.userInfo.name, placeholder: '请输入昵称' })
                .borderRadius(10)
                .border({ width: 3, color: `${this.inputStatus.nickname ? '#E2CEEF' : 'rgba(255,255,255,0.7)'}` })
                .margin({ top: 6, bottom: 8 })
                .backgroundColor("rgba(255,255,255,0.7)")
                .onChange(value => {
                  this.userInfo.name = value
                })
                .onBlur(() => {
                  this.inputStatus.nickname = false
                })
                .onFocus(() => {
                  this.inputStatus.nickname = true
                })
            }


            Column() {
              Text('性别').width('100%').fontColor('#fff').fontWeight(FontWeight.Bold)
              Select([
                { value: '男' },
                { value: '女' }
              ])
                .selected(this.selectedGenderIndex)
                .border({ width: 3, color: `${this.inputStatus.nickname ? '#E2CEEF' : 'rgba(255,255,255,0.7)'}` })
                .margin({ top: 6, bottom: 8 })
                .backgroundColor("rgba(255,255,255,0.7)")
                .value(this.userinfo.gender == 'F' ? '女' : '男')
                .borderRadius(10)
                .font({ size: 16, weight: 300 })
                .fontColor('#182431')
                .selectedOptionFont({ size: 16, weight: 400 })
                .optionFont({ size: 16, weight: 400 })
                .arrowPosition(ArrowPosition.END)
                .menuAlign(MenuAlignType.START, { dx: 0, dy: 0 })
                .onSelect((index: number) => {
                  console.info('Select:', index);
                  this.selectedGenderIndex = index;
                  this.userinfo.gender = index === 0 ? 'M' : 'F'
                })
                .onBlur(() => {
                  this.inputStatus.sex = false
                })
                .onFocus(() => {
                  this.inputStatus.sex = true
                })
                .margin({ top: 6, bottom: 20 })
                .width('100%')
            }

            // 出生年月
            Column() {
              Text('出生年月').width('100%').fontColor('#fff').fontWeight(FontWeight.Bold)

              Button(this.userinfo.birthday + '                                              ' || '',
                { type: ButtonType.Normal, stateEffect: true })
                .width('100%')
                .backgroundColor("rgba(255,255,255,0.7)")
                .border({ width: 3, color: 'rgba(255,255,255,0.7)' })
                .borderRadius(10)
                .margin({ top: 6, bottom: 20 })
                .fontSize(16)
                .fontColor('#182431')

                .onClick(() => {
                  const context = this.getUIContext()
                  context.showDatePickerDialog({
                    start: new Date('1950-01-01'),
                    end: new Date('2100-12-31'),
                    selected: this.userinfo.birthday ? new Date(this.userInfo.birthday) : new Date('2000-01-01'),
                    onDateAccept: (value: Date) => {
                      // 格式化为 yyyy-MM-dd
                      const year = value.getFullYear()
                      const month = (value.getMonth() + 1).toString().padStart(2, '0')
                      const day = value.getDate().toString().padStart(2, '0')
                      this.userinfo.birthday = `${year}-${month}-${day}`
                      console.info("选择日期: " + this.userinfo.birthday)
                    },
                    onCancel: () => {
                      console.info("取消日期选择")
                    }
                  })
                })
            }


            Column() {
              Text('身高').width('100%').fontColor('#fff').fontWeight(FontWeight.Bold)
              TextInput({
                text: this.userinfo.heightCm == 0 ? '' : this.userinfo.heightCm.toString(),
                placeholder: '请输入身高'
              })
                .borderRadius(10)
                .border({ width: 3, color: `${this.inputStatus.sex ? '#E2CEEF' : 'rgba(255,255,255,0.7)'}` })
                .margin({ top: 6, bottom: 8 })
                .backgroundColor("rgba(255,255,255,0.7)")
                .onChange(value => {
                  this.userinfo.heightCm = Number(value)
                })
                .onBlur(() => {
                  this.inputStatus.sex = false
                })
                .onFocus(() => {
                  this.inputStatus.sex = true
                })
            }

            Column() {
              Text('体重').width('100%').fontColor('#fff').fontWeight(FontWeight.Bold)
              TextInput({
                text: this.userinfo.weightKg == 0 ? '' : this.userinfo.weightKg.toString(),
                placeholder: '请输入体重'
              })
                .borderRadius(10)
                .border({ width: 3, color: `${this.inputStatus.weight ? '#E2CEEF' : 'rgba(255,255,255,0.7)'}` })
                .margin({ top: 6, bottom: 8 })
                .backgroundColor("rgba(255,255,255,0.7)")
                .onChange(value => {
                  this.userinfo.weightKg = Number(value)
                })
            }
          }.margin({ top: 40 }).padding({ left: 20, right: 20 })

          Column() {
            Button('保存修改', { type: ButtonType.Normal })
              .borderRadius(30).backgroundColor('#AF97BE')
              .width('100%')

          }.margin({ top: 10 }).padding({ left: 20, right: 20 })
          .onClick(async () => {
            const preferencesData = await preferences.getPreferences(getContext(), 'token')
            const token = await preferencesData.get('token', '')
            const res = await
            http.createHttp().request(`${API_BASE_URL}/user/v1/edit`, {
              header: {
                "Authorization": `Bearer ${token}`,
                'Content-Type': 'application/x-www-form-urlencoded'
              },
              method: http.RequestMethod.POST,
              extraData: `name=${this.userInfo.name}&birthday=${this.userinfo.birthday}&gender=${this.userinfo.gender}&height=${this.userinfo.heightCm}&weight=${this.userinfo.weightKg}`
            }
            )

            const resData = JSON.parse(res.result as string) as Res
            if (resData.code == 200) {
              this.promptAction.showToast({
                message: '修改成功',
                duration: 2000,
                bottom: '50%',
                backgroundColor: '#EBF1FF'
              })
              router.back()
            } else {
              this.promptAction.showToast({
                message: '修改失败',
                duration: 2000,
                bottom: '50%',
                backgroundColor: 'rgba(255,235,238,1)'
              })
              router.back()
            }
          })

        }
      }
      .height("100%")
      .backgroundImage($r('app.media.back'))
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    }
  }
}
