import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emdy_chat/manager/firebase_manager.dart';
import 'package:emdy_chat/manager/user_manager.dart';
import 'package:emdy_chat/modal/chat.dart';
import 'package:emdy_chat/modal/message.dart';
import 'package:emdy_chat/util/constant.dart';
import 'package:emdy_chat/util/type_util.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class ChatPageController extends ChangeNotifier {
  static final Map<String, ChatPageController> _instances = {};
  static Map<String, ChatPageController> get instances => _instances;

  final Chat chat;

  ///Stream listen messages of current [chat]
  StreamSubscription? streamSubscription;

  ///For user to text message and send to cloud
  late TextEditingController teMessage;

  ChatPageController(this.chat) {
    _instances[chat.id] = this;
    teMessage = TextEditingController(text: '');
    listenMessagesOfChat();
  }

  void listenMessagesOfChat() {
    print('AsyncMessages of ChatID = ${chat.id}: Init');
    streamSubscription?.cancel();
    streamSubscription = FirebaseFirestore.instance
        .collection(FirebaseManager.chatCollection)
        .doc(chat.id)
        .collection(FirebaseManager.messageCollection)
        .snapshots()
        .listen((snapshot) {
      chat.messages.clear();
      for (var messageDoc in snapshot.docs) {
        chat.messages.add(Message.fromDocumentSnapshot(messageDoc));
      }
      chat.messages.sort((a, b) => b.time.compareTo(a.time));
      notifyListeners();
    });
  }

  Future<String> sendMessage({String? message}) async {
    String content = message ?? teMessage.text.trim();
    if (content.isEmpty) {
      return success;
    }
    late String result;
    teMessage.clear();
    await FirebaseFirestore.instance
        .collection(FirebaseManager.chatCollection)
        .doc(chat.id)
        .collection(FirebaseManager.messageCollection)
        .doc(FirebaseManager.randomId())
        .set({
      'chatId': chat.id,
      'content': content,
      'senderId': UserManager.uid,
      'time': DateTime.now(),
      'type': MessageType.text
    }).then((_) {
      result = success;
      FirebaseFirestore.instance
          .collection(FirebaseManager.chatCollection)
          .doc(chat.id)
          .update({
        'recentAction': RecentActionType.sentMessage,
        'recentActor': UserManager.uid,
        'recentTime': Timestamp.now()
      });
    }).onError((error, stackTrace) {
      print(error);
      result = error.toString();
    });
    return result;
  }

  Future<String> sendImage(Uint8List image, int messageType) async {
    String randomId = FirebaseManager.randomId();
    String storageRef = messageType == MessageType.picture
        ? '${FirebaseManager.messagesStorage}/${chat.id}/${FirebaseManager.imageStorage}/$randomId'
        : '${FirebaseManager.messagesStorage}/${chat.id}/${FirebaseManager.videoStorage}/$randomId';
    String? imageUrl;
    String result = await FirebaseStorage.instance
        .ref(storageRef)
        .putData(image)
        .then((p0) async {
      FirebaseFirestore.instance
          .collection(FirebaseManager.chatCollection)
          .doc(chat.id)
          .update({
        'recentAction': RecentActionType.sentMedia,
        'recentActor': UserManager.uid,
        'recentTime': Timestamp.now()
      });
      FirebaseManager.storageMediaCache[randomId] = image;
      imageUrl = await p0.ref.getDownloadURL();
      return success;
    }).onError((error, stackTrace) {
      print(error);
      return error.toString();
    });
    if (result == success) {
      result = await FirebaseFirestore.instance
          .collection(FirebaseManager.chatCollection)
          .doc(chat.id)
          .collection(FirebaseManager.messageCollection)
          .doc(randomId)
          .set({
            'chatId': chat.id,
            'content': imageUrl,
            'senderId': UserManager.uid,
            'time': DateTime.now(),
            'type': messageType,
          })
          .then((value) => success)
          .onError((error, stackTrace) {
            print(error);
            return error.toString();
          });
    }
    return success;
  }

  void cancelStream() {
    print('AsyncMessages of ChatID = ${chat.id}: Cancel');
    streamSubscription?.cancel();
  }

  Future<void> deleteChat() async {
    await chat.delete().then((value) {
      FirebaseStorage.instance
          .ref('${FirebaseManager.messagesStorage}/${chat.id}')
          .delete();
    });
  }

  void rebuild(Chat other) {
    chat.copyFrom(other);
    notifyListeners();
  }

  @override
  void dispose() {
    _instances.remove(chat.id);
    super.dispose();
  }
}
