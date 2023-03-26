import 'package:diviction_counselor/config/style.dart';
import 'package:diviction_counselor/screen/login_screen.dart';
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
  bool isMounted = true;

  @override
  void dispose() {
    isMounted = false;
    ref.invalidate(loginStateProvider);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.read(authProvider.notifier).isLogin();
    final isLogin = ref.watch(loginStateProvider);

    Future.delayed(const Duration(milliseconds: 2000), () async {
      print('isLogin.value : ${isLogin.value}');
      if (!isMounted || isLogin.value == null) return;
      if (isLogin.value!) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const BottomNavigation())); // BottomNavigation()
      } else {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const LoginScreen()));
      }
    });

    return Container(
      color: Colors.white,
      child: const Center(
          child: Text('Diviction', style: TextStyles.splashTitleTextStyle)),
    );
  }
}
