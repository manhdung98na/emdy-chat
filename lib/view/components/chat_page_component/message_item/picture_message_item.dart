import 'package:cached_network_image/cached_network_image.dart';
import 'package:emdy_chat/configure/color.dart';
import 'package:emdy_chat/modal/chat.dart';
import 'package:emdy_chat/modal/message.dart';
import 'package:emdy_chat/view/controls/error_media.dart';
import 'package:flutter/material.dart';

class PictureMessageItem extends StatelessWidget {
  final Chat chat;
  final int index;

  const PictureMessageItem(this.chat, this.index, {super.key});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: message.content!,
      progressIndicatorBuilder: (context, url, downloadProgress) => Container(
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
    // return FirebaseManager.storageMediaCache.containsKey(message.id)
    //     ? Image.memory(
    //         FirebaseManager.storageMediaCache[message.id]!,
    //         fit: BoxFit.contain,
    //       )
    //     : Image.network(
    //         message.content!,
    //         errorBuilder: (context, error, stackTrace) =>
    //             const ErrorMediaWidget(),
    //         loadingBuilder: (context, child, loadingProgress) {
    //           if (loadingProgress == null) return child;
    //           return Center(
    //             child: CircularProgressIndicator(
    //               value: loadingProgress.expectedTotalBytes != null
    //                   ? loadingProgress.cumulativeBytesLoaded /
    //                       loadingProgress.expectedTotalBytes!
    //                   : null,
    //             ),
    //           );
    //         },
    //       );
  }

  Message get message => chat.messages[index];
}
