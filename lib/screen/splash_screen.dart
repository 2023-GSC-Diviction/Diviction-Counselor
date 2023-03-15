import 'package:diviction_counselor/config/style.dart';
import 'package:diviction_counselor/screen/login_screen.dart';
import 'package:diviction_counselor/screen/bottom_nav.dart';
import 'package:diviction_counselor/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final loginStateProvider =
    FutureProvider.autoDispose((ref) => AuthService().isLogin());

class SplashScreen extends ConsumerWidget {
  const SplashScreen({Key? key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(authProvider.notifier).isLogin();
    final isLogin = ref.watch(loginStateProvider);
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    Future.delayed(const Duration(milliseconds: 1500), () async {
      print('isLogin.value : ${isLogin.value}');
      if(isLogin.value == null)
        return;
      if (isLogin.value!) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const BottomNavigation()));
      } else {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const LoginScreen()));
      }
    });

    return Container(
      color: Colors.white,
      child: const Center(
          child: Text('Diviction', style: TextStyles.splashTitleTextStyle)),
    );
  }
}
