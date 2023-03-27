import 'package:diviction_counselor/model/network_result.dart';
import 'package:diviction_counselor/network/dio_client.dart';
import 'package:diviction_counselor/screen/add_checklist_screen.dart';
import 'package:diviction_counselor/screen/bottom_nav.dart';
import 'package:diviction_counselor/screen/sign/login_screen.dart';
import 'package:diviction_counselor/screen/splash_screen.dart';
import 'package:diviction_counselor/service/auth_service.dart';
import 'package:diviction_counselor/service/chat_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_options.dart';
import 'model/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "lib/config/.env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  DioClient();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const MaterialApp(
      home: SplashScreen(),
    );
  }
}
