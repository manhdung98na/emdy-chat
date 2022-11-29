import 'package:emdy_chat/configure/route.dart';
import 'package:emdy_chat/configure/size.dart';
import 'package:emdy_chat/controller/home_page_controller.dart';
import 'package:emdy_chat/view/components/home_page_components/home_page_appbar.dart';
import 'package:emdy_chat/view/components/home_page_components/home_page_body.dart';
import 'package:emdy_chat/view/components/home_page_components/home_page_bottom.dart';
import 'package:emdy_chat/view/components/left_drawer/left_drawer.dart';
import 'package:emdy_chat/view/components/new_chat/create_new_chat.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomePageController controller;

  @override
  void initState() {
    print('home page init');
    super.initState();
    controller = HomePageController.instance..initialize();
  }

  @override
  Widget build(BuildContext context) {
    print('home page build');

    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        drawer: const LeftDrawer(),
        appBar: const HomePageAppBar(),
        bottomNavigationBar: const HomePageBottom(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: floatingActionButton,
        body: const HomePageBody(),
      ),
    );
  }

  FloatingActionButton get floatingActionButton {
    return FloatingActionButton(
      heroTag: "CreateNewChat",
      elevation: SizeConfig.elevation,
      shape: const CircleBorder(),
      onPressed: () {
        RouteConfig.pushWidget(context, const NewChat());
      },
      child: const Icon(Icons.add),
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.cancelStream();
  }
}
