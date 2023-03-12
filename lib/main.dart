import 'package:diviction_counselor/model/network_result.dart';
import 'package:diviction_counselor/network/dio_client.dart';
import 'package:diviction_counselor/screen/bottom_nav.dart';
import 'package:diviction_counselor/screen/login_screen.dart';
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
      home: FutureBuilder<bool>(
        future: tokenValidate(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data!) {
              return BottomNavigation();
            } else {
              return LoginScreen();
            }
          } else {
            return Container(
              color: Colors.white,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
      // home: SignUpScreen(),
    );
  }

  Future<bool> tokenValidate() async {
    final AT = await storage.read(key: 'accessToken');
    final RT = await storage.read(key: 'refreshToken');
    print('accessToken : $AT');
    print('refreshToken : $RT');
    var response = await DioClient().postTokenDaildate(
      '$baseUrl/auth/validate/token'
    );

    if (response.result == Result.success) {
      print("정상적인 토큰 검증 API Call 결과값 : ${response.response}");
      return response.response;
    }
    print("정상적인 토큰 검증 API Call이 이루어지지 않았습니다.");
    return false;
  }
}

