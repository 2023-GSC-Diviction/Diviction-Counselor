import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as fss;

import '../model/network_result.dart';

const storage = fss.FlutterSecureStorage();

class DioClient {
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;

  String? _acToken;
  String? _refToken;
  final Dio _dio = Dio();

  DioClient._internal() {
    _getToken();
  }

  _getToken() async {
    _acToken = await storage.read(key: 'accessToken');
    _refToken = await storage.read(key: 'refreshToken');
  }

  _checkToken(Headers headers) {
    if (headers.value('accessToken') != null) {
      _tokenRefresh(
          headers.value('accessToken')!, headers.value('refreshToken')!);
    }
  }

  _tokenRefresh(String acToken, String refToken) async {
    storage.write(key: 'accessToken', value: acToken);
    storage.write(key: 'refreshToken', value: refToken);

    _acToken = acToken;
    _refToken = refToken;
  }

  // post, get, put, delete등 다양한 콜이 생기면서 하나로 처리할 필요가 생김
  // method에 'post', 'get', 'put', 'delete'중 하나를 작성
  Future<NetWorkResult> request(
      String method,
      String url,
      dynamic data,
      bool useToken,
      ) async {
    try {
      print("요청한 url : ${url}");
      _getToken();
      Response response = await _dio.request(
        url,
        data: json.encode(data),
        options: Options(
          method: method,
          contentType: Headers.jsonContentType,
          headers: useToken
              ? {
            HttpHeaders.authorizationHeader: 'Bearer $_acToken',
            'RT': _refToken,
          }
              : null,
        ),
      );
      if (response.statusCode == 200) {
        print("${response.realUri} [200] 요청성공");
        _checkToken(response.headers);
        return NetWorkResult(
          result: Result.success,
          response: response.data,
        );
      } else if (response.statusCode == 401) {
        if (response.headers.value('CODE') == 'RTE') {
          print("${response.realUri} [401] 요청실패 RTE");
          return NetWorkResult(result: Result.tokenExpired);
        } else {
          print("${response.realUri} [401] 요청실패 ETC");
          return NetWorkResult(result: Result.fail);
        }
      } else {
        print("${response.realUri} [500] 서버에서 처리가 안됌");
        _checkToken(response.headers);
        return NetWorkResult(result: Result.fail);
      }
    } on DioError catch (e) {
      if (e.response != null) {
        print('url : $url [DioError] : ${e.response}');
        return NetWorkResult(result: Result.fail, response: e.response);
      } else {
        print('url : $url [DioError] : ${e.response}');
        return NetWorkResult(result: Result.fail, response: e);
      }
    }
  }
}
