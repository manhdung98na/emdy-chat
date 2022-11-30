import 'package:emdy_chat/configure/color.dart';
import 'package:emdy_chat/controller/home_page_controller.dart';
import 'package:emdy_chat/view/controls/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePageBottom extends StatefulWidget {
  const HomePageBottom({super.key});

  @override
  State<HomePageBottom> createState() => _HomePageBottomState();
}

class _HomePageBottomState extends State<HomePageBottom>
    with TickerProviderStateMixin {
  HomePageController get controller => HomePageController.instance;

  late AnimationController firstController,
      secondController,
      thirdController,
      fourController,
      chosenController;

  late Animation first, second, third, four;

  @override
  void initState() {
    super.initState();
    firstController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    )..forward();
    chosenController = firstController;
    secondController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );
    thirdController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );
    fourController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );
    first =
        ColorTween(begin: Colors.transparent, end: ColorConfig.purpleColorLogo)
            .animate(firstController);
    second =
        ColorTween(begin: Colors.transparent, end: ColorConfig.purpleColorLogo)
            .animate(secondController);
    third =
        ColorTween(begin: Colors.transparent, end: ColorConfig.purpleColorLogo)
            .animate(thirdController);
    four =
        ColorTween(begin: Colors.transparent, end: ColorConfig.purpleColorLogo)
            .animate(fourController);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 62,
      child: CustomPaint(
        painter: HomePageBottomPainter(),
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            children: [
              Expanded(
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      clickButton(0);
                      controller.switchScreen(0);
                    },
                    child: AnimatedBuilder(
                      animation: first,
                      builder: (_, __) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          buildIconBackground(
                            controller: firstController,
                            animation: first,
                            child: Icon(
                              Icons.message_outlined,
                              color: Colors.white,
                              size: 20 + firstController.value * 4,
                            ),
                          ),
                          buildText(
                            text: AppLocalizations.of(context)!.accepted,
                            fontSize: firstController.value * 12,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      clickButton(1);
                      controller.switchScreen(1);
                    },
                    child: AnimatedBuilder(
                      animation: second,
                      builder: (_, __) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          buildIconBackground(
                            controller: secondController,
                            animation: second,
                            child: Icon(
                              Icons.comments_disabled_outlined,
                              color: Colors.white,
                              size: 20 + secondController.value * 4,
                            ),
                          ),
                          buildText(
                            text: AppLocalizations.of(context)!.ignored,
                            fontSize: secondController.value * 12,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Expanded(
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      clickButton(2);
                      controller.switchScreen(2);
                    },
                    child: AnimatedBuilder(
                      animation: third,
                      builder: (_, __) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          buildIconBackground(
                            controller: thirdController,
                            animation: third,
                            child: Icon(
                              Icons.block_outlined,
                              color: Colors.white,
                              size: 20 + thirdController.value * 4,
                            ),
                          ),
                          buildText(
                            text: AppLocalizations.of(context)!.blocked,
                            fontSize: thirdController.value * 12,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                  child: Center(
                      child: GestureDetector(
                onTap: () {
                  clickButton(3);
                  controller.switchScreen(3);
                },
                child: AnimatedBuilder(
                  animation: four,
                  builder: (_, __) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      buildIconBackground(
                        controller: fourController,
                        animation: four,
                        child: Icon(
                          Icons.hourglass_top_rounded,
                          color: Colors.white,
                          size: 20 + fourController.value * 4,
                        ),
                      ),
                      buildText(
                        text: AppLocalizations.of(context)!.waiting,
                        fontSize: fourController.value * 12,
                      )
                    ],
                  ),
                ),
              )))
            ],
          ),
        ),
      ),
    );
  }

  Container buildIconBackground(
      {required AnimationController controller,
      required Animation animation,
      required Widget child}) {
    return Container(
      width: 30 + controller.value * 5,
      height: 30 + controller.value * 5,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: animation.value,
      ),
      child: child,
    );
  }

  AppText buildText({required String text, required double fontSize}) {
    return AppText(
      text: text,
      textAlign: TextAlign.center,
      maxLines: 1,
      style:
          Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: fontSize),
    );
  }

  void clickButton(int index) {
    switch (index) {
      case 0:
        firstController.forward();
        chosenController.reverse();
        chosenController = firstController;
        break;
      case 1:
        secondController.forward();
        chosenController.reverse();
        chosenController = secondController;
        break;
      case 2:
        thirdController.forward();
        chosenController.reverse();
        chosenController = thirdController;
        break;
      case 3:
        fourController.forward();
        chosenController.reverse();
        chosenController = fourController;
        break;
      default:
    }
  }

  @override
  void dispose() {
    super.dispose();
    firstController.dispose();
    secondController.dispose();
    thirdController.dispose();
    fourController.dispose();
  }
}

class HomePageBottomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double w = size.width;
    double h = size.height;

    Paint paint = Paint()..color = Colors.black38;
    Path path = Path()
      ..moveTo(0, 10)
      ..quadraticBezierTo(w * 0.2, 0, w * 0.35, 0)
      ..quadraticBezierTo(w * 0.38, 2, w * 0.4, 20)
      ..arcToPoint(
        Offset(w * 0.6, 20),
        radius: const Radius.circular(42),
        clockwise: false,
      )
      ..quadraticBezierTo(w * 0.62, 2, w * 0.65, 0)
      ..quadraticBezierTo(w * 0.8, 0, w, 10)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
