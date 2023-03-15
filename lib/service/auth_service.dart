import 'package:diviction_counselor/model/network_result.dart';
import 'package:diviction_counselor/network/dio_client.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as fss;

import '../model/user.dart';

const storage = fss.FlutterSecureStorage();

class AuthService {
  static final AuthService _authService = AuthService._internal();
  factory AuthService() {
    return _authService;
  }
  AuthService._internal();

  final String? _baseUrl = dotenv.env['BASE_URL'];

  Future<bool> isLogin() async {
    // 로그인 검증
    String? acToken = await storage.read(key: 'accessToken');
    String? rfToken = await storage.read(key: 'refreshToken');
    try {
      if (acToken == null && rfToken == null) {
        return false;
      } else {
        NetWorkResult result = await DioClient().post(
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
      NetWorkResult result = await DioClient().post(
          '$_baseUrl/auth/signIn/counselor',
          {'email': email, 'password': password, 'authority': 'ROLE_COUNSELOR'},
          false);
      if (result.result == Result.success) {
        storage.write(
            key: 'accessToken', value: result.response['accessToken']);
        storage.write(
            key: 'refreshToken', value: result.response['refreshToken']);
        // 값 검증
        final AT = await storage.read(key: 'accessToken');
        final RT = await storage.read(key: 'refreshToken');
        print('accessToken : $AT');
        print('refreshToken : $RT');
        return result.response;
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      throw Exception('Failed to login');
    }
  }

  Future<bool> signUp(User user) async {
    try {
      NetWorkResult result = await DioClient()
          .post('$_baseUrl/auth/signUp/member', user.toJson(), false);
      print(result);
      if (result.result == Result.success) {
        return true;
      } else {
        throw false;
      }
    } catch (e) {
      throw false;
    }
  }
}
