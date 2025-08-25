import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sweet_pal/core/utils/app_colors.dart';
import 'package:sweet_pal/core/providers/theme_provider.dart';

class HaveAnAccountSection extends StatelessWidget {
  final String leadingText;
  final String actionText;
  final VoidCallback onTap;

  const HaveAnAccountSection({
    super.key,
    required this.leadingText,
    required this.actionText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Text(leadingText, style: TextStyle(
          color: Provider.of<ThemeProvider>(context, listen: false).textColor,
        )),
        GestureDetector(
          onTap: onTap,
          child: Text(
            actionText,
            style: const TextStyle(
              color: AppColors.secondaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
