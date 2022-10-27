import 'package:emdy_chat/manager/user_manager.dart';
import 'package:emdy_chat/view/controls/inprogress_widget.dart';
import 'package:emdy_chat/view/pages/home_page.dart';
import 'package:emdy_chat/view/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  late Stream<User?> stream;

  @override
  void initState() {
    UserManager.getAvatar();
    super.initState();
    stream = FirebaseAuth.instance.authStateChanges();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          loadingInitialData(snapshot);
          return const HomePage();
        }
        return const LoginPage();
      },
    );
  }

  void loadingInitialData(AsyncSnapshot<User?> snapshot) async {
    Future.delayed(
      Duration.zero,
      () => showDialog(
        context: context,
        barrierDismissible: false,
        useRootNavigator: true,
        builder: (context) => const InprogressWidget(),
      ),
    );
    UserManager.uid = snapshot.data?.uid;
    await UserManager.getUserById()
        .then((value) => UserManager.getAvatar())
        .whenComplete(() async {
      Navigator.pop(context);
    });
  }
}
