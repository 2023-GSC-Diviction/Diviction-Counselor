import 'package:diviction_counselor/screen/add_checklist_screen.dart';
import 'package:diviction_counselor/screen/memo_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/style.dart';
import '../model/chat.dart';
import '../model/counselor.dart';
import '../model/user.dart';
import '../service/chat_service.dart';
import '../widget/chat/messages.dart';
import '../widget/profile_image.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.chatroomId, required this.user});

  final String chatroomId;
  final User user;

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
            appBar: AppBar(
              toolbarHeight: MediaQuery.of(context).size.height * 0.12,
              backgroundColor: Color.fromARGB(255, 42, 42, 42),
              title: GestureDetector(
                // onTap: () => onProfilePressed(context, widget.counselor),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          ProfileImage(
                            onProfileImagePressed: () => {},
                            // onProfilePressed(context, widget.counselor),
                            isChoosedPicture: false,
                            path: widget.user.profile_img_url,

                            imageSize:
                                MediaQuery.of(context).size.height * 0.07,
                          ),
                          const SizedBox(width: 20),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.user.name,
                                    style: const TextStyle(
                                        color: Palette.appColor3,
                                        fontSize: 23,
                                        fontWeight: FontWeight.bold)),
                                Text(widget.user.address,
                                    style: const TextStyle(
                                        color: Palette.appColor3,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400)),
                              ],
                            ),
                          )
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MemoScreen()));
                        },
                        child: const Icon(
                          Icons.post_add,
                          color: Palette.appColor3,
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: const Icon(
                          Icons.face,
                          color: Palette.appColor3,
                        ),
                      )
                    ]),
              ),
              centerTitle: true,
              elevation: 0,
            ),
            backgroundColor: Color.fromARGB(255, 42, 42, 42),
            extendBodyBehindAppBar: false,
            body: Scaffold(
                floatingActionButton: FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddChecklistScreen(
                                    user: widget.user,
                                  )));
                    },
                    child: Text('add checkList for ${widget.user.name}')),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerTop,
                body: Stack(
                  children: [
                    Container(
                        decoration: const BoxDecoration(
                          color: Palette.appColor3,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30)),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                                child: StreamBuilder(
                              stream: ChatService()
                                  .getChatRoomData(widget.chatroomId),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Messages(
                                      messages: snapshot.data!.messages.reversed
                                          .toList(),
                                      user: widget.user,
                                      memberName: snapshot.data!.user.name);
                                } else {
                                  return const Center(
                                    child: Text('sendMessage'),
                                  );
                                }
                              },
                            )),
                            sendMesssage()
                          ],
                        ))
                  ],
                ))));
  }

  Widget sendMesssage() => Container(
      height: MediaQuery.of(context).size.height * 0.08,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(color: Color.fromARGB(18, 0, 0, 0), blurRadius: 10)
        ],
        color: Palette.appColor4.withOpacity(0.03),
      ),
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
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
        createdAt: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()));

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
            content: 'image@${image.path}',
            sender: userId,
            createdAt:
                DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()));
        ChatService().sendImage(widget.chatroomId, image, message);
      }
      print(image);
    } catch (e) {
      print(e);
    }
  }
}
