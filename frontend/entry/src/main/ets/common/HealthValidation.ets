export function isPositiveNumber(value: string): boolean {
  const parsed = Number(value);
  return value.trim().length > 0 && !Number.isNaN(parsed) && parsed > 0;
}

export function formatDistance(distanceM: number): string {
  return `${(distanceM / 1000).toFixed(2)} km`;
}

export function formatRecordedAt(value: string): string {
  if (value.length < 16) {
    return value;
  }
  return `${value.substring(0, 10).replace(/-/g, '/')} ${value.substring(11, 16)}`;
}

interface BasicApiResponse {
  code: number;
  msg: string;
}

export function parseApiCode(value: string): number {
  const response = JSON.parse(value) as BasicApiResponse;
  return response.code;
}
