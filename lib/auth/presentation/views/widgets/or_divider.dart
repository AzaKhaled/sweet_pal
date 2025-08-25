import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sweet_pal/core/providers/theme_provider.dart';
import 'package:sweet_pal/core/utils/app_text_styles.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60.0),
      child: Row(
        children: [
          Expanded(child: Divider(color: themeProvider.textColor.withOpacity(0.3))),
          const SizedBox(width: 18),
          Text(
            'OR Continue with',
            textAlign: TextAlign.center,
            style: TextStyles.montserrat400_10_black.copyWith(
              color: themeProvider.textColor,
            ),
          ),
          const SizedBox(width: 18),
          Expanded(child: Divider(color: themeProvider.textColor.withOpacity(0.3))),
        ],
      ),
    );
  }
}
