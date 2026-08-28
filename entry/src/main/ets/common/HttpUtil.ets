import http from '@ohos.net.http';

const BASE_URL: string = 'http://10.216.116.10:8086/yx';

let globalToken: string = '';

// ✅ 1. 先定义接口（告诉TS这个对象的类型）
export interface GlobalDataInterface {
  address: string;
  currentTime: string;
}

// ✅ 2. 按接口定义全局变量（消除无类型报错）
export const GlobalData: GlobalDataInterface = {
  address: '-',
  currentTime: '-'
};

export function setToken(token: string): void {
  globalToken = token;
}

export function getToken(): string {
  return globalToken;
}

let storedUsername: string = '';

export function setUsername(name: string): void {
  storedUsername = name;
}

export function getUsername(): string {
  return storedUsername;
}

let storedRole: string = '';

export function setRole(role: string): void {
  storedRole = role;
}

export function getRole(): string {
  return storedRole;
}

export interface HttpResponse {
  code: number;
  data: string;
  header: Object;
}

function buildUrl(path: string, params?: Record<string, string>): string {
  let url = BASE_URL + path;
  if (params) {
    let queryParts: string[] = [];
    let keys = Object.keys(params);
    for (let i = 0; i < keys.length; i++) {
      let key = keys[i];
      let val = params[key];
      if (val !== undefined && val !== null) {
        queryParts.push(key + '=' + encodeURIComponent(val));
      }
    }
    if (queryParts.length > 0) {
      url += '?' + queryParts.join('&');
    }
  }
  return url;
}

export function httpGet(path: string, params?: Record<string, string>): Promise<string> {
  return new Promise((resolve, reject) => {
    let httpRequest = http.createHttp();
    let url = buildUrl(path, params);
    httpRequest.request(url, {
      method: http.RequestMethod.GET,
      header: {
        'Content-Type': 'application/json',
        'Authorization': globalToken
      },
      readTimeout: 15000,
      connectTimeout: 15000
    }, (err, data) => {
      if (!err && data) {
        resolve(data.result as string);
      } else {
        reject(err);
      }
      httpRequest.destroy();
    });
  });
}

export function httpPost(path: string, body: object): Promise<HttpResponse> {
  return new Promise((resolve, reject) => {
    let httpRequest = http.createHttp();
    let url = BASE_URL + path;
    httpRequest.request(url, {
      method: http.RequestMethod.POST,
      header: {
        'Content-Type': 'application/json',
        'Authorization': globalToken
      },
      extraData: JSON.stringify(body),
      readTimeout: 15000,
      connectTimeout: 15000
    }, (err, data) => {
      if (!err && data) {
        let resp: HttpResponse = {
          code: data.responseCode,
          data: data.result as string,
          header: data.header
        };
        resolve(resp);
      } else {
        reject(err);
      }
      httpRequest.destroy();
    });
  });
}

export function httpLogin(username: string, password: string): Promise<HttpResponse> {
  return new Promise((resolve, reject) => {
    let httpRequest = http.createHttp();
    let url = BASE_URL + '/login';
    httpRequest.request(url, {
      method: http.RequestMethod.POST,
      header: {
        'Content-Type': 'application/json'
      },
      extraData: JSON.stringify({ 'username': username, 'password': password }),
      readTimeout: 15000,
      connectTimeout: 15000
    }, (err, data) => {
      if (!err && data) {
        let headerObj = data.header as Record<string, string>;
        let token = '';
        if (headerObj && headerObj['authorization']) {
          token = headerObj['authorization'];
        } else if (headerObj && headerObj['Authorization']) {
          token = headerObj['Authorization'];
        }
        let headerResult: Record<string, string> = { 'authorization': token };
        let resp: HttpResponse = {
          code: data.responseCode,
          data: data.result as string,
          header: headerResult
        };
        resolve(resp);
      } else {
        reject(err);
      }
      httpRequest.destroy();
    });
  });
}
