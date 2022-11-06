import 'dart:typed_data';

import 'package:emdy_chat/configure/color.dart';
import 'package:emdy_chat/controller/chat_page/chat_page_controller.dart';
import 'package:emdy_chat/manager/file_manager.dart';
import 'package:emdy_chat/util/constant.dart';
import 'package:emdy_chat/util/popup_util.dart';
import 'package:emdy_chat/util/type_util.dart';
import 'package:emdy_chat/view/components/chat_page_component/message_item/message_item.dart';
import 'package:emdy_chat/view/controls/app_text_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPageBody extends StatelessWidget {
  const ChatPageBody({super.key, required this.controller});

  final ChatPageController controller;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: controller,
      child: Consumer<ChatPageController>(
        builder: (_, controller, __) {
          return Column(
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
              buildBottomButtonRow(context),
              const SizedBox(height: 4)
            ],
          );
        },
      ),
    );
  }

  Row buildBottomButtonRow(BuildContext context) {
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
          onPressed: () => pickImageAndSend(context),
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
              onPressed: () => sendMessage(context),
              icon: const Icon(Icons.send_rounded),
            ),
          ),
        ),
        IconButton(
          splashRadius: 1,
          color: ColorConfig.purpleColorLogo,
          iconSize: 30,
          onPressed: () {
            sendMessage(context, message: likeCharacter);
          },
          icon: const Icon(Icons.thumb_up),
        ),
      ],
    );
  }

  void sendMessage(BuildContext context, {String? message}) async {
    await controller.sendMessage(message: message).then((result) {
      if (result != success) {
        PopupUtil.showSnackBar(context, result);
      }
    });
  }

  void pickImageAndSend(BuildContext context) async {
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
