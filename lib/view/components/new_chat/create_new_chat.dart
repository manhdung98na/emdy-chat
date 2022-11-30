import 'package:emdy_chat/configure/app_manager.dart';
import 'package:emdy_chat/controller/new_chat_controller.dart';
import 'package:emdy_chat/util/type_util.dart';
import 'package:emdy_chat/view/components/chat_page_component/chat_page_body.dart';
import 'package:emdy_chat/view/components/new_chat/found_user_list.dart';
import 'package:emdy_chat/view/controls/app_text.dart';
import 'package:emdy_chat/view/controls/app_text_field.dart';
import 'package:emdy_chat/view/controls/inprogress_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class NewChat extends StatelessWidget {
  const NewChat({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buidlAppBar(context),
      backgroundColor: Theme.of(context).primaryColor,
      body: ChangeNotifierProvider(
        create: (context) => NewChatController(),
        child: Consumer<NewChatController>(
          child: const Center(
            child: InprogressWidget(size: 80),
          ),
          builder: (_, controller, child) => Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              buildInput(context, controller),
              if (controller.isLoading) child!,
              Expanded(
                child: controller.chatPageController != null
                    ? ChatPageBody(controller: controller.chatPageController!)
                    : FoundUserList(controller: controller),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar buidlAppBar(BuildContext context) => AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Hero(
          tag: "CreateNewChat",
          child: AppText(
            text: AppLocalizations.of(context)!.newMessage,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      );

  Widget buildInput(BuildContext context, NewChatController controller) {
    return PhysicalModel(
      elevation: 4,
      shadowColor: Colors.black54,
      color: Theme.of(context).primaryColor,
      child: Row(
        children: [
          Container(
            width: 50,
            alignment: Alignment.center,
            child: AppText(
                text: '${AppLocalizations.of(context)!.to}:',
                textAlign: TextAlign.center),
          ),
          Expanded(
            child: AppTextField(
              autoFocus: true,
              borderType: BorderType.none,
              hint: AppLocalizations.of(context)!.inputReceiverUID,
              padding: const EdgeInsets.symmetric(vertical: 10),
              textCapitalization: TextCapitalization.none,
              // prefixWidget: Row(
              //   mainAxisSize: MainAxisSize.min,
              //   children: [
              //     Container(
              //       width: 100,
              //       height: 20,
              //       decoration: BoxDecoration(
              //         color: ColorConfig.secondaryColor,
              //         borderRadius: BorderRadius.circular(10),
              //       ),
              //     ),
              //   ],
              // ),
              suffixWidget: InkWell(
                onTap: () {
                  AppManager.unfocus(context);
                  controller.searchUserById();
                },
                child: const Icon(Icons.person_search_outlined, size: 24),
              ),
              controller: controller.teUserId,
              onSubmit: (_) => controller.searchUserById(),
            ),
          ),
        ],
      ),
    );
  }
}
