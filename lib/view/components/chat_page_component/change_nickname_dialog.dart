import 'package:emdy_chat/configure/color.dart';
import 'package:emdy_chat/configure/style.dart';
import 'package:emdy_chat/controller/chat_page/change_nickname_controller.dart';
import 'package:emdy_chat/controller/chat_page/chat_page_controller.dart';
import 'package:emdy_chat/manager/user_manager.dart';
import 'package:emdy_chat/util/constant.dart';
import 'package:emdy_chat/util/popup_util.dart';
import 'package:emdy_chat/util/type_util.dart';
import 'package:emdy_chat/view/controls/app_text.dart';
import 'package:emdy_chat/view/controls/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChangeNicknameDialog extends StatelessWidget {
  const ChangeNicknameDialog({super.key, required this.controller});

  final ChatPageController controller;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: ColorConfig.primaryColor,
      child: ChangeNotifierProvider(
        create: (context) => ChangeNicknameController(controller),
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
          child: Consumer<ChangeNicknameController>(
            builder: (_, controller, __) {
              return Form(
                key: controller.formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: AppLocalizations.of(context)!.nicknames,
                      style: StyleConfig.headerTextStyle.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (controller.isLoading)
                      const LinearProgressIndicator(
                          color: ColorConfig.purpleColorLogo),
                    AppTextField(
                      readOnly: controller.isLoading,
                      controller: controller.thisNickname,
                      autoFocus: true,
                      borderType: BorderType.underline,
                      textCapitalization: TextCapitalization.words,
                      padding: const EdgeInsets.only(top: 15),
                      buildCounter: () => AppText(
                        text: UserManager.currentUser?.fullName ??
                            AppLocalizations.of(context)!.you,
                        style: StyleConfig.hintTextStyle,
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return AppLocalizations.of(context)!
                              .nicknameCannotEmpty;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    AppTextField(
                      readOnly: controller.isLoading,
                      controller: controller.otherNickname,
                      borderType: BorderType.underline,
                      textCapitalization: TextCapitalization.words,
                      padding: const EdgeInsets.only(top: 15),
                      buildCounter: () => AppText(
                        text: controller.theOpposite?.fullName ?? '',
                        style: StyleConfig.hintTextStyle,
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return AppLocalizations.of(context)!
                              .nicknameCannotEmpty;
                        }
                        return null;
                      },
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(top: 8),
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          await controller.update().then((value) {
                            if (value == null || value) {
                              Navigator.pop(context);
                              PopupUtil.showSnackBar(context, success);
                            }
                          });
                        },
                        icon: const Icon(Icons.save),
                        label: Text(
                          AppLocalizations.of(context)!.save,
                          style: StyleConfig.contentTextStyle.copyWith(
                            color: ColorConfig.primaryColor,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
