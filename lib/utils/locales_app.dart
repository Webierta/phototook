import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocalesApp {
  static final List<String> langCodes =
      AppLocalizations.supportedLocales // [Locale('en'), Locale('es')]
          .map((locale) => (locale.languageCode))
          .toList();

  String langName(String codeLang) {
    return switch (codeLang) {
      'en' => 'English',
      'es' => 'Español',
      'de' => 'Deutsch',
      _ => 'English',
    };
  }
}
