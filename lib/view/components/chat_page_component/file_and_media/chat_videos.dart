import 'package:emdy_chat/controller/chat_page/file_and_media_controller.dart';
import 'package:emdy_chat/view/controls/error_media.dart';
import 'package:emdy_chat/view/controls/inprogress_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ChatVideos extends StatefulWidget {
  const ChatVideos({super.key, required this.controller});

  final FileAndMediaController controller;

  @override
  State<ChatVideos> createState() => _ChatVideosState();
}

class _ChatVideosState extends State<ChatVideos> {
  late FileAndMediaController controller;
  late List<Uint8List?> thumbails;
  late bool isLoadThumbail;

  @override
  void initState() {
    isLoadThumbail = true;
    controller = widget.controller;
    thumbails = [];
    getThumbail();
    super.initState();
  }

  void getThumbail() async {
    for (var videoUrl in controller.videos) {
      if (videoUrl == null) {
        thumbails.add(null);
      } else {
        thumbails.add(await VideoThumbnail.thumbnailData(
          video: videoUrl,
          imageFormat: ImageFormat.WEBP,
          quality: 75,
        ));
      }
    }
    if (mounted) {
      setState(() {
        isLoadThumbail = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoadThumbail) {
      return const InprogressWidget();
    }
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      ),
      itemCount: thumbails.length,
      itemBuilder: (context, index) {
        if (thumbails[index] != null) {
          return Image.memory(thumbails[index]!);
        }
        return const ErrorMediaWidget();
      },
    );
  }
}
