import 'package:diviction_counselor/model/counselor.dart';
import 'package:diviction_counselor/model/network_result.dart';
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

  Future memoSave(Map<String, dynamic> data) async {
    try {
      var result = await MemoService().memoSave(data);
      if (result) {
        print('메모저장 성공');
        state = SaveState.success;
        return true;
      } else {
        print('메모저장 실패');
        state = SaveState.fail;
        return false;
      }
    } catch (e) {
      print(e);
      state = SaveState.fail;
      return false;
    }
  }

  Future memoUpdate(Map<String, dynamic> data) async {
    try {
      var result = await MemoService().memoUpdate(data);
      if (result) {
        print('메모수정 성공');
        state = SaveState.success;
        return true;
      } else {
        print('메모수정 실패');
        state = SaveState.fail;
        return false;
      }
    } catch (e) {
      print('메모수정 실패, $e');
      state = SaveState.fail;
      return false;
    }
  }
}
