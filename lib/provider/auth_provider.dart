import 'package:diviction_counselor/model/counselor.dart';
import 'package:diviction_counselor/service/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user.dart';

enum SignState { proceeding, success, fail }

class AuthState extends StateNotifier<SignState> {
  AuthState() : super(SignState.proceeding);

  @override
  set state(SignState value) {
    // TODO: implement state
    super.state = value;
  }

  Future isLogin() async {
    try {
      var result = await AuthService().isLogin();
      if (result) {
        print('자동로그인 성공');
        state = SignState.success;
        return;
      } else {
        print('자동로그인 실패');
        state = SignState.fail;
        return;
      }
    } catch (e) {
      print(e);
      state = SignState.fail;
    }
  }

  Future signIn(String email, String password) async {
    try {
      var result = await AuthService().signIn(email, password);

      if (result) {
        print('로그인 성공');
        state = SignState.success;
        return;
      } else {
        print('로그인 실패');
        state = SignState.fail;
        return;
      }
    } catch (e) {
      print(e);
      state = SignState.fail;
    }
  }

  // Future signUp(Map<String, dynamic> counselor) async {
  //   try {
  //     bool result = await AuthService().signUp(counselor);
  //     if (result) {
  //       print('회원가입 성공');
  //       state = LoadState.success;
  //     } else {
  //       print('회원가입 실패');
  //       state = LoadState.fail;
  //     }
  //   } catch (e) {
  //     print(e);
  //     state = LoadState.fail;
  //   }
  // }

  Future SignupWithloadImage(String path, Map<String, String> counselor) async {
    try {
      var result = await AuthService().SignupWithloadImage(path: path, counselor: counselor);
      if (result) {
        state = SignState.success;
      } else {
        state = SignState.fail;
      }
    } catch (e) {
      print(e);
      state = SignState.fail;
    }
  }

  saveData(String email) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('email') == null || prefs.getString('email') != email) {
      AuthService().getCounselor(email);
    }
  }
}
