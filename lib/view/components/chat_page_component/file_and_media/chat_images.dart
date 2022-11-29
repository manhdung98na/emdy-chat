import 'package:cached_network_image/cached_network_image.dart';
import 'package:emdy_chat/configure/color.dart';
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
        // if (controller.images[index] != null) {
        return CachedNetworkImage(
          key: Key(controller.images[index]),
          imageUrl: controller.images[index],
          progressIndicatorBuilder: (context, url, downloadProgress) =>
              Container(
            width: 100,
            height: 100,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(16),
            ),
            child: CircularProgressIndicator(
              value: downloadProgress.progress,
              color: ColorConfig.purpleColorLogo,
            ),
          ),
          errorWidget: (context, url, error) => const ErrorMediaWidget(),
        );
        // }
        // return const ErrorMediaWidget();
      },
    );
  }
}
