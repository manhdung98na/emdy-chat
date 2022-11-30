import 'package:emdy_chat/configure/color.dart';
import 'package:emdy_chat/manager/user_manager.dart';
import 'package:emdy_chat/modal/chat.dart';
import 'package:emdy_chat/modal/message.dart';
import 'package:emdy_chat/view/controls/app_text.dart';
import 'package:flutter/material.dart';

class TextMessageItem extends StatelessWidget {
  const TextMessageItem(this.chat, this.index, {super.key});

  /// Đoạn chat chứa message đang hiển thị
  final Chat chat;

  /// Index của message
  final int index;

  Message get message => chat.messages[index];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: getBackgroundColor(context),
        borderRadius: borderRadius,
        boxShadow: const [
          BoxShadow(color: Colors.black45, blurRadius: 1.25),
        ],
      ),
      child: AppText(
        text: message.content!,
        style: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(color: getTextColor(context)),
        textOverflow: TextOverflow.clip,
        maxLines: null,
      ),
    );
  }

  Alignment get alignment => message.senderId == UserManager.uid
      ? Alignment.centerRight
      : Alignment.centerLeft;

  LinearGradient getBackgroundColor(BuildContext context) => LinearGradient(
        colors: message.senderId == UserManager.uid
            ? [
                Theme.of(context).indicatorColor,
                Theme.of(context).focusColor,
              ]
            : [
                const Color.fromARGB(255, 196, 182, 231),
                const Color.fromARGB(255, 244, 240, 255),
              ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  Color getTextColor(BuildContext context) =>
      message.senderId == UserManager.uid
          ? Theme.of(context).primaryColor
          : ColorConfig.navyColorLogo;

  BorderRadius get borderRadius => message.senderId == UserManager.uid
      ? const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          topLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        )
      : const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        );
}
