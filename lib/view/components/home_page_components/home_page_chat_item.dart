import 'package:emdy_chat/configure/assets.dart';
import 'package:emdy_chat/configure/route.dart';
import 'package:emdy_chat/configure/size.dart';
import 'package:emdy_chat/configure/style.dart';
import 'package:emdy_chat/controller/home_page_controller.dart';
import 'package:emdy_chat/modal/chat.dart';
import 'package:emdy_chat/view/controls/app_text.dart';
import 'package:emdy_chat/view/controls/error_media.dart';
import 'package:emdy_chat/view/pages/chat_page.dart';
import 'package:flutter/material.dart';

class HomePageChatItem extends StatelessWidget {
  const HomePageChatItem({super.key, required this.chat});
  final Chat chat;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => RouteConfig.pushWidget(context, ChatPage(chat: chat)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      leading: Hero(
        tag: chat.id,
        child: SizedBox(
          width: 60,
          height: 60,
          child: ClipRRect(
              borderRadius:
                  BorderRadius.circular(SizeConfig.circleAvatarRadius),
              child: chatAvatar),
        ),
      ),
      title: AppText(
        text: chat.name,
        style: StyleConfig.contentTextStyle.copyWith(fontSize: 16),
        textOverflow: TextOverflow.ellipsis,
      ),
      subtitle: AppText(
        text: '${chat.recentActorName} ${chat.recentAction}',
        style: StyleConfig.hintTextStyle,
      ),
    );
  }

  Widget get chatAvatar {
    if (HomePageController.instance.avatar.containsKey(chat.theOppositeId) ||
        HomePageController.instance.avatar[chat.theOppositeId] != null) {
      return Image.memory(
        HomePageController.instance.avatar[chat.theOppositeId]!,
        errorBuilder: (context, error, stackTrace) => const ErrorMediaWidget(),
      );
    }
    return Image.asset(
      AssetsConfig.defaultAvatar,
      fit: BoxFit.cover,
    );
  }
}
