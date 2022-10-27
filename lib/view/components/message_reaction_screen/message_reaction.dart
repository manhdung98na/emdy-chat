import 'package:emdy_chat/configure/assets.dart';
import 'package:emdy_chat/manager/user_manager.dart';
import 'package:emdy_chat/modal/message.dart';
import 'package:emdy_chat/util/type_util.dart';
import 'package:flutter/material.dart';

class MessageReaction extends StatelessWidget {
  const MessageReaction({super.key, required this.message});

  final Message message;

  double get size => 12;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
              color: Colors.black38,
              blurRadius: 4,
              spreadRadius: 0,
              offset: Offset(0.5, 0.5)),
        ],
      ),
      child: Image.asset(
        getReactionUrl(message.react[UserManager.uid]!),
        height: size,
        width: size,
      ),
    );
  }

  String getReactionUrl(int reactType) {
    switch (reactType) {
      case ReactionType.love:
        return AssetsConfig.pngLove;
      case ReactionType.haha:
        return AssetsConfig.pngHaha;
      case ReactionType.sad:
        return AssetsConfig.pngSad;
      case ReactionType.wow:
        return AssetsConfig.pngWow;
      case ReactionType.angry:
        return AssetsConfig.pngAngry;
      default:
        return AssetsConfig.pngLike;
    }
  }
}
