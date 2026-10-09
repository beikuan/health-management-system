import { describe, it, expect } from '@ohos/hypium';
import { formatDistance, isPositiveNumber, parseApiCode } from '../../../main/ets/common/HealthValidation';

export default function abilityTest() {
  describe('healthDataContract', () => {
    it('validatesInputAndResponse', 0, () => {
      expect(isPositiveNumber('98')).assertTrue();
      expect(isPositiveNumber('-1')).assertFalse();
      expect(parseApiCode('{"code":200,"msg":"ok"}')).assertEqual(200);
      expect(formatDistance(1000)).assertEqual('1.00 km');
    });
  });
}
