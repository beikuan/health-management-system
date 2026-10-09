import { API_BASE_URL } from '../../common/ApiConfig';
import http from '@ohos.net.http';
import router from '@ohos.router';

interface Tip {
  show: boolean,
  text: string,
  type: string
}

interface Res {
  msg: string,
  code: number
}

interface InputStatus {
  username: boolean,
  name: boolean,
  password: boolean,
  confirmPassword: boolean
}

@Entry
@Component
struct Register {
  @State username: string = "";
  @State name: string = "";
  @State password: string = "";
  @State confirmPassword: string = "";
  // @State tip:boolean = false
  // @State tipText:string = ""
  // @State tipType:string = "error"
  @State tip: Tip = {
    show: false,
    text: '',
    type: 'error'
  }
  @State inputStatus: InputStatus = {
    username: false,
    name: false,
    password: false,
    confirmPassword: false
  }

  build() {
    Column() {
      // 头部
      Column() {
        Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Start }) {
          Text('注册').fontColor('#fff').fontSize(30).fontWeight(900)
          Text('创建您的账号').fontColor('#5D6A85').margin({ top: 10 })
        }.height(100).width('100%')
      }.padding({ left: 25, right: 25 })


      // logo
      Column() {
        Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
          Image($r('app.media.startIcon')).width(80).height(80).objectFit(ImageFit.Contain)
        }
        .width(100).borderRadius(20)
      }

      // 中间
      Column() {
        Column() {
          Text('账号').width('100%').fontColor('#fff').fontWeight(FontWeight.Bold)
          TextInput({ placeholder: '请输入账号' })
            .borderRadius(10)
            .border({ width: 3, color: `${this.inputStatus.username ? '#E2CEEF' : 'rgba(255,255,255,0.7)'}` })
            .margin({ top: 6, bottom: 20 })
            .backgroundColor("rgba(255,255,255,0.7)")
            .onChange(value => {
              this.username = value
            })
            .onBlur(() => {
              this.inputStatus.username = false
            })
            .onFocus(() => {
              this.inputStatus.username = true
            })
        }

        Column() {
          Text('昵称').width('100%').fontColor('#fff').fontWeight(FontWeight.Bold)
          TextInput({ placeholder: '请输入昵称' })
            .borderRadius(10)
            .border({ width: 3, color: `${this.inputStatus.name ? '#E2CEEF' : 'rgba(255,255,255,0.7)'}` })
            .margin({ top: 6, bottom: 20 })
            .backgroundColor("rgba(255,255,255,0.7)")
            .onChange(value => {
              this.name = value
            })
            .onBlur(() => {
              this.inputStatus.name = false
            })
            .onFocus(() => {
              this.inputStatus.name = true
            })

        }

        Column() {
          Text('密码').width('100%').fontColor('#fff').fontWeight(FontWeight.Bold)
          TextInput({ placeholder: '请输入密码' }).type(InputType.Password)
            .borderRadius(10)
            .border({ width: 3, color: `${this.inputStatus.password ? '#E2CEEF' : 'rgba(255,255,255,0.7)'}` })
            .margin({ top: 6, bottom: 20 })
            .backgroundColor("rgba(255,255,255,0.7)")
            .onChange(value => {
              this.password = value
            })
            .onBlur(() => {
              this.inputStatus.password = false
            })
            .onFocus(() => {
              this.inputStatus.password = true
            })
        }

        Column() {
          Text('确认密码').width('100%').fontColor('#fff').fontWeight(FontWeight.Bold)
          TextInput({ placeholder: '请再次输入密码' }).type(InputType.Password)
            .borderRadius(10)
            .border({ width: 3, color: `${this.inputStatus.confirmPassword ? '#E2CEEF' : 'rgba(255,255,255,0.7)'}` })
            .margin({ top: 6, bottom: 20 })
            .backgroundColor("rgba(255,255,255,0.7)")
            .onChange(value => {
              this.confirmPassword = value
            })
            .onBlur(() => {
              this.inputStatus.confirmPassword = false
            })
            .onFocus(() => {
              this.inputStatus.confirmPassword = true
            })
        }

        Column() {
          Button('注册', { type: ButtonType.Normal })
            .borderRadius(10).backgroundColor('#AF97BE')
            .width('100%')
            .onClick(async () => {
              if (this.username == "" || this.name == "" || this.password == "" || this.confirmPassword == "") {
                this.tip.show = true
                this.tip.text = '请填写所有必填项！'
                return
              } else {
                this.tip.show = false
              }
              if (this.password != this.confirmPassword) {
                this.tip.show = true
                this.tip.text = '两次输入的密码不一致！'
                return
              } else {
                this.tip.show = false
              }
              // 调用后端接口，把用户填写的信息传给后端
              if (this.password.length < 6) {
                this.tip.show = true
                this.tip.text = '密码至少需要 6 位！'
                return
              }
              try {
                const res = await http.createHttp().request(`${API_BASE_URL}/user/v1/register`, {
                  method: http.RequestMethod.POST,
                  header: { 'Content-Type': 'application/json' },
                  extraData: JSON.stringify({ username: this.username, name: this.name, password: this.password }),
                  connectTimeout: 10000,
                  readTimeout: 10000
                })
                const resData = JSON.parse(res.result as string) as Res
                if (res.responseCode == 201) {
                  this.tip.text = '注册成功，请登录'
                  this.tip.type = 'success'
                  this.tip.show = true
                  setTimeout(() => {
                    router.replaceUrl({ url: 'pages/login/Login' })
                  }, 1200)
                } else {
                  this.tip.text = resData.msg || '注册失败，请稍后重试！'
                  this.tip.type = 'error'
                  this.tip.show = true
                }
              } catch (error) {
                this.tip.text = '网络连接失败，请检查后端服务后重试'
                this.tip.type = 'error'
                this.tip.show = true
              }
            })
          if (this.tip.show) {
            Column() {
              Text(this.tip.text)
                .fontColor('#c62828')
                .width('100%')
                .textAlign(TextAlign.Center)
                .fontSize(14)
                .margin({ top: 10 })
                .padding(10)
                .borderRadius(10)
                .backgroundColor(this.getTipBackgroundColor())
            }
          }
          Row() {
            Text('已有账号？')
            Text('立即登录').fontColor('#AF97BE')
              .onClick(() => {
                router.pushUrl({ url: 'pages/login/Login' })
              })
          }.margin({ top: 10 })
        }
      }.padding(20)

      // 底部
      Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        Text('© 2025 健康监测系统 | 数据仅供参考').fontSize(12)
      }.backgroundColor('#f8fcff').height(60).width('100%')
      .position({ bottom: -30 })

    }.height('100%')
    .backgroundImage($r('app.media.back'))
    .expandSafeArea()
  }

  getTipBackgroundColor() {
    if (this.tip.type == 'error') {
      return 'rgba(255,235,238,0.7)'
    } else {
      return 'rgba(232,245,233,0.7)'
    }
  }
}
