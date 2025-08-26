import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sweet_pal/core/utils/app_colors.dart';
import 'package:sweet_pal/core/providers/theme_provider.dart';
import 'package:sweet_pal/core/utils/localization_helper.dart';

class PublicOffireSection extends StatelessWidget {
  const PublicOffireSection({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(color: Provider.of<ThemeProvider>(context, listen: false).textColor),
        children: [
          TextSpan(text: LocalizationHelper.translate('By clicking the ', 'عند النقر على ')),
          const TextSpan(
            text: 'Register',
            style: TextStyle(
              color: AppColors.secondaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(text: LocalizationHelper.translate(' button, you agree to the public offer', ' زر، فإنك توافق على العرض العام')),
        ],
      ),
    );
  }
}
