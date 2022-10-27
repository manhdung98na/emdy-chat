import 'package:emdy_chat/configure/color.dart';
import 'package:emdy_chat/configure/size.dart';
import 'package:emdy_chat/configure/style.dart';
import 'package:emdy_chat/controller/register_controller.dart';
import 'package:emdy_chat/util/constant.dart';
import 'package:emdy_chat/util/popup_util.dart';
import 'package:emdy_chat/util/string_util.dart';
import 'package:emdy_chat/util/type_util.dart';
import 'package:emdy_chat/view/controls/app_text.dart';
import 'package:emdy_chat/view/controls/app_text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late RegisterController controller;

  @override
  void initState() {
    controller = RegisterController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var viewInsets = MediaQuery.of(context).viewInsets;

    return Scaffold(
      backgroundColor: ColorConfig.primaryColor,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          //left-bottom
          if (viewInsets.bottom == 0)
            const CustomPaint(
              painter: RegisterPageCustomBottomLeft(),
              size: Size.infinite,
            ),
          //top right
          const CustomPaint(
            painter: RegisterPageCustomTopRight(),
            size: Size.fromHeight(150),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                alignment: Alignment.centerLeft,
                child: AppText(
                  text: 'REGISTER',
                  style: StyleConfig.headerTextStyle.copyWith(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: ColorConfig.purpleColorLogo,
                  ),
                ),
              ),
              //input form
              Padding(
                padding:
                    const EdgeInsets.fromLTRB(28, 20, 28, SizeConfig.rowSpace),
                child: ChangeNotifierProvider.value(
                  value: controller,
                  child: Consumer<RegisterController>(
                    builder: (_, controller, __) => Form(
                      key: controller.formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppTextField(
                            label: 'Name',
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.name,
                            underline: true,
                            suffixWidget: const Icon(Icons.person),
                            controller: controller.teName,
                            validator: StringUtil.validateName,
                          ),
                          const SizedBox(height: SizeConfig.rowSpace),
                          AppTextField(
                            label: 'Email',
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.emailAddress,
                            underline: true,
                            suffixWidget: const Icon(Icons.email),
                            controller: controller.teEmail,
                            hint: 'Example: abc@gmail.com',
                            textCapitalization: TextCapitalization.none,
                            validator: StringUtil.validateEmail,
                          ),
                          const SizedBox(height: SizeConfig.rowSpace),
                          AppTextField(
                            label: 'Password',
                            textInputAction: TextInputAction.go,
                            obscureText: controller.hidePassword,
                            underline: true,
                            suffixWidget: IconButton(
                              splashRadius: 0.1,
                              onPressed: controller.toggleHidePassword,
                              icon: controller.hidePassword
                                  ? const Icon(Icons.lock)
                                  : const Icon(Icons.lock_open),
                            ),
                            controller: controller.tePassword,
                            onSubmit: (String _) => submit(),
                            validator: StringUtil.validatePassword,
                            buildCounter: checkPasswordHealth,
                          ),
                          const SizedBox(height: 20),
                          _buildRegisterButton(context, controller),
                          const SizedBox(height: SizeConfig.rowSpace),
                          _buildAlreadyHaveAccount(context),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterButton(
          BuildContext context, RegisterController controller) =>
      Align(
        alignment: Alignment.centerRight,
        child: Container(
          width: 170,
          height: SizeConfig.buttonHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [ColorConfig.navyColorLogo, ColorConfig.purpleColorLogo],
            ),
          ),
          child: ElevatedButton.icon(
            style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                  minimumSize: MaterialStateProperty.all(
                    const Size(250, SizeConfig.buttonHeight),
                  ),
                  backgroundColor:
                      MaterialStateProperty.all(Colors.transparent),
                  elevation: MaterialStateProperty.all(0),
                ),
            onPressed: submit,
            icon: const Icon(Icons.login_rounded),
            label: const AppText(
                text: 'Sign up', style: StyleConfig.buttonTextStyle),
          ),
        ),
      );

  Widget _buildAlreadyHaveAccount(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: RichText(
        text: TextSpan(
          text: 'Already have an account? ',
          style: StyleConfig.contentTextStyle,
          children: [
            TextSpan(
              text: 'Login now',
              recognizer: TapGestureRecognizer()
                ..onTap = () => Navigator.pop(context),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            )
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget? checkPasswordHealth() {
    if (controller.tePassword.text.isEmpty) {
      return null;
    }
    var health = StringUtil.checkPasswordHealth(controller.tePassword.text);
    String text;
    Color color;
    switch (health) {
      case PasswordHeath.weak:
        text = 'Password is weak!';
        color = Colors.yellow;
        break;
      case PasswordHeath.good:
        text = 'Password is good!';
        color = ColorConfig.hintTextColor;
        break;
      case PasswordHeath.strong:
        text = 'Password is strong!';
        color = Colors.green;
        break;
      default:
        text = 'Password must have at least 6 characters';
        color = Colors.red;
    }
    return AppText(
        text: text, style: StyleConfig.hintTextStyle.copyWith(color: color));
  }

  void submit() async {
    if (controller.formKey.currentState!.validate()) {
      await controller.register(context).then((value) {
        if (value == success) {
          Navigator.pop(context);
        }
        PopupUtil.showSnackBar(context, value);
      });
    }
  }
}

class RegisterPageCustomTopRight extends CustomPainter {
  const RegisterPageCustomTopRight();

  @override
  void paint(Canvas canvas, Size size) {
    var width = size.width;
    var heightUnder = size.height;
    Paint paintUnder = Paint()
      ..color = ColorConfig.purpleColorLogo.withOpacity(0.8);
    Path pathUnder = Path()
      ..moveTo(0, 0)
      ..lineTo(width, 0)
      ..lineTo(width, heightUnder)
      ..quadraticBezierTo(
          width * 0.9, heightUnder * 1.05, width * 0.75, heightUnder * 0.6)
      ..quadraticBezierTo(
          width * 0.65, heightUnder * 0.2, width * 0.45, heightUnder * 0.15)
      ..quadraticBezierTo(
          width * 0.3, heightUnder * 0.08, 0, heightUnder * 0.05)
      ..close();

    var heightAbove = size.height * 0.8;
    Paint paintAbove = Paint()
      ..color = ColorConfig.navyColorLogo.withOpacity(0.5);
    Path pathAbove = Path()
      ..moveTo(0, 0)
      ..lineTo(width, 0)
      ..lineTo(width, heightAbove)
      ..quadraticBezierTo(
          width * 0.7, heightAbove, width * 0.5, heightAbove * 0.3)
      ..quadraticBezierTo(width * 0.4, heightAbove * 0.05, width * 0.2, 0)
      ..close();

    canvas.drawPath(pathUnder, paintUnder);
    canvas.drawPath(pathAbove, paintAbove);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class RegisterPageCustomBottomLeft extends CustomPainter {
  const RegisterPageCustomBottomLeft();

  @override
  void paint(Canvas canvas, Size size) {
    var width = size.width;
    var screenHeight = size.height;
    var boundaryHeight = screenHeight - 150;

    Paint paintUnder = Paint()
      ..color = ColorConfig.navyColorLogo.withOpacity(0.5);
    Path pathUnder = Path()
      ..moveTo(0, screenHeight)
      ..lineTo(0, boundaryHeight)
      ..cubicTo(width * 0.3, boundaryHeight * 0.95, width * 0.35,
          screenHeight * 0.98, width, screenHeight * 0.97)
      ..lineTo(width, screenHeight)
      ..close();

    Paint paintAbove = Paint()
      ..color = ColorConfig.purpleColorLogo.withOpacity(0.8);
    Path pathAbove = Path()
      ..moveTo(0, screenHeight)
      ..lineTo(0, boundaryHeight * 1.15)
      ..quadraticBezierTo(
          width * 0.35, screenHeight, width, boundaryHeight * 1.07)
      ..lineTo(width, screenHeight)
      ..close();

    canvas.drawPath(pathAbove, paintAbove);
    canvas.drawPath(pathUnder, paintUnder);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
