import 'package:emdy_chat/configure/color.dart';
import 'package:flutter/material.dart';

/// Widget hiển thị khi tải các file media bị lỗi
class ErrorMediaWidget extends StatelessWidget {
  const ErrorMediaWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(
        Icons.broken_image_outlined,
        size: 34,
        color: ColorConfig.navyColorLogo,
      ),
    );
  }
}
