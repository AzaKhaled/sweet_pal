import 'package:flutter_test/flutter_test.dart';
import 'package:sweet_pal/core/services/localization_service.dart';
import 'package:flutter/material.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized(); // Ensure the binding is initialized

  group('LocalizationService Tests', () {
    late LocalizationService localizationService;

    setUp(() {
      localizationService = LocalizationService();
    });

    test('Initial locale should be English', () {
      expect(localizationService.currentLocale, const Locale('en', 'US'));
    });

    test('Supported locales should include English and Arabic', () {
      expect(localizationService.supportedLocales.length, 2);
      expect(localizationService.supportedLocales, contains(const Locale('en', 'US')));
      expect(localizationService.supportedLocales, contains(const Locale('ar', 'SA')));
    });

    test('isArabic() should return false for English locale', () {
      expect(localizationService.isArabic(), false);
    });

    test('getCurrentLanguageCode() should return "en" for English locale', () {
      expect(localizationService.getCurrentLanguageCode(), 'en');
    });

    test('setLocale should change current locale', () async {
      await localizationService.setLocale(const Locale('ar', 'SA'));
      expect(localizationService.currentLocale, const Locale('ar', 'SA'));
      expect(localizationService.isArabic(), true);
      expect(localizationService.getCurrentLanguageCode(), 'ar');
    });

    test('setLocale should not change for unsupported locale', () async {
      final initialLocale = localizationService.currentLocale;
      await localizationService.setLocale(const Locale('fr', 'FR'));
      expect(localizationService.currentLocale, initialLocale); // Should remain unchanged
    });
  });
}
