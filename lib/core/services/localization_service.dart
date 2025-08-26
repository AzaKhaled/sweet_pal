import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationService extends ChangeNotifier {
  static const String _languageCodeKey = 'language_code';
  static const String _countryCodeKey = 'country_code';

  static final LocalizationService _instance = LocalizationService._internal();
  factory LocalizationService() => _instance;
  LocalizationService._internal();

  final List<Locale> _supportedLocales = [
    const Locale('en', 'US'), // English
    const Locale('ar', 'SA'), // Arabic
  ];

  Locale _currentLocale = const Locale('en', 'US');

  List<Locale> get supportedLocales => _supportedLocales;
  Locale get currentLocale => _currentLocale;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_languageCodeKey);
    final countryCode = prefs.getString(_countryCodeKey);

    if (languageCode != null && countryCode != null) {
      _currentLocale = Locale(languageCode, countryCode);
    } else {
      // Default to device locale or English
      _currentLocale = const Locale('en', 'US');
    }
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    if (!_supportedLocales.contains(locale)) {
      return;
    }

    _currentLocale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageCodeKey, locale.languageCode);
    if (locale.countryCode != null) {
      await prefs.setString(_countryCodeKey, locale.countryCode!);
    }
    notifyListeners();
  }

  bool isArabic() {
    return _currentLocale.languageCode == 'ar';
  }

  String getCurrentLanguageCode() {
    return _currentLocale.languageCode;
  }
}
