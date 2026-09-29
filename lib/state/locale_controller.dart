import 'package:flutter/material.dart';

class LocaleController extends ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  static const supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
    Locale('or'),
    Locale('bn'),
    Locale('te'),
    Locale('ta'),
    Locale('mr'),
  ];

  void setLanguage(String languageCode) {
    final supported = supportedLocales.any(
      (item) => item.languageCode == languageCode,
    );

    if (!supported || _locale.languageCode == languageCode) {
      return;
    }

    _locale = Locale(languageCode);
    notifyListeners();
  }
}