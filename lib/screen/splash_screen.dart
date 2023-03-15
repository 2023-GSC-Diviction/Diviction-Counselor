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
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLogin = ref.watch(loginStateProvider);
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    Future.delayed(const Duration(milliseconds: 1000), () async {
      isLogin.when(
        data: (value) {
          if (value == true) {
            BottomNavigation();
          } else if (value == false) {
            LoginScreen();
          }
        },
        loading: () {},
        error: (error, stackTrace) {},
      );
    });

    return Container(
      color: Colors.white,
      child: const Center(
          child: Text('Diviction', style: TextStyles.splashTitleTextStyle)),
    );
  }
}
