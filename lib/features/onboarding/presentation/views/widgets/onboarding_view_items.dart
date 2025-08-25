import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sweet_pal/core/providers/theme_provider.dart';
import 'package:sweet_pal/core/utils/app_text_styles.dart';

class OnboardingViewItems extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;

  const OnboardingViewItems({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  imagePath,
                  width: 200.w,
                  height: 250.h,
                  // تحسين الأداء - تخزين مؤقت للصورة
                  // cacheColorFilter: true,
                  // تحسين الأداء - تحسين جودة الصورة
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 12.h),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyles.montserrat800_24.copyWith(
                    color: Provider.of<ThemeProvider>(context).textColor,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyles.montserrat600_14_grey.copyWith(
                    color: Provider.of<ThemeProvider>(context).secondaryTextColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
