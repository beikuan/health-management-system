import { API_BASE_URL } from '../../common/ApiConfig';
import http from '@ohos.net.http';
import router from '@ohos.router';
import { preferences } from '@kit.ArkData';

interface Tip {
  show:boolean,
  text:string,
  type:string
}

interface Res {
  msg:string,
  code:number,
  data:AuthData
}

interface AuthData {
  accessToken:string,
  expiresInMs:number
}

interface InputStatus {
  username:boolean,
  password:boolean
}

@Entry
@Component
struct Login {

  @State username:string = "";
  @State password:string = "";

  @State tip:Tip = {
    show: false,
    text: '',
    type: 'error'
  }

  @State inputStatus:InputStatus = {
    username: false,
    password: false
  }

  build() {
    Column() {
      // 头部

      Column(){
        Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Start }) {
          Text('登录').fontColor('#fff').fontSize(30).fontWeight(900)
          Text('请登录以访问您的健康数据').fontColor('#5D6A85').margin({ top: 10 })
        }.height(100).width('100%')
      }.padding({left:25,right:25})

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
          TextInput({ placeholder: '请输入账号' }).borderRadius(10)
            .border({ width: 3, color: `${this.inputStatus.username ? '#E2CEEF' : 'rgba(255,255,255,0.7)'}` })
            .margin({ top: 6, bottom: 20}).backgroundColor("rgba(255,255,255,0.7)")
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
          Text('密码').width('100%').fontColor('#fff').fontWeight(FontWeight.Bold)
          TextInput({ placeholder: '请输入密码' }).type(InputType.Password).borderRadius(10)
            .border({ width: 3, color: `${this.inputStatus.password ? '#E2CEEF' : 'rgba(255,255,255,0.7)'}` })
            .margin({ top: 6, bottom: 20 }).backgroundColor("rgba(255,255,255,0.7)")
            .onChange(value => { this.password = value })
            .onBlur(() => {
              this.inputStatus.password = false
            })
            .onFocus(() => {
              this.inputStatus.password = true
            })
        }
        Column() {
          Button('登录', { type: ButtonType.Normal })
            .borderRadius(10).backgroundColor('#AF97BE')
            .width('100%')
            .onClick(async () => {
              if(this.username == '' || this.password == '') {
                this.tip.show = true
                this.tip.text = '请填写所有必填项！'
                this.tip.type = 'error'
                return
              }
              // 请求后端，把填写的账号密码发送给后端
              try {
                const res = await http.createHttp().request(`${API_BASE_URL}/user/v1/login`, {
                  method: http.RequestMethod.POST,
                  header: { 'Content-Type': 'application/json' },
                  extraData: JSON.stringify({ username: this.username, password: this.password }),
                  connectTimeout: 10000,
                  readTimeout: 10000
                })
                const resData = JSON.parse(res.result as string) as Res
                if(res.responseCode == 200 && resData.code == 200) {
                  const preferencesData = await preferences.getPreferences(getContext(), 'token')
                  await preferencesData.put('token', resData.data.accessToken)
                  await preferencesData.flush()
                  router.replaceUrl({ url: "pages/tabs/TabsPage" })
                } else {
                  this.tip.show = true
                  this.tip.text = resData.msg || '用户名或者密码有误！'
                  this.tip.type = 'error'
                }
              } catch (error) {
                this.tip.show = true
                this.tip.text = '网络连接失败，请检查后端服务后重试'
                this.tip.type = 'error'
              }
            })
          if(this.tip.show) {
            Column() {
              Text(this.tip.text)
                .fontColor('#c62828').width('100%').textAlign(TextAlign.Center).fontSize(14)
                .margin({ top: 10 }).padding(10).borderRadius(10)
                .backgroundColor(this.getTipBackgroundColor())
            }
          }
          Row() {
            Text('还没有账号？').fontColor("#fff")
            Text('立即注册').fontColor('#AF97BE')
              .onClick(() => {
                router.pushUrl({ url: 'pages/login/Register' })
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
    if(this.tip.type == 'error') {
      return 'rgba(255,235,238,0.7)'
    } else {
      return 'rgba(232,245,233,0.7)'
    }
  }
}
