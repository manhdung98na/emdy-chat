import 'package:emdy_chat/configure/color.dart';
import 'package:emdy_chat/configure/size.dart';
import 'package:emdy_chat/controller/chat_page/file_and_media_controller.dart';
import 'package:emdy_chat/modal/chat.dart';
import 'package:emdy_chat/view/components/chat_page_component/file_and_media/chat_images.dart';
import 'package:emdy_chat/view/components/chat_page_component/file_and_media/chat_videos.dart';
import 'package:emdy_chat/view/controls/app_text.dart';
import 'package:emdy_chat/view/controls/inprogress_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class FileAndMediaDialog extends StatefulWidget {
  const FileAndMediaDialog({super.key, required this.chat});

  final Chat chat;

  @override
  State<FileAndMediaDialog> createState() => _FileAndMediaDialogState();
}

class _FileAndMediaDialogState extends State<FileAndMediaDialog> {
  late FileAndMediaController controller;

  @override
  void initState() {
    controller = FileAndMediaController(widget.chat);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: controller,
      child: Consumer<FileAndMediaController>(
        builder: (_, controller, child) {
          return Scaffold(
            appBar: buildAppBar(),
            bottomNavigationBar: buildBottomBar(),
            body: buildBody(),
          );
        },
      ),
    );
  }

  Widget buildBody() {
    if (controller.isLoading) {
      return const InprogressWidget();
    }
    return IndexedStack(
      index: controller.indexScreen,
      sizing: StackFit.expand,
      children: [
        ChatImages(controller: controller),
        ChatVideos(controller: controller),
      ],
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: SizeConfig.elevation,
      title: AppText(
        text: AppLocalizations.of(context)!.fileAndMedia,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }

  Widget buildBottomBar() {
    return BottomNavigationBar(
      elevation: 10,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: controller.indexScreen == 0
              ? const Icon(Icons.photo_library_rounded, size: 28)
              : const Icon(Icons.photo_library_outlined, size: 20),
          label: AppLocalizations.of(context)!.images,
        ),
        BottomNavigationBarItem(
          icon: controller.indexScreen == 1
              ? const Icon(Icons.video_library_rounded, size: 28)
              : const Icon(Icons.video_library_outlined, size: 20),
          label: AppLocalizations.of(context)!.videos,
        ),
      ],
      currentIndex: controller.indexScreen,
      selectedItemColor: ColorConfig.purpleColorLogo,
      onTap: (int? index) {
        if (index == null) {
          return;
        }
        controller.switchScreen(index);
      },
    );
  }
}
