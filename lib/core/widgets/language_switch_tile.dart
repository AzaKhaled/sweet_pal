import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sweet_pal/core/services/localization_service.dart';

class LanguageSwitchTile extends StatelessWidget {
  const LanguageSwitchTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalizationService>(
      builder: (context, localizationService, child) {
        return SwitchListTile(
          title: const Text('Arabic Language'),
          subtitle: Text(localizationService.isArabic() ? 'Enabled' : 'Disabled'),
          value: localizationService.isArabic(),
          onChanged: (bool value) async {
            final newLocale = value ? const Locale('ar', 'SA') : const Locale('en', 'US');
            await localizationService.setLocale(newLocale);
          },
          secondary: const Icon(Icons.language),
        );
      },
    );
  }
}
