import { router } from '@kit.ArkUI'
interface Menu{
  icon:Resource
}
@Entry
@Component
struct sportPlan {
  @State menus:Menu[] = [
    {icon: $r('app.media.sports')},
    {icon: $r('app.media.sports')},
    {icon: $r('app.media.sports')},
    {icon: $r('app.media.sports')},
  ]

  build() {
    Column(){
      Row() {
        Image($r('app.media.background')).width(30).height(30)
          .onClick(() => {
            router.back()
          })
        Text('运动计划')
          .width('80%')
          .fontSize(25).fontColor('#000')
          .fontWeight(FontWeight.Bold)
          .textAlign(TextAlign.Center)
          .padding(20)
          .margin({right:10})
      }
      Divider()
      Scroll(){
        Column(){
          Column(){
            Text('已完成计划数据').margin({bottom:8,top:10})
            Row(){
              Text('0'+'分钟').margin({right:30}).fontSize(30)
              Text('0'+'千卡').fontSize(30)
            }
          }.width('80%').alignItems(HorizontalAlign.Start).justifyContent(FlexAlign.Start).margin({bottom:20})

          Column(){
            Text('运动计划').margin({bottom:10})
          }.width('90%').alignItems(HorizontalAlign.Start).justifyContent(FlexAlign.Start)


          ForEach(this.menus, (item: Menu, index: number) => {
            Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
              Image(item.icon).width('90%').borderRadius(10)
            }.margin({bottom:20})
          })

          Column(){
            Text('')
          }.margin(20)
        }
        }
      }

    }
}