import 'package:diviction_counselor/model/counselor.dart';
import 'package:diviction_counselor/service/auth_service.dart';
import 'package:diviction_counselor/service/memo_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/user.dart';

enum SaveState { proceeding, success, fail }

class MemoState extends StateNotifier<SaveState> {
  MemoState() : super(SaveState.proceeding);

  @override
  set state(SaveState value) {
    // TODO: implement state
    super.state = value;
  }

  Future memoSave() async {
    // try {
    //   var result = await MemoService().memoSave();
    //   if (result) {
    //     print('자동로그인 성공');
    //     state = SaveState.success;
    //     return;
    //   } else {
    //     print('자동로그인 실패');
    //     state = SaveState.fail;
    //     return;
    //   }
    // } catch (e) {
    //   print(e);
    //   state = SaveState.fail;
    // }
  }
}
