import 'package:emdy_chat/configure/app_manager.dart';
import 'package:emdy_chat/util/popup_util.dart';
import 'package:emdy_chat/view/controls/inprogress_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends ChangeNotifier {
  late TextEditingController teEmail, tePassword;
  late bool hidePassword;
  late GlobalKey<FormState> formKey;

  LoginController() {
    initialize();
  }

  initialize() async {
    formKey = GlobalKey<FormState>();
    hidePassword = true;
    teEmail = TextEditingController();
    tePassword = TextEditingController();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    teEmail.text = sharedPreferences.getString('email') ?? '';
    // notifyListeners();
  }

  void toggleHidePassword() {
    hidePassword = !hidePassword;
    notifyListeners();
  }

  void login(BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    var loadingWidgetKey = GlobalKey<InprogressWidgetState>();
    AppManager.unfocus(context);
    PopupUtil.showLoadingDialog(context, loadingWidgetKey);

    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: teEmail.text, password: tePassword.text)
        .then((value) => saveEmailToLocal())
        .catchError((error, stackTrace) {
      PopupUtil.showSnackBar(
          context, (error as FirebaseException).message ?? 'Firebase error!');
    }).whenComplete(() {
      Navigator.of(loadingWidgetKey.currentContext!).pop();
    });
  }

  Future<void> saveEmailToLocal() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('email', teEmail.text);
  }
}
