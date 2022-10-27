import 'package:emdy_chat/configure/color.dart';
import 'package:emdy_chat/configure/size.dart';
import 'package:emdy_chat/configure/style.dart';
import 'package:emdy_chat/controller/user_avatar_controller.dart';
import 'package:emdy_chat/manager/user_manager.dart';
import 'package:emdy_chat/view/controls/app_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DrawerAvatar extends StatelessWidget {
  const DrawerAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.hardEdge,
      fit: StackFit.passthrough,
      children: [
        Center(
          child: Container(
            height: 150,
            width: 150,
            decoration: const BoxDecoration(shape: BoxShape.circle),
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
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 25,
            alignment: Alignment.center,
            color: Colors.white.withOpacity(0.75),
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () => showOption(context),
              color: ColorConfig.purpleColorLogo,
              iconSize: 20,
              icon: const Icon(Icons.camera_alt),
            ),
          ),
        )
      ],
    );
  }

  void showOption(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => SimpleDialog(
        backgroundColor: ColorConfig.primaryColor,
        elevation: SizeConfig.elevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SizeConfig.borderRadius),
        ),
        title: const Text('Update avatar'),
        titleTextStyle: StyleConfig.headerTextStyle,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          ListTile(
            onTap: () {
              Navigator.pop(dialogContext);
              UserAvatarController.instance.removeAvatar(context);
            },
            title: const AppText(text: 'Remove avatar'),
            minLeadingWidth: 20,
            leading: const Icon(Icons.highlight_off, color: Colors.red),
          ),
          ListTile(
            onTap: () {
              Navigator.pop(dialogContext);
              UserAvatarController.instance.updateAvatar(context);
            },
            title: const AppText(text: 'Choose from device'),
            minLeadingWidth: 20,
            leading: const Icon(Icons.photo_library,
                color: ColorConfig.purpleColorLogo),
          ),
        ],
      ),
    );
  }
}
