import 'package:emdy_chat/configure/color.dart';
import 'package:emdy_chat/configure/size.dart';
import 'package:emdy_chat/controller/user_avatar_controller.dart';
import 'package:emdy_chat/manager/user_manager.dart';
import 'package:emdy_chat/view/controls/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class DrawerAvatar extends StatelessWidget {
  const DrawerAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        clipBehavior: Clip.hardEdge,
        fit: StackFit.passthrough,
        children: [
          Container(
            height: 150,
            width: 150,
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              // borderRadius: BorderRadius.circular(SizeConfig.circleAvatarRadius),
            ),
            child: ChangeNotifierProvider.value(
              value: UserAvatarController.instance,
              child: Consumer<UserAvatarController>(
                builder: (_, __, ___) => UserManager.avatarWidget,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: InkWell(
              onTap: () => showOption(context),
              child: Icon(
                Icons.camera_alt,
                size: 20,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
          )
        ],
      ),
    );
  }

  void showOption(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => SimpleDialog(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: SizeConfig.elevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SizeConfig.borderRadius),
        ),
        title: AppText(text: AppLocalizations.of(context)!.updateAvatar),
        titleTextStyle: Theme.of(context).textTheme.headlineSmall,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          ListTile(
            onTap: () {
              Navigator.pop(dialogContext);
              UserAvatarController.instance.updateAvatar(context);
            },
            title:
                AppText(text: AppLocalizations.of(context)!.chooseFromDevice),
            minLeadingWidth: 20,
            leading: const Icon(Icons.photo_library,
                color: ColorConfig.purpleColorLogo),
          ),
          if (UserManager.currentUser!.hasAvatar)
            ListTile(
              onTap: () {
                Navigator.pop(dialogContext);
                UserAvatarController.instance.removeAvatar(context);
              },
              title: AppText(text: AppLocalizations.of(context)!.removeAvatar),
              minLeadingWidth: 20,
              leading: const Icon(Icons.highlight_off, color: Colors.red),
            ),
        ],
      ),
    );
  }
}
