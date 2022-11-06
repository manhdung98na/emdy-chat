import 'package:emdy_chat/configure/size.dart';
import 'package:emdy_chat/configure/style.dart';
import 'package:emdy_chat/controller/user_avatar_controller.dart';
import 'package:emdy_chat/manager/user_manager.dart';
import 'package:emdy_chat/view/controls/app_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePageAppBar extends StatefulWidget with PreferredSizeWidget {
  const HomePageAppBar({super.key});

  @override
  State<HomePageAppBar> createState() => HomePageAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class HomePageAppBarState extends State<HomePageAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      leading: Builder(
        builder: (context) => InkWell(
          onTap: () => Scaffold.of(context).openDrawer(),
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: ClipRRect(
              borderRadius:
                  BorderRadius.circular(SizeConfig.circleAvatarRadius),
              child: ChangeNotifierProvider.value(
                value: UserAvatarController.instance,
                child: Consumer<UserAvatarController>(
                  builder: (_, __, ___) => UserManager.avatarWidget,
                ),
              ),
            ),
          ),
        ),
      ),
      title: const AppText(
        text: 'Messages',
        style: StyleConfig.headerTextStyle,
      ),
      actions: [
        ElevatedButton(
          onPressed: () {},
          style: appBarButtonStyle,
          child: const Icon(
            Icons.photo_camera,
            color: Colors.black,
            size: 18,
          ),
        ),
      ],
    );
  }

  ButtonStyle get appBarButtonStyle => ButtonStyle(
        elevation: MaterialStateProperty.all(0),
        padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
        shape: MaterialStateProperty.all(const CircleBorder()),
        backgroundColor: MaterialStateProperty.all(Colors.black12),
        maximumSize: MaterialStateProperty.all(const Size(35, 35)),
        minimumSize: MaterialStateProperty.all(const Size(35, 35)),
        alignment: Alignment.center,
      );
}
