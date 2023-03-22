import 'package:dio/dio.dart';
import 'package:diviction_counselor/model/counselor.dart';
import 'package:diviction_counselor/model/network_result.dart';
import 'package:diviction_counselor/network/dio_client.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as fss;
import '../model/user.dart';

const storage = fss.FlutterSecureStorage();

class MemoService {
  static final MemoService _memoService = MemoService._internal();
  factory MemoService() {
    return _memoService;
  }
  MemoService._internal();

  final String? _baseUrl = dotenv.env['BASE_URL'];

  Future memosave() async {
    // try {
    //   NetWorkResult result = await DioClient()
    //       .get('$_baseUrl/counselor/email/$email', true);
    //   if (result.result == Result.success) {
    //     Counselor counselor = Counselor.fromJson(result.response);
    //     counselor.savePreference(counselor);
    //   } else {
    //     throw Exception('Failed to getUser');
    //   }
    // } catch (e) {
    //   throw Exception('Failed to getUser');
    // }
  }
}
