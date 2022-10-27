import 'package:emdy_chat/manager/file_manager.dart';
import 'package:emdy_chat/manager/user_manager.dart';
import 'package:emdy_chat/view/controls/inprogress_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Quản lý ảnh đại diện của người dùng
///
/// Cho phép người dùng cập nhật, gỡ bỏ ảnh đại diện và reload giao diện sau khi thay đổi
class UserAvatarController extends ChangeNotifier {
  UserAvatarController._();

  static final UserAvatarController _instance = UserAvatarController._();

  static UserAvatarController get instance => _instance;

  void removeAvatar(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const InprogressWidget(),
    );
    await UserManager.removeAvatar().then((result) {
      if (result) {
        UserManager.currentUser!.avatar = null;
        notifyListeners();
      }
    }).whenComplete(() => Navigator.pop(context));
  }

  void updateAvatar(BuildContext context) async {
    PlatformFile? pickedImage = await FileManager.pickSingleMedia(context,
        allowedExtensions: FileManager.imageExtension);
    if (pickedImage == null || pickedImage.bytes == null) {
      return;
    }
    Uint8List compressedImage = await FileManager.compressImage(pickedImage);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const InprogressWidget(),
    );
    await UserManager.updateAvatar(compressedImage).then((result) {
      if (result) {
        UserManager.currentUser!.avatar = compressedImage;
        notifyListeners();
      }
    }).whenComplete(() => Navigator.pop(context));
  }

  void rebuild() => notifyListeners();
}
