import 'package:emdy_chat/configure/color.dart';
import 'package:flutter/material.dart';

class LoadingMediaWidget extends StatelessWidget {
  const LoadingMediaWidget({super.key});

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
      child: const CircularProgressIndicator(
        color: ColorConfig.purpleColorLogo,
      ),
    );
  }
}
