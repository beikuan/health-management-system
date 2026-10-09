import { common } from '@kit.AbilityKit';
import { preferences } from '@kit.ArkData';
import { router } from '@kit.ArkUI';
import http from '@ohos.net.http';
import { API_BASE_URL } from './ApiConfig';

export class ApiClient {
  static async request(context: common.Context, path: string,
    method: http.RequestMethod = http.RequestMethod.GET, body: string = ''): Promise<http.HttpResponse> {
    const preferencesData = await preferences.getPreferences(context, 'token');
    const token = await preferencesData.get('token', '');
    const headers: Record<string, string> = {
      'Content-Type': 'application/json'
    };
    if (token.toString().length > 0) {
      headers['Authorization'] = `Bearer ${token}`;
    }

    const request = http.createHttp();
    try {
      const response = await request.request(`${API_BASE_URL}${path}`, {
        method: method,
        header: headers,
        extraData: body,
        connectTimeout: 10000,
        readTimeout: 10000
      });
      if (response.responseCode === 401) {
        await preferencesData.delete('token');
        await preferencesData.flush();
        router.replaceUrl({ url: 'pages/login/Login' });
      }
      return response;
    } finally {
      request.destroy();
    }
  }
}
