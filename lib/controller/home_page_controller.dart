import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emdy_chat/controller/chat_page/chat_page_controller.dart';
import 'package:emdy_chat/manager/firebase_manager.dart';
import 'package:emdy_chat/manager/user_manager.dart';
import 'package:emdy_chat/modal/chat.dart';
import 'package:emdy_chat/util/type_util.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class HomePageController extends ChangeNotifier {
  static final HomePageController _instance = HomePageController._();
  static HomePageController get instance => _instance;
  HomePageController._();

  ///All chats of current user
  late List<Chat> chats;

  ///Avatar of members in chat
  late Map<String, Uint8List?> avatar;

  ///index of screens
  late int indexScreen;

  ///To identify if having at least 1 listener is open
  ///
  ///* True = [chatStream] is listening
  ///* False = [chatStream] is not
  late bool isStreaming;

  ///This listens the changes of [chats] collection
  StreamSubscription? chatStream;

  ///[TextEdittingController] for search text field
  TextEditingController? teSearch;

  void initialize() async {
    isStreaming = false;
    chats = [];
    avatar = {};
    indexScreen = 0;
    teSearch = teSearch ?? TextEditingController();
    asyncChatsFromCloud();
  }

  void asyncChatsFromCloud() {
    if (isStreaming) {
      return;
    }
    print('AsyncChats: Init');
    isStreaming = true;
    chatStream?.cancel();
    chatStream = FirebaseFirestore.instance
        .collection(FirebaseManager.chatCollection)
        .where('members', arrayContains: UserManager.uid)
        .snapshots()
        .listen((snapshots) async {
      chats.clear();
      if (snapshots.size == 0) {
        return;
      }
      for (var doc in snapshots.docs) {
        Chat temp = Chat.fromDocumentSnapshot(doc);
        chats.add(temp);
        if (!avatar.containsKey(temp.theOppositeId)) {
          avatar[temp.theOppositeId] = await FirebaseStorage.instance
              .ref('${FirebaseManager.usersStorage}/${temp.theOppositeId}')
              .getData();
        }
      }
      chats.sort((a, b) => a.recentTime.compareTo(b.recentTime));
      for (var docChange in snapshots.docChanges) {
        var chatChange =
            chats.firstWhere((element) => element.id == docChange.doc.id);
        if (ChatPageController.instances.containsKey(chatChange.id)) {
          ChatPageController.instances[chatChange.id]!.rebuild(chatChange);
        }
      }
      notifyListeners();
    });
  }

  switchScreen(int newIndex) {
    if (indexScreen == newIndex) {
      return;
    }
    indexScreen = newIndex;
    notifyListeners();
  }

  Iterable<Chat> filterChats() {
    switch (indexScreen) {
      case 0:
        return chats.where((element) => element.status == ChatStatus.accepted);
      case 1:
        return chats.where((element) => element.status == ChatStatus.ignored);
      default:
        return chats.where((element) => element.status == ChatStatus.block);
    }
  }

  void cancelStream() {
    print('AsyncChats: Cancel');
    chatStream?.cancel();
    isStreaming = false;
    teSearch = null;
    UserManager.reset();
  }
}
