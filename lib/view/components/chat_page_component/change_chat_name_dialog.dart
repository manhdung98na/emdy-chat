import 'package:emdy_chat/configure/color.dart';
import 'package:emdy_chat/configure/style.dart';
import 'package:emdy_chat/controller/chat_page/chat_page_controller.dart';
import 'package:emdy_chat/util/constant.dart';
import 'package:emdy_chat/util/popup_util.dart';
import 'package:emdy_chat/util/type_util.dart';
import 'package:emdy_chat/view/controls/app_text.dart';
import 'package:emdy_chat/view/controls/app_text_field.dart';
import 'package:flutter/material.dart';

class ChangeChatNameDialog extends StatefulWidget {
  const ChangeChatNameDialog({super.key, required this.controller});

  final ChatPageController controller;

  @override
  State<ChangeChatNameDialog> createState() => _ChangeChatNameDialogState();
}

class _ChangeChatNameDialogState extends State<ChangeChatNameDialog> {
  late TextEditingController teName;
  late GlobalKey<FormState> formKey;
  late bool isLoading;

  @override
  void initState() {
    isLoading = false;
    teName = TextEditingController(text: widget.controller.chat.name);
    formKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: ColorConfig.primaryColor,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              text: 'Conversation name',
              style: StyleConfig.headerTextStyle.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const AppText(
              text:
                  'To change conversation name, please type new name and save!',
              maxLines: 2,
              style: StyleConfig.hintTextStyle,
            ),
            const SizedBox(height: 8),
            if (isLoading)
              const LinearProgressIndicator(color: ColorConfig.purpleColorLogo),
            Form(
              key: formKey,
              child: AppTextField(
                readOnly: isLoading,
                controller: teName,
                autoFocus: true,
                borderType: BorderType.underline,
                textCapitalization: TextCapitalization.words,
                padding: const EdgeInsets.only(top: 15),
                validator: (v) {
                  if (v?.trim().isEmpty ?? true) {
                    return 'Name can not empty';
                  }
                  return null;
                },
                suffixWidget: IconButton(
                  onPressed: updateName,
                  icon: const Icon(
                    Icons.save,
                    color: ColorConfig.purpleColorLogo,
                    size: 32,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void updateName() async {
    if (isLoading) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    if (formKey.currentState?.validate() ?? false) {
      await widget.controller.chat.updateName(teName.text.trim()).then((value) {
        if (value == success) {
          Navigator.pop(context);
        } else {
          setState(() {
            isLoading = false;
          });
        }
        PopupUtil.showSnackBar(context, value);
      });
    }
  }
}
