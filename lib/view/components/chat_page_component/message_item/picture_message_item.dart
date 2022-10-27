import 'package:emdy_chat/manager/firebase_manager.dart';
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
    return FirebaseManager.storageMediaCache.containsKey(message.id)
        ? Image.memory(
            FirebaseManager.storageMediaCache[message.id]!,
            fit: BoxFit.contain,
          )
        : Image.network(
            message.content!,
            errorBuilder: (context, error, stackTrace) =>
                const ErrorMediaWidget(),
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
          );
  }

  Message get message => chat.messages[index];
}
