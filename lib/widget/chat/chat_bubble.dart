import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:diviction_counselor/model/chat.dart';
import 'package:diviction_counselor/screen/profile/user_profile_screen.dart';
import 'package:diviction_counselor/service/auth_service.dart';
import 'package:flutter/material.dart';

import '../../config/style.dart';
import '../../model/user.dart';
import '../../screen/bottom_navigation/ProfileTab/profile_screen.dart';
import '../../util/chat_time_format.dart';
import '../profile_button.dart';

class ChatBubbles extends StatelessWidget {
  const ChatBubbles(this.message, this.isMe, this.user, {Key? key})
      : super(key: key);

  final Message message;
  final User user;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (isMe)
            Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child:
                    Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text(dataTimeFormat(message.createdAt),
                      style: TextStyles.shadowTextStyle),
                  BubbleSpecialOne(
                      text: message.content,
                      isSender: true,
                      color: Colors.blue,
                      textStyle: TextStyles.blueBottonTextStyle),
                ])),
          if (!isMe)
            Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProfileButton(
                          name: user.email,
                          path: user.profile_img_url,
                          type: true,
                          onProfilePressed: () {
                            onProfilePressed(context, user.email);
                          }),
                      Padding(
                          padding: const EdgeInsets.only(left: 35),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                BubbleSpecialOne(
                                  text: message.content,
                                  isSender: false,
                                  color: Palette.appColor2.withOpacity(0.3),
                                  textStyle:
                                      TextStyles.chatNotMeBubbleTextStyle,
                                ),
                                Text(dataTimeFormat(message.createdAt),
                                    style: TextStyles.shadowTextStyle),
                              ]))
                    ]))
        ]);
  }

  onProfilePressed(BuildContext context, String email) async {
    User user = await AuthService().getUser(email);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => UserProfileScreen(
                  user: user,
                )));
  }
}

class ProfileButton extends StatelessWidget {
  const ProfileButton(
      {required this.name,
      required this.path,
      this.onProfilePressed,
      required this.type,
      super.key});

  final String name;
  final String? path;
  final bool type;
  final onProfilePressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        ProfileImage(
          onProfileImagePressed: onProfilePressed,
          isChoosedPicture: false,
          path: path,
          type: 1,
          imageSize: 40,
        ),
        !type
            ? Container()
            : GestureDetector(
                onTap: () => onProfilePressed,
                child: Container(
                    padding: EdgeInsets.only(left: 10),
                    child:
                        Text(name, style: TextStyles.chatNicknameTextStyle))),
      ]),
    );
  }
}

class ProfileImage extends StatefulWidget {
  final onProfileImagePressed;
  final isChoosedPicture;
  final String? path;
  final int type;
  final double imageSize;

  const ProfileImage({
    Key? key,
    required this.onProfileImagePressed,
    required this.isChoosedPicture,
    required this.path,
    required this.type,
    required this.imageSize,
  }) : super(key: key);

  @override
  State<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      GestureDetector(
          onTap: widget.onProfileImagePressed,
          child: Container(
            width: widget.imageSize,
            height: widget.imageSize,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: widget.path != null
                      ? NetworkImage(
                          'https://storage.googleapis.com/diviction/user-profile/1904839d-fa3e-4c5b-af64-2028dcbcc56d')
                      : const AssetImage('assets/icons/counselor.png')
                          as ImageProvider,
                  fit: BoxFit.cover),
            ),
          )),
      widget.type == 0
          ? Positioned(
              // Positioned : 위치 정렬에 쓰임. 아래는 오른쪽 아래로 부터 0.01만큼 떨어지게 배치하라는 코드
              right: 0,
              bottom: 0,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                width: MediaQuery.of(context).size.height * 0.045,
                height: MediaQuery.of(context).size.height * 0.045,
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 23,
                ),
              ),
            )
          : const SizedBox()
    ]);
  }
}
