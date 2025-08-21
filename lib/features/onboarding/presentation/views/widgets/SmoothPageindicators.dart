import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SmoothPageindicators extends StatelessWidget {
  final PageController controller;
  final int totalPages;

  const SmoothPageindicators({
    super.key,
    required this.controller,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: SmoothPageIndicator(
        controller: controller,
        count: totalPages,
        effect: WormEffect(
          dotColor: Colors.grey.shade400,
          activeDotColor: const Color(0xff22A45D),
          dotHeight: 8,
          dotWidth: 8,
        ),
      ),
    );
  }
}
