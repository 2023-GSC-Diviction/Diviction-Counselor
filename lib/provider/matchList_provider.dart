import 'package:diviction_counselor/model/network_result.dart';
import 'package:diviction_counselor/network/dio_client.dart';
import 'package:diviction_counselor/service/matchList_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MatchListProvider extends StateNotifier<List<dynamic>> {
  MatchListProvider() : super([]);
  int? _lastFetchedAt;

  Future<void> getMatchList() async {
    if (_lastFetchedAt != null && DateTime.now().millisecondsSinceEpoch - _lastFetchedAt! < 500) {
      // 마지막 요청 후 500밀리초 미만인 경우 중복 요청으로 처리
      return;
    }
    _lastFetchedAt = DateTime.now().millisecondsSinceEpoch;

    try {
      final matches = await MatchingService().getMatchList(1);
      state = matches;
    } catch (e) {
      throw Exception('Failed to getMatchList');
    }
  }
}