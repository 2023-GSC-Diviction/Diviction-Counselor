import 'package:dio/dio.dart';
import 'package:diviction_counselor/model/counselor.dart';
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
    print('acToken : $acToken');
    print('rfToken : $rfToken');
    try {
      if (acToken == null && rfToken == null) {
        return false;
      } else {
        NetWorkResult result = await DioClient().post(
            '$_baseUrl/auth/validate/token',
            {
              'accessToken':
                  "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJ0ZXN0MTIzNEBnbWFpbC5jb20iLCJyb2xlIjoiUk9MRV9DT1VOU0VMT1IiLCJleHAiOjE2Nzg5MDUzOTN9.NxqB3_Gbzu1Afi-TaGGjXUDfJ6pahrj43VOH6inelVwQPaRGJF0zhBEckEL9RWp27_9nNqgpztrE1Wwoukd-HQ",
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
        final token = result.response['token'];
        storage.write(key: 'accessToken', value: token['accessToken']);
        storage.write(key: 'refreshToken', value: token['refreshToken']);
        // 값 검증
        final AT = await storage.read(key: 'accessToken');
        final RT = await storage.read(key: 'refreshToken');
        print('accessToken : $AT');
        print('refreshToken : $RT');
        getUser(result.response['email']);
        return true;
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      throw Exception('Failed to login');
    }
  }

  Future getUser(String email) async {
    try {
      NetWorkResult result = await DioClient()
          .get('$_baseUrl/counselor/email/$email', {'user_email': email}, true);
      if (result.result == Result.success) {
        Counselor counselor = Counselor.fromJson(result.response);
        counselor.savePreference(counselor);
      } else {
        throw Exception('Failed to getUser');
      }
    } catch (e) {
      throw Exception('Failed to getUser');
    }
  }

  Future<bool> signUp(Counselor counselor) async {
    try {
      // final Dio _dio = Dio();
      // _dio.post(path, data: data, options: options)
      NetWorkResult result = await DioClient()
          .post('$_baseUrl/auth/signUp/member', counselor.toJson(), false);
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
