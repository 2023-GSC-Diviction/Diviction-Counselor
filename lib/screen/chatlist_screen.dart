import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/style.dart';
import '../service/chat_service.dart';

final counselorListProvider =
    StreamProvider.autoDispose((ref) => ChatService().getChatListData());

class MemberListScreen extends ConsumerStatefulWidget {
  const MemberListScreen({super.key});

  @override
  MemberListScreenState createState() => MemberListScreenState();
}

class MemberListScreenState extends ConsumerState<MemberListScreen> {
  @override
  Widget build(BuildContext context) {
    final chatList = ref.watch(counselorListProvider);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('My Chat', style: TextStyles.titleTextStyle),
          const SizedBox(height: 20),
          chatList.when(
              data: (item) => item.isEmpty
                  ? const Center(child: Text('empty'))
                  : ListView.builder(
                      itemBuilder: ((context, index) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(50)),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item[index].otherName,
                                      style: TextStyles.chatNicknameTextStyle),
                                  const SizedBox(height: 5),
                                  Text(item[index].lastMessage,
                                      style:
                                          TextStyles.chatNotMeBubbleTextStyle)
                                ],
                              )
                            ],
                          ),
                        );
                      }),
                      itemCount: item.length,
                    ),
              error: (e, st) =>
                  Expanded(child: Center(child: Text('Error: $e'))),
              loading: () => const Expanded(
                  child: Center(child: CircularProgressIndicator())))
        ],
      ),
    );
  }
}
