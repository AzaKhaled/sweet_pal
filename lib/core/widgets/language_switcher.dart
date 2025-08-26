import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sweet_pal/core/services/localization_service.dart';

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final localizationService = Provider.of<LocalizationService>(context);
    final currentLocale = localizationService.currentLocale;

    return PopupMenuButton<Locale>(
      icon: const Icon(Icons.language),
      onSelected: (Locale locale) async {
        await localizationService.setLocale(locale);
        // The MaterialApp will automatically rebuild because LocalizationService
        // extends ChangeNotifier and notifies listeners
      },
      itemBuilder: (BuildContext context) => localizationService.supportedLocales
          .map((Locale locale) => PopupMenuItem<Locale>(
                value: locale,
                child: Row(
                  children: [
                    Text(_getLanguageName(locale)),
                    if (locale.languageCode == currentLocale.languageCode)
                      const Icon(Icons.check, size: 16),
                  ],
                ),
              ))
          .toList(),
    );
  }

  String _getLanguageName(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'ar':
        return 'العربية';
      default:
        return locale.languageCode;
    }
  }
}
