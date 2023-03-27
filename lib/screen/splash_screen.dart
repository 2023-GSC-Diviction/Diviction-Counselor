import 'package:diviction_counselor/config/style.dart';
import 'package:diviction_counselor/screen/sign/login_screen.dart';
import 'package:diviction_counselor/screen/bottom_nav.dart';
import 'package:diviction_counselor/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final loginStateProvider =
    FutureProvider.autoDispose((ref) => AuthService().isLogin());

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void dispose() {
    super.dispose();
    ref.invalidate(loginStateProvider);
  }

  @override
  Widget build(BuildContext context) {
    final isLogin = ref.watch(loginStateProvider);

    Future.delayed(const Duration(milliseconds: 1000), () async {
      isLogin.when(
        data: (value) {
          if (value == true) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const BottomNavigation())); //
          } else if (value == false) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const BottomNavigation())); //
          } else {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const BottomNavigation())); //
          }
        },
        loading: () {},
        error: (error, stackTrace) {},
      );
      // print('isLogin.value : ${isLogin.value}');
      // if (isLogin.value == null) return;
      // if (isLogin.value!) {
      // BottomNavigation()
      // } else {
      //   Navigator.of(context)
      //       .push(MaterialPageRoute(builder: (context) => const LoginScreen()));
      // }
    });

    return Container(
      color: Colors.white,
      child: const Center(
          child: Text('Diviction', style: TextStyles.splashTitleTextStyle)),
    );
  }
}
