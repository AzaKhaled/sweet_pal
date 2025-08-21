import 'package:flutter/material.dart';
import 'package:sweet_pal/features/home/presentation/views/widgets/home_view.dart';

class NavigationHelper {
  /// Navigate to the dashboard/home page
  static void navigateToDashboard(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomeView()),
      (route) => false,
    );
  }

  /// Navigate to dashboard with specific tab
  static void navigateToDashboardWithTab(BuildContext context, int tabIndex) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => HomeView(initialTab: tabIndex),
      ),
      (route) => false,
    );
  }

  /// Handle back button press to go to dashboard
  static void handleBackToDashboard(BuildContext context) {
    navigateToDashboard(context);
  }
}
