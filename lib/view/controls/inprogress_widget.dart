import 'dart:math';

import 'package:emdy_chat/configure/assets.dart';
import 'package:emdy_chat/configure/color.dart';
import 'package:flutter/material.dart';

class InprogressWidget extends StatefulWidget {
  const InprogressWidget({super.key});

  @override
  State<InprogressWidget> createState() => InprogressWidgetState();
}

class InprogressWidgetState extends State<InprogressWidget>
    with TickerProviderStateMixin {
  late AnimationController firstController, secondController;
  late Animation firstAnimation, secondAnimation;
  double size = 180;

  @override
  void initState() {
    super.initState();
    firstController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    firstAnimation =
        Tween<double>(begin: -pi, end: pi).animate(firstController);
    secondController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );
    secondAnimation =
        Tween<double>(begin: -pi, end: pi).animate(secondController);
    firstController.repeat();
    secondController.repeat();
  }

  @override
  void dispose() {
    firstController.dispose();
    secondController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Center(
        child: Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: ColorConfig.primaryColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedBuilder(
                animation: firstAnimation,
                builder: (context, child) => CustomPaint(
                  painter: LoadingPainter(
                      firstAnimation.value, secondAnimation.value),
                  size: const Size(110, 110),
                ),
              ),
              Image.asset(AssetsConfig.logo, height: 50, width: 50)
            ],
          ),
        ),
      ),
    );
  }
}

class LoadingPainter extends CustomPainter {
  const LoadingPainter(this.firstAngle, this.secondAngle);

  final double firstAngle;
  final double secondAngle;

  @override
  void paint(Canvas canvas, Size size) {
    Paint firstArc = Paint()
      ..color = ColorConfig.navyColorLogo
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;

    Paint secondArc = Paint()
      ..color = ColorConfig.purpleColorLogo
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromLTRB(0, 0, size.width, size.height),
      firstAngle,
      2,
      false,
      firstArc,
    );
    canvas.drawArc(
      Rect.fromLTRB(
          size.width * .1, size.height * .1, size.width * .9, size.height * .9),
      secondAngle,
      2,
      false,
      secondArc,
    );
  }

  @override
  bool shouldRepaint(covariant LoadingPainter oldDelegate) =>
      oldDelegate.firstAngle != firstAngle ||
      oldDelegate.secondAngle != secondAngle;
}
