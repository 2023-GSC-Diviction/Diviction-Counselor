import 'package:diviction_counselor/model/user.dart';
import 'package:diviction_counselor/network/dio_client.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../model/counselor.dart';
import '../model/network_result.dart';

class UserService {
  static final UserService _counselorService =
  UserService._internal();
  factory UserService() {
    return _counselorService;
  }
  UserService._internal();
  final String? _baseUrl = dotenv.env['BASE_URL'];

  Future<List<User>> getUsers(Map<String, String> option) async {
    var response = await DioClient().request('get','$_baseUrl/member/all', {}, true);

    if (response.result == Result.success) {
      var res = response.response;
      List<User> users = res
          .map((user) {
        return User.fromJson(user);
      })
          .cast<User>()
          .toList();

      return users;
    } else {
      throw Exception('Failed to load users');
    }
  }
}
