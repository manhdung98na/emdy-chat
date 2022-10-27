import 'package:emdy_chat/util/type_util.dart';
import 'package:emdy_chat/view/controls/inprogress_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_compression_flutter/image_compression_flutter.dart';

class FileManager {
  FileManager._();

  static const List<String> imageExtension = ['png', 'jpg', 'jpge'];

  static const List<String> videoExtension = ['mp4'];

  // Check extension of File and return type of it
  static int checkType(String extension) {
    var imageExtensions = [
      'jpg',
      'png',
      'jpeg',
      'jfif',
      'pjpeg',
      'pjp',
      'webp'
    ];
    var videExtensions = ['mp4', 'wmw', 'webm', 'avi'];
    if (imageExtensions.contains(extension.toLowerCase())) {
      return MessageType.picture;
    } else if (videExtensions.contains(extension.toLowerCase())) {
      return MessageType.video;
    }
    return MessageType.text;
  }

  /// Allow user to pick a file (image or video type) from device
  static Future<PlatformFile?> pickSingleMedia(BuildContext context,
      {List<String>? allowedExtensions}) async {
    showDialog(
        context: context, builder: (context) => const InprogressWidget());
    FilePickerResult? pickedFile = await FilePicker.platform
        .pickFiles(
          type: FileType.custom,
          allowMultiple: false,
          allowCompression: true,
          withData: true,
          lockParentWindow: true,
          allowedExtensions:
              allowedExtensions ?? [...imageExtension, ...videoExtension],
        )
        .whenComplete(() => Navigator.pop(context));
    return pickedFile?.files.single;
  }

  /// This will compress and reduce size of image
  static Future<Uint8List> compressImage(PlatformFile file) async {
    ImageFile input = ImageFile(filePath: file.path!, rawBytes: file.bytes!);
    Configuration config = Configuration(
      outputType: ImageOutputType.webpThenJpg,
      // can only be true for Android and iOS while using ImageOutputType.jpg or ImageOutputType.pngÏ
      useJpgPngNativeCompressor:
          !kIsWeb && defaultTargetPlatform == TargetPlatform.android ||
              defaultTargetPlatform == TargetPlatform.iOS,
      quality: 40,
    );

    var output = await compressor
        .compress(ImageFileConfiguration(input: input, config: config));
    return output.rawBytes;
  }

  /// This will compress and reduce size of image
  static Future<Uint8List> compressVideo(PlatformFile file) async {
    return file.bytes!;
  }
}
