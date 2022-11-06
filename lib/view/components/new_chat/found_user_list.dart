import 'package:emdy_chat/configure/assets.dart';
import 'package:emdy_chat/configure/color.dart';
import 'package:emdy_chat/configure/style.dart';
import 'package:emdy_chat/controller/new_chat_controller.dart';
import 'package:emdy_chat/modal/user.dart';
import 'package:emdy_chat/view/controls/app_text.dart';
import 'package:flutter/material.dart';

class FoundUserList extends StatelessWidget {
  const FoundUserList({super.key, required this.controller});

  final NewChatController controller;

  List<User> get list => controller.foundUsers;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list.length + 1,
      itemBuilder: (context, index) {
        if (index == list.length) {
          return buildLoadMoreWidget();
        }

        User user = list[index];
        return ListTile(
          key: Key(user.id),
          onTap: () {
            controller.loadChatByReceiverId(user.id);
          },
          leading: Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: ColorConfig.navyColorLogo, width: 0.1),
              image: DecorationImage(image: buildAvatar(user)),
            ),
          ),
          title: AppText(
            text: user.fullName,
            style: StyleConfig.titleTextStyle,
          ),
          subtitle: AppText(
            text: '@${user.userId}',
            style: StyleConfig.hintTextStyle,
          ),
        );
      },
    );
  }

  ImageProvider buildAvatar(User user) {
    if (user.avatar == null) {
      return const AssetImage(AssetsConfig.defaultAvatar);
    } else {
      return MemoryImage(user.avatar!);
    }
  }

  Widget buildLoadMoreWidget() {
    if (controller.lastUserSnapshot == null) {
      return const SizedBox();
    }
    return Center(
      child: Material(
        color: ColorConfig.primaryColor,
        borderRadius: BorderRadius.circular(20),
        elevation: 2,
        shadowColor: ColorConfig.secondaryColor,
        child: InkWell(
          onTap: () {
            controller.loadMore();
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 100,
            height: 30,
            alignment: Alignment.center,
            child: const AppText(
              text: 'Load more',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
