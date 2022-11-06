import 'package:emdy_chat/configure/color.dart';
import 'package:emdy_chat/configure/size.dart';
import 'package:emdy_chat/configure/style.dart';
import 'package:emdy_chat/util/type_util.dart';
import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    this.label,
    this.hint,
    this.prefixWidget,
    this.suffixWidget,
    this.textInputAction,
    this.onSubmit,
    this.autoFocus = false,
    this.focusNode,
    this.onChange,
    this.obscureText = false,
    this.textCapitalization,
    this.validator,
    this.borderType = BorderType.outline,
    this.buildCounter,
    this.keyboardType,
    this.borderRadius,
    this.hintStyle,
    this.padding,
    this.boxConstraints,
    this.maxLines = 1,
    this.readOnly = false,
  });

  final TextEditingController controller;

  /// This shows in the top-left corner, and display above the border
  final String? label;

  /// This will show when [TextField] value is empty, and will disappear when value is not empty
  final String? hint;

  /// TextStyle of [hint].
  ///
  /// Default is [StyleConfig.hintTextStyle]
  final TextStyle? hintStyle;

  /// Widget show in the left of text. This will be ignored if [borderType] is true
  final Widget? prefixWidget;

  /// Widget show in the right of text
  final Widget? suffixWidget;

  /// Change type of button in the bottom-right corner of keyboard
  ///
  /// Default is [TextInputAction.done]
  final TextInputAction? textInputAction;

  /// Executed when [TextField] is submitted
  ///
  /// For example:
  ///
  ///   * Android/IOS platform: [textInputAction] = [TextInputAction.go]
  ///   * Web platform: Users press Enter key
  final Function(String value)? onSubmit;

  /// This function will be execute when user changes value of [TextField], such as type/remove a character
  final Function(String value)? onChange;

  /// If true, TextField will be focused when display screen.
  ///
  /// Default is false
  final bool autoFocus;

  final FocusNode? focusNode;

  /// If true, replace text by [*] characters
  ///
  /// If false, show text as normal
  ///
  /// Default is false
  final bool obscureText;

  /// Configures how the platform keyboard will select an uppercase or lowercase keyboard.
  ///
  /// Only supports text keyboards, other keyboard types will ignore this configuration.
  ///
  /// Default is `TextCapitalization.sentences`
  final TextCapitalization? textCapitalization;

  /// Use this to validate value of [TextField]
  final String? Function(String?)? validator;

  /// Type of border:
  /// * [BorderType.none] : no border
  /// * [BorderType.underline] : bottom-border
  /// * [BorderType.outline] : 4 edges-border
  ///
  /// Default is [BorderType.none]
  final BorderType borderType;

  final Widget? Function()? buildCounter;

  final TextInputType? keyboardType;

  /// This is for make [RoundedTextField]
  final double? borderRadius;

  ///The space between content and border
  final EdgeInsets? padding;

  /// Limit the height and width of [TextField]
  final BoxConstraints? boxConstraints;

  /// Maximum lines of [TextField]'s content. If you don't want to limit, set [maxLines] = null
  ///
  /// Default is 1.
  final int? maxLines;

  /// Whether user can type or not
  final bool? readOnly;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      readOnly: readOnly ?? false,
      textCapitalization: textCapitalization ?? TextCapitalization.sentences,
      obscureText: obscureText,
      controller: controller,
      autofocus: autoFocus,
      keyboardAppearance: Brightness.dark,
      keyboardType: keyboardType ?? TextInputType.text,
      textInputAction: textInputAction ?? TextInputAction.done,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      focusNode: focusNode,
      maxLines: maxLines,
      showCursor: true,
      textDirection: TextDirection.ltr,
      decoration: InputDecoration(
        contentPadding:
            padding ?? const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
        // contentPadding: padding,
        fillColor: ColorConfig.primaryColor,
        filled: false,
        hoverColor: ColorConfig.secondaryColor,
        labelText: label,
        hintText: hint,
        hintStyle: hintStyle ?? StyleConfig.hintTextStyle,
        alignLabelWithHint: true,
        floatingLabelAlignment: FloatingLabelAlignment.start,
        prefixIcon: borderType == BorderType.underline ? null : prefixWidget,
        suffixIcon: suffixWidget,
        border: border,
        enabledBorder: border,
        constraints: boxConstraints,
      ),
      buildCounter: (context,
              {required currentLength, required isFocused, maxLength}) =>
          buildCounter?.call(),
    );
  }

  InputBorder get border {
    switch (borderType) {
      case BorderType.none:
        return InputBorder.none;
      case BorderType.underline:
        return underlineBorder;
      default:
        return outlineBorder;
    }
  }

  OutlineInputBorder get outlineBorder => OutlineInputBorder(
        borderSide: const BorderSide(color: ColorConfig.navyColorLogo),
        borderRadius:
            BorderRadius.circular(borderRadius ?? SizeConfig.borderRadius),
        gapPadding: 6,
      );

  UnderlineInputBorder get underlineBorder => const UnderlineInputBorder(
        borderSide: BorderSide(color: ColorConfig.navyColorLogo, width: 0.5),
      );
}
