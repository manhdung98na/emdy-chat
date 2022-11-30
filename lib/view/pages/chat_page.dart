import 'package:emdy_chat/configure/assets.dart';
import 'package:emdy_chat/configure/color.dart';
import 'package:emdy_chat/configure/size.dart';
import 'package:emdy_chat/controller/chat_page/chat_page_controller.dart';
import 'package:emdy_chat/controller/home_page_controller.dart';
import 'package:emdy_chat/modal/chat.dart';
import 'package:emdy_chat/util/popup_util.dart';
import 'package:emdy_chat/view/components/chat_page_component/chat_page_body.dart';
import 'package:emdy_chat/view/components/chat_page_component/chat_page_bottom_sheet.dart';
import 'package:emdy_chat/view/controls/app_text.dart';
import 'package:emdy_chat/view/controls/error_media.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.chat});

  final Chat chat;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late ChatPageController controller;

  @override
  void initState() {
    controller = ChatPageController(widget.chat);
    super.initState();
  }

  @override
  void dispose() {
    controller.cancelStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: ChatPageBody(controller: controller),
    );
  }

  Widget get chatAvatar {
    if (HomePageController.instance.avatar
            .containsKey(widget.chat.theOppositeId) &&
        HomePageController.instance.avatar[widget.chat.theOppositeId] != null) {
      return Image.memory(
        HomePageController.instance.avatar[widget.chat.theOppositeId]!,
        height: 40,
        width: 40,
        errorBuilder: (context, error, stackTrace) => const ErrorMediaWidget(),
      );
    }
    return Image.asset(
      AssetsConfig.defaultAvatar,
      height: 40,
      width: 40,
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: SizeConfig.elevation,
      leadingWidth: 50,
      leading: IconButton(
        padding: EdgeInsets.zero,
        onPressed: () => Navigator.pop(context),
        alignment: Alignment.center,
        color: ColorConfig.purpleColorLogo,
        icon: const Icon(Icons.arrow_back),
      ),
      titleSpacing: 4,
      title: Row(
        children: [
          Hero(
            tag: controller.chat.id,
            child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(SizeConfig.circleAvatarRadius),
                child: chatAvatar),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: AppText(
              text: controller.chat.name,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          padding: EdgeInsets.zero,
          splashRadius: 1,
          onPressed: () {},
          color: Theme.of(context).indicatorColor,
          icon: const Icon(Icons.call),
        ),
        IconButton(
          padding: EdgeInsets.zero,
          splashRadius: 1,
          onPressed: () {},
          color: Theme.of(context).indicatorColor,
          icon: const Icon(Icons.video_call),
        ),
        IconButton(
          padding: EdgeInsets.zero,
          splashRadius: 1,
          onPressed: () {
            PopupUtil.showBottomSheet(
                context,
                ChatPageBottomSheet(
                    controller: controller, chatPageContext: context));
          },
          color: Theme.of(context).indicatorColor,
          icon: const Icon(Icons.info_rounded),
        ),
      ],
    );
  }
}
