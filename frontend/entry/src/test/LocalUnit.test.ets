import { describe, it, expect } from '@ohos/hypium';
import { formatDistance, formatRecordedAt, isPositiveNumber, parseApiCode } from '../main/ets/common/HealthValidation';

export default function localUnitTest() {
  describe('healthUtilities', () => {
    it('validatesHealthInput', 0, () => {
      expect(isPositiveNumber('72')).assertTrue();
      expect(isPositiveNumber('0')).assertFalse();
      expect(isPositiveNumber('abc')).assertFalse();
    });
    it('formatsHealthValues', 0, () => {
      expect(formatDistance(2350)).assertEqual('2.35 km');
      expect(formatRecordedAt('2026-10-09T08:05:00')).assertEqual('2026/10/09 08:05');
      expect(parseApiCode('{"code":201,"msg":"ok"}')).assertEqual(201);
    });
  });
}
