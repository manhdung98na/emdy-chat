import 'dart:io';

import 'package:emdy_chat/configure/color.dart';
import 'package:emdy_chat/configure/size.dart';
import 'package:emdy_chat/configure/style.dart';
import 'package:emdy_chat/manager/user_manager.dart';
import 'package:emdy_chat/view/components/left_drawer/drawer_avatar.dart';
import 'package:emdy_chat/view/controls/app_text.dart';
import 'package:emdy_chat/view/controls/rounded_icon.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
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
          _buildTitle('User info'),
          ListTile(
            onTap: () {},
            leading: const RoundedIcon(
              iconData: Icons.person_pin_rounded,
              color: ColorConfig.purpleColorLogo,
            ),
            title: const AppText(
              text: 'Profile',
              style: StyleConfig.titleTextStyle,
            ),
          ),
          _buildTitle('System'),
          ListTile(
            onTap: () {},
            leading: const RoundedIcon(
              iconData: Icons.contrast_rounded,
              color: Colors.black,
            ),
            title: const AppText(
              text: 'Theme : Light',
              style: StyleConfig.titleTextStyle,
            ),
          ),
          _buildTitle('Others'),
          ListTile(
            onTap: () {
              FirebaseAuth.instance.signOut();
            },
            leading: const RoundedIcon(
              iconData: Icons.logout,
              color: Colors.blueGrey,
            ),
            title: const AppText(
              text: 'Sign out',
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
            title: const AppText(
              text: 'Quit app',
              style: StyleConfig.titleTextStyle,
            ),
          ),
          ListTile(
            onTap: () {},
            leading: const RoundedIcon(
              iconData: Icons.report_problem_rounded,
              color: Colors.red,
            ),
            title: const AppText(
              text: 'Report',
              style: StyleConfig.titleTextStyle,
            ),
          ),
          ListTile(
            onTap: () {},
            leading: RoundedIcon(
              iconData: Icons.info,
              color: Colors.yellow.shade700,
            ),
            title: const AppText(
              text: 'About us',
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
