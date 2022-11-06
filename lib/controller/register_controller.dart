import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emdy_chat/configure/app_manager.dart';
import 'package:emdy_chat/manager/firebase_manager.dart';
import 'package:emdy_chat/util/constant.dart';
import 'package:emdy_chat/util/popup_util.dart';
import 'package:emdy_chat/view/controls/inprogress_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterController extends ChangeNotifier {
  late TextEditingController teName, teEmail, tePassword;
  late bool hidePassword;
  late GlobalKey<FormState> formKey;

  RegisterController() {
    formKey = GlobalKey<FormState>();
    hidePassword = true;
    teName = TextEditingController();
    teEmail = TextEditingController();
    tePassword = TextEditingController();
  }

  void toggleHidePassword() {
    hidePassword = !hidePassword;
    notifyListeners();
  }

  Future<String> register(BuildContext context) async {
    var loadingWidgetKey = GlobalKey<InprogressWidgetState>();
    AppManager.unfocus(context);
    PopupUtil.showLoadingDialog(context, loadingWidgetKey);

    var createUserResult = await createUserWithEmailAndPass();

    if (createUserResult['message'] != success) {
      if (loadingWidgetKey.currentState!.mounted) {
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      }
      return createUserResult['message'];
    }

    UserCredential userCredential = createUserResult['userCredential'];

    String writeUserDataResult = await writeUserToCloud(userCredential);

    if (loadingWidgetKey.currentState!.mounted) {
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    }
    return writeUserDataResult;
  }

  Future<Map> createUserWithEmailAndPass() async {
    UserCredential? userCredential;
    String? message;

    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: teEmail.text.trim(), password: tePassword.text)
        .then((value) {
      userCredential = value;
      message = success;
    }).onError((error, stackTrace) {
      message = (error as FirebaseException).message ?? 'Firebase error!';
    });

    return {'message': message, 'userCredential': userCredential};
  }

  Future<String> writeUserToCloud(UserCredential userCredential) async {
    return await FirebaseFirestore.instance
        .collection(FirebaseManager.userCollection)
        .doc(userCredential.user!.uid)
        .set({
          'email': userCredential.user!.email,
          'fullName': teName.text.trim(),
          'userId': userCredential.user!.uid,
          'hasAvatar': false,
        })
        .then((value) => success)
        .onError((error, stackTrace) {
          print('Write user data: -${error.toString()}');
          userCredential.user!.delete();
          return (error as FirebaseException).message ?? 'Firebase error!';
        });
  }
}
