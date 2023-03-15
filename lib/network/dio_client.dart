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
  int? _id;
  final Dio _dio = Dio();

  DioClient._internal() {
    _getToken();
    _getId();
  }

  _getToken() async {
    _acToken = await storage.read(key: 'accessToken');
    _refToken = await storage.read(key: 'refreshToken');
    print('_getToken() _acToken : $_acToken');
    print('_getToken() _refToken : $_refToken');
    _id = (await storage.read(key: 'id')) as int?;
  }

  _checkToken(Headers headers) {
    if (headers.value('accessToken') != null) {
      _tokenRefresh(
          headers.value('accessToken')!, headers.value('refreshToken')!);
    }
  }

  _getId() async {

  }

  _tokenRefresh(String acToken, String refToken) async {
    storage.write(key: 'accessToken', value: acToken); // 토큰값 덮어쓰기
    storage.write(key: 'refreshToken', value: refToken); // 토큰값 덮어쓰기
    _acToken = acToken;
    _refToken = refToken;
  }

  Future<NetWorkResult> get(
      String url, Map<String, dynamic>? parameter, bool useToken) async {
    try {
      Response response = await _dio.get(url,
          queryParameters: parameter,
          options: useToken
              ? Options(headers: {
            HttpHeaders.authorizationHeader: _acToken,
            HttpHeaders.contentTypeHeader: 'application/json',
            'Content-Type': 'application/json',
            'RT': _refToken
          })
              : Options(headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            'Content-Type': 'application/json',
          }));
      print('response.statusCode : ${response.statusCode}, message : ${response.statusMessage}');
      if (response.statusCode == 200) {
        _checkToken(response.headers);
        return NetWorkResult(result: Result.success, response: response.data);
      } else if (response.statusCode == 401) {
        if (response.headers.value('CODE') == 'RTE') {
          return NetWorkResult(result: Result.tokenExpired);
        } else {
          return NetWorkResult(result: Result.fail);
        }
      } else {
        _checkToken(response.headers);
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

  Future<NetWorkResult> post(String url, dynamic data, bool useToken) async {
    try {
      Response response = await _dio.post(url,
          data: json.encode(data),
          options: useToken
              ? Options(
            headers: {
              HttpHeaders.authorizationHeader: _acToken,
              HttpHeaders.contentTypeHeader: 'application/json',
              'Content-Type': 'application/json',
              'RT':
              _refToken, // 이거는 토큰이 만료되었을 때, 새로운 토큰을 받아오기 위해 필요한 헤더입니다.
            },
          )
              : Options(
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              'Content-Type': 'application/json',
            },
          ));
      print('response.statusCode : ${response.statusCode}, message : ${response.statusMessage}');
      if (response.statusCode == 200) {
        _checkToken(response.headers);
        return NetWorkResult(result: Result.success, response: response.data);
      } else if (response.statusCode == 401) {
        if (response.headers.value('CODE') == 'RTE') {
          return NetWorkResult(result: Result.tokenExpired);
        } else {
          return NetWorkResult(result: Result.fail);
        }
      } else {
        _checkToken(response.headers);
        return NetWorkResult(result: Result.fail);
      }
    } on DioError catch (e) {
      if (e.response != null) {
        print(e.response.toString());
        return NetWorkResult(result: Result.fail, response: e.response);
      } else {
        print(e.response.toString());
        return NetWorkResult(result: Result.fail, response: e);
      }
    }
  }
}
