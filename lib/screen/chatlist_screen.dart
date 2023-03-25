import 'package:diviction_counselor/model/chat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/style.dart';
import '../service/chat_service.dart';
import 'chat_screen.dart';

final chatProvider = FutureProvider((ref) => ChatService().getChatList());

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
    final chat = ref.watch(chatProvider);

    // return chat.when(data: (data) {
    //   if(data.isNotEmpty){

    //   }
    //   return
    // },)
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('My Chat', style: TextStyles.titleTextStyle),
          const SizedBox(height: 20),
          chat.when(
              data: (data) {
                if (data.isEmpty) {
                  return Center(child: Text('empty'));
                } else {
                  return Expanded(
                      child: StreamBuilder(
                          stream: ChatService().getChatListData(),
                          builder: (context, snapshot) {
                            return ListView.builder(
                                itemBuilder: ((context, index) {
                                  return Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ChatScreen(
                                                            chatroomId: snapshot
                                                                .data![index]
                                                                .chatRoomId,
                                                          )));
                                            },
                                            child: Container(
                                              height: 70,
                                              margin: const EdgeInsets.only(
                                                  bottom: 20),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 50,
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                        color: Colors.grey,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50)),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          snapshot.data![index]
                                                              .otherName,
                                                          style: TextStyles
                                                              .chatNicknameTextStyle),
                                                      const SizedBox(height: 5),
                                                      Text(
                                                          snapshot.data![index]
                                                              .lastMessage,
                                                          style: TextStyles
                                                              .chatNotMeBubbleTextStyle)
                                                    ],
                                                  )
                                                ],
                                              ),
                                            )),
                                        GestureDetector(
                                            onTap: () {},
                                            child: Container(
                                              width: 100,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                color: Colors.blue,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: const Center(
                                                child: Text('accept',
                                                    style: TextStyles
                                                        .blueBottonTextStyle),
                                              ),
                                            ))
                                      ]);
                                }),
                                itemCount: data.length);
                          }));
                }
              },
              error: (e, st) =>
                  Expanded(child: Center(child: Text('Error: $e', style: TextStyle(fontSize: 25),))),
              loading: () => const Expanded(
                  child: Center(child: CircularProgressIndicator())))
        ],
      ),
    );
  }
}
