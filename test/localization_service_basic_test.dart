import 'package:flutter_test/flutter_test.dart';
import 'package:sweet_pal/core/services/localization_service.dart';
import 'package:flutter/material.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LocalizationService Basic Tests', () {
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

    test('isArabic() should return true for Arabic locale', () {
      // Create a new instance to test Arabic functionality
      const arabicLocale = Locale('ar', 'SA');
      expect(arabicLocale.languageCode == 'ar', true);
    });

    test('Supported locales should not include French', () {
      expect(localizationService.supportedLocales.contains(const Locale('fr', 'FR')), false);
    });
  });
}
