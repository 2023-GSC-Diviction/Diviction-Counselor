import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:flutter/material.dart';

import '../../config/style.dart';
import '../../screen/bottom_navigation/ProfileTab/profile_screen.dart';
import '../profile_button.dart';

class ChatBubbles extends StatelessWidget {
  const ChatBubbles(this.message, this.isMe, this.userName, {Key? key})
      : super(key: key);

  final String message;
  final String userName;
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
              child: BubbleSpecialOne(
                  text: message,
                  isSender: true,
                  color: Colors.blue,
                  textStyle: TextStyles.blueBottonTextStyle),
            ),
          if (!isMe)
            Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProfileButton(
                          nickname: userName,
                          id: 'id',
                          onProfilePressed: onProfilePressed),
                      Padding(
                        padding: const EdgeInsets.only(left: 35),
                        child: BubbleSpecialOne(
                          text: message,
                          isSender: false,
                          color: Palette.chatGrayColor,
                          textStyle: TextStyles.chatNotMeBubbleTextStyle,
                        ),
                      )
                    ]))
        ]);
  }

  onProfilePressed(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ProfileScreen()));
  }
}
