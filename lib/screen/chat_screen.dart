import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/chat.dart';
import '../model/counselor.dart';
import '../service/chat_service.dart';
import '../widget/chat/messages.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.chatroomId});

  final String chatroomId;

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  bool isChoosedPicture = false;
  String newMessage = '';
  bool isSended = false;
  late String userId;
  final sendBoxSize = 40.0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getUserId();
  }

  // 저장된 유저 가져오기**
  getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('email')!;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // 키보드 닫기 이벤트
        },
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            // appBar: const MyAppbar(
            //   isMain: false,
            //   hasBack: true,
            //   hasDialog: false,
            // ),
            extendBodyBehindAppBar: false,
            body: Column(
              children: [
                Expanded(
                    child: StreamBuilder(
                  stream: ChatService().getChatRoomData(widget.chatroomId),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Messages(
                          messages: snapshot.data!.messages.reversed.toList(),
                          userId: userId, // 상담사 id
                          memberName: snapshot.data!.user.name); // 중독자 이름
                    } else {
                      return const Center(
                        child: Text('sendMessage'),
                      );
                    }
                  },
                )),
                sendMesssage()
              ],
            )));
  }

  Widget sendMesssage() => Container(
      height: sendBoxSize + 20,
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(color: Color.fromARGB(18, 0, 0, 0), blurRadius: 10)
        ],
        color: const Color(0xffF4F4F5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(children: [
        IconButton(
          padding: EdgeInsets.zero,
          onPressed: onSendImagePressed,
          icon: const Icon(Icons.camera_alt),
          color: Colors.blue,
          iconSize: 25,
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
            child: TextField(
          maxLines: null,
          keyboardType: TextInputType.multiline,
          textCapitalization: TextCapitalization.sentences,
          controller: _controller,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              onPressed: onSendMessage,
              icon: const Icon(Icons.send),
              color: Colors.blue,
              iconSize: 25,
            ),
            hintText: "Type your message here",
            hintMaxLines: 1,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
            hintStyle: const TextStyle(
              fontSize: 16,
            ),
            fillColor: Colors.white,
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: const BorderSide(
                color: Colors.white,
                width: 0.2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: const BorderSide(
                color: Colors.black26,
                width: 0.2,
              ),
            ),
          ),
          onChanged: (value) {
            newMessage = value;
          },
        )),
      ]));

  onSendMessage() {
    final Message message = Message(
        content: newMessage,
        sender: userId,
        createdAt: DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now()));

    ChatService().sendMessage(
      widget.chatroomId,
      message,
    );

    _controller.text = '';
    FocusScope.of(context).unfocus();
  }

  onSendImagePressed() async {
    final picker = ImagePicker();
    try {
      final image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          isChoosedPicture = true;
        });
        final message = Message(
            content: '@image/${image.path}',
            sender: userId,
            createdAt:
                DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now()));
        ChatService().sendImage(widget.chatroomId, image, message);
      }
      print(image);
    } catch (e) {
      print(e);
    }
  }
}
