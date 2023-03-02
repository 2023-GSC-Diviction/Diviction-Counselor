import 'package:diviction_counselor/screen/login_screen.dart';
import 'package:diviction_counselor/screen/signup_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: 'NotoSans'
      ),
      home: LoginScreen(),
      // home: SignUpScreen(),
    )
  );
}
