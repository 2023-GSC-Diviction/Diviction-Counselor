import 'dart:io';

import 'package:flutter/material.dart';

class ProfileImage extends StatefulWidget {
  final onProfileImagePressed;
  final isChoosedPicture;
  final String? path;
  final imageSize;

  const ProfileImage({
    Key? key,
    required this.onProfileImagePressed,
    required this.isChoosedPicture,
    required this.path,
    this.imageSize,
  }) : super(key: key);

  @override
  State<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(children: [
        IconButton(
          onPressed: widget.onProfileImagePressed,
          // ClipOval : 아래 자식의 UI를 동그랗게 만들어주는 위젯
          icon: (() {
            if (widget.isChoosedPicture)
              return ClipOval(child: choosedImage());
            else
              return ClipOval(child: Image.asset('assets/icons/user_icon.png'));
          })(),
          // 이미지 크기는 iconSize에서 조절함
          iconSize:
              widget.imageSize ?? MediaQuery.of(context).size.height * 0.12,
        ),
        // Positioned(
        //   // Positioned : 위치 정렬에 쓰임. 아래는 오른쪽 아래로 부터 0.01만큼 떨어지게 배치하라는 코드
        //   right: MediaQuery.of(context).size.height * 0.01,
        //   bottom: MediaQuery.of(context).size.height * 0.01,
        //   child: SizedBox(
        //     width: MediaQuery.of(context).size.height * 0.025,
        //     height: MediaQuery.of(context).size.height * 0.025,
        //     child: Image.asset('assets/image/Pencil.png', fit: BoxFit.fill),
        //   ),
        // ),
      ]),
    );
  }

  Widget choosedImage() {
    return widget.path == null
        ? defaultImage()
        : Image.network(
            widget.path!,
            width: double.maxFinite,
            height: double.maxFinite,
            fit: BoxFit.fill,
          );
  }

  Widget defaultImage() {
    return Image.asset(
      'assets/image/DefaultProfileImage.png',
      width: double.maxFinite,
      height: double.maxFinite,
      fit: BoxFit.fill,
    );
  }
}
