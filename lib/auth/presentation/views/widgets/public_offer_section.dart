import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sweet_pal/core/utils/app_colors.dart';
import 'package:sweet_pal/core/providers/theme_provider.dart';

class PublicOffireSection extends StatelessWidget {
  const PublicOffireSection({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(color: Provider.of<ThemeProvider>(context, listen: false).textColor),
        children: [
          TextSpan(text: 'By clicking the '),
          TextSpan(
            text: 'Register',
            style: TextStyle(
              color: AppColors.secondaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(text: ' button, you agree to the public offer'),
        ],
      ),
    );
  }
}
