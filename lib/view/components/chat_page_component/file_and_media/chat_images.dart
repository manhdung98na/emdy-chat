import 'package:emdy_chat/controller/chat_page/file_and_media_controller.dart';
import 'package:emdy_chat/view/controls/error_media.dart';
import 'package:flutter/material.dart';

class ChatImages extends StatelessWidget {
  const ChatImages({super.key, required this.controller});

  final FileAndMediaController controller;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      ),
      itemCount: controller.images.length,
      itemBuilder: (context, index) {
        if (controller.images[index] != null) {
          return Image.memory(controller.images[index]!);
        }
        return const ErrorMediaWidget();
      },
    );
  }
}
