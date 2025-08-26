import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sweet_pal/core/utils/app_colors.dart';
import 'package:sweet_pal/core/utils/app_text_styles.dart';
import 'package:sweet_pal/core/providers/theme_provider.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.hintText,
    required this.textInputType,
    this.suffixIcon,
    this.onSaved,
    this.onChanged,
    this.obscureText = false,
    this.preffixIcon,
    this.controller,
    this.validator,
  });

  final String hintText;
  final TextInputType textInputType;
  final Widget? suffixIcon;
  final Widget? preffixIcon;
  final void Function(String?)? onSaved;
  final void Function(String)? onChanged;
  final bool obscureText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      onSaved: onSaved,
      onChanged: onChanged,
      validator:
          validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'required';
            }
            return null;
          },
      keyboardType: textInputType,
      style: TextStyle(color: themeProvider.textColor),
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        prefixIcon: preffixIcon,
        hintStyle: TextStyles.montserrat500_12_grey.copyWith(
          color: themeProvider.secondaryTextColor,
        ),
        hintText: hintText,
        filled: true,
        fillColor: themeProvider.cardBackgroundColor,
        border: buildBorder(themeProvider),
        enabledBorder: buildBorder(themeProvider),
        focusedBorder: buildBorder(themeProvider, isFocused: true),
      ),
    );
  }

  OutlineInputBorder buildBorder(ThemeProvider themeProvider, {bool isFocused = false}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(24),
      borderSide: BorderSide(
        width: 1, 
        color: isFocused ? AppColors.primaryColor : themeProvider.secondaryTextColor.withOpacity(0.3),
      ),
    );
  }
}
