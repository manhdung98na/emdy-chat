import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emdy_chat/configure/assets.dart';
import 'package:emdy_chat/controller/user_avatar_controller.dart';
import 'package:emdy_chat/manager/firebase_manager.dart';
import 'package:emdy_chat/modal/user.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UserManager {
  UserManager._();

  static String? uid;
  static User? currentUser;

  static Widget get avatarWidget {
    if (currentUser?.avatar == null) {
      return Image.asset(AssetsConfig.defaultAvatar);
    }
    return Image.memory(
      currentUser!.avatar!,
      fit: BoxFit.cover,
    );
  }

  static Future<void> getUserById() async {
    await FirebaseFirestore.instance
        .collection(FirebaseManager.userCollection)
        .doc(uid)
        .get()
        .then((value) {
      currentUser = User.fromSnapshot(value);
    });
  }

  static Future<void> getAvatar() async {
    currentUser?.avatar = await FirebaseStorage.instance
        .ref('${FirebaseManager.usersStorage}/$uid')
        .getData();
    UserAvatarController.instance.rebuild();
  }

  static Future<bool> updateAvatar(Uint8List avatar) async {
    return await FirebaseStorage.instance
        .ref('${FirebaseManager.usersStorage}/$uid')
        .putData(avatar)
        .then((p0) => true)
        .onError((error, stackTrace) {
      print(error);
      return false;
    });
  }

  static Future<bool> removeAvatar() async {
    return await FirebaseStorage.instance
        .ref('${FirebaseManager.usersStorage}/$uid')
        .delete()
        .then((p0) => true)
        .onError((error, stackTrace) {
      print(error);
      return false;
    });
  }

  static void reset() {
    uid = null;
    currentUser = null;
  }
}
