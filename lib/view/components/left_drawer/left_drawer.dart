import 'dart:io';

import 'package:emdy_chat/configure/color.dart';
import 'package:emdy_chat/configure/size.dart';
import 'package:emdy_chat/configure/style.dart';
import 'package:emdy_chat/controller/locale_controller.dart';
import 'package:emdy_chat/manager/user_manager.dart';
import 'package:emdy_chat/view/components/left_drawer/drawer_avatar.dart';
import 'package:emdy_chat/view/controls/app_text.dart';
import 'package:emdy_chat/view/controls/rounded_icon.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    var localeProvider = Provider.of<LocaleController>(context);

    return Drawer(
      backgroundColor: ColorConfig.primaryColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(25)),
      ),
      child: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(SizeConfig.rowSpace),
            child: DrawerAvatar(),
          ),
          AppText(
            text: UserManager.currentUser!.fullName,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: StyleConfig.titleTextStyle.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(
            height: 30,
            color: Colors.black26,
          ),
          _buildTitle(AppLocalizations.of(context)!.userInfo),
          ListTile(
            onTap: () {},
            leading: const RoundedIcon(
              iconData: Icons.person_pin_rounded,
              color: ColorConfig.purpleColorLogo,
            ),
            title: AppText(
              text: AppLocalizations.of(context)!.profile,
              style: StyleConfig.titleTextStyle,
            ),
          ),
          _buildTitle(AppLocalizations.of(context)!.system),
          ListTile(
            onTap: () {},
            leading: const RoundedIcon(
              iconData: Icons.contrast_rounded,
              color: Colors.black,
            ),
            title: AppText(
              text:
                  '${AppLocalizations.of(context)!.theme}: ${AppLocalizations.of(context)!.light}',
              style: StyleConfig.titleTextStyle,
            ),
          ),
          ListTile(
            onTap: () {
              if (localeProvider.locale?.languageCode == 'vi') {
                localeProvider.setLocale(const Locale('en'));
              } else {
                localeProvider.setLocale(const Locale('vi'));
              }
            },
            leading: const RoundedIcon(
              iconData: Icons.language,
              color: Colors.lightBlue,
            ),
            title: AppText(
              text:
                  '${AppLocalizations.of(context)!.language}: ${localeProvider.getLocaleName(context)}',
              style: StyleConfig.titleTextStyle,
            ),
          ),
          _buildTitle(AppLocalizations.of(context)!.others),
          ListTile(
            onTap: () {
              FirebaseAuth.instance.signOut();
            },
            leading: const RoundedIcon(
              iconData: Icons.logout,
              color: Colors.blueGrey,
            ),
            title: AppText(
              text: AppLocalizations.of(context)!.signOut,
              style: StyleConfig.titleTextStyle,
            ),
          ),
          ListTile(
            onTap: () {
              exit(0);
            },
            leading: const RoundedIcon(
              iconData: Icons.flash_off_sharp,
              color: Colors.brown,
            ),
            title: AppText(
              text: AppLocalizations.of(context)!.quitApp,
              style: StyleConfig.titleTextStyle,
            ),
          ),
          ListTile(
            onTap: () {},
            leading: const RoundedIcon(
              iconData: Icons.report_problem_rounded,
              color: Colors.red,
            ),
            title: AppText(
              text: AppLocalizations.of(context)!.report,
              style: StyleConfig.titleTextStyle,
            ),
          ),
          ListTile(
            onTap: () {},
            leading: RoundedIcon(
              iconData: Icons.info,
              color: Colors.yellow.shade700,
            ),
            title: AppText(
              text: AppLocalizations.of(context)!.aboutUs,
              style: StyleConfig.titleTextStyle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: AppText(
        text: title,
        style: StyleConfig.hintTextStyle
            .copyWith(fontSize: 14, fontWeight: FontWeight.bold),
      ),
    );
  }
}
