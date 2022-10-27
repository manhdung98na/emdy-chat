import 'package:emdy_chat/configure/color.dart';
import 'package:emdy_chat/configure/size.dart';
import 'package:emdy_chat/controller/home_page_controller.dart';
import 'package:flutter/material.dart';

class HomePageBottom extends StatefulWidget {
  const HomePageBottom({super.key});

  @override
  State<HomePageBottom> createState() => _HomePageBottomState();
}

class _HomePageBottomState extends State<HomePageBottom> {
  HomePageController get controller => HomePageController.instance;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: controller.indexScreen,
      backgroundColor: ColorConfig.primaryColor,
      onDestinationSelected: (value) {
        setState(() {
          controller.switchScreen(value);
        });
      },
      animationDuration: const Duration(milliseconds: 1000),
      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      height: 60,
      elevation: SizeConfig.elevation,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.message_outlined),
          label: 'Accepted chats',
        ),
        NavigationDestination(
          icon: Icon(Icons.comments_disabled_outlined),
          label: 'Ignored chats',
        ),
        NavigationDestination(
          icon: Icon(Icons.block_outlined),
          label: 'Blocked chats',
        ),
      ],
    );
  }
}
