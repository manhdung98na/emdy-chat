import 'package:emdy_chat/configure/assets.dart';
import 'package:emdy_chat/configure/color.dart';
import 'package:emdy_chat/configure/size.dart';
import 'package:emdy_chat/configure/style.dart';
import 'package:emdy_chat/controller/chat_page/chat_page_controller.dart';
import 'package:emdy_chat/controller/home_page_controller.dart';
import 'package:emdy_chat/manager/file_manager.dart';
import 'package:emdy_chat/modal/chat.dart';
import 'package:emdy_chat/util/constant.dart';
import 'package:emdy_chat/util/popup_util.dart';
import 'package:emdy_chat/util/type_util.dart';
import 'package:emdy_chat/view/components/chat_page_component/chat_page_bottom_sheet.dart';
import 'package:emdy_chat/view/components/chat_page_component/message_item/message_item.dart';
import 'package:emdy_chat/view/controls/app_text.dart';
import 'package:emdy_chat/view/controls/app_text_field.dart';
import 'package:emdy_chat/view/controls/error_media.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    return ChangeNotifierProvider.value(
      value: controller,
      child: Consumer<ChatPageController>(
        child: buildAppBar(),
        builder: (_, controller, appBar) {
          return Scaffold(
            appBar: appBar as PreferredSizeWidget,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    itemCount: controller.chat.messages.length,
                    itemBuilder: (context, index) {
                      return MessageItem(
                        key: Key(controller.chat.messages[index].id),
                        chat: controller.chat,
                        index: index,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                buildBottomButtonRow(),
                const SizedBox(height: 4)
              ],
            ),
          );
        },
      ),
    );
  }

  Widget get chatAvatar {
    if (HomePageController.instance.avatar
            .containsKey(widget.chat.theOppositeId) ||
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
              style: StyleConfig.titleTextStyle
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
          color: ColorConfig.purpleColorLogo,
          icon: const Icon(Icons.call),
        ),
        IconButton(
          padding: EdgeInsets.zero,
          splashRadius: 1,
          onPressed: () {},
          color: ColorConfig.purpleColorLogo,
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
          color: ColorConfig.purpleColorLogo,
          icon: const Icon(Icons.info_rounded),
        ),
      ],
    );
  }

  Row buildBottomButtonRow() {
    return Row(
      children: [
        IconButton(
          splashRadius: 1,
          color: ColorConfig.purpleColorLogo,
          onPressed: () {},
          iconSize: 30,
          icon: const Icon(Icons.camera_alt_rounded),
        ),
        IconButton(
          splashRadius: 1,
          color: ColorConfig.purpleColorLogo,
          iconSize: 30,
          onPressed: pickImageAndSend,
          icon: const Icon(Icons.photo_rounded),
        ),
        Expanded(
          child: AppTextField(
            controller: controller.teMessage,
            hint: 'Message',
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            borderRadius: 30,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            maxLines: null,
            boxConstraints: const BoxConstraints(maxHeight: 40),
            suffixWidget: IconButton(
              onPressed: sendMessage,
              icon: const Icon(Icons.send_rounded),
            ),
          ),
        ),
        IconButton(
          splashRadius: 1,
          color: ColorConfig.purpleColorLogo,
          iconSize: 30,
          onPressed: () {
            sendMessage(message: likeCharacter);
          },
          icon: const Icon(Icons.thumb_up),
        ),
      ],
    );
  }

  void sendMessage({String? message}) async {
    String result = await controller.sendMessage(message: message);
    if (result != success && mounted) {
      PopupUtil.showSnackBar(context, result);
    }
  }

  void pickImageAndSend() async {
    PlatformFile? file = await FileManager.pickSingleMedia(context);
    if (file == null || file.extension == null) {
      return;
    }

    int fileType = FileManager.checkType(file.extension!);
    Uint8List compressedImage;
    if (fileType == MessageType.picture) {
      compressedImage = await FileManager.compressImage(file);
    } else if (fileType == MessageType.video) {
      compressedImage = await FileManager.compressVideo(file);
    } else {
      compressedImage = file.bytes!;
    }
    controller.sendImage(compressedImage, fileType);
  }
}
