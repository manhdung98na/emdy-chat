import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocaleController extends ChangeNotifier {
  LocaleController();

  late BuildContext context;

  Locale? _locale;

  Locale? get locale => _locale;

  String getLocaleName(context) {
    switch (_locale?.languageCode ?? 'en') {
      case 'vi':
        return AppLocalizations.of(context)!.vietnamese;
      default:
        return AppLocalizations.of(context)!.english;
    }
  }

  void setLocale(Locale locale) {
    if (!AppLocalizations.supportedLocales.contains(locale)) {
      return;
    }
    _locale = locale;
    notifyListeners();
  }
}
