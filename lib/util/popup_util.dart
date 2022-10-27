import 'package:emdy_chat/view/controls/inprogress_widget.dart';
import 'package:flutter/material.dart';

class PopupUtil {
  static showSnackBar(BuildContext context, String message) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          action: SnackBarAction(
            label: 'OK',
            onPressed: () {
              // ScaffoldMessenger.of(context)
              //     .hideCurrentSnackBar(reason: SnackBarClosedReason.swipe);
            },
          ),
          duration: const Duration(milliseconds: 3000),
        ),
      );

  static showLoadingDialog(
          BuildContext context, GlobalKey<InprogressWidgetState> loadingKey) =>
      showDialog(
        context: context,
        barrierDismissible: false,
        useRootNavigator: true,
        builder: (context) => WillPopScope(
          onWillPop: () => Future.value(false),
          child: InprogressWidget(key: loadingKey),
        ),
      );

  static void showBottomSheet(BuildContext context, Widget child) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      elevation: 15,
      enableDrag: true,
      builder: (context) => child,
    );
  }
}
