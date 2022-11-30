import 'dart:io';

import 'package:emdy_chat/configure/color.dart';
import 'package:emdy_chat/configure/size.dart';
import 'package:emdy_chat/controller/locale_controller.dart';
import 'package:emdy_chat/controller/theme_controller.dart';
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
    var localeProvider = Provider.of<LocaleController>(context, listen: false);
    var themeProvider = Provider.of<ThemeController>(context, listen: false);

    return Drawer(
      // backgroundColor: Theme.of(context).primaryColor,
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
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const Divider(
            height: 30,
            color: Colors.black26,
          ),
          _buildTitle(context, AppLocalizations.of(context)!.userInfo),
          ListTile(
            onTap: () {},
            leading: const RoundedIcon(
              iconData: Icons.person_pin_rounded,
              color: ColorConfig.purpleColorLogo,
            ),
            title: AppText(
              text: AppLocalizations.of(context)!.profile,
              style: Theme.of(context).textTheme.titleMedium!,
            ),
          ),
          _buildTitle(context, AppLocalizations.of(context)!.system),
          ListTile(
            onTap: () {
              themeProvider.toggleTheme();
            },
            leading: const RoundedIcon(
              iconData: Icons.contrast_rounded,
              color: Colors.black,
            ),
            title: AppText(
              text:
                  '${AppLocalizations.of(context)!.theme}: ${themeProvider.getThemeName(context)}',
              style: Theme.of(context).textTheme.titleMedium!,
            ),
          ),
          ListTile(
            onTap: () {
              if ((localeProvider.locale?.languageCode ??
                      LocaleController.defaultLocaleCode) ==
                  'vi') {
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
              style: Theme.of(context).textTheme.titleMedium!,
            ),
          ),
          _buildTitle(context, AppLocalizations.of(context)!.others),
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
              style: Theme.of(context).textTheme.titleMedium!,
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
              style: Theme.of(context).textTheme.titleMedium!,
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
              style: Theme.of(context).textTheme.titleMedium!,
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
              style: Theme.of(context).textTheme.titleMedium!,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: AppText(
        text: title,
        style: Theme.of(context)
            .textTheme
            .bodySmall!
            .copyWith(fontSize: 14, fontWeight: FontWeight.bold),
      ),
    );
  }
}
