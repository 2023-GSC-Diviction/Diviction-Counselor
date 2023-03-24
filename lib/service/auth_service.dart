import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:diviction_counselor/model/counselor.dart';
import 'package:diviction_counselor/model/network_result.dart';
import 'package:diviction_counselor/network/dio_client.dart';
import 'package:diviction_counselor/service/chat_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as fss;
import 'package:image_picker/image_picker.dart';
import '../model/user.dart';
import 'package:http/http.dart' as http;

const storage = fss.FlutterSecureStorage();

class AuthService {
  static final AuthService _authService = AuthService._internal();
  factory AuthService() {
    return _authService;
  }
  AuthService._internal();

  final String? _baseUrl = dotenv.env['BASE_URL'];

  Future<bool> isLogin() async {
    String? acToken = await storage.read(key: 'accessToken');
    String? rfToken = await storage.read(key: 'refreshToken');
    try {
      if (acToken == null && rfToken == null) {
        return false;
      } else {
        NetWorkResult result = await DioClient().request(
            'post',
            '$_baseUrl/auth/validate/token',
            {
              'accessToken': acToken,
              'refreshToken': rfToken,
              'authority': 'ROLE_COUNSELOR'
            },
            false);
        if (result.result == Result.success) {
          return true;
        } else {
          return false;
        }
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> signIn(String email, String password) async {
    try {
      NetWorkResult result = await DioClient().request(
          'post',
          '$_baseUrl/auth/signIn/counselor',
          {'email': email, 'password': password, 'authority': 'ROLE_COUNSELOR'},
          false);
      if (result.result == Result.success) {
        final token = result.response['token'];
        storage.write(key: 'accessToken', value: token['accessToken']);
        storage.write(key: 'refreshToken', value: token['refreshToken']);
        getCounselor(email);
        return true;
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      throw Exception('Failed to login');
    }
  }

  // Future<bool> signUp(Map<String, dynamic> counselor) async {
  //   try {
  //     NetWorkResult result = await DioClient()
  //         .post('$_baseUrl/auth/signUp/conunselor', counselor, false);
  //     if (result.result == Result.success) {
  //       return true;
  //     } else {
  //       throw false;
  //     }
  //   } catch (e) {
  //     throw false;
  //   }
  // }

  Future SignupWithloadImage({
    required XFile file,
    required Map<String, String> counselor,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl/auth/signUp/counselor');
      final request = http.MultipartRequest('POST', url);
      // 파일 업로드를 위한 http.MultipartRequest 생성
      http.MultipartFile multipartFile =
          await http.MultipartFile.fromPath('multipartFile', file.path);
      request.headers.addAll(
          {"Content-Type": "multipart/form-data"}); // request에 header 추가

      // 이미지 파일을 http.MultipartFile로 변환하여 request에 추가
      request.files.add(multipartFile);
      request.fields.addAll(counselor); // request에 fields 추가

      var streamedResponse = await request.send();
      var result = await http.Response.fromStream(streamedResponse);
      print(result.body);
      if (result.statusCode == 200) {
        Counselor counselor = Counselor.fromJson(json.decode(result.body));
        counselor.savePreference(counselor);
        ChatService();
        return true;
      } else {
        throw Exception('Failed to signUp');
      }
      return false;
    } catch (e) {
      throw Exception('Failed to signUp');
    }
  }

  Future<bool> emailCheck(String email, String role) async {
    try {
      NetWorkResult result = await DioClient().request(
          'get',
          '$_baseUrl/auth/check/email/$email/role/$role',
          {'email': email, 'role': role},
          false);
      if (result.result == Result.success) {
        return result.response;
      } else {
        throw Exception('Failed to emailCheck');
      }
    } catch (e) {
      throw Exception('Failed to emailCheck');
    }
  }

  Future getCounselor(String email) async {
    try {
      NetWorkResult result = await DioClient().request('get',
          '$_baseUrl/counselor/email/$email', {'user_email': email}, true);
      if (result.result == Result.success) {
        Counselor counselor = Counselor.fromJson(result.response);
        counselor.savePreference(counselor);
      } else {
        throw Exception('Failed to getCounselor');
      }
    } catch (e) {
      throw Exception('Failed to getCounselor');
    }
  }
}
