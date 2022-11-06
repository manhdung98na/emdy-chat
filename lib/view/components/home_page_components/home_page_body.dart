import 'package:emdy_chat/configure/color.dart';
import 'package:emdy_chat/configure/style.dart';
import 'package:emdy_chat/controller/home_page_controller.dart';
import 'package:emdy_chat/view/components/home_page_components/home_page_chat_item.dart';
import 'package:emdy_chat/view/controls/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePageBody extends StatelessWidget {
  const HomePageBody({super.key});

  HomePageController get controller => HomePageController.instance;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ChangeNotifierProvider.value(
        value: controller,
        child: Consumer<HomePageController>(
          builder: (_, controller, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                searchWidget,
                ...buildList(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget get searchWidget {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: AppTextField(
        controller: controller.teSearch!,
        keyboardType: TextInputType.text,
        borderRadius: 30,
        hint: 'Search chats here',
        hintStyle: StyleConfig.contentTextStyle.copyWith(
          color: ColorConfig.hintTextColor,
        ),
        prefixWidget: const Icon(
          Icons.search,
          color: ColorConfig.hintTextColor,
        ),
        onChange: (value) {},
      ),
    );
  }

  List<Widget> buildList() {
    var listChat = controller.filterChats();
    if (listChat.isEmpty) {
      var alignment = Alignment.topCenter;
      return [
        const SizedBox(height: 100),
        SizedBox(
          height: 100,
          child: StatefulBuilder(
            builder: (context, setState) {
              Future.delayed(
                Duration.zero,
                () => setState(() => alignment = Alignment.bottomCenter),
              );
              return AnimatedAlign(
                alignment: alignment,
                curve: Curves.bounceOut,
                duration: const Duration(milliseconds: 500),
                child: const Text('No available chat'),
              );
            },
          ),
        )
      ];
    }

    return listChat.map((e) => HomePageChatItem(chat: e)).toList();
  }
}
