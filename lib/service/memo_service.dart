import 'package:dio/dio.dart';
import 'package:diviction_counselor/model/counselor.dart';
import 'package:diviction_counselor/model/memo.dart';
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

  Future memoSave(Map<String, dynamic> data) async {
    try {
      NetWorkResult result =
          await DioClient().request('post', '$_baseUrl/memo/save', data, false);
      if (result.result == Result.success) {
        return true;
      } else {
        throw Exception('Failed to MemoSaved');
      }
    } catch (e) {
      throw Exception('Failed to MemoSaved');
    }
  }

  Future<List<Memo>> getMemoLists(int matchId) async {
    try {
      NetWorkResult response = await DioClient()
          .request('get', '$_baseUrl/memo/get/$matchId', {}, false);
      if (response.result == Result.success) {
        var res = response.response;
        // print("res : $res");
        List<Memo> memo = res
            .map(
              (memo) {
                return Memo.fromJson(memo);
              },
            )
            .cast<Memo>()
            .toList();
        return memo;
      } else {
        throw Exception('Failed to load memolists');
      }
    } catch (e) {
      throw Exception('Error : Failed to load memolists, 에러메시지 : $e');
    }
  }

  Future memoUpdate(Map<String, dynamic> data) async {
    try {
      NetWorkResult result = await DioClient().request(
          'put',
          '$_baseUrl/memo/update/${data['memoId']}',
          {
            'title': null,
            'content': data['content'],
          },
          false);
      if (result.result == Result.success) {
        return true;
      } else {
        throw Exception('Failed to MemoUpdate');
      }
    } catch (e) {
      throw Exception('Failed to MemoUpdate');
    }
  }

  Future memoDelete(Map<String, dynamic> data) async {
    try {
      NetWorkResult result = await DioClient().request(
          'delete', '$_baseUrl/memo/delete/${data['memoId']}', {}, false);
      if (result.result == Result.success) {
        return true;
      } else {
        throw Exception('Failed to MemoDelete');
      }
    } catch (e) {
      throw Exception('Failed to MemoDelete');
    }
  }
}
