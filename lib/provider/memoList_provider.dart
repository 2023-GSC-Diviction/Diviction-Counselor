import 'package:diviction_counselor/model/memo.dart';
import 'package:diviction_counselor/network/dio_client.dart';
import 'package:diviction_counselor/service/memo_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/drug.dart';

class MemoListProvider extends StateNotifier<List<Memo>> {
  MemoListProvider() : super(<Memo>[]);

  final MemoService _memoService = MemoService();
  int? _lastFetchedAt; // 중복 호출 문제로 인해 호출시간 체크함
  // Map<String, String> _options = {};

  @override
  set state(List<Memo> value) {
    super.state = value;
  }

  Future<void> getMemoList(int MatchId) async {
    if (_lastFetchedAt != null && DateTime.now().millisecondsSinceEpoch - _lastFetchedAt! < 500) {
      // 마지막 요청 후 500밀리초 미만인 경우 중복 요청으로 처리
      return;
    }
    _lastFetchedAt = DateTime.now().millisecondsSinceEpoch;

    var memo = await _memoService.getMemoLists(MatchId);
    if (memo.isNotEmpty) {
      state = memo;
    }
  }

  // void addOption(String type, String option) {
  //   _options[type] = option;
  //   _memoService.getMemoLists(MatchId).then((value) {
  //     state = value;
  //   }).catchError((onError) => null);
  // }
}
