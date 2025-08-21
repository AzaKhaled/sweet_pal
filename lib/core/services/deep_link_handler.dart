import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sweet_pal/auth/presentation/views/widgets/unified_password_reset.dart';

class DeepLinkHandler {
  static Future<void> init(BuildContext context) async {
    final appLinks = AppLinks();

    // Handle initial link
    final initialUri = await appLinks.getInitialLink();
    if (initialUri != null) {
      handleAuthDeepLink(initialUri, context);
    }

    // Handle stream of links
    appLinks.uriLinkStream.listen((uri) {
      handleAuthDeepLink(uri, context);
    });
  }

  static Future<void> handleAuthDeepLink(Uri uri, BuildContext context) async {
    if (uri.host == 'reset-password' || uri.path.contains('reset-password')) {
      final refreshToken = uri.queryParameters['refresh_token'];

      if (refreshToken != null) {
        try {
          final response = await Supabase.instance.client.auth.setSession(
            refreshToken,
          );

          if (response.session != null) {
            // Navigate to unified password reset screen
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const ResetPasswordView()),
              (route) => false,
            );
          }
        } catch (e) {
          debugPrint('Error setting session: $e');
        }
      }
    }
  }
}
