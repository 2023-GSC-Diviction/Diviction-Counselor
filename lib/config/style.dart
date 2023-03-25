import 'package:flutter/material.dart';

class TextStyles {
  static const TextStyle titleTextStyle = TextStyle(
      fontSize: 22,
      color: Color.fromRGBO(51, 51, 51, 1),
      height: 1.4,
      letterSpacing: 0.02,
      fontWeight: FontWeight.w700);
  static const TextStyle questionTextStyle = TextStyle(
      fontSize: 19,
      color: Color.fromRGBO(51, 51, 51, 1),
      height: 1.4,
      letterSpacing: 0.02,
      fontWeight: FontWeight.w600);
  static const TextStyle answerTextStyle = TextStyle(
      fontSize: 18,
      height: 1.4,
      color: Color.fromRGBO(51, 51, 51, 1),
      fontWeight: FontWeight.w500);

  static const TextStyle mainTextStyle = TextStyle(
      fontSize: 16,
      height: 1.4,
      color: Color.fromRGBO(51, 51, 51, 1),
      fontWeight: FontWeight.w500);

  static const TextStyle bottomTextStyle = TextStyle(
      fontSize: 16,
      color: Color.fromRGBO(51, 51, 51, 1),
      fontWeight: FontWeight.w500);
  static const TextStyle shadowTextStyle = TextStyle(
      letterSpacing: 0.04,
      fontSize: 11,
      color: Color.fromRGBO(82, 82, 82, 0.644));
  static const TextStyle blueBottonTextStyle = TextStyle(
      letterSpacing: 0.04,
      fontSize: 14,
      color: Color.fromRGBO(255, 255, 255, 1));
  static const TextStyle chatNicknameTextStyle =
      TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w600);
  static const TextStyle chatNotMeBubbleTextStyle =
      TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w400);
  static const TextStyle splashTitleTextStyle = TextStyle(
      decoration: TextDecoration.none,
      color: Colors.black54,
      fontSize: 25,
      fontWeight: FontWeight.w600);
  static const TextStyle optionButtonTextStyle = TextStyle(
      color: Colors.black87, fontSize: 14, fontWeight: FontWeight.normal);

  static const TextStyle dialogTextStyle = TextStyle(
      fontSize: 19,
      color: Color.fromRGBO(51, 51, 51, 1),
      height: 1.4,
      letterSpacing: 0.02,
      fontWeight: FontWeight.w600);
  static const TextStyle dialogTextStyle2 = TextStyle(
      fontSize: 16,
      color: Color.fromRGBO(51, 51, 51, 1),
      height: 1.4,
      letterSpacing: 0.02,
      fontWeight: FontWeight.w500);
  static const TextStyle dialogConfirmTextStyle =
      TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16);
  static const TextStyle dialogCancelTextStyle = TextStyle(
      color: Colors.black54, fontWeight: FontWeight.w700, fontSize: 16);
  static const TextStyle commentBtnTextStyle = TextStyle(
      fontSize: 15,
      height: 1.2,
      color: Color.fromRGBO(51, 51, 51, 1),
      fontWeight: FontWeight.w400);
  static const TextStyle descriptionTextStyle =
      TextStyle(color: Color.fromRGBO(153, 153, 153, 1), fontSize: 14);
  static const TextStyle subTitmeTextStyle = TextStyle(
      fontSize: 23,
      color: Colors.white,
      height: 1.4,
      letterSpacing: 0.02,
      fontWeight: FontWeight.w600);

  static const underlineTextStyle = TextStyle(
    color: Color(0xFFC3C3C3),
    decoration: TextDecoration.underline, // 밑줄 넣기
    decorationThickness: 1.5, // 밑줄 두께
    // fontStyle: FontStyle
  );
}

class Palette {
  static const Color appColor = Color(0xFFBD6741C7);
  static const Color appColor2 = Color.fromARGB(255, 255, 255, 255);
  static const Color mainTextColor = Color.fromRGBO(51, 51, 51, 1);
  static const Color chatGrayColor = Color.fromARGB(255, 224, 224, 230);
  static const Color borderColor = Color.fromARGB(255, 203, 203, 209);
  static const Color bottomBoxBorderColor = Color.fromARGB(10, 0, 0, 0);
}

Container dividingLine = Container(
  decoration: BoxDecoration(
    border: Border(
      top: BorderSide(
        width: 1,
        color: Colors.grey,
      ),
    ),
  ),
);

/*
0xFF63C9DB / Color.fromARGB(255, 99, 201, 219)과 비슷한 채도와 명암을 가지는 보라색 계열 색상
0xFF5B84B1 -> DD
0xFF7E8AA2
0xFF5F5AA2
0xFF9D7CBF
0xFF7C5295
----------
0xFFC77DFF
----------
0xFF2EC4B6
0xFF48B5A8
---
0xFF7F8B8C
0xFF95A5A6
 */
