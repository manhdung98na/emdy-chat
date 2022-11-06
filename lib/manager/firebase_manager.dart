import 'dart:math';

import 'package:flutter/foundation.dart';

class FirebaseManager {
  FirebaseManager._();

  ///This caches all image and thumbail of video
  static final Map<String, Uint8List> storageMediaCache = {};

  //Firestore
  static const String chatCollection = 'chats';
  static const String messageCollection = 'messages';
  static const String userCollection = 'users';

  //Storage
  static const String chatAvatarStorage = 'chat_avatar';
  static const String messagesStorage = 'messages';
  static const String usersStorage = 'users';
  static const String imageStorage = 'imgs';
  static const String videoStorage = 'vids';

  static String randomId() {
    DateTime now = DateTime.now();
    int idTemp = now.millisecondsSinceEpoch;
    for (int i = 1; i <= 3; i++) {
      idTemp = idTemp * 10 + Random().nextInt(10);
    }
    return idTemp.toString();
  }
}
