import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocaleController extends ChangeNotifier {
  static const String defaultLocaleCode = 'vi';

  Locale? _locale;

  Locale? get locale => _locale;

  String getLocaleName(context) {
    switch (_locale?.languageCode ?? 'vi') {
      case 'vi':
        return AppLocalizations.of(context)!.vietnamese;
      default:
        return AppLocalizations.of(context)!.english;
    }
  }

  void setLocale(Locale newLocale) {
    if (!AppLocalizations.supportedLocales.contains(newLocale)) {
      return;
    }
    _locale = newLocale;
    notifyListeners();
  }
}
