import 'package:emdy_chat/modal/chat.dart';
import 'package:emdy_chat/modal/message.dart';
import 'package:emdy_chat/view/controls/loading_media.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoMessageItem extends StatefulWidget {
  final Chat chat;
  final int index;

  const VideoMessageItem(this.chat, this.index, {super.key});

  @override
  State<VideoMessageItem> createState() => _VideoMessageItemState();
}

class _VideoMessageItemState extends State<VideoMessageItem> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  Message get message => widget.chat.messages[widget.index];

  @override
  void initState() {
    _controller = VideoPlayerController.network(message.content!)
      ..setLooping(false);
    _initializeVideoPlayerFuture = _controller.initialize();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingMediaWidget();
          }
          return Stack(
            fit: StackFit.passthrough,
            children: [
              AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
              Positioned.fill(child: Center(child: playButton)),
            ],
          );
        });
  }

  Icon get playButton => const Icon(
        Icons.play_circle_outline_rounded,
        color: Colors.white,
        size: 40,
      );
}
