import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as fss;
import 'dart:convert';
import '../model/network_result.dart';

// 객체가 독립적이여서 전역에서 초기화후 끌어서 사용
final storage = fss.FlutterSecureStorage();
final String baseUrl = 'http://15.164.100.67:8080';

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

  _tokenRefresh(String acToken, String refToken) async {
    storage.write(key: 'accessToken', value: acToken); // 토큰값 덮어쓰기
    storage.write(key: 'refreshToken', value: refToken); // 토큰값 덮어쓰기
    _acToken = acToken;
    _refToken = refToken;
  }

  Future<NetWorkResult> get(String url, Map<String, dynamic>? parameter) async {
    try {
      Response response = await _dio.get(
        url,
        queryParameters: parameter,
      );
      if (response.statusCode == 200) {
        return NetWorkResult(result: Result.success, response: response.data);
      } else {
        return NetWorkResult(result: Result.fail);
      }
    } on DioError catch (e) {
      if (e.response != null) {
        return NetWorkResult(result: Result.fail, response: e.response);
      } else {
        return NetWorkResult(result: Result.fail, response: e);
      }
    }
  }

  // 처음 회원가입 로그인 시에는 options 값이 들어갈 수 없으므로 useToken을 통해서 options값 선택하게 함
  Future<NetWorkResult> post(String url, dynamic data, bool useToken) async {
    print(json.encode(data));
    print('${(json.encode(data)).runtimeType}');
    print(_dio.options);

    try {
      Response response = await _dio.post(
        url,
        data: json.encode(data),
        options: useToken ? Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $_acToken',
            HttpHeaders.contentTypeHeader: 'application/json',
            'Content-Type': 'application/json',
            'RT': _refToken
          },
        ) : null,
      );
      if (response.statusCode == 200) {
        return NetWorkResult(result: Result.success, response: response.data);
      } else {
        return NetWorkResult(result: Result.fail);
      }
    } on DioError catch (e) {
      if (e.response != null) {
        return NetWorkResult(result: Result.fail, response: e.response);
      } else {
        return NetWorkResult(result: Result.fail, response: e);
      }
    }
  }

  /** 앱 시작시 AT 토큰을 검증*/
  Future<NetWorkResult> postTokenDaildate(String url) async {
    final at = storage.read(key: 'accessToken');
    print('_acToken : $at');
    try {
      Response response = await _dio.post(
        url,
        options: Options(
          headers: {
            "token" :'Bearer $at',
          }
        )
      );
      if (response.statusCode == 200) {
        return NetWorkResult(result: Result.success, response: response.data);
      } else {
        return NetWorkResult(result: Result.fail);
      }
    } on DioError catch (e) {
      if (e.response != null) {
        return NetWorkResult(result: Result.fail, response: e.response);
      } else {
        return NetWorkResult(result: Result.fail, response: e);
      }
    }
  }
}
