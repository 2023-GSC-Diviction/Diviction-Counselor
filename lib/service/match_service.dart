import 'package:dio/dio.dart';
import 'package:diviction_counselor/model/counselor.dart';
import 'package:diviction_counselor/model/network_result.dart';
import 'package:diviction_counselor/network/dio_client.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as fss;
import '../model/user.dart';

const storage = fss.FlutterSecureStorage();

class MatchService {
  static final MatchService _matchService = MatchService._internal();
  factory MatchService() {
    return _matchService;
  }
  MatchService._internal();

  final String? _baseUrl = dotenv.env['BASE_URL'];

  Future<List<dynamic>> getMatchList(int counselorId) async {
    try {
      NetWorkResult result = await DioClient().get(
          '$_baseUrl/counselor/match/list/$counselorId', {}, false);
      if (result.result == Result.success) {
        return result.response;
      } else {
        throw Exception('Failed to getMatchList');
      }
    } catch (e) {
      throw Exception('Failed to getMatchList');
    }
  }

  // get 테스트용 정상 작동함
  // Future<NetWorkResult> getMatchList() async {
  //   try {
  //     NetWorkResult result = await DioClient()
  //         .get('$_baseUrl/audit/list/member/7', {}, false);
  //     print(result.response);
  //     if (result.result == Result.success) {
  //       return NetWorkResult(result: Result.success, response: result.response);
  //     } else {
  //       return NetWorkResult(result: Result.fail);
  //     }
  //   } catch (e) {
  //     return NetWorkResult(result: Result.fail, response: e);
  //   }
  // }

}
