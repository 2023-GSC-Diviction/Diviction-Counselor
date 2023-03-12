import 'package:diviction_counselor/screen/login_screen.dart';
import 'package:diviction_counselor/screen/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: 'NotoSans'
      ),
      home: LoginScreen(),
      // home: SignUpScreen(),
    );
  }
}

