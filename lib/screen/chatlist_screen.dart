import 'package:cached_network_image/cached_network_image.dart';
import 'package:diviction_counselor/model/chat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/style.dart';
import '../service/auth_service.dart';
import '../service/chat_service.dart';
import '../util/chat_time_format.dart';
import '../widget/chat/chat_bubble.dart';
import 'chat_screen.dart';

// final chatProvider = FutureProvider((ref) => ChatService().getChatList());
final chatListProvider =
    StreamProvider.autoDispose((ref) => ChatService().getChatListData());

class MemberListScreen extends ConsumerStatefulWidget {
  const MemberListScreen({super.key});

  @override
  MemberListScreenState createState() => MemberListScreenState();
}

class MemberListScreenState extends ConsumerState<MemberListScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getList();
  }

  // getList() async {
  //   final list = ChatService().getChatList();
  //   chatList = await list;
  // }

  // List<MyChat> chatList = [];

  @override
  Widget build(BuildContext context) {
    final chat = ref.watch(chatListProvider);

    // return chat.when(data: (data) {
    //   if(data.isNotEmpty){

    //   }
    //   return
    // },)

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('My Chat', style: TextStyles.titleTextStyle),
        const SizedBox(height: 20),
        chat.when(
            data: (data) {
              if (data.isEmpty) {
                return Center(child: Text('empty'));
              } else {
                return chatList(data);
                // StreamBuilder(
                //     stream: ChatService().getChatListData(),
                //     builder: (context, snapshot) {
                //       if (snapshot.data != null) {
                // return

                // } else {
                //   return Container(
                //     child: Text('No Chat'),
                //   );
                // }
                // }),
              }
            },
            error: (e, st) => Expanded(
                    child: Center(
                        child: Text(
                  'Error: $e',
                  style: TextStyle(fontSize: 25),
                ))),
            loading: () => const Expanded(
                child: Center(child: CircularProgressIndicator())))
      ]),
    );
  }

  onButtonPressed(String chatRoomId, String userEmail) async {
    final user = await AuthService().getUser(userEmail);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChatScreen(
                  chatroomId: chatRoomId,
                  user: user,
                )));
  }

  Widget chatList(List<MyChat> chats) {
    return Expanded(
        child: ListView.builder(
            itemCount: chats.length,
            shrinkWrap: false,
            padding: const EdgeInsets.only(bottom: 40),
            itemBuilder: (context, index) {
              return InkWell(
                  onTap: () => onButtonPressed(
                      chats[index].chatRoomId, chats[index].otherEmail),
                  child: Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: Stack(children: [
                        Container(
                          child: Row(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ProfileButton(
                                    name: chats[index].otherName,
                                    path: chats[index].otherPhotoUrl,
                                    type: false,
                                    onProfilePressed: () {}),
                                const SizedBox(
                                  width: 20,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(chats[index].otherName,
                                        style: TextStyles.chatHeading),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(chats[index].lastMessage,
                                        style: TextStyles.chatbodyText),
                                  ],
                                ),
                              ]),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Text(dataTimeFormat(chats[index].lastTime),
                              style: TextStyles.chatTimeText),
                        )
                      ])));
            }));
  }
}
