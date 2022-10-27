import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emdy_chat/controller/chat_page/chat_page_controller.dart';
import 'package:emdy_chat/manager/user_manager.dart';
import 'package:emdy_chat/modal/user.dart';
import 'package:flutter/cupertino.dart';

class ChangeNicknameController extends ChangeNotifier {
  ChangeNicknameController(this.chatPageController) {
    getOtherUserInfo();
    isLoading = false;
    thisNickname = TextEditingController(text: currentUserNickname);
    otherNickname = TextEditingController(text: otherUserNickname);
    formKey = GlobalKey<FormState>();
  }

  late bool isLoading;
  late TextEditingController thisNickname, otherNickname;
  late GlobalKey<FormState> formKey;

  final ChatPageController chatPageController;

  User? theOpposite;

  String get currentUserNickname =>
      chatPageController.chat.nicknames[UserManager.uid]!;
  String get otherUserNickname => chatPageController.chat.nicknames.entries
      .firstWhere((element) => element.key != UserManager.uid)
      .value;

  /// This method gets info of the opposite from cloud
  void getOtherUserInfo() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(chatPageController.chat.theOppositeId)
        .get()
        .then((doc) {
      theOpposite = User.fromSnapshot(doc);
      notifyListeners();
    });
  }

  Future<bool?> update() async {
    if (isLoading) {
      return null;
    }
    if (!formKey.currentState!.validate()) {
      return false;
    }
    isLoading = true;
    notifyListeners();
    return await chatPageController.chat
        .updateNickname({
          UserManager.uid!: thisNickname.text.trim(),
          chatPageController.chat.theOppositeId: otherNickname.text.trim(),
        })
        .then((value) => true)
        .onError((error, stackTrace) => false)
        .whenComplete(() {
          isLoading = false;
          notifyListeners();
        });
  }
}
