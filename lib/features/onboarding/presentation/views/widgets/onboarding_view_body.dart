import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sweet_pal/auth/presentation/views/sigin_view.dart';
import 'package:sweet_pal/core/utils/app_images.dart';
import 'package:sweet_pal/core/utils/app_text_styles.dart';
import 'package:sweet_pal/core/utils/widgets/custombutton.dart';
import 'package:sweet_pal/features/onboarding/presentation/views/widgets/SmoothPageindicators.dart';
import 'package:sweet_pal/features/onboarding/presentation/views/widgets/onboarding_view_items.dart';

class OnboardingViewBody extends StatefulWidget {
  const OnboardingViewBody({super.key});
  @override
  State<OnboardingViewBody> createState() => _OnboardingViewBodyState();
}

class _OnboardingViewBodyState extends State<OnboardingViewBody> {
  final PageController _controller = PageController();
  int _currentPage = 0;
  final int _totalPages = 4;

  // تحسين الأداء - تخزين البيانات
  static const List<Map<String, String>> _onboardingData = [
    {
      'imagePath': Assets.imagesIllustration,
      'title': 'Welcome',
      'subtitle':
          'It\'s a pleasure to meet you. We are excited that you\'re here so let\'s get started!',
    },
    {
      'imagePath': Assets.imagesIllustration1,
      'title': 'All your favorites',
      'subtitle':
          'order from the best local restaurants with easy,on-demand delivery',
    },
    {
      'imagePath': Assets.imagesIllustrations,
      'title': 'Free delivery offers',
      'subtitle':
          'free deliver for new customers via paypal pay and other payment methods',
    },
    {
      'imagePath': Assets.imagesIllustrations1,
      'title': 'Choose your food',
      'subtitle':
          'Easily find your type of food craving and you\'ll get delivery in wide range.',
    },
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.h),
        child: AppBar(
          elevation: 0,
          flexibleSpace: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 14.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 60.h,
                    width: 60.w,
                    child: SvgPicture.asset(
                      Assets.Logo,
                      fit: BoxFit.contain,
                      // تحسين الأداء - تخزين مؤقت للصورة
                      cacheColorFilter: true,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  const Text('TamangFoodService', style: TextStyles.montserrat800_24),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              onPageChanged: (index) {
                // تحسين الأداء - تأجيل setState
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    setState(() {
                      _currentPage = index;
                    });
                  }
                });
              },
              itemCount: _totalPages,
              itemBuilder: (context, index) {
                final data = _onboardingData[index];
                return OnboardingViewItems(
                  imagePath: data['imagePath']!,
                  title: data['title']!,
                  subtitle: data['subtitle']!,
                );
              },
            ),
          ),
          // Buttons
          SmoothPageindicators(
            controller: _controller,
            totalPages: _totalPages,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0, left: 16, right: 16),
            child: CustomButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SiginView()),
                );
              },
              text: 'Get Started',
            ),
          ),
        ],
      ),
    );
  }
}
