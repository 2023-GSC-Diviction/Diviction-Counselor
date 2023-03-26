import 'package:diviction_counselor/provider/auth_provider.dart';
import 'package:diviction_counselor/screen/bottom_nav.dart';
import 'package:diviction_counselor/widget/title_header.dart';
import 'package:diviction_counselor/model/network_result.dart';
import 'package:diviction_counselor/network/dio_client.dart';
import 'package:diviction_counselor/screen/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:diviction_counselor/widget/custom_round_button.dart';

// StateNotifierProvider는 StateNotifier를 이용하여 상태 관리를 하는 클래스
//
final authProvider = StateNotifierProvider.autoDispose<AuthState, SignState>(
    (ref) => AuthState());

final underlineTextStyle = TextStyle(
  color: Color(0xFFC3C3C3),
  decoration: TextDecoration.underline, // 밑줄 넣기
  decorationThickness: 1.5, // 밑줄 두께
  // fontStyle: FontStyle
);

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  TextEditingController textEditingController_id = TextEditingController();
  TextEditingController textEditingController_pw = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // authProvider의 상태를 무효화시키는 역할, Provider의 상태 변화를 다른 Consumer들이 반영
    ref.invalidate(authProvider);
  }

  @override
  Widget build(BuildContext context) {
    final isLogin = ref.watch(authProvider);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      switch (isLogin) {
        case SignState.success:
          // Provider의 상태 변화를 다른 Consumer들이 반영
          ref.invalidate(authProvider);
          toMain();
          break;
        case SignState.fail:
          showSnackbar();
          ref.refresh(authProvider);
          break;
        default:
      }
    });

    // GestureDetector를 최상단으로 두고, requestFocus(FocusNode())를 통해서 키보드를 닫을 수 있음.
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.21),
              TitleHeader(
                titleContext: 'Log In',
                subContext:
                    'Experience a service that helps prevent and treat various addictions with Diviction.',
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              _CustomInputField(
                HintText: 'E-Mail',
                textEditingController: textEditingController_id,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.015),
              _CustomInputField(
                HintText: 'Password',
                textEditingController: textEditingController_pw,
              ),
              _PushSignupPage(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.20),
              CustomRoundButton(
                title: 'Log In',
                onPressed: onPressedLoginButton,
              ),
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    "Forget Password?",
                    style: underlineTextStyle,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  onPressedLoginButton() async {
    print('로그인 버튼 눌림');
    print('아이디 : ${textEditingController_id.text}');
    print('비밀번호 : ${textEditingController_pw.text}');

    if (textEditingController_id.text == '' ||
        textEditingController_pw.text == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('fill in the blank'),
          duration: Duration(seconds: 1),
        ),
      );
    }
    // API Call : authProvider의 notifier를 사용하여, signIn() 메서드를 호출
    else {
      ref
          .read(authProvider.notifier)
          .signIn(textEditingController_id.text, textEditingController_pw.text);
    }
  }

  // 로그인 성공시
  void toMain() {
    Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                const BottomNavigation()) // 리버팟 적용된 HomeScreen 만들기
        );
  }

  // 로그인 실패시
  void showSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('login fail'),
      ),
    );
  }
}

class _CustomInputField extends StatelessWidget {
  final HintText;
  final textEditingController;

  const _CustomInputField({
    Key? key,
    required this.HintText,
    required this.textEditingController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.055,
      decoration: BoxDecoration(
        color: Color(0xFFEEEEEE),
        borderRadius: BorderRadius.circular(56),
        border: Border.all(width: 1, color: Colors.black12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              HintText == 'E-Mail' ? Icons.email_outlined : Icons.key_outlined,
              size: 30,
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.01),
            Expanded(
              child: TextField(
                obscureText: HintText != 'E-Mail',
                controller: textEditingController,
                cursorColor: Colors.grey,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  border: InputBorder.none, // TextField 아래 밑줄 제거
                  hintText: HintText,
                  hintStyle: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PushSignupPage extends StatelessWidget {
  const _PushSignupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(),
        TextButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => SignupScreen(),
              ),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Don't have an account?",
                style: underlineTextStyle,
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.02),
              Text(
                'Sign up',
                style: TextStyle(color: Color(0xFF3E3E3E)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
