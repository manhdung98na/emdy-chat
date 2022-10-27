import 'package:emdy_chat/configure/app_manager.dart';
import 'package:emdy_chat/manager/user_manager.dart';
import 'package:emdy_chat/modal/chat.dart';
import 'package:emdy_chat/modal/message.dart';
import 'package:emdy_chat/util/type_util.dart';
import 'package:emdy_chat/view/components/chat_page_component/message_item/picture_message_item.dart';
import 'package:emdy_chat/view/components/chat_page_component/message_item/text_message_item.dart';
import 'package:emdy_chat/view/components/chat_page_component/message_item/video_message_item.dart';
import 'package:emdy_chat/view/components/message_reaction_screen/message_reaction.dart';
import 'package:emdy_chat/view/components/message_reaction_screen/reaction_screen.dart';
import 'package:flutter/material.dart';

class MessageItem extends StatelessWidget {
  const MessageItem({super.key, required this.chat, required this.index});

  final Chat chat;
  final int index;

  Message get message => chat.messages[index];

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      alignment: alignment,
      child: GestureDetector(
        onTap: () {
          // hiển thị chi tiết (được gửi lúc mấy giờ,...)
        },
        onLongPress: () => showReactionBox(context, screenSize),
        child: Stack(
          fit: StackFit.passthrough,
          clipBehavior: Clip.none,
          children: [
            buildMessage(screenSize), // Message content: text, image, video
            if (message.react.isNotEmpty)
              Positioned(
                bottom: -4,
                left: 8,
                right: 8,
                child: Container(
                  alignment: message.senderId == UserManager.uid
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: MessageReaction(message: message),
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget buildMessage(Size screenSize) {
    Widget messageContent;
    switch (message.type) {
      case MessageType.text:
        messageContent = TextMessageItem(chat, index);
        break;
      case MessageType.video:
        messageContent = VideoMessageItem(chat, index);
        break;
      default:
        messageContent = PictureMessageItem(chat, index);
    }
    return ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: screenSize.width * 0.65,
          maxHeight: message.type == MessageType.text
              ? double.infinity
              : screenSize.height * 0.3,
        ),
        child: messageContent);
  }

  Alignment get alignment {
    return message.senderId == UserManager.uid
        ? Alignment.centerRight
        : Alignment.centerLeft;
  }

  void showReactionBox(BuildContext context, Size screenSize) {
    AppManager.unfocus(context);
    showDialog(
      context: context,
      builder: (context) => ReactionScreen(
        messageContent: buildMessage(screenSize),
        message: message,
      ),
    );
  }
}
