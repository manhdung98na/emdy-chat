import 'package:emdy_chat/controller/chat_page/chat_page_controller.dart';
import 'package:emdy_chat/util/popup_util.dart';
import 'package:emdy_chat/util/type_util.dart';
import 'package:emdy_chat/view/components/chat_page_component/change_chat_name_dialog.dart';
import 'package:emdy_chat/view/components/chat_page_component/change_nickname_dialog.dart';
import 'package:emdy_chat/view/components/chat_page_component/file_and_media/file_and_media_dialog.dart';
import 'package:emdy_chat/view/controls/app_text.dart';
import 'package:emdy_chat/view/controls/inprogress_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChatPageBottomSheet extends StatelessWidget {
  const ChatPageBottomSheet({
    super.key,
    required this.controller,
    required this.chatPageContext,
  });

  final BuildContext chatPageContext;
  final ChatPageController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        color: Theme.of(context).primaryColor,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10),
            width: 80,
            height: 6,
            decoration: BoxDecoration(
              color: Theme.of(context).dividerColor,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          if (controller.chat.type == ChatType.group)
            // Conversation avatar
            ListTile(
              onTap: () => changeAvatar(context),
              leading: const Icon(
                Icons.person_pin,
              ),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              title: AppText(
                text: AppLocalizations.of(context)!.conversationAvatar,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          // Conversation name
          ListTile(
            onTap: () => changeName(context),
            leading: const Icon(
              Icons.drive_file_rename_outline_outlined,
            ),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            title: AppText(
              text: AppLocalizations.of(context)!.conversationName,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          // Nicknames
          ListTile(
            onTap: () => changeNicknames(context),
            leading: const Icon(
              Icons.privacy_tip_outlined,
            ),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            title: AppText(
              text: AppLocalizations.of(context)!.nicknames,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          // File and Media
          ListTile(
            onTap: () => getFileAndMedia(context),
            leading: const Icon(
              Icons.perm_media_outlined,
            ),
            title: AppText(
              text: AppLocalizations.of(context)!.fileAndMedia,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          // Ignore
          if (controller.chat.status != ChatStatus.block)
            ListTile(
              onTap: () {
                int newStatus = controller.chat.status == ChatStatus.ignored
                    ? ChatStatus.accepted
                    : ChatStatus.ignored;
                updateChatStatus(context, newStatus);
              },
              leading: Icon(
                controller.chat.status == ChatStatus.ignored
                    ? Icons.comment_outlined
                    : Icons.comments_disabled_outlined,
              ),
              title: AppText(
                text: controller.chat.status == ChatStatus.ignored
                    ? AppLocalizations.of(context)!.unignored
                    : AppLocalizations.of(context)!.ignored,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          // Block
          ListTile(
            onTap: () async {
              int newStatus = controller.chat.status == ChatStatus.block
                  ? ChatStatus.accepted
                  : ChatStatus.block;
              updateChatStatus(context, newStatus);
            },
            leading: Icon(
              controller.chat.status == ChatStatus.block
                  ? Icons.lock_open_rounded
                  : Icons.block,
            ),
            title: AppText(
              text: controller.chat.status == ChatStatus.block
                  ? AppLocalizations.of(context)!.unblock
                  : AppLocalizations.of(context)!.blocked,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          // Delete
          ListTile(
            onTap: () => delete(context),
            leading: const Icon(
              Icons.delete_outline_rounded,
              color: Colors.red,
            ),
            title: AppText(
              text: AppLocalizations.of(context)!.delete,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void changeAvatar(BuildContext context) {}

  void changeName(BuildContext context) {
    Navigator.pop(context);
    showDialog(
        context: context,
        builder: (context) => ChangeChatNameDialog(controller: controller));
  }

  void changeNicknames(BuildContext context) {
    Navigator.pop(context);
    showDialog(
        context: context,
        builder: (context) => ChangeNicknameDialog(controller: controller));
  }

  void getFileAndMedia(BuildContext context) {
    Navigator.pop(context);
    Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => FileAndMediaDialog(chat: controller.chat),
        ));
  }

  void updateChatStatus(BuildContext context, int newStatus) async {
    Navigator.pop(context);
    var key = GlobalKey<InprogressWidgetState>();
    PopupUtil.showLoadingDialog(chatPageContext, key);
    await controller.chat.updateStatus(newStatus).then((value) {
      Navigator.pop(key.currentState!.context);
      PopupUtil.showSnackBar(chatPageContext, value);
    });
  }

  void delete(BuildContext context) async {
    Navigator.pop(context);
    var key = GlobalKey<InprogressWidgetState>();
    PopupUtil.showLoadingDialog(context, key);
    await controller.deleteChat().then((value) {
      // Navigator.pop(key.currentState!.context);
      Navigator.popUntil(
        chatPageContext,
        (route) => route.isFirst,
      );
    });
  }
}
