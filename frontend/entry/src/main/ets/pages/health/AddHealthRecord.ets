import http from '@ohos.net.http';
import { promptAction, router } from '@kit.ArkUI';
import { ApiClient } from '../../common/ApiClient';
import { isPositiveNumber } from '../../common/HealthValidation';

interface MetricOption {
  type: string;
  label: string;
  unit: string;
}

interface HealthRecordBody {
  type: string;
  recordedAt: string;
  bpm?: number;
  spo2?: number;
  rpm?: number;
  steps?: number;
  calories?: number;
  distanceM?: number;
  activityType?: string;
  durationMin?: number;
  averageHeartRate?: number;
  systolic?: number;
  diastolic?: number;
  glucoseMmol?: number;
  uricAcidUmol?: number;
  totalCholesterol?: number;
}

@Entry
@Component
struct AddHealthRecord {
  private metrics: MetricOption[] = [
    { type: 'HEART_RATE', label: '心率', unit: '次/分钟' },
    { type: 'BLOOD_OXYGEN', label: '血氧', unit: '%' },
    { type: 'RESPIRATION', label: '呼吸频率', unit: '次/分钟' },
    { type: 'STEPS', label: '运动步数', unit: '步' },
    { type: 'SLEEP', label: '睡眠', unit: '小时' },
    { type: 'BLOOD_PRESSURE', label: '血压', unit: 'mmHg' },
    { type: 'BLOOD_GLUCOSE', label: '血糖', unit: 'mmol/L' },
    { type: 'URIC_ACID', label: '尿酸', unit: 'μmol/L' },
    { type: 'BLOOD_LIPID', label: '总胆固醇', unit: 'mmol/L' }
  ];

  @State selectedType: string = 'HEART_RATE';
  @State primaryValue: string = '';
  @State secondaryValue: string = '';
  @State calories: string = '';
  @State distanceM: string = '';
  @State durationMin: string = '';
  @State averageHeartRate: string = '';
  @State activityType: string = 'WALK';
  @State submitting: boolean = false;
  @State errorMessage: string = '';

  private selectedMetric(): MetricOption {
    const selected = this.metrics.find((item: MetricOption) => item.type === this.selectedType);
    return selected === undefined ? this.metrics[0] : selected;
  }

  private resetValues() {
    this.primaryValue = '';
    this.secondaryValue = '';
    this.calories = '';
    this.distanceM = '';
    this.durationMin = '';
    this.averageHeartRate = '';
    this.errorMessage = '';
  }

  private buildBody(): HealthRecordBody {
    const body: HealthRecordBody = {
      type: this.selectedType,
      recordedAt: new Date().toISOString().replace('Z', '')
    };
    const value = Number(this.primaryValue);
    switch (this.selectedType) {
      case 'HEART_RATE': body.bpm = value; break;
      case 'BLOOD_OXYGEN': body.spo2 = value; break;
      case 'RESPIRATION': body.rpm = value; break;
      case 'SLEEP': body.durationMin = Math.round(value * 60); break;
      case 'BLOOD_PRESSURE':
        body.systolic = Math.round(value);
        body.diastolic = Math.round(Number(this.secondaryValue));
        break;
      case 'BLOOD_GLUCOSE': body.glucoseMmol = value; break;
      case 'URIC_ACID': body.uricAcidUmol = value; break;
      case 'BLOOD_LIPID': body.totalCholesterol = value; break;
      case 'STEPS':
        body.steps = Math.round(value);
        body.activityType = this.activityType;
        body.durationMin = Math.round(Number(this.durationMin));
        body.distanceM = Number(this.distanceM);
        body.calories = Number(this.calories);
        body.averageHeartRate = Number(this.averageHeartRate);
        break;
    }
    return body;
  }

  private async submit() {
    if (!isPositiveNumber(this.primaryValue)) {
      this.errorMessage = '请输入有效的正数';
      return;
    }
    if (this.selectedType === 'BLOOD_PRESSURE' && !isPositiveNumber(this.secondaryValue)) {
      this.errorMessage = '请输入有效的舒张压';
      return;
    }
    if (this.selectedType === 'STEPS' &&
      (!isPositiveNumber(this.durationMin) || !isPositiveNumber(this.distanceM) ||
        !isPositiveNumber(this.calories) || !isPositiveNumber(this.averageHeartRate))) {
      this.errorMessage = '请完整填写运动详情';
      return;
    }

    this.submitting = true;
    this.errorMessage = '';
    try {
      const response = await ApiClient.request(getContext(), '/health/records', http.RequestMethod.POST,
        JSON.stringify(this.buildBody()));
      if (response.responseCode === 201) {
        promptAction.showToast({ message: '健康数据已保存' });
        // 重建主页面，使首页、统计和运动记录同步读取最新数据。
        router.replaceUrl({ url: 'pages/tabs/TabsPage' });
      } else if (response.responseCode !== 401) {
        this.errorMessage = '保存失败，请检查输入内容';
      }
    } catch (error) {
      this.errorMessage = '网络连接失败，请稍后重试';
    } finally {
      this.submitting = false;
    }
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.chevron_left')).width(28).height(28).onClick(() => router.back());
        Text('录入健康数据').fontSize(24).fontWeight(FontWeight.Bold).margin({ left: 12 });
      }.width('100%').padding({ left: 18, right: 18, top: 28, bottom: 16 });

      Scroll() {
        Column({ space: 14 }) {
          Text('选择指标').fontSize(16).fontWeight(FontWeight.Bold).width('100%');
          Flex({ wrap: FlexWrap.Wrap }) {
            ForEach(this.metrics, (item: MetricOption) => {
              Button(item.label)
                .fontSize(13)
                .fontColor(this.selectedType === item.type ? Color.White : '#5D6175')
                .backgroundColor(this.selectedType === item.type ? '#7C5CFC' : '#ECEAF8')
                .margin({ right: 8, bottom: 8 })
                .onClick(() => {
                  this.selectedType = item.type;
                  this.resetValues();
                });
            });
          }.width('100%');

          Text(`${this.selectedMetric().label}（${this.selectedMetric().unit}）`)
            .fontSize(15).width('100%');
          TextInput({ placeholder: '请输入数值', text: this.primaryValue })
            .type(InputType.Number)
            .onChange((value: string) => this.primaryValue = value);

          if (this.selectedType === 'BLOOD_PRESSURE') {
            Text('舒张压（mmHg）').fontSize(15).width('100%');
            TextInput({ placeholder: '请输入舒张压', text: this.secondaryValue })
              .type(InputType.Number)
              .onChange((value: string) => this.secondaryValue = value);
          }

          if (this.selectedType === 'STEPS') {
            Text('运动类型').fontSize(15).width('100%');
            Row({ space: 10 }) {
              Button('步行').backgroundColor(this.activityType === 'WALK' ? '#FE7B04' : '#D8D8E5')
                .onClick(() => this.activityType = 'WALK');
              Button('跑步').backgroundColor(this.activityType === 'RUN' ? '#3CBB00' : '#D8D8E5')
                .onClick(() => this.activityType = 'RUN');
            }.width('100%');
            TextInput({ placeholder: '运动时长（分钟）', text: this.durationMin }).type(InputType.Number)
              .onChange((value: string) => this.durationMin = value);
            TextInput({ placeholder: '距离（米）', text: this.distanceM }).type(InputType.Number)
              .onChange((value: string) => this.distanceM = value);
            TextInput({ placeholder: '消耗热量（千卡）', text: this.calories }).type(InputType.Number)
              .onChange((value: string) => this.calories = value);
            TextInput({ placeholder: '平均心率（次/分钟）', text: this.averageHeartRate }).type(InputType.Number)
              .onChange((value: string) => this.averageHeartRate = value);
          }

          if (this.errorMessage.length > 0) {
            Text(this.errorMessage).fontColor('#C62828').fontSize(14).width('100%');
          }
          Button(this.submitting ? '保存中…' : '保存记录')
            .width('100%').height(48).backgroundColor('#7C5CFC')
            .enabled(!this.submitting).onClick(() => this.submit());
          Text('健康数据与 AI 建议仅供健康管理参考，不替代医生诊断。')
            .fontSize(12).fontColor('#888').width('100%').textAlign(TextAlign.Center);
        }.padding(20).width('100%');
      }.layoutWeight(1);
    }
    .width('100%').height('100%')
    .backgroundColor('#F6F5FC')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM]);
  }
}
