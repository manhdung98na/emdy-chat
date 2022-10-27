import 'package:emdy_chat/util/type_util.dart';

class StringUtil {
  static final _specificCharactersRegex =
      RegExp(r'[!@#$&*+=<>,;:|/?[\]{\}\\"]]*');
  static final _emailRegex = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  static String? validateName(String? name) {
    if (name == null || name.isEmpty) {
      return 'Name must not be empty!';
    }
    if (_specificCharactersRegex.hasMatch(name)) {
      return 'Name must not contain specific character!';
    }
    if (name.length > 64) {
      return 'Name can only have 64 characters in maximum!';
    }
    return null;
  }

  static String? validateEmail(String? email) {
    if (email == null || email.trim().isEmpty) {
      return 'Email can not be empty!';
    }
    if (!_emailRegex.hasMatch(email.trim())) {
      return 'Email is invalid!';
    }
    return null;
  }

  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password can not be empty!';
    }
    if (password.length < 6) {
      return 'Password must contain at least 6 characters!';
    }
    return null;
  }

  static PasswordHeath checkPasswordHealth(String password) {
    if (password.length < 6) {
      return PasswordHeath.mustHave6Character;
    }
    RegExp passValidStrong = RegExp(r'(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)');
    if (passValidStrong.hasMatch(password)) {
      return PasswordHeath.strong;
    }
    RegExp passValidNormal = RegExp(r'[0-9]*([A-Z][a-z])|([a-z][A-Z])+');
    if (passValidNormal.hasMatch(password)) {
      return PasswordHeath.good;
    }

    return PasswordHeath.weak;
  }
}
