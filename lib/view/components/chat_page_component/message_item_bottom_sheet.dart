import 'package:emdy_chat/configure/color.dart';
import 'package:emdy_chat/configure/style.dart';
import 'package:emdy_chat/modal/message.dart';
import 'package:emdy_chat/util/popup_util.dart';
import 'package:emdy_chat/view/controls/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MessageItemBottomSheet extends StatelessWidget {
  const MessageItemBottomSheet({super.key, required this.message});

  final Message message;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        color: ColorConfig.primaryColor,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10),
            width: 80,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          // Copy
          ListTile(
            onTap: () async {
              Clipboard.setData(ClipboardData(text: message.content))
                  .then((value) {
                Navigator.pop(context);
                PopupUtil.showSnackBar(context,
                    AppLocalizations.of(context)!.messageContentCopied);
              });
            },
            leading: const Icon(Icons.copy_outlined),
            title: AppText(
              text: AppLocalizations.of(context)!.copy,
              style: StyleConfig.contentTextStyle,
            ),
          ),
          // Delete
          ListTile(
            onTap: () {
              message.delete().then((value) => Navigator.pop(context));
            },
            leading: const Icon(
              Icons.delete_outline_rounded,
              color: Colors.red,
            ),
            title: AppText(
              text: AppLocalizations.of(context)!.delete,
              style: StyleConfig.contentTextStyle.copyWith(
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
