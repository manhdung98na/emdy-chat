import 'package:emdy_chat/configure/assets.dart';
import 'package:emdy_chat/configure/color.dart';
import 'package:emdy_chat/configure/route.dart';
import 'package:emdy_chat/configure/size.dart';
import 'package:emdy_chat/configure/style.dart';
import 'package:emdy_chat/controller/locale_controller.dart';
import 'package:emdy_chat/controller/login_controller.dart';
import 'package:emdy_chat/view/controls/app_text.dart';
import 'package:emdy_chat/view/controls/app_text_field.dart';
import 'package:emdy_chat/view/pages/register_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    var viewInsets = MediaQuery.of(context).viewInsets;
    return Scaffold(
      backgroundColor: ColorConfig.primaryColor,
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          _buildCuveBanner(viewInsets.bottom),
          const SizedBox(height: 20),
          Expanded(
              child: Image.asset(AssetsConfig.logo, height: 170, width: 170)),
          //input form
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 20, 28, SizeConfig.rowSpace),
            child: ChangeNotifierProvider(
              create: (context) => LoginController(),
              child: Consumer<LoginController>(
                builder: (_, controller, __) => Form(
                  key: controller.formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppTextField(
                        prefixWidget: const Icon(Icons.email_rounded),
                        controller: controller.teEmail,
                        label: AppLocalizations.of(context)!.email,
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.none,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: SizeConfig.rowSpace),
                      AppTextField(
                        prefixWidget: const Icon(Icons.lock_rounded),
                        label: AppLocalizations.of(context)!.password,
                        textInputAction: TextInputAction.done,
                        obscureText: controller.hidePassword,
                        suffixWidget: IconButton(
                          splashRadius: 0.1,
                          onPressed: controller.toggleHidePassword,
                          icon: controller.hidePassword
                              ? const Icon(Icons.lock)
                              : const Icon(Icons.lock_open),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return AppLocalizations.of(context)!
                                .passwordCanNotEmpty;
                          }
                          return null;
                        },
                        controller: controller.tePassword,
                      ),
                      const SizedBox(height: SizeConfig.rowSpace),
                      _buildLoginButton(context, controller)
                    ],
                  ),
                ),
              ),
            ),
          ),
          _buildSignUp(context),
          const SizedBox(height: 10),
          _buildMultiLanguage(context),
          const SizedBox(height: 35),
        ],
      ),
    );
  }

  Stack _buildCuveBanner(double bottomPad) => Stack(
        fit: StackFit.passthrough,
        children: [
          CustomPaint(
            painter: LoginPagePaintBelow(bottomPad),
            size: Size.fromHeight(200 - bottomPad),
          ),
          CustomPaint(
            painter: LoginPagePaintAbove(bottomPad),
            size: Size.fromHeight(170 - bottomPad),
          ),
        ],
      );

  ElevatedButton _buildLoginButton(
          BuildContext context, LoginController controller) =>
      ElevatedButton.icon(
        style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
              minimumSize: MaterialStateProperty.all(
                const Size(double.infinity, SizeConfig.buttonHeight),
              ),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
        onPressed: () => controller.login(context),
        icon: const Icon(Icons.login_rounded),
        label: AppText(
          text: AppLocalizations.of(context)!.signIn,
          style: StyleConfig.contentTextStyle.copyWith(color: Colors.white),
        ),
      );

  Widget _buildSignUp(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: '${AppLocalizations.of(context)!.dontHaveAccount} ',
        style: StyleConfig.contentTextStyle,
        children: [
          TextSpan(
            text: AppLocalizations.of(context)!.registerHere,
            recognizer: TapGestureRecognizer()
              ..onTap =
                  () => RouteConfig.pushWidget(context, const RegisterPage()),
            style: StyleConfig.contentTextStyle.copyWith(
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  Row _buildMultiLanguage(BuildContext context) {
    var localeProvider = Provider.of<LocaleController>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {
            localeProvider.setLocale(const Locale('vi'));
          },
          child: const Text('Vi', style: TextStyle(color: Colors.black)),
        ),
        TextButton(
          onPressed: () {
            localeProvider.setLocale(const Locale('en'));
          },
          child: const Text('En', style: TextStyle(color: Colors.black)),
        ),
      ],
    );
  }
}

class LoginPagePaintBelow extends CustomPainter {
  const LoginPagePaintBelow(this.bottomPad);

  /// Bottom padding when showing keyboard
  final double bottomPad;

  @override
  void paint(Canvas canvas, Size size) {
    double width = size.width, height = size.height - bottomPad;
    Paint paint = Paint()
      ..shader = LinearGradient(colors: [
        ColorConfig.navyColorLogo.withOpacity(0.5),
        ColorConfig.purpleColorLogo.withOpacity(0.5),
      ]).createShader(
          Rect.fromPoints(Offset(0, height / 2), Offset(width, height / 2)));
    Path path = Path()
      ..moveTo(0, 0)
      ..lineTo(width, 0)
      ..lineTo(width, height * 0.65)
      ..quadraticBezierTo(width * 0.65, height, width * 0.5, height * 0.8)
      ..conicTo(width * 0.3, height * 0.5, 0, height * 0.5, 2)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class LoginPagePaintAbove extends CustomPainter {
  const LoginPagePaintAbove(this.bottomPad);

  /// Bottom padding when showing keyboard
  final double bottomPad;

  @override
  void paint(Canvas canvas, Size size) {
    double width = size.width, height = size.height - bottomPad;
    Paint paint = Paint()
      ..shader = const LinearGradient(colors: [
        ColorConfig.navyColorLogo,
        ColorConfig.purpleColorLogo,
      ]).createShader(
          Rect.fromPoints(Offset(0, height / 2), Offset(width, height / 2)));
    Path path = Path()
      ..moveTo(0, 0)
      ..lineTo(width, 0)
      ..lineTo(width, height * 0.65)
      ..quadraticBezierTo(width * 0.65, height, width * 0.5, height * 0.8)
      ..conicTo(width * 0.3, height * 0.5, 0, height * 0.5, 2)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
