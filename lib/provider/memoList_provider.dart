import 'package:diviction_counselor/model/memo.dart';
import 'package:diviction_counselor/network/dio_client.dart';
import 'package:diviction_counselor/service/memo_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/drug.dart';

class MemoListProvider extends StateNotifier<List<Memo>> {
  MemoListProvider() : super(<Memo>[]);

  final MemoService _memoService = MemoService();
  // Map<String, String> _options = {};

  @override
  set state(List<Memo> value) {
    super.state = value;
  }

  void getMemoList(int MatchId) async {
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
