import 'package:diviction_counselor/model/network_result.dart';
import 'package:diviction_counselor/network/dio_client.dart';
import 'package:diviction_counselor/screen/bottom_nav.dart';
import 'package:diviction_counselor/screen/login_screen.dart';
import 'package:diviction_counselor/screen/splash_screen.dart';
import 'package:diviction_counselor/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final loginStateProvider =
FutureProvider.autoDispose((ref) => AuthService().isLogin());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "lib/config/.env");
  DioClient();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 앱시작시 바로 토큰 검증을 해서 스플레시 1초후 값을 읽고 바로 이동할 수 있게끔
    ref.read(authProvider.notifier).isLogin();
    return const MaterialApp(
      home: SplashScreen(),
    );
  }
}

