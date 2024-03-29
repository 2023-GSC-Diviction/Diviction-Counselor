import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/chat.dart';
import 'firebase_storage_service.dart';

class ChatService {
  static final ChatService _chatService = ChatService._internal();
  factory ChatService() {
    return _chatService;
  }
  ChatService._internal() {
    // getUserEmail();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<MyChat> userChatlist = [];
  late SharedPreferences prefs;

  String userEmail = '';

  // 저장된 유저 가져오기**
  getUserEmail() async {
    prefs = await SharedPreferences.getInstance();
    userEmail = prefs.getString('email')!.replaceAll('.', '');
    print('userEmail : $userEmail');
  }

  Future<List<MyChat>> getChatList() async {
    prefs = await SharedPreferences.getInstance();
    userEmail = prefs.getString('email')!.replaceAll('.', '');
    print('userEmail : $userEmail');

    try {
      final snapshot =
          await _firestore.collection('users').doc(userEmail).get();
      if (snapshot.exists) {
        final List<MyChat> chats = [];
        (snapshot.data() as Map)
            .entries
            .map((e) => chats.add(MyChat.fromJson(e.value)))
            .toList();

        return chats;
      } else {
        return [];
      }
    } catch (e) {
      print("getChatList - error : $e");
      throw e;
    }
  }

  Stream<List<MyChat>> getChatListData() async* {
    prefs = await SharedPreferences.getInstance();
    userEmail = prefs.getString('email')!.replaceAll('.', '');
    try {
      final data = _firestore
          .collection('users')
          .doc(userEmail)
          .snapshots()
          .map((event) {
        final List<MyChat> chats = [];
        if (event.data() == null) return chats;
        (event.data() as Map)
            .entries
            .map((e) => chats.add(MyChat.fromJson(e.value)))
            .toList();

        return chats;
      });
      yield* data;
    } catch (e) {
      print("getChatListData - error : $e");
      if (e is FirebaseException && e.code == 'path.isNotEmpty') yield [];
    }
  }

  Stream<ChatRoom> getChatRoomData(String chatroomId) {
    try {
      final stream = _firestore
          .collection('chatrooms')
          .doc(chatroomId)
          .snapshots()
          .map((event) => ChatRoom.fromDocumentSnapshot(event));

      return stream;
    } catch (e) {
      throw e;
    }
  }

  void sendMessage(String chatRoomId, Message message) async {
    try {
      final snapshot =
          await _firestore.collection('chatrooms').doc(chatRoomId).get();
      if (snapshot.exists) {
        final roomData = ChatRoom.fromDocumentSnapshot(snapshot);
        final messages = roomData.messages;
        messages.add(message);
        _firestore
            .collection('chatrooms')
            .doc(chatRoomId)
            .update({'messages': messages.map((e) => e.toJson()).toList()});
      }

      savaLastMessage(userEmail, chatRoomId, message); //counselor
      savaLastMessage(chatRoomId.split('&')[1], chatRoomId, message); // member
    } catch (e) {
      print(e);
    }
  }

  savaLastMessage(String id, String chatRoomId, Message message) async {
    try {
      final snapshot = await _firestore.collection('users').doc(id).get();
      if (snapshot.exists) {
        final chat = MyChat.fromJson(snapshot.data()![chatRoomId]);
        if (message.content.contains('image@')) {
          chat.lastMessage = '사진';
        } else {
          chat.lastMessage = message.content;
        }
        chat.lastTime = message.createdAt;
        _firestore
            .collection('users')
            .doc(id)
            .update({chatRoomId: chat.toJson()});
      } else {
        final chat = MyChat(
            chatRoomId: chatRoomId,
            otherEmail: chatRoomId.split('&')[0] == id
                ? chatRoomId.split('&')[1]
                : chatRoomId.split('&')[0],
            otherName: chatRoomId.split('&')[0] == id
                ? chatRoomId.split('&')[1]
                : chatRoomId.split('&')[0],
            otherPhotoUrl: '1',
            lastMessage: message.content,
            lastTime: message.createdAt);
        _firestore.collection('users').doc(id).set({chatRoomId: chat.toJson()});
      }
    } catch (e) {
      if (e is FirebaseException && e.code == 'not-found') {
        final chat = MyChat(
            chatRoomId: chatRoomId,
            otherEmail: chatRoomId.split('&')[0] == id
                ? chatRoomId.split('&')[1]
                : chatRoomId.split('&')[0],
            otherName: chatRoomId.split('&')[0] == id
                ? chatRoomId.split('&')[1]
                : chatRoomId.split('&')[0],
            otherPhotoUrl: '1',
            lastMessage: message.content,
            lastTime: message.createdAt);
        _firestore.collection('users').doc(id).set({chatRoomId: chat.toJson()});
      } else {
        print(e);
      }
    }
  }

  Future sendImage(String chatRoomId, XFile file, Message message) async {
    sendMessage(chatRoomId, message);
    FirebaseStorageService()
        .uploadImage('$chatRoomId/${file.path}', File(file.path));
  }

// 상담사는 채팅방 생성 x
  // Future newChatRoom(ChatRoom chatroom, Message message) async {
  //   saveUserChatlist(
  //       user,
  //       MyChat(
  //           chatRoomId: chatroom.chatRoomId,
  //           otherEmail: chatroom.counselor.email,
  //           otherName: chatroom.counselor.name,
  //           otherPhotoUrl: chatroom.counselor.photoUrl ?? '1',
  //           lastMessage: message.content));
  //   saveUserChatlist(
  //       chatroom.counselor.email.replaceAll('.', ''),
  //       MyChat(
  //           chatRoomId: chatroom.chatRoomId,
  //           otherEmail: chatroom.user.email,
  //           otherName: chatroom.user.name,
  //           otherPhotoUrl: chatroom.user.photoUrl ?? '1',
  //           lastMessage: message.content));

  //   _firestore
  //       .collection('chatrooms')
  //       .doc(chatroom.chatRoomId)
  //       .set(chatroom.toJson());
  // }

  // Future saveUserChatlist(String id, MyChat chat) async {
  //   _firestore
  //       .collection('users')
  //       .doc(id)
  //       .set({chat.chatRoomId: chat.toJson()});
  //   // List<MyChat> rooms = [];
  //   // if (snapshot.exists) {
  //   //   final data = snapshot.data()!['chatlist'];
  //   //   for (var e in data) {
  //   //     rooms.add(MyChat.fromJson(e));
  //   //   }
  //   //   if (rooms.isEmpty) {
  //   //     rooms = [chat];
  //   //   } else {
  //   //     rooms.add(chat);
  //   //   }
  //   // }

  //   // _firestore
  //   //     .collection('users')
  //   //     .doc(id)
  //   //     .set({'chatlist': rooms.map((e) => e.toJson())});
  // }
}
